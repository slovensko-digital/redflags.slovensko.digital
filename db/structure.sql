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
-- Name: metais; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA metais;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: origin_types; Type: TABLE; Schema: metais; Owner: -
--

CREATE TABLE metais.origin_types (
    id bigint NOT NULL,
    name character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: origin_types_id_seq; Type: SEQUENCE; Schema: metais; Owner: -
--

CREATE SEQUENCE metais.origin_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: origin_types_id_seq; Type: SEQUENCE OWNED BY; Schema: metais; Owner: -
--

ALTER SEQUENCE metais.origin_types_id_seq OWNED BY metais.origin_types.id;


--
-- Name: project_documents; Type: TABLE; Schema: metais; Owner: -
--

CREATE TABLE metais.project_documents (
    id bigint NOT NULL,
    project_origin_id bigint NOT NULL,
    origin_type_id bigint NOT NULL,
    name character varying NOT NULL,
    value character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    filename character varying,
    uuid character varying,
    description character varying,
    group_order integer
);


--
-- Name: project_documents_id_seq; Type: SEQUENCE; Schema: metais; Owner: -
--

CREATE SEQUENCE metais.project_documents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: project_documents_id_seq; Type: SEQUENCE OWNED BY; Schema: metais; Owner: -
--

ALTER SEQUENCE metais.project_documents_id_seq OWNED BY metais.project_documents.id;


--
-- Name: project_event_types; Type: TABLE; Schema: metais; Owner: -
--

CREATE TABLE metais.project_event_types (
    id bigint NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: project_event_types_id_seq; Type: SEQUENCE; Schema: metais; Owner: -
--

CREATE SEQUENCE metais.project_event_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: project_event_types_id_seq; Type: SEQUENCE OWNED BY; Schema: metais; Owner: -
--

ALTER SEQUENCE metais.project_event_types_id_seq OWNED BY metais.project_event_types.id;


--
-- Name: project_events; Type: TABLE; Schema: metais; Owner: -
--

CREATE TABLE metais.project_events (
    id bigint NOT NULL,
    project_origin_id bigint NOT NULL,
    origin_type_id bigint NOT NULL,
    name character varying NOT NULL,
    value character varying NOT NULL,
    date timestamp without time zone NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    event_type_id bigint
);


--
-- Name: project_events_id_seq; Type: SEQUENCE; Schema: metais; Owner: -
--

CREATE SEQUENCE metais.project_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: project_events_id_seq; Type: SEQUENCE OWNED BY; Schema: metais; Owner: -
--

ALTER SEQUENCE metais.project_events_id_seq OWNED BY metais.project_events.id;


--
-- Name: project_links; Type: TABLE; Schema: metais; Owner: -
--

CREATE TABLE metais.project_links (
    id bigint NOT NULL,
    project_origin_id bigint NOT NULL,
    origin_type_id bigint NOT NULL,
    name character varying NOT NULL,
    value character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: project_links_id_seq; Type: SEQUENCE; Schema: metais; Owner: -
--

CREATE SEQUENCE metais.project_links_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: project_links_id_seq; Type: SEQUENCE OWNED BY; Schema: metais; Owner: -
--

ALTER SEQUENCE metais.project_links_id_seq OWNED BY metais.project_links.id;


--
-- Name: project_origins; Type: TABLE; Schema: metais; Owner: -
--

CREATE TABLE metais.project_origins (
    id bigint NOT NULL,
    project_id bigint NOT NULL,
    origin_type_id bigint NOT NULL,
    title character varying NOT NULL,
    status character varying,
    description text,
    guarantor character varying,
    project_manager character varying,
    start_date timestamp without time zone,
    end_date timestamp without time zone,
    finance_source character varying,
    investment numeric(15,2),
    operation numeric(15,2),
    supplier character varying,
    targets_text text,
    events_text text,
    documents_text text,
    links_text text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    phase character varying,
    approved_investment numeric(15,2),
    approved_operation numeric(15,2),
    metais_created_at timestamp without time zone,
    status_change_date timestamp without time zone,
    supplier_cin bigint,
    benefits numeric(15,2)
);


--
-- Name: project_origins_id_seq; Type: SEQUENCE; Schema: metais; Owner: -
--

CREATE SEQUENCE metais.project_origins_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: project_origins_id_seq; Type: SEQUENCE OWNED BY; Schema: metais; Owner: -
--

ALTER SEQUENCE metais.project_origins_id_seq OWNED BY metais.project_origins.id;


--
-- Name: project_suppliers; Type: TABLE; Schema: metais; Owner: -
--

CREATE TABLE metais.project_suppliers (
    id bigint NOT NULL,
    project_origin_id bigint NOT NULL,
    origin_type_id bigint NOT NULL,
    supplier_type_id bigint NOT NULL,
    name character varying NOT NULL,
    value character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    date timestamp without time zone
);


--
-- Name: project_suppliers_id_seq; Type: SEQUENCE; Schema: metais; Owner: -
--

CREATE SEQUENCE metais.project_suppliers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: project_suppliers_id_seq; Type: SEQUENCE OWNED BY; Schema: metais; Owner: -
--

ALTER SEQUENCE metais.project_suppliers_id_seq OWNED BY metais.project_suppliers.id;


--
-- Name: projects; Type: TABLE; Schema: metais; Owner: -
--

CREATE TABLE metais.projects (
    id bigint NOT NULL,
    code character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    uuid character varying
);


--
-- Name: projects_id_seq; Type: SEQUENCE; Schema: metais; Owner: -
--

CREATE SEQUENCE metais.projects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: projects_id_seq; Type: SEQUENCE OWNED BY; Schema: metais; Owner: -
--

ALTER SEQUENCE metais.projects_id_seq OWNED BY metais.projects.id;


--
-- Name: supplier_types; Type: TABLE; Schema: metais; Owner: -
--

CREATE TABLE metais.supplier_types (
    id bigint NOT NULL,
    name character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: supplier_types_id_seq; Type: SEQUENCE; Schema: metais; Owner: -
--

CREATE SEQUENCE metais.supplier_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: supplier_types_id_seq; Type: SEQUENCE OWNED BY; Schema: metais; Owner: -
--

ALTER SEQUENCE metais.supplier_types_id_seq OWNED BY metais.supplier_types.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: combined_projects; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.combined_projects (
    id bigint NOT NULL,
    metais_project_id bigint NOT NULL,
    evaluation_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: combined_projects_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.combined_projects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: combined_projects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.combined_projects_id_seq OWNED BY public.combined_projects.id;


--
-- Name: good_job_batches; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.good_job_batches (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    description text,
    serialized_properties jsonb,
    on_finish text,
    on_success text,
    on_discard text,
    callback_queue_name text,
    callback_priority integer,
    enqueued_at timestamp(6) without time zone,
    discarded_at timestamp(6) without time zone,
    finished_at timestamp(6) without time zone,
    jobs_finished_at timestamp(6) without time zone
);


--
-- Name: good_job_concurrency_claims; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.good_job_concurrency_claims (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    job_id uuid NOT NULL,
    locked_by_id uuid,
    state smallint NOT NULL,
    key text NOT NULL
);


--
-- Name: good_job_executions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.good_job_executions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    active_job_id uuid NOT NULL,
    job_class text,
    queue_name text,
    serialized_params jsonb,
    scheduled_at timestamp(6) without time zone,
    finished_at timestamp(6) without time zone,
    error text,
    error_event smallint,
    error_backtrace text[],
    process_id uuid,
    duration interval
);


--
-- Name: good_job_processes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.good_job_processes (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    state jsonb,
    lock_type smallint
);


--
-- Name: good_job_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.good_job_settings (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    key text,
    value jsonb
);


--
-- Name: good_jobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.good_jobs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    queue_name text,
    priority integer,
    serialized_params jsonb,
    scheduled_at timestamp(6) without time zone,
    performed_at timestamp(6) without time zone,
    finished_at timestamp(6) without time zone,
    error text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    active_job_id uuid,
    concurrency_key text,
    cron_key text,
    retried_good_job_id uuid,
    cron_at timestamp(6) without time zone,
    batch_id uuid,
    batch_callback_id uuid,
    is_discrete boolean,
    executions_count integer,
    job_class text,
    error_event smallint,
    labels text[],
    locked_by_id uuid,
    locked_at timestamp(6) without time zone,
    lock_type smallint
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
    updated_at timestamp without time zone NOT NULL,
    metais_code character varying
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
-- Name: projects_metais_projects; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.projects_metais_projects (
    project_id bigint,
    metais_project_id bigint
);


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
-- Name: origin_types id; Type: DEFAULT; Schema: metais; Owner: -
--

ALTER TABLE ONLY metais.origin_types ALTER COLUMN id SET DEFAULT nextval('metais.origin_types_id_seq'::regclass);


--
-- Name: project_documents id; Type: DEFAULT; Schema: metais; Owner: -
--

ALTER TABLE ONLY metais.project_documents ALTER COLUMN id SET DEFAULT nextval('metais.project_documents_id_seq'::regclass);


--
-- Name: project_event_types id; Type: DEFAULT; Schema: metais; Owner: -
--

ALTER TABLE ONLY metais.project_event_types ALTER COLUMN id SET DEFAULT nextval('metais.project_event_types_id_seq'::regclass);


--
-- Name: project_events id; Type: DEFAULT; Schema: metais; Owner: -
--

ALTER TABLE ONLY metais.project_events ALTER COLUMN id SET DEFAULT nextval('metais.project_events_id_seq'::regclass);


--
-- Name: project_links id; Type: DEFAULT; Schema: metais; Owner: -
--

ALTER TABLE ONLY metais.project_links ALTER COLUMN id SET DEFAULT nextval('metais.project_links_id_seq'::regclass);


--
-- Name: project_origins id; Type: DEFAULT; Schema: metais; Owner: -
--

ALTER TABLE ONLY metais.project_origins ALTER COLUMN id SET DEFAULT nextval('metais.project_origins_id_seq'::regclass);


--
-- Name: project_suppliers id; Type: DEFAULT; Schema: metais; Owner: -
--

ALTER TABLE ONLY metais.project_suppliers ALTER COLUMN id SET DEFAULT nextval('metais.project_suppliers_id_seq'::regclass);


--
-- Name: projects id; Type: DEFAULT; Schema: metais; Owner: -
--

ALTER TABLE ONLY metais.projects ALTER COLUMN id SET DEFAULT nextval('metais.projects_id_seq'::regclass);


--
-- Name: supplier_types id; Type: DEFAULT; Schema: metais; Owner: -
--

ALTER TABLE ONLY metais.supplier_types ALTER COLUMN id SET DEFAULT nextval('metais.supplier_types_id_seq'::regclass);


--
-- Name: combined_projects id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.combined_projects ALTER COLUMN id SET DEFAULT nextval('public.combined_projects_id_seq'::regclass);


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
-- Name: rating_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rating_types ALTER COLUMN id SET DEFAULT nextval('public.rating_types_id_seq'::regclass);


--
-- Name: revisions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.revisions ALTER COLUMN id SET DEFAULT nextval('public.revisions_id_seq'::regclass);


--
-- Name: origin_types origin_types_pkey; Type: CONSTRAINT; Schema: metais; Owner: -
--

ALTER TABLE ONLY metais.origin_types
    ADD CONSTRAINT origin_types_pkey PRIMARY KEY (id);


--
-- Name: project_documents project_documents_pkey; Type: CONSTRAINT; Schema: metais; Owner: -
--

ALTER TABLE ONLY metais.project_documents
    ADD CONSTRAINT project_documents_pkey PRIMARY KEY (id);


--
-- Name: project_event_types project_event_types_pkey; Type: CONSTRAINT; Schema: metais; Owner: -
--

ALTER TABLE ONLY metais.project_event_types
    ADD CONSTRAINT project_event_types_pkey PRIMARY KEY (id);


--
-- Name: project_events project_events_pkey; Type: CONSTRAINT; Schema: metais; Owner: -
--

ALTER TABLE ONLY metais.project_events
    ADD CONSTRAINT project_events_pkey PRIMARY KEY (id);


--
-- Name: project_links project_links_pkey; Type: CONSTRAINT; Schema: metais; Owner: -
--

ALTER TABLE ONLY metais.project_links
    ADD CONSTRAINT project_links_pkey PRIMARY KEY (id);


--
-- Name: project_origins project_origins_pkey; Type: CONSTRAINT; Schema: metais; Owner: -
--

ALTER TABLE ONLY metais.project_origins
    ADD CONSTRAINT project_origins_pkey PRIMARY KEY (id);


--
-- Name: project_suppliers project_suppliers_pkey; Type: CONSTRAINT; Schema: metais; Owner: -
--

ALTER TABLE ONLY metais.project_suppliers
    ADD CONSTRAINT project_suppliers_pkey PRIMARY KEY (id);


--
-- Name: projects projects_pkey; Type: CONSTRAINT; Schema: metais; Owner: -
--

ALTER TABLE ONLY metais.projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (id);


--
-- Name: supplier_types supplier_types_pkey; Type: CONSTRAINT; Schema: metais; Owner: -
--

ALTER TABLE ONLY metais.supplier_types
    ADD CONSTRAINT supplier_types_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: combined_projects combined_projects_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.combined_projects
    ADD CONSTRAINT combined_projects_pkey PRIMARY KEY (id);


--
-- Name: good_job_batches good_job_batches_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.good_job_batches
    ADD CONSTRAINT good_job_batches_pkey PRIMARY KEY (id);


--
-- Name: good_job_concurrency_claims good_job_concurrency_claims_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.good_job_concurrency_claims
    ADD CONSTRAINT good_job_concurrency_claims_pkey PRIMARY KEY (id);


--
-- Name: good_job_executions good_job_executions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.good_job_executions
    ADD CONSTRAINT good_job_executions_pkey PRIMARY KEY (id);


--
-- Name: good_job_processes good_job_processes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.good_job_processes
    ADD CONSTRAINT good_job_processes_pkey PRIMARY KEY (id);


--
-- Name: good_job_settings good_job_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.good_job_settings
    ADD CONSTRAINT good_job_settings_pkey PRIMARY KEY (id);


--
-- Name: good_jobs good_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.good_jobs
    ADD CONSTRAINT good_jobs_pkey PRIMARY KEY (id);


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
-- Name: index_metais.project_documents_on_origin_type_id; Type: INDEX; Schema: metais; Owner: -
--

CREATE INDEX "index_metais.project_documents_on_origin_type_id" ON metais.project_documents USING btree (origin_type_id);


--
-- Name: index_metais.project_documents_on_project_origin_id; Type: INDEX; Schema: metais; Owner: -
--

CREATE INDEX "index_metais.project_documents_on_project_origin_id" ON metais.project_documents USING btree (project_origin_id);


--
-- Name: index_metais.project_events_on_event_type_id; Type: INDEX; Schema: metais; Owner: -
--

CREATE INDEX "index_metais.project_events_on_event_type_id" ON metais.project_events USING btree (event_type_id);


--
-- Name: index_metais.project_events_on_origin_type_id; Type: INDEX; Schema: metais; Owner: -
--

CREATE INDEX "index_metais.project_events_on_origin_type_id" ON metais.project_events USING btree (origin_type_id);


--
-- Name: index_metais.project_events_on_project_origin_id; Type: INDEX; Schema: metais; Owner: -
--

CREATE INDEX "index_metais.project_events_on_project_origin_id" ON metais.project_events USING btree (project_origin_id);


--
-- Name: index_metais.project_links_on_origin_type_id; Type: INDEX; Schema: metais; Owner: -
--

CREATE INDEX "index_metais.project_links_on_origin_type_id" ON metais.project_links USING btree (origin_type_id);


--
-- Name: index_metais.project_links_on_project_origin_id; Type: INDEX; Schema: metais; Owner: -
--

CREATE INDEX "index_metais.project_links_on_project_origin_id" ON metais.project_links USING btree (project_origin_id);


--
-- Name: index_metais.project_origins_on_origin_type_id; Type: INDEX; Schema: metais; Owner: -
--

CREATE INDEX "index_metais.project_origins_on_origin_type_id" ON metais.project_origins USING btree (origin_type_id);


--
-- Name: index_metais.project_origins_on_project_id; Type: INDEX; Schema: metais; Owner: -
--

CREATE INDEX "index_metais.project_origins_on_project_id" ON metais.project_origins USING btree (project_id);


--
-- Name: index_metais.project_suppliers_on_origin_type_id; Type: INDEX; Schema: metais; Owner: -
--

CREATE INDEX "index_metais.project_suppliers_on_origin_type_id" ON metais.project_suppliers USING btree (origin_type_id);


--
-- Name: index_metais.project_suppliers_on_project_origin_id; Type: INDEX; Schema: metais; Owner: -
--

CREATE INDEX "index_metais.project_suppliers_on_project_origin_id" ON metais.project_suppliers USING btree (project_origin_id);


--
-- Name: index_metais.project_suppliers_on_supplier_type_id; Type: INDEX; Schema: metais; Owner: -
--

CREATE INDEX "index_metais.project_suppliers_on_supplier_type_id" ON metais.project_suppliers USING btree (supplier_type_id);


--
-- Name: index_combined_projects_on_evaluation_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_combined_projects_on_evaluation_id ON public.combined_projects USING btree (evaluation_id);


--
-- Name: index_combined_projects_on_metais_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_combined_projects_on_metais_project_id ON public.combined_projects USING btree (metais_project_id);


--
-- Name: index_good_job_batches_on_created_at_and_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_job_batches_on_created_at_and_id ON public.good_job_batches USING btree (created_at DESC, id DESC);


--
-- Name: index_good_job_batches_on_finished_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_job_batches_on_finished_at ON public.good_job_batches USING btree (finished_at) WHERE (finished_at IS NOT NULL);


--
-- Name: index_good_job_concurrency_claims_for_promotion; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_job_concurrency_claims_for_promotion ON public.good_job_concurrency_claims USING btree (key, state, created_at);


--
-- Name: index_good_job_concurrency_claims_on_job_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_job_concurrency_claims_on_job_id ON public.good_job_concurrency_claims USING btree (job_id);


--
-- Name: index_good_job_concurrency_claims_on_key_and_job_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_good_job_concurrency_claims_on_key_and_job_id ON public.good_job_concurrency_claims USING btree (key, job_id);


--
-- Name: index_good_job_concurrency_claims_on_locked_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_job_concurrency_claims_on_locked_by_id ON public.good_job_concurrency_claims USING btree (locked_by_id) WHERE (locked_by_id IS NOT NULL);


--
-- Name: index_good_job_executions_on_active_job_id_and_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_job_executions_on_active_job_id_and_created_at ON public.good_job_executions USING btree (active_job_id, created_at);


--
-- Name: index_good_job_executions_on_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_job_executions_on_created_at ON public.good_job_executions USING btree (created_at);


--
-- Name: index_good_job_executions_on_process_id_and_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_job_executions_on_process_id_and_created_at ON public.good_job_executions USING btree (process_id, created_at);


--
-- Name: index_good_job_executions_on_scheduled_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_job_executions_on_scheduled_at ON public.good_job_executions USING btree (scheduled_at);


--
-- Name: index_good_job_jobs_for_candidate_lookup; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_job_jobs_for_candidate_lookup ON public.good_jobs USING btree (priority, created_at) WHERE (finished_at IS NULL);


--
-- Name: index_good_job_settings_on_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_good_job_settings_on_key ON public.good_job_settings USING btree (key);


--
-- Name: index_good_jobs_dequeue_by_queue; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_jobs_dequeue_by_queue ON public.good_jobs USING btree (queue_name, priority, created_at) WHERE ((finished_at IS NULL) AND (locked_by_id IS NULL));


--
-- Name: index_good_jobs_dequeue_by_queue_scheduled_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_jobs_dequeue_by_queue_scheduled_at ON public.good_jobs USING btree (queue_name, priority, scheduled_at) WHERE ((finished_at IS NULL) AND (locked_by_id IS NULL));


--
-- Name: index_good_jobs_for_candidate_dequeue_unlocked; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_jobs_for_candidate_dequeue_unlocked ON public.good_jobs USING btree (priority, scheduled_at, id) WHERE ((finished_at IS NULL) AND (locked_by_id IS NULL));


--
-- Name: index_good_jobs_jobs_on_finished_at_only; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_jobs_jobs_on_finished_at_only ON public.good_jobs USING btree (finished_at) WHERE (finished_at IS NOT NULL);


--
-- Name: index_good_jobs_on_active_job_id_and_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_jobs_on_active_job_id_and_created_at ON public.good_jobs USING btree (active_job_id, created_at);


--
-- Name: index_good_jobs_on_batch_callback_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_jobs_on_batch_callback_id ON public.good_jobs USING btree (batch_callback_id) WHERE (batch_callback_id IS NOT NULL);


--
-- Name: index_good_jobs_on_batch_callback_id_unfinished; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_jobs_on_batch_callback_id_unfinished ON public.good_jobs USING btree (batch_callback_id) WHERE ((batch_callback_id IS NOT NULL) AND (finished_at IS NULL));


--
-- Name: index_good_jobs_on_batch_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_jobs_on_batch_id ON public.good_jobs USING btree (batch_id) WHERE (batch_id IS NOT NULL);


--
-- Name: index_good_jobs_on_batch_id_unfinished; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_jobs_on_batch_id_unfinished ON public.good_jobs USING btree (batch_id) WHERE ((batch_id IS NOT NULL) AND (finished_at IS NULL));


--
-- Name: index_good_jobs_on_concurrency_key_and_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_jobs_on_concurrency_key_and_created_at ON public.good_jobs USING btree (concurrency_key, created_at);


--
-- Name: index_good_jobs_on_concurrency_key_when_unfinished; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_jobs_on_concurrency_key_when_unfinished ON public.good_jobs USING btree (concurrency_key) WHERE (finished_at IS NULL);


--
-- Name: index_good_jobs_on_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_jobs_on_created_at ON public.good_jobs USING btree (created_at);


--
-- Name: index_good_jobs_on_cron_key_and_created_at_cond; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_jobs_on_cron_key_and_created_at_cond ON public.good_jobs USING btree (cron_key, created_at) WHERE (cron_key IS NOT NULL);


--
-- Name: index_good_jobs_on_cron_key_and_cron_at_cond; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_good_jobs_on_cron_key_and_cron_at_cond ON public.good_jobs USING btree (cron_key, cron_at DESC NULLS LAST) WHERE (cron_key IS NOT NULL);


--
-- Name: index_good_jobs_on_discarded; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_jobs_on_discarded ON public.good_jobs USING btree (finished_at DESC) WHERE ((finished_at IS NOT NULL) AND (error IS NOT NULL));


--
-- Name: index_good_jobs_on_discarded_job_class; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_jobs_on_discarded_job_class ON public.good_jobs USING btree (job_class, finished_at) WHERE ((finished_at IS NOT NULL) AND (error IS NOT NULL));


--
-- Name: index_good_jobs_on_job_class; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_jobs_on_job_class ON public.good_jobs USING btree (job_class);


--
-- Name: index_good_jobs_on_labels; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_jobs_on_labels ON public.good_jobs USING gin (labels) WHERE (labels IS NOT NULL);


--
-- Name: index_good_jobs_on_locked_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_jobs_on_locked_by_id ON public.good_jobs USING btree (locked_by_id) WHERE (locked_by_id IS NOT NULL);


--
-- Name: index_good_jobs_on_priority_scheduled_at_unfinished; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_jobs_on_priority_scheduled_at_unfinished ON public.good_jobs USING btree (priority, scheduled_at, id) WHERE (finished_at IS NULL);


--
-- Name: index_good_jobs_on_queue_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_jobs_on_queue_name ON public.good_jobs USING btree (queue_name);


--
-- Name: index_good_jobs_on_queue_name_priority_scheduled_at_unfinished; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_jobs_on_queue_name_priority_scheduled_at_unfinished ON public.good_jobs USING btree (queue_name, scheduled_at, id) WHERE (finished_at IS NULL);


--
-- Name: index_good_jobs_on_scheduled_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_jobs_on_scheduled_at ON public.good_jobs USING btree (scheduled_at) WHERE (finished_at IS NULL);


--
-- Name: index_good_jobs_on_scheduled_at_and_queue_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_jobs_on_scheduled_at_and_queue_name ON public.good_jobs USING btree (scheduled_at, queue_name);


--
-- Name: index_good_jobs_on_unfinished_or_errored; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_jobs_on_unfinished_or_errored ON public.good_jobs USING btree (id) WHERE ((finished_at IS NULL) OR (error IS NOT NULL));


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
-- Name: index_projects_metais_projects_on_metais_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_projects_metais_projects_on_metais_project_id ON public.projects_metais_projects USING btree (metais_project_id);


--
-- Name: index_projects_metais_projects_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_projects_metais_projects_on_project_id ON public.projects_metais_projects USING btree (project_id);


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
-- Name: project_origins fk_rails_20e053d2e1; Type: FK CONSTRAINT; Schema: metais; Owner: -
--

ALTER TABLE ONLY metais.project_origins
    ADD CONSTRAINT fk_rails_20e053d2e1 FOREIGN KEY (project_id) REFERENCES metais.projects(id);


--
-- Name: project_links fk_rails_2aa878383f; Type: FK CONSTRAINT; Schema: metais; Owner: -
--

ALTER TABLE ONLY metais.project_links
    ADD CONSTRAINT fk_rails_2aa878383f FOREIGN KEY (project_origin_id) REFERENCES metais.project_origins(id);


--
-- Name: project_events fk_rails_2f479867fb; Type: FK CONSTRAINT; Schema: metais; Owner: -
--

ALTER TABLE ONLY metais.project_events
    ADD CONSTRAINT fk_rails_2f479867fb FOREIGN KEY (event_type_id) REFERENCES metais.project_event_types(id);


--
-- Name: project_events fk_rails_473e22a88e; Type: FK CONSTRAINT; Schema: metais; Owner: -
--

ALTER TABLE ONLY metais.project_events
    ADD CONSTRAINT fk_rails_473e22a88e FOREIGN KEY (origin_type_id) REFERENCES metais.origin_types(id);


--
-- Name: project_origins fk_rails_4e9327b9e1; Type: FK CONSTRAINT; Schema: metais; Owner: -
--

ALTER TABLE ONLY metais.project_origins
    ADD CONSTRAINT fk_rails_4e9327b9e1 FOREIGN KEY (origin_type_id) REFERENCES metais.origin_types(id);


--
-- Name: project_suppliers fk_rails_596e77825e; Type: FK CONSTRAINT; Schema: metais; Owner: -
--

ALTER TABLE ONLY metais.project_suppliers
    ADD CONSTRAINT fk_rails_596e77825e FOREIGN KEY (project_origin_id) REFERENCES metais.project_origins(id);


--
-- Name: project_suppliers fk_rails_6d5c5bc861; Type: FK CONSTRAINT; Schema: metais; Owner: -
--

ALTER TABLE ONLY metais.project_suppliers
    ADD CONSTRAINT fk_rails_6d5c5bc861 FOREIGN KEY (origin_type_id) REFERENCES metais.origin_types(id);


--
-- Name: project_links fk_rails_82aaaab23a; Type: FK CONSTRAINT; Schema: metais; Owner: -
--

ALTER TABLE ONLY metais.project_links
    ADD CONSTRAINT fk_rails_82aaaab23a FOREIGN KEY (origin_type_id) REFERENCES metais.origin_types(id);


--
-- Name: project_documents fk_rails_94c7d5ceab; Type: FK CONSTRAINT; Schema: metais; Owner: -
--

ALTER TABLE ONLY metais.project_documents
    ADD CONSTRAINT fk_rails_94c7d5ceab FOREIGN KEY (origin_type_id) REFERENCES metais.origin_types(id);


--
-- Name: project_documents fk_rails_db808f0ecf; Type: FK CONSTRAINT; Schema: metais; Owner: -
--

ALTER TABLE ONLY metais.project_documents
    ADD CONSTRAINT fk_rails_db808f0ecf FOREIGN KEY (project_origin_id) REFERENCES metais.project_origins(id);


--
-- Name: project_suppliers fk_rails_e14d4d6e7a; Type: FK CONSTRAINT; Schema: metais; Owner: -
--

ALTER TABLE ONLY metais.project_suppliers
    ADD CONSTRAINT fk_rails_e14d4d6e7a FOREIGN KEY (supplier_type_id) REFERENCES metais.supplier_types(id);


--
-- Name: project_events fk_rails_e243232959; Type: FK CONSTRAINT; Schema: metais; Owner: -
--

ALTER TABLE ONLY metais.project_events
    ADD CONSTRAINT fk_rails_e243232959 FOREIGN KEY (project_origin_id) REFERENCES metais.project_origins(id);


--
-- Name: combined_projects fk_rails_0d08d8ab66; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.combined_projects
    ADD CONSTRAINT fk_rails_0d08d8ab66 FOREIGN KEY (evaluation_id) REFERENCES public.projects(id);


--
-- Name: combined_projects fk_rails_18e52e7275; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.combined_projects
    ADD CONSTRAINT fk_rails_18e52e7275 FOREIGN KEY (metais_project_id) REFERENCES metais.projects(id);


--
-- Name: phase_revisions fk_rails_290d0a047c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.phase_revisions
    ADD CONSTRAINT fk_rails_290d0a047c FOREIGN KEY (revision_id) REFERENCES public.revisions(id);


--
-- Name: projects_metais_projects fk_rails_747f5e41f3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects_metais_projects
    ADD CONSTRAINT fk_rails_747f5e41f3 FOREIGN KEY (project_id) REFERENCES public.projects(id);


--
-- Name: phases fk_rails_7768cfc98c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.phases
    ADD CONSTRAINT fk_rails_7768cfc98c FOREIGN KEY (phase_type_id) REFERENCES public.phase_types(id);


--
-- Name: projects_metais_projects fk_rails_7d4b01aec6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects_metais_projects
    ADD CONSTRAINT fk_rails_7d4b01aec6 FOREIGN KEY (metais_project_id) REFERENCES metais.projects(id);


--
-- Name: pages fk_rails_9214ad0f21; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pages
    ADD CONSTRAINT fk_rails_9214ad0f21 FOREIGN KEY (phase_id) REFERENCES public.phases(id);


--
-- Name: phase_revision_ratings fk_rails_9a5c0eae42; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.phase_revision_ratings
    ADD CONSTRAINT fk_rails_9a5c0eae42 FOREIGN KEY (phase_revision_id) REFERENCES public.phase_revisions(id);


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
-- Name: phase_revision_ratings fk_rails_df4b31c2b5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.phase_revision_ratings
    ADD CONSTRAINT fk_rails_df4b31c2b5 FOREIGN KEY (rating_type_id) REFERENCES public.rating_types(id);


--
-- Name: pages fk_rails_ee4b1c338f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pages
    ADD CONSTRAINT fk_rails_ee4b1c338f FOREIGN KEY (latest_revision_id) REFERENCES public.revisions(id);


--
-- Name: phase_revisions fk_rails_fb290ef702; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.phase_revisions
    ADD CONSTRAINT fk_rails_fb290ef702 FOREIGN KEY (stage_id) REFERENCES public.project_stages(id);


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
('20261121190617'),
('20261121190616'),
('20261120120000'),
('20251205131243'),
('20241212091706'),
('20240924210648'),
('20240825115911'),
('20240825111806'),
('20240823082322'),
('20240822143116'),
('20240822112026'),
('20240821212620'),
('20240821210736'),
('20240820193320'),
('20240820080303'),
('20240820080110'),
('20240731124741'),
('20240730180654'),
('20240724072736'),
('20240724071253'),
('20240716120919'),
('20240716083355'),
('20240715182749'),
('20240715181117'),
('20240715175807'),
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

