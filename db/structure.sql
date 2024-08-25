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
    description character varying
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
    description character varying,
    budget character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    body_html character varying,
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
-- Name: projects2; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.projects2 (
    id bigint NOT NULL,
    metais_project_id bigint NOT NULL,
    evaluation_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: projects2_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.projects2_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: projects2_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.projects2_id_seq OWNED BY public.projects2.id;


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
-- Name: que_jobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.que_jobs (
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

COMMENT ON TABLE public.que_jobs IS '3';


--
-- Name: que_jobs_job_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.que_jobs_job_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: que_jobs_job_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.que_jobs_job_id_seq OWNED BY public.que_jobs.job_id;


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
-- Name: projects2 id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects2 ALTER COLUMN id SET DEFAULT nextval('public.projects2_id_seq'::regclass);


--
-- Name: que_jobs job_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.que_jobs ALTER COLUMN job_id SET DEFAULT nextval('public.que_jobs_job_id_seq'::regclass);


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
-- Name: projects2 projects2_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects2
    ADD CONSTRAINT projects2_pkey PRIMARY KEY (id);


--
-- Name: projects projects_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (id);


--
-- Name: que_jobs que_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.que_jobs
    ADD CONSTRAINT que_jobs_pkey PRIMARY KEY (queue, priority, run_at, job_id);


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
-- Name: index_projects2_on_evaluation_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_projects2_on_evaluation_id ON public.projects2 USING btree (evaluation_id);


--
-- Name: index_projects2_on_metais_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_projects2_on_metais_project_id ON public.projects2 USING btree (metais_project_id);


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
-- Name: projects2 fk_rails_167b3161dd; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects2
    ADD CONSTRAINT fk_rails_167b3161dd FOREIGN KEY (evaluation_id) REFERENCES public.projects(id);


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
('20171110114322'),
('20180531154604'),
('20180531162036'),
('20180531165022'),
('20180620144613'),
('20220306165121'),
('20240609101956'),
('20240609114857'),
('20240609120517'),
('20240610100714'),
('20240610100956'),
('20240610102411'),
('20240610110713'),
('20240611122213'),
('20240611153648'),
('20240611153759'),
('20240613113501'),
('20240621112043'),
('20240715175807'),
('20240715181117'),
('20240715182749'),
('20240716083355'),
('20240716120919'),
('20240724071253'),
('20240724072736'),
('20240730180654'),
('20240731124741'),
('20240801081124'),
('20240820080110'),
('20240820080303'),
('20240821210736'),
('20240821212620'),
('20240822112026'),
('20240822143116'),
('20240823082322'),
('20240825111806');