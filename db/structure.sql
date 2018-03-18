SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: pages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE pages (
    id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    published_revision_id bigint,
    latest_revision_id bigint
);


--
-- Name: pages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE pages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE pages_id_seq OWNED BY pages.id;


--
-- Name: project_revision_ratings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE project_revision_ratings (
    id bigint NOT NULL,
    project_revision_id bigint NOT NULL,
    rating_type_id bigint NOT NULL,
    score integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: project_revision_ratings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE project_revision_ratings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: project_revision_ratings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE project_revision_ratings_id_seq OWNED BY project_revision_ratings.id;


--
-- Name: project_revisions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE project_revisions (
    id bigint NOT NULL,
    project_id bigint NOT NULL,
    revision_id bigint NOT NULL,
    title character varying NOT NULL,
    full_name character varying,
    guarantor character varying,
    description character varying,
    budget character varying,
    status character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    body_html character varying,
    total_score integer,
    maximum_score integer,
    redflags_count integer DEFAULT 0,
    summary text,
    recommendation text
);


--
-- Name: project_revisions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE project_revisions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: project_revisions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE project_revisions_id_seq OWNED BY project_revisions.id;


--
-- Name: projects; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE projects (
    id bigint NOT NULL,
    page_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    published_revision_id bigint,
    category integer DEFAULT 2 NOT NULL
);


--
-- Name: projects_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE projects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: projects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE projects_id_seq OWNED BY projects.id;


--
-- Name: que_jobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE que_jobs (
    priority smallint DEFAULT 100 NOT NULL,
    run_at timestamp with time zone DEFAULT now() NOT NULL,
    job_id bigint NOT NULL,
    job_class text NOT NULL,
    args json DEFAULT '[]'::json NOT NULL,
    error_count integer DEFAULT 0 NOT NULL,
    last_error text,
    queue text DEFAULT ''::text NOT NULL
);


--
-- Name: TABLE que_jobs; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE que_jobs IS '3';


--
-- Name: que_jobs_job_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE que_jobs_job_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: que_jobs_job_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE que_jobs_job_id_seq OWNED BY que_jobs.job_id;


--
-- Name: rating_phases; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE rating_phases (
    id bigint NOT NULL,
    name character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: rating_phases_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE rating_phases_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rating_phases_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE rating_phases_id_seq OWNED BY rating_phases.id;


--
-- Name: rating_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE rating_types (
    id bigint NOT NULL,
    rating_phase_id bigint NOT NULL,
    name character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: rating_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE rating_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rating_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE rating_types_id_seq OWNED BY rating_types.id;


--
-- Name: revisions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE revisions (
    id bigint NOT NULL,
    page_id bigint NOT NULL,
    version integer NOT NULL,
    raw jsonb,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    title character varying NOT NULL
);


--
-- Name: revisions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE revisions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: revisions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE revisions_id_seq OWNED BY revisions.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: pages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY pages ALTER COLUMN id SET DEFAULT nextval('pages_id_seq'::regclass);


--
-- Name: project_revision_ratings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY project_revision_ratings ALTER COLUMN id SET DEFAULT nextval('project_revision_ratings_id_seq'::regclass);


--
-- Name: project_revisions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY project_revisions ALTER COLUMN id SET DEFAULT nextval('project_revisions_id_seq'::regclass);


--
-- Name: projects id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY projects ALTER COLUMN id SET DEFAULT nextval('projects_id_seq'::regclass);


--
-- Name: que_jobs job_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY que_jobs ALTER COLUMN job_id SET DEFAULT nextval('que_jobs_job_id_seq'::regclass);


--
-- Name: rating_phases id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY rating_phases ALTER COLUMN id SET DEFAULT nextval('rating_phases_id_seq'::regclass);


--
-- Name: rating_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY rating_types ALTER COLUMN id SET DEFAULT nextval('rating_types_id_seq'::regclass);


--
-- Name: revisions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY revisions ALTER COLUMN id SET DEFAULT nextval('revisions_id_seq'::regclass);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: pages pages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pages
    ADD CONSTRAINT pages_pkey PRIMARY KEY (id);


--
-- Name: project_revision_ratings project_revision_ratings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY project_revision_ratings
    ADD CONSTRAINT project_revision_ratings_pkey PRIMARY KEY (id);


--
-- Name: project_revisions project_revisions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY project_revisions
    ADD CONSTRAINT project_revisions_pkey PRIMARY KEY (id);


--
-- Name: projects projects_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (id);


--
-- Name: que_jobs que_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY que_jobs
    ADD CONSTRAINT que_jobs_pkey PRIMARY KEY (queue, priority, run_at, job_id);


--
-- Name: rating_phases rating_phases_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY rating_phases
    ADD CONSTRAINT rating_phases_pkey PRIMARY KEY (id);


--
-- Name: rating_types rating_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY rating_types
    ADD CONSTRAINT rating_types_pkey PRIMARY KEY (id);


--
-- Name: revisions revisions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY revisions
    ADD CONSTRAINT revisions_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: index_project_revision_ratings_on_project_revision_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_project_revision_ratings_on_project_revision_id ON project_revision_ratings USING btree (project_revision_id);


--
-- Name: index_project_revision_ratings_on_rating_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_project_revision_ratings_on_rating_type_id ON project_revision_ratings USING btree (rating_type_id);


--
-- Name: index_project_revisions_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_project_revisions_on_project_id ON project_revisions USING btree (project_id);


--
-- Name: index_project_revisions_on_revision_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_project_revisions_on_revision_id ON project_revisions USING btree (revision_id);


--
-- Name: index_projects_on_page_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_projects_on_page_id ON projects USING btree (page_id);


--
-- Name: index_projects_on_published_revision_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_projects_on_published_revision_id ON projects USING btree (published_revision_id);


--
-- Name: index_rating_types_on_rating_phase_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_rating_types_on_rating_phase_id ON rating_types USING btree (rating_phase_id);


--
-- Name: index_revisions_on_page_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_revisions_on_page_id ON revisions USING btree (page_id);


--
-- Name: index_revisions_on_page_id_and_version; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_revisions_on_page_id_and_version ON revisions USING btree (page_id, version);


--
-- Name: projects fk_rails_0734b65c75; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY projects
    ADD CONSTRAINT fk_rails_0734b65c75 FOREIGN KEY (published_revision_id) REFERENCES project_revisions(id);


--
-- Name: projects fk_rails_2f0408551d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY projects
    ADD CONSTRAINT fk_rails_2f0408551d FOREIGN KEY (page_id) REFERENCES pages(id);


--
-- Name: rating_types fk_rails_3b79085a72; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY rating_types
    ADD CONSTRAINT fk_rails_3b79085a72 FOREIGN KEY (rating_phase_id) REFERENCES rating_phases(id);


--
-- Name: project_revision_ratings fk_rails_89f94d4743; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY project_revision_ratings
    ADD CONSTRAINT fk_rails_89f94d4743 FOREIGN KEY (project_revision_id) REFERENCES project_revisions(id);


--
-- Name: project_revision_ratings fk_rails_8f89f5f94e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY project_revision_ratings
    ADD CONSTRAINT fk_rails_8f89f5f94e FOREIGN KEY (rating_type_id) REFERENCES rating_types(id);


--
-- Name: project_revisions fk_rails_9bbd5a8be5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY project_revisions
    ADD CONSTRAINT fk_rails_9bbd5a8be5 FOREIGN KEY (revision_id) REFERENCES revisions(id);


--
-- Name: revisions fk_rails_d1037952e2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY revisions
    ADD CONSTRAINT fk_rails_d1037952e2 FOREIGN KEY (page_id) REFERENCES pages(id);


--
-- Name: project_revisions fk_rails_e5ad51d682; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY project_revisions
    ADD CONSTRAINT fk_rails_e5ad51d682 FOREIGN KEY (project_id) REFERENCES projects(id);


--
-- Name: pages fk_rails_ee4b1c338f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pages
    ADD CONSTRAINT fk_rails_ee4b1c338f FOREIGN KEY (latest_revision_id) REFERENCES revisions(id);


--
-- Name: pages fk_rails_ffffd09d52; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pages
    ADD CONSTRAINT fk_rails_ffffd09d52 FOREIGN KEY (published_revision_id) REFERENCES revisions(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20171024153945'),
('20171024154001'),
('20171024155327'),
('20171025151045'),
('20171027113100'),
('20171027113228'),
('20171027113301'),
('20171027121514'),
('20171027121801'),
('20171027121807'),
('20171027121959'),
('20171027122134'),
('20171030115814'),
('20171031125640'),
('20171031131417'),
('20171108160920'),
('20171110104007'),
('20171110114322');


