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
-- Name: codelist_investment_type; Type: TABLE; Schema: metais; Owner: -
--

CREATE TABLE metais.codelist_investment_type (
    id bigint NOT NULL,
    code character varying NOT NULL,
    nazov character varying NOT NULL,
    order_list integer NOT NULL,
    popis character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: codelist_investment_type_id_seq; Type: SEQUENCE; Schema: metais; Owner: -
--

CREATE SEQUENCE metais.codelist_investment_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: codelist_investment_type_id_seq; Type: SEQUENCE OWNED BY; Schema: metais; Owner: -
--

ALTER SEQUENCE metais.codelist_investment_type_id_seq OWNED BY metais.codelist_investment_type.id;


--
-- Name: codelist_program; Type: TABLE; Schema: metais; Owner: -
--

CREATE TABLE metais.codelist_program (
    id bigint NOT NULL,
    kod_metais character varying NOT NULL,
    nazov character varying NOT NULL,
    nazov_en character varying,
    ref_id character varying,
    zdroj character varying,
    raw_data text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    uuid character varying
);


--
-- Name: codelist_program_id_seq; Type: SEQUENCE; Schema: metais; Owner: -
--

CREATE SEQUENCE metais.codelist_program_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: codelist_program_id_seq; Type: SEQUENCE OWNED BY; Schema: metais; Owner: -
--

ALTER SEQUENCE metais.codelist_program_id_seq OWNED BY metais.codelist_program.id;


--
-- Name: codelist_project_phase; Type: TABLE; Schema: metais; Owner: -
--

CREATE TABLE metais.codelist_project_phase (
    id bigint NOT NULL,
    code character varying NOT NULL,
    nazov character varying NOT NULL,
    order_list integer NOT NULL,
    popis character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: codelist_project_phase_id_seq; Type: SEQUENCE; Schema: metais; Owner: -
--

CREATE SEQUENCE metais.codelist_project_phase_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: codelist_project_phase_id_seq; Type: SEQUENCE OWNED BY; Schema: metais; Owner: -
--

ALTER SEQUENCE metais.codelist_project_phase_id_seq OWNED BY metais.codelist_project_phase.id;


--
-- Name: codelist_project_state; Type: TABLE; Schema: metais; Owner: -
--

CREATE TABLE metais.codelist_project_state (
    id bigint NOT NULL,
    code character varying NOT NULL,
    nazov character varying NOT NULL,
    order_list integer NOT NULL,
    popis character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: codelist_project_state_id_seq; Type: SEQUENCE; Schema: metais; Owner: -
--

CREATE SEQUENCE metais.codelist_project_state_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: codelist_project_state_id_seq; Type: SEQUENCE OWNED BY; Schema: metais; Owner: -
--

ALTER SEQUENCE metais.codelist_project_state_id_seq OWNED BY metais.codelist_project_state.id;


--
-- Name: codelist_source; Type: TABLE; Schema: metais; Owner: -
--

CREATE TABLE metais.codelist_source (
    id bigint NOT NULL,
    code character varying NOT NULL,
    nazov character varying NOT NULL,
    order_list integer NOT NULL,
    popis character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: codelist_source_id_seq; Type: SEQUENCE; Schema: metais; Owner: -
--

CREATE SEQUENCE metais.codelist_source_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: codelist_source_id_seq; Type: SEQUENCE OWNED BY; Schema: metais; Owner: -
--

ALTER SEQUENCE metais.codelist_source_id_seq OWNED BY metais.codelist_source.id;


--
-- Name: isvs; Type: TABLE; Schema: metais; Owner: -
--

CREATE TABLE metais.isvs (
    id bigint NOT NULL,
    project_id bigint,
    uuid character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    latest_version_id bigint
);


--
-- Name: isvs_document_versions; Type: TABLE; Schema: metais; Owner: -
--

CREATE TABLE metais.isvs_document_versions (
    id bigint NOT NULL,
    document_id bigint NOT NULL,
    nazov character varying NOT NULL,
    kod_metais character varying NOT NULL,
    ref_id character varying NOT NULL,
    mime_type character varying,
    content_length integer,
    status character varying,
    poznamka text,
    typ_dokumentu character varying,
    filename character varying,
    metais_created_at timestamp without time zone,
    metais_updated_at timestamp without time zone,
    raw_data jsonb NOT NULL,
    raw_meta jsonb NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: isvs_document_versions_id_seq; Type: SEQUENCE; Schema: metais; Owner: -
--

CREATE SEQUENCE metais.isvs_document_versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: isvs_document_versions_id_seq; Type: SEQUENCE OWNED BY; Schema: metais; Owner: -
--

ALTER SEQUENCE metais.isvs_document_versions_id_seq OWNED BY metais.isvs_document_versions.id;


--
-- Name: isvs_documents; Type: TABLE; Schema: metais; Owner: -
--

CREATE TABLE metais.isvs_documents (
    id bigint NOT NULL,
    isvs_id bigint,
    uuid character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    latest_version_id bigint
);


--
-- Name: isvs_documents_id_seq; Type: SEQUENCE; Schema: metais; Owner: -
--

CREATE SEQUENCE metais.isvs_documents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: isvs_documents_id_seq; Type: SEQUENCE OWNED BY; Schema: metais; Owner: -
--

ALTER SEQUENCE metais.isvs_documents_id_seq OWNED BY metais.isvs_documents.id;


--
-- Name: isvs_id_seq; Type: SEQUENCE; Schema: metais; Owner: -
--

CREATE SEQUENCE metais.isvs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: isvs_id_seq; Type: SEQUENCE OWNED BY; Schema: metais; Owner: -
--

ALTER SEQUENCE metais.isvs_id_seq OWNED BY metais.isvs.id;


--
-- Name: isvs_versions; Type: TABLE; Schema: metais; Owner: -
--

CREATE TABLE metais.isvs_versions (
    id bigint NOT NULL,
    isvs_id bigint NOT NULL,
    nazov character varying NOT NULL,
    kod_metais character varying NOT NULL,
    ref_id character varying,
    popis text,
    popis_as_is text,
    poznamka text,
    zdroj character varying,
    stav_isvs character varying,
    typ_isvs character varying,
    raw_data jsonb NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    metais_created_at timestamp without time zone
);


--
-- Name: isvs_versions_id_seq; Type: SEQUENCE; Schema: metais; Owner: -
--

CREATE SEQUENCE metais.isvs_versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: isvs_versions_id_seq; Type: SEQUENCE OWNED BY; Schema: metais; Owner: -
--

ALTER SEQUENCE metais.isvs_versions_id_seq OWNED BY metais.isvs_versions.id;


--
-- Name: project_changes; Type: TABLE; Schema: metais; Owner: -
--

CREATE TABLE metais.project_changes (
    id bigint NOT NULL,
    project_version_id bigint NOT NULL,
    field character varying,
    old_value character varying,
    new_value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: project_changes_id_seq; Type: SEQUENCE; Schema: metais; Owner: -
--

CREATE SEQUENCE metais.project_changes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: project_changes_id_seq; Type: SEQUENCE OWNED BY; Schema: metais; Owner: -
--

ALTER SEQUENCE metais.project_changes_id_seq OWNED BY metais.project_changes.id;


--
-- Name: project_document_versions; Type: TABLE; Schema: metais; Owner: -
--

CREATE TABLE metais.project_document_versions (
    id bigint NOT NULL,
    document_id bigint NOT NULL,
    nazov character varying NOT NULL,
    kod_metais character varying NOT NULL,
    ref_id character varying NOT NULL,
    mime_type character varying,
    content_length integer,
    status character varying,
    poznamka text,
    typ_dokumentu character varying,
    filename character varying,
    metais_created_at timestamp without time zone,
    metais_updated_at timestamp without time zone,
    raw_data jsonb NOT NULL,
    raw_meta jsonb NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: project_document_versions_id_seq; Type: SEQUENCE; Schema: metais; Owner: -
--

CREATE SEQUENCE metais.project_document_versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: project_document_versions_id_seq; Type: SEQUENCE OWNED BY; Schema: metais; Owner: -
--

ALTER SEQUENCE metais.project_document_versions_id_seq OWNED BY metais.project_document_versions.id;


--
-- Name: project_documents; Type: TABLE; Schema: metais; Owner: -
--

CREATE TABLE metais.project_documents (
    id bigint NOT NULL,
    project_id bigint,
    uuid character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    latest_version_id bigint
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
-- Name: project_versions; Type: TABLE; Schema: metais; Owner: -
--

CREATE TABLE metais.project_versions (
    id bigint NOT NULL,
    project_id bigint NOT NULL,
    nazov character varying NOT NULL,
    kod_metais character varying NOT NULL,
    typ_investicie character varying,
    prijimatel character varying,
    faza_projektu character varying,
    program character varying,
    popis text,
    datum_zacatia timestamp without time zone,
    termin_ukoncenia timestamp without time zone,
    schvalovaci_proces character varying,
    zdroj character varying,
    financna_skupina character varying,
    suma_vydavkov numeric(15,2),
    rocne_naklady numeric(15,2),
    ref_id character varying,
    status character varying,
    zmena_stavu timestamp without time zone,
    schvalene_rocne_naklady numeric(15,2),
    schvaleny_rozpocet numeric(15,2),
    datum_nfp timestamp without time zone,
    link_nfp character varying,
    vyhlasenie_vo timestamp without time zone,
    vo character varying,
    zmluva_o_dielo timestamp without time zone,
    zmluva_o_dielo_crz character varying,
    raw_data jsonb NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    metais_created_at timestamp without time zone
);


--
-- Name: project_versions_id_seq; Type: SEQUENCE; Schema: metais; Owner: -
--

CREATE SEQUENCE metais.project_versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: project_versions_id_seq; Type: SEQUENCE OWNED BY; Schema: metais; Owner: -
--

ALTER SEQUENCE metais.project_versions_id_seq OWNED BY metais.project_versions.id;


--
-- Name: projects; Type: TABLE; Schema: metais; Owner: -
--

CREATE TABLE metais.projects (
    id bigint NOT NULL,
    uuid character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    latest_version_id bigint
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
-- Name: codelist_investment_type id; Type: DEFAULT; Schema: metais; Owner: -
--

ALTER TABLE ONLY metais.codelist_investment_type ALTER COLUMN id SET DEFAULT nextval('metais.codelist_investment_type_id_seq'::regclass);


--
-- Name: codelist_program id; Type: DEFAULT; Schema: metais; Owner: -
--

ALTER TABLE ONLY metais.codelist_program ALTER COLUMN id SET DEFAULT nextval('metais.codelist_program_id_seq'::regclass);


--
-- Name: codelist_project_phase id; Type: DEFAULT; Schema: metais; Owner: -
--

ALTER TABLE ONLY metais.codelist_project_phase ALTER COLUMN id SET DEFAULT nextval('metais.codelist_project_phase_id_seq'::regclass);


--
-- Name: codelist_project_state id; Type: DEFAULT; Schema: metais; Owner: -
--

ALTER TABLE ONLY metais.codelist_project_state ALTER COLUMN id SET DEFAULT nextval('metais.codelist_project_state_id_seq'::regclass);


--
-- Name: codelist_source id; Type: DEFAULT; Schema: metais; Owner: -
--

ALTER TABLE ONLY metais.codelist_source ALTER COLUMN id SET DEFAULT nextval('metais.codelist_source_id_seq'::regclass);


--
-- Name: isvs id; Type: DEFAULT; Schema: metais; Owner: -
--

ALTER TABLE ONLY metais.isvs ALTER COLUMN id SET DEFAULT nextval('metais.isvs_id_seq'::regclass);


--
-- Name: isvs_document_versions id; Type: DEFAULT; Schema: metais; Owner: -
--

ALTER TABLE ONLY metais.isvs_document_versions ALTER COLUMN id SET DEFAULT nextval('metais.isvs_document_versions_id_seq'::regclass);


--
-- Name: isvs_documents id; Type: DEFAULT; Schema: metais; Owner: -
--

ALTER TABLE ONLY metais.isvs_documents ALTER COLUMN id SET DEFAULT nextval('metais.isvs_documents_id_seq'::regclass);


--
-- Name: isvs_versions id; Type: DEFAULT; Schema: metais; Owner: -
--

ALTER TABLE ONLY metais.isvs_versions ALTER COLUMN id SET DEFAULT nextval('metais.isvs_versions_id_seq'::regclass);


--
-- Name: project_changes id; Type: DEFAULT; Schema: metais; Owner: -
--

ALTER TABLE ONLY metais.project_changes ALTER COLUMN id SET DEFAULT nextval('metais.project_changes_id_seq'::regclass);


--
-- Name: project_document_versions id; Type: DEFAULT; Schema: metais; Owner: -
--

ALTER TABLE ONLY metais.project_document_versions ALTER COLUMN id SET DEFAULT nextval('metais.project_document_versions_id_seq'::regclass);


--
-- Name: project_documents id; Type: DEFAULT; Schema: metais; Owner: -
--

ALTER TABLE ONLY metais.project_documents ALTER COLUMN id SET DEFAULT nextval('metais.project_documents_id_seq'::regclass);


--
-- Name: project_versions id; Type: DEFAULT; Schema: metais; Owner: -
--

ALTER TABLE ONLY metais.project_versions ALTER COLUMN id SET DEFAULT nextval('metais.project_versions_id_seq'::regclass);


--
-- Name: projects id; Type: DEFAULT; Schema: metais; Owner: -
--

ALTER TABLE ONLY metais.projects ALTER COLUMN id SET DEFAULT nextval('metais.projects_id_seq'::regclass);


--
-- Name: codelist_investment_type codelist_investment_type_pkey; Type: CONSTRAINT; Schema: metais; Owner: -
--

ALTER TABLE ONLY metais.codelist_investment_type
    ADD CONSTRAINT codelist_investment_type_pkey PRIMARY KEY (id);


--
-- Name: codelist_program codelist_program_pkey; Type: CONSTRAINT; Schema: metais; Owner: -
--

ALTER TABLE ONLY metais.codelist_program
    ADD CONSTRAINT codelist_program_pkey PRIMARY KEY (id);


--
-- Name: codelist_project_phase codelist_project_phase_pkey; Type: CONSTRAINT; Schema: metais; Owner: -
--

ALTER TABLE ONLY metais.codelist_project_phase
    ADD CONSTRAINT codelist_project_phase_pkey PRIMARY KEY (id);


--
-- Name: codelist_project_state codelist_project_state_pkey; Type: CONSTRAINT; Schema: metais; Owner: -
--

ALTER TABLE ONLY metais.codelist_project_state
    ADD CONSTRAINT codelist_project_state_pkey PRIMARY KEY (id);


--
-- Name: codelist_source codelist_source_pkey; Type: CONSTRAINT; Schema: metais; Owner: -
--

ALTER TABLE ONLY metais.codelist_source
    ADD CONSTRAINT codelist_source_pkey PRIMARY KEY (id);


--
-- Name: isvs_document_versions isvs_document_versions_pkey; Type: CONSTRAINT; Schema: metais; Owner: -
--

ALTER TABLE ONLY metais.isvs_document_versions
    ADD CONSTRAINT isvs_document_versions_pkey PRIMARY KEY (id);


--
-- Name: isvs_documents isvs_documents_pkey; Type: CONSTRAINT; Schema: metais; Owner: -
--

ALTER TABLE ONLY metais.isvs_documents
    ADD CONSTRAINT isvs_documents_pkey PRIMARY KEY (id);


--
-- Name: isvs isvs_pkey; Type: CONSTRAINT; Schema: metais; Owner: -
--

ALTER TABLE ONLY metais.isvs
    ADD CONSTRAINT isvs_pkey PRIMARY KEY (id);


--
-- Name: isvs_versions isvs_versions_pkey; Type: CONSTRAINT; Schema: metais; Owner: -
--

ALTER TABLE ONLY metais.isvs_versions
    ADD CONSTRAINT isvs_versions_pkey PRIMARY KEY (id);


--
-- Name: project_changes project_changes_pkey; Type: CONSTRAINT; Schema: metais; Owner: -
--

ALTER TABLE ONLY metais.project_changes
    ADD CONSTRAINT project_changes_pkey PRIMARY KEY (id);


--
-- Name: project_document_versions project_document_versions_pkey; Type: CONSTRAINT; Schema: metais; Owner: -
--

ALTER TABLE ONLY metais.project_document_versions
    ADD CONSTRAINT project_document_versions_pkey PRIMARY KEY (id);


--
-- Name: project_documents project_documents_pkey; Type: CONSTRAINT; Schema: metais; Owner: -
--

ALTER TABLE ONLY metais.project_documents
    ADD CONSTRAINT project_documents_pkey PRIMARY KEY (id);


--
-- Name: project_versions project_versions_pkey; Type: CONSTRAINT; Schema: metais; Owner: -
--

ALTER TABLE ONLY metais.project_versions
    ADD CONSTRAINT project_versions_pkey PRIMARY KEY (id);


--
-- Name: projects projects_pkey; Type: CONSTRAINT; Schema: metais; Owner: -
--

ALTER TABLE ONLY metais.projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (id);


--
-- Name: index_metais.codelist_investment_type_on_code; Type: INDEX; Schema: metais; Owner: -
--

CREATE INDEX "index_metais.codelist_investment_type_on_code" ON metais.codelist_investment_type USING btree (code);


--
-- Name: index_metais.codelist_program_on_kod_metais; Type: INDEX; Schema: metais; Owner: -
--

CREATE INDEX "index_metais.codelist_program_on_kod_metais" ON metais.codelist_program USING btree (kod_metais);


--
-- Name: index_metais.codelist_project_phase_on_code; Type: INDEX; Schema: metais; Owner: -
--

CREATE INDEX "index_metais.codelist_project_phase_on_code" ON metais.codelist_project_phase USING btree (code);


--
-- Name: index_metais.codelist_project_state_on_code; Type: INDEX; Schema: metais; Owner: -
--

CREATE INDEX "index_metais.codelist_project_state_on_code" ON metais.codelist_project_state USING btree (code);


--
-- Name: index_metais.codelist_source_on_code; Type: INDEX; Schema: metais; Owner: -
--

CREATE INDEX "index_metais.codelist_source_on_code" ON metais.codelist_source USING btree (code);


--
-- Name: index_metais.isvs_document_versions_on_document_id; Type: INDEX; Schema: metais; Owner: -
--

CREATE INDEX "index_metais.isvs_document_versions_on_document_id" ON metais.isvs_document_versions USING btree (document_id);


--
-- Name: index_metais.isvs_documents_on_isvs_id; Type: INDEX; Schema: metais; Owner: -
--

CREATE INDEX "index_metais.isvs_documents_on_isvs_id" ON metais.isvs_documents USING btree (isvs_id);


--
-- Name: index_metais.isvs_documents_on_latest_version_id; Type: INDEX; Schema: metais; Owner: -
--

CREATE INDEX "index_metais.isvs_documents_on_latest_version_id" ON metais.isvs_documents USING btree (latest_version_id);


--
-- Name: index_metais.isvs_documents_on_uuid; Type: INDEX; Schema: metais; Owner: -
--

CREATE INDEX "index_metais.isvs_documents_on_uuid" ON metais.isvs_documents USING btree (uuid);


--
-- Name: index_metais.isvs_on_latest_version_id; Type: INDEX; Schema: metais; Owner: -
--

CREATE INDEX "index_metais.isvs_on_latest_version_id" ON metais.isvs USING btree (latest_version_id);


--
-- Name: index_metais.isvs_on_project_id; Type: INDEX; Schema: metais; Owner: -
--

CREATE INDEX "index_metais.isvs_on_project_id" ON metais.isvs USING btree (project_id);


--
-- Name: index_metais.isvs_on_uuid; Type: INDEX; Schema: metais; Owner: -
--

CREATE INDEX "index_metais.isvs_on_uuid" ON metais.isvs USING btree (uuid);


--
-- Name: index_metais.isvs_versions_on_isvs_id; Type: INDEX; Schema: metais; Owner: -
--

CREATE INDEX "index_metais.isvs_versions_on_isvs_id" ON metais.isvs_versions USING btree (isvs_id);


--
-- Name: index_metais.project_changes_on_project_version_id; Type: INDEX; Schema: metais; Owner: -
--

CREATE INDEX "index_metais.project_changes_on_project_version_id" ON metais.project_changes USING btree (project_version_id);


--
-- Name: index_metais.project_document_versions_on_document_id; Type: INDEX; Schema: metais; Owner: -
--

CREATE INDEX "index_metais.project_document_versions_on_document_id" ON metais.project_document_versions USING btree (document_id);


--
-- Name: index_metais.project_documents_on_latest_version_id; Type: INDEX; Schema: metais; Owner: -
--

CREATE INDEX "index_metais.project_documents_on_latest_version_id" ON metais.project_documents USING btree (latest_version_id);


--
-- Name: index_metais.project_documents_on_project_id; Type: INDEX; Schema: metais; Owner: -
--

CREATE INDEX "index_metais.project_documents_on_project_id" ON metais.project_documents USING btree (project_id);


--
-- Name: index_metais.project_documents_on_uuid; Type: INDEX; Schema: metais; Owner: -
--

CREATE INDEX "index_metais.project_documents_on_uuid" ON metais.project_documents USING btree (uuid);


--
-- Name: index_metais.project_versions_on_project_id; Type: INDEX; Schema: metais; Owner: -
--

CREATE INDEX "index_metais.project_versions_on_project_id" ON metais.project_versions USING btree (project_id);


--
-- Name: index_metais.projects_on_latest_version_id; Type: INDEX; Schema: metais; Owner: -
--

CREATE INDEX "index_metais.projects_on_latest_version_id" ON metais.projects USING btree (latest_version_id);


--
-- Name: index_metais.projects_on_uuid; Type: INDEX; Schema: metais; Owner: -
--

CREATE INDEX "index_metais.projects_on_uuid" ON metais.projects USING btree (uuid);


--
-- Name: projects fk_rails_1925410d1c; Type: FK CONSTRAINT; Schema: metais; Owner: -
--

ALTER TABLE ONLY metais.projects
    ADD CONSTRAINT fk_rails_1925410d1c FOREIGN KEY (latest_version_id) REFERENCES metais.project_versions(id);


--
-- Name: isvs_documents fk_rails_2926a855af; Type: FK CONSTRAINT; Schema: metais; Owner: -
--

ALTER TABLE ONLY metais.isvs_documents
    ADD CONSTRAINT fk_rails_2926a855af FOREIGN KEY (isvs_id) REFERENCES metais.isvs(id);


--
-- Name: isvs_documents fk_rails_5d253a31fc; Type: FK CONSTRAINT; Schema: metais; Owner: -
--

ALTER TABLE ONLY metais.isvs_documents
    ADD CONSTRAINT fk_rails_5d253a31fc FOREIGN KEY (latest_version_id) REFERENCES metais.isvs_document_versions(id);


--
-- Name: project_versions fk_rails_819be9e3a6; Type: FK CONSTRAINT; Schema: metais; Owner: -
--

ALTER TABLE ONLY metais.project_versions
    ADD CONSTRAINT fk_rails_819be9e3a6 FOREIGN KEY (project_id) REFERENCES metais.projects(id);


--
-- Name: project_documents fk_rails_868923b92d; Type: FK CONSTRAINT; Schema: metais; Owner: -
--

ALTER TABLE ONLY metais.project_documents
    ADD CONSTRAINT fk_rails_868923b92d FOREIGN KEY (project_id) REFERENCES metais.projects(id);


--
-- Name: isvs fk_rails_8befaa8056; Type: FK CONSTRAINT; Schema: metais; Owner: -
--

ALTER TABLE ONLY metais.isvs
    ADD CONSTRAINT fk_rails_8befaa8056 FOREIGN KEY (project_id) REFERENCES metais.projects(id);


--
-- Name: project_documents fk_rails_9352955d7e; Type: FK CONSTRAINT; Schema: metais; Owner: -
--

ALTER TABLE ONLY metais.project_documents
    ADD CONSTRAINT fk_rails_9352955d7e FOREIGN KEY (latest_version_id) REFERENCES metais.project_document_versions(id);


--
-- Name: project_changes fk_rails_a57192e308; Type: FK CONSTRAINT; Schema: metais; Owner: -
--

ALTER TABLE ONLY metais.project_changes
    ADD CONSTRAINT fk_rails_a57192e308 FOREIGN KEY (project_version_id) REFERENCES metais.project_versions(id);


--
-- Name: project_document_versions fk_rails_ae50626673; Type: FK CONSTRAINT; Schema: metais; Owner: -
--

ALTER TABLE ONLY metais.project_document_versions
    ADD CONSTRAINT fk_rails_ae50626673 FOREIGN KEY (document_id) REFERENCES metais.project_documents(id);


--
-- Name: isvs_document_versions fk_rails_affcff3ef1; Type: FK CONSTRAINT; Schema: metais; Owner: -
--

ALTER TABLE ONLY metais.isvs_document_versions
    ADD CONSTRAINT fk_rails_affcff3ef1 FOREIGN KEY (document_id) REFERENCES metais.isvs_documents(id);


--
-- Name: isvs fk_rails_be183a92d5; Type: FK CONSTRAINT; Schema: metais; Owner: -
--

ALTER TABLE ONLY metais.isvs
    ADD CONSTRAINT fk_rails_be183a92d5 FOREIGN KEY (latest_version_id) REFERENCES metais.isvs_versions(id);


--
-- Name: isvs_versions fk_rails_ce75fc7d23; Type: FK CONSTRAINT; Schema: metais; Owner: -
--

ALTER TABLE ONLY metais.isvs_versions
    ADD CONSTRAINT fk_rails_ce75fc7d23 FOREIGN KEY (isvs_id) REFERENCES metais.isvs(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

