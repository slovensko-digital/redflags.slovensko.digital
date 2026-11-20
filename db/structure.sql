SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: que_validate_tags(jsonb); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.que_validate_tags(tags_array jsonb) RETURNS boolean
    LANGUAGE sql
    AS $$
  SELECT bool_and(
    jsonb_typeof(value) = 'string'
    AND
    char_length(value::text) <= 100
  )
  FROM jsonb_array_elements(tags_array)
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: que_jobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.que_jobs (
    priority smallint DEFAULT 100 NOT NULL,
    run_at timestamp with time zone DEFAULT now() NOT NULL,
    id bigint NOT NULL,
    job_class text NOT NULL,
    error_count integer DEFAULT 0 NOT NULL,
    last_error_message text,
    queue text DEFAULT 'default'::text NOT NULL,
    last_error_backtrace text,
    finished_at timestamp with time zone,
    expired_at timestamp with time zone,
    args jsonb DEFAULT '[]'::jsonb NOT NULL,
    data jsonb DEFAULT '{}'::jsonb NOT NULL,
    job_schema_version integer NOT NULL,
    kwargs jsonb DEFAULT '{}'::jsonb NOT NULL,
    CONSTRAINT error_length CHECK (((char_length(last_error_message) <= 500) AND (char_length(last_error_backtrace) <= 10000))),
    CONSTRAINT job_class_length CHECK ((char_length(
CASE job_class
    WHEN 'ActiveJob::QueueAdapters::QueAdapter::JobWrapper'::text THEN ((args -> 0) ->> 'job_class'::text)
    ELSE job_class
END) <= 200)),
    CONSTRAINT queue_length CHECK ((char_length(queue) <= 100)),
    CONSTRAINT valid_args CHECK ((jsonb_typeof(args) = 'array'::text)),
    CONSTRAINT valid_data CHECK (((jsonb_typeof(data) = 'object'::text) AND ((NOT (data ? 'tags'::text)) OR ((jsonb_typeof((data -> 'tags'::text)) = 'array'::text) AND (jsonb_array_length((data -> 'tags'::text)) <= 5) AND public.que_validate_tags((data -> 'tags'::text))))))
)
WITH (fillfactor='90');


--
-- Name: TABLE que_jobs; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.que_jobs IS '7';


--
-- Name: que_determine_job_state(public.que_jobs); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.que_determine_job_state(job public.que_jobs) RETURNS text
    LANGUAGE sql
    AS $$
  SELECT
    CASE
    WHEN job.expired_at  IS NOT NULL    THEN 'expired'
    WHEN job.finished_at IS NOT NULL    THEN 'finished'
    WHEN job.error_count > 0            THEN 'errored'
    WHEN job.run_at > CURRENT_TIMESTAMP THEN 'scheduled'
    ELSE                                     'ready'
    END
$$;


--
-- Name: que_job_notify(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.que_job_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  DECLARE
    locker_pid integer;
    sort_key json;
  BEGIN
    -- Don't do anything if the job is scheduled for a future time.
    IF NEW.run_at IS NOT NULL AND NEW.run_at > now() THEN
      RETURN null;
    END IF;

    -- Pick a locker to notify of the job's insertion, weighted by their number
    -- of workers. Should bounce pseudorandomly between lockers on each
    -- invocation, hence the md5-ordering, but still touch each one equally,
    -- hence the modulo using the job_id.
    SELECT pid
    INTO locker_pid
    FROM (
      SELECT *, last_value(row_number) OVER () + 1 AS count
      FROM (
        SELECT *, row_number() OVER () - 1 AS row_number
        FROM (
          SELECT *
          FROM public.que_lockers ql, generate_series(1, ql.worker_count) AS id
          WHERE
            listening AND
            queues @> ARRAY[NEW.queue] AND
            ql.job_schema_version = NEW.job_schema_version
          ORDER BY md5(pid::text || id::text)
        ) t1
      ) t2
    ) t3
    WHERE NEW.id % count = row_number;

    IF locker_pid IS NOT NULL THEN
      -- There's a size limit to what can be broadcast via LISTEN/NOTIFY, so
      -- rather than throw errors when someone enqueues a big job, just
      -- broadcast the most pertinent information, and let the locker query for
      -- the record after it's taken the lock. The worker will have to hit the
      -- DB in order to make sure the job is still visible anyway.
      SELECT row_to_json(t)
      INTO sort_key
      FROM (
        SELECT
          'job_available' AS message_type,
          NEW.queue       AS queue,
          NEW.priority    AS priority,
          NEW.id          AS id,
          -- Make sure we output timestamps as UTC ISO 8601
          to_char(NEW.run_at AT TIME ZONE 'UTC', 'YYYY-MM-DD"T"HH24:MI:SS.US"Z"') AS run_at
      ) t;

      PERFORM pg_notify('que_listener_' || locker_pid::text, sort_key::text);
    END IF;

    RETURN null;
  END
$$;


--
-- Name: que_state_notify(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.que_state_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  DECLARE
    row record;
    message json;
    previous_state text;
    current_state text;
  BEGIN
    IF TG_OP = 'INSERT' THEN
      previous_state := 'nonexistent';
      current_state  := public.que_determine_job_state(NEW);
      row            := NEW;
    ELSIF TG_OP = 'DELETE' THEN
      previous_state := public.que_determine_job_state(OLD);
      current_state  := 'nonexistent';
      row            := OLD;
    ELSIF TG_OP = 'UPDATE' THEN
      previous_state := public.que_determine_job_state(OLD);
      current_state  := public.que_determine_job_state(NEW);

      -- If the state didn't change, short-circuit.
      IF previous_state = current_state THEN
        RETURN null;
      END IF;

      row := NEW;
    ELSE
      RAISE EXCEPTION 'Unrecognized TG_OP: %', TG_OP;
    END IF;

    SELECT row_to_json(t)
    INTO message
    FROM (
      SELECT
        'job_change' AS message_type,
        row.id       AS id,
        row.queue    AS queue,

        coalesce(row.data->'tags', '[]'::jsonb) AS tags,

        to_char(row.run_at AT TIME ZONE 'UTC', 'YYYY-MM-DD"T"HH24:MI:SS.US"Z"') AS run_at,
        to_char(now()      AT TIME ZONE 'UTC', 'YYYY-MM-DD"T"HH24:MI:SS.US"Z"') AS time,

        CASE row.job_class
        WHEN 'ActiveJob::QueueAdapters::QueAdapter::JobWrapper' THEN
          coalesce(
            row.args->0->>'job_class',
            'ActiveJob::QueueAdapters::QueAdapter::JobWrapper'
          )
        ELSE
          row.job_class
        END AS job_class,

        previous_state AS previous_state,
        current_state  AS current_state
    ) t;

    PERFORM pg_notify('que_state', message::text);

    RETURN null;
  END
$$;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: pages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pages (
    id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    published_revision_id bigint,
    latest_revision_id bigint,
    phase_id bigint
);


--
-- Name: pages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pages_id_seq OWNED BY public.pages.id;


--
-- Name: phase_revision_ratings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.phase_revision_ratings (
    id bigint NOT NULL,
    phase_revision_id bigint NOT NULL,
    rating_type_id bigint NOT NULL,
    score integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: phase_revision_ratings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.phase_revision_ratings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: phase_revision_ratings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.phase_revision_ratings_id_seq OWNED BY public.phase_revision_ratings.id;


--
-- Name: phase_revisions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.phase_revisions (
    id bigint NOT NULL,
    revision_id bigint NOT NULL,
    title character varying NOT NULL,
    full_name character varying,
    guarantor character varying,
    description text,
    budget character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    body_html text,
    total_score integer,
    maximum_score integer,
    redflags_count integer DEFAULT 0,
    summary text,
    recommendation text,
    stage_id bigint,
    current_status character varying,
    phase_id bigint,
    published boolean DEFAULT false,
    was_published boolean DEFAULT false,
    published_at timestamp without time zone
);


--
-- Name: phase_revisions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.phase_revisions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: phase_revisions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.phase_revisions_id_seq OWNED BY public.phase_revisions.id;


--
-- Name: phase_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.phase_types (
    id bigint NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: phase_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.phase_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: phase_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.phase_types_id_seq OWNED BY public.phase_types.id;


--
-- Name: phases; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.phases (
    id bigint NOT NULL,
    project_id bigint,
    phase_type_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: phases_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.phases_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: phases_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.phases_id_seq OWNED BY public.phases.id;


--
-- Name: project_stages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.project_stages (
    id bigint NOT NULL,
    name character varying NOT NULL,
    "position" integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: project_stages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.project_stages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: project_stages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.project_stages_id_seq OWNED BY public.project_stages.id;


--
-- Name: projects; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.projects (
    id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: projects_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.projects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: projects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.projects_id_seq OWNED BY public.projects.id;


--
-- Name: que_jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.que_jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: que_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.que_jobs_id_seq OWNED BY public.que_jobs.id;


--
-- Name: que_lockers; Type: TABLE; Schema: public; Owner: -
--

CREATE UNLOGGED TABLE public.que_lockers (
    pid integer NOT NULL,
    worker_count integer NOT NULL,
    worker_priorities integer[] NOT NULL,
    ruby_pid integer NOT NULL,
    ruby_hostname text NOT NULL,
    queues text[] NOT NULL,
    listening boolean NOT NULL,
    job_schema_version integer DEFAULT 1,
    CONSTRAINT valid_queues CHECK (((array_ndims(queues) = 1) AND (array_length(queues, 1) IS NOT NULL))),
    CONSTRAINT valid_worker_priorities CHECK (((array_ndims(worker_priorities) = 1) AND (array_length(worker_priorities, 1) IS NOT NULL)))
);


--
-- Name: que_values; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.que_values (
    key text NOT NULL,
    value jsonb DEFAULT '{}'::jsonb NOT NULL,
    CONSTRAINT valid_value CHECK ((jsonb_typeof(value) = 'object'::text))
)
WITH (fillfactor='90');


--
-- Name: rating_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.rating_types (
    id bigint NOT NULL,
    name character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: rating_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.rating_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rating_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.rating_types_id_seq OWNED BY public.rating_types.id;


--
-- Name: revisions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.revisions (
    id bigint NOT NULL,
    page_id bigint NOT NULL,
    version integer NOT NULL,
    raw jsonb,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    title character varying NOT NULL,
    tags character varying[] DEFAULT '{}'::character varying[]
);


--
-- Name: revisions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.revisions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: revisions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.revisions_id_seq OWNED BY public.revisions.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: pages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pages ALTER COLUMN id SET DEFAULT nextval('public.pages_id_seq'::regclass);


--
-- Name: phase_revision_ratings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.phase_revision_ratings ALTER COLUMN id SET DEFAULT nextval('public.phase_revision_ratings_id_seq'::regclass);


--
-- Name: phase_revisions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.phase_revisions ALTER COLUMN id SET DEFAULT nextval('public.phase_revisions_id_seq'::regclass);


--
-- Name: phase_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.phase_types ALTER COLUMN id SET DEFAULT nextval('public.phase_types_id_seq'::regclass);


--
-- Name: phases id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.phases ALTER COLUMN id SET DEFAULT nextval('public.phases_id_seq'::regclass);


--
-- Name: project_stages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_stages ALTER COLUMN id SET DEFAULT nextval('public.project_stages_id_seq'::regclass);


--
-- Name: projects id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects ALTER COLUMN id SET DEFAULT nextval('public.projects_id_seq'::regclass);


--
-- Name: que_jobs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.que_jobs ALTER COLUMN id SET DEFAULT nextval('public.que_jobs_id_seq'::regclass);


--
-- Name: rating_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rating_types ALTER COLUMN id SET DEFAULT nextval('public.rating_types_id_seq'::regclass);


--
-- Name: revisions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.revisions ALTER COLUMN id SET DEFAULT nextval('public.revisions_id_seq'::regclass);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: pages pages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pages
    ADD CONSTRAINT pages_pkey PRIMARY KEY (id);


--
-- Name: phase_revision_ratings phase_revision_ratings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.phase_revision_ratings
    ADD CONSTRAINT phase_revision_ratings_pkey PRIMARY KEY (id);


--
-- Name: phase_revisions phase_revisions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.phase_revisions
    ADD CONSTRAINT phase_revisions_pkey PRIMARY KEY (id);


--
-- Name: phase_types phase_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.phase_types
    ADD CONSTRAINT phase_types_pkey PRIMARY KEY (id);


--
-- Name: phases phases_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.phases
    ADD CONSTRAINT phases_pkey PRIMARY KEY (id);


--
-- Name: project_stages project_stages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_stages
    ADD CONSTRAINT project_stages_pkey PRIMARY KEY (id);


--
-- Name: projects projects_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (id);


--
-- Name: que_jobs que_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.que_jobs
    ADD CONSTRAINT que_jobs_pkey PRIMARY KEY (id);


--
-- Name: que_lockers que_lockers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.que_lockers
    ADD CONSTRAINT que_lockers_pkey PRIMARY KEY (pid);


--
-- Name: que_values que_values_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.que_values
    ADD CONSTRAINT que_values_pkey PRIMARY KEY (key);


--
-- Name: rating_types rating_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rating_types
    ADD CONSTRAINT rating_types_pkey PRIMARY KEY (id);


--
-- Name: revisions revisions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.revisions
    ADD CONSTRAINT revisions_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: index_pages_on_phase_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pages_on_phase_id ON public.pages USING btree (phase_id);


--
-- Name: index_phase_revision_ratings_on_phase_revision_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_phase_revision_ratings_on_phase_revision_id ON public.phase_revision_ratings USING btree (phase_revision_id);


--
-- Name: index_phase_revision_ratings_on_rating_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_phase_revision_ratings_on_rating_type_id ON public.phase_revision_ratings USING btree (rating_type_id);


--
-- Name: index_phase_revisions_on_phase_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_phase_revisions_on_phase_id ON public.phase_revisions USING btree (phase_id);


--
-- Name: index_phase_revisions_on_revision_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_phase_revisions_on_revision_id ON public.phase_revisions USING btree (revision_id);


--
-- Name: index_phase_revisions_on_stage_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_phase_revisions_on_stage_id ON public.phase_revisions USING btree (stage_id);


--
-- Name: index_phases_on_phase_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_phases_on_phase_type_id ON public.phases USING btree (phase_type_id);


--
-- Name: index_phases_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_phases_on_project_id ON public.phases USING btree (project_id);


--
-- Name: index_revisions_on_page_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_revisions_on_page_id ON public.revisions USING btree (page_id);


--
-- Name: index_revisions_on_page_id_and_version; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_revisions_on_page_id_and_version ON public.revisions USING btree (page_id, version);


--
-- Name: index_revisions_on_tags; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_revisions_on_tags ON public.revisions USING gin (tags);


--
-- Name: que_jobs_args_gin_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX que_jobs_args_gin_idx ON public.que_jobs USING gin (args jsonb_path_ops);


--
-- Name: que_jobs_data_gin_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX que_jobs_data_gin_idx ON public.que_jobs USING gin (data jsonb_path_ops);


--
-- Name: que_jobs_kwargs_gin_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX que_jobs_kwargs_gin_idx ON public.que_jobs USING gin (kwargs jsonb_path_ops);


--
-- Name: que_poll_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX que_poll_idx ON public.que_jobs USING btree (job_schema_version, queue, priority, run_at, id) WHERE ((finished_at IS NULL) AND (expired_at IS NULL));


--
-- Name: que_jobs que_job_notify; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER que_job_notify AFTER INSERT ON public.que_jobs FOR EACH ROW WHEN ((NOT (COALESCE(current_setting('que.skip_notify'::text, true), ''::text) = 'true'::text))) EXECUTE FUNCTION public.que_job_notify();


--
-- Name: que_jobs que_state_notify; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER que_state_notify AFTER INSERT OR DELETE OR UPDATE ON public.que_jobs FOR EACH ROW WHEN ((NOT (COALESCE(current_setting('que.skip_notify'::text, true), ''::text) = 'true'::text))) EXECUTE FUNCTION public.que_state_notify();


--
-- Name: phases fk_rails_7768cfc98c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.phases
    ADD CONSTRAINT fk_rails_7768cfc98c FOREIGN KEY (phase_type_id) REFERENCES public.phase_types(id);


--
-- Name: phase_revision_ratings fk_rails_89f94d4743; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.phase_revision_ratings
    ADD CONSTRAINT fk_rails_89f94d4743 FOREIGN KEY (phase_revision_id) REFERENCES public.phase_revisions(id);


--
-- Name: phase_revision_ratings fk_rails_8f89f5f94e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.phase_revision_ratings
    ADD CONSTRAINT fk_rails_8f89f5f94e FOREIGN KEY (rating_type_id) REFERENCES public.rating_types(id);


--
-- Name: pages fk_rails_9214ad0f21; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pages
    ADD CONSTRAINT fk_rails_9214ad0f21 FOREIGN KEY (phase_id) REFERENCES public.phases(id);


--
-- Name: phase_revisions fk_rails_9b7644f642; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.phase_revisions
    ADD CONSTRAINT fk_rails_9b7644f642 FOREIGN KEY (stage_id) REFERENCES public.project_stages(id);


--
-- Name: phase_revisions fk_rails_9bbd5a8be5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.phase_revisions
    ADD CONSTRAINT fk_rails_9bbd5a8be5 FOREIGN KEY (revision_id) REFERENCES public.revisions(id);


--
-- Name: phases fk_rails_b0efe660f5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.phases
    ADD CONSTRAINT fk_rails_b0efe660f5 FOREIGN KEY (project_id) REFERENCES public.projects(id);


--
-- Name: phase_revisions fk_rails_c47dd3e5d5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.phase_revisions
    ADD CONSTRAINT fk_rails_c47dd3e5d5 FOREIGN KEY (phase_id) REFERENCES public.phases(id);


--
-- Name: revisions fk_rails_d1037952e2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.revisions
    ADD CONSTRAINT fk_rails_d1037952e2 FOREIGN KEY (page_id) REFERENCES public.pages(id);


--
-- Name: pages fk_rails_ee4b1c338f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pages
    ADD CONSTRAINT fk_rails_ee4b1c338f FOREIGN KEY (latest_revision_id) REFERENCES public.revisions(id);


--
-- Name: pages fk_rails_ffffd09d52; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pages
    ADD CONSTRAINT fk_rails_ffffd09d52 FOREIGN KEY (published_revision_id) REFERENCES public.revisions(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20261120120000'),
('20251205131243'),
('20241212091706'),
('20240621112043'),
('20240613113501'),
('20240611153759'),
('20240611153648'),
('20240611122213'),
('20240610110713'),
('20240610102411'),
('20240610100956'),
('20240610100714'),
('20240609120517'),
('20240609114857'),
('20240609101956'),
('20220306165121'),
('20180620144613'),
('20180531165022'),
('20180531162036'),
('20180531154604'),
('20171110114322'),
('20171110104007'),
('20171108160920'),
('20171031131417'),
('20171031125640'),
('20171030115814'),
('20171027122134'),
('20171027121959'),
('20171027121807'),
('20171027121801'),
('20171027121514'),
('20171027113301'),
('20171027113228'),
('20171027113100'),
('20171025151045'),
('20171024155327'),
('20171024154001'),
('20171024153945');

