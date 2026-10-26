--
-- PostgreSQL database dump
--

\restrict n8AB8KqoVKQRsfHf39aqSE69bYMk7JBAvUdCBNYJVLlQDaf6YvaaHz7FMip1Lkz

-- Dumped from database version 18.6
-- Dumped by pg_dump version 18.6

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: auditoria; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auditoria (
    id bigint NOT NULL,
    usuario_id bigint,
    tabla character varying(255) NOT NULL,
    registro_id bigint,
    accion character varying(255) NOT NULL,
    datos_antes json,
    datos_despues json,
    ip character varying(45),
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    CONSTRAINT auditoria_accion_check CHECK (((accion)::text = ANY ((ARRAY['crear'::character varying, 'actualizar'::character varying, 'eliminar'::character varying])::text[])))
);


ALTER TABLE public.auditoria OWNER TO postgres;

--
-- Name: auditoria_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auditoria_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.auditoria_id_seq OWNER TO postgres;

--
-- Name: auditoria_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auditoria_id_seq OWNED BY public.auditoria.id;


--
-- Name: cache; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cache (
    key character varying(255) NOT NULL,
    value text NOT NULL,
    expiration integer NOT NULL
);


ALTER TABLE public.cache OWNER TO postgres;

--
-- Name: cache_locks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cache_locks (
    key character varying(255) NOT NULL,
    owner character varying(255) NOT NULL,
    expiration integer NOT NULL
);


ALTER TABLE public.cache_locks OWNER TO postgres;

--
-- Name: contratos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.contratos (
    id bigint NOT NULL,
    locatario_id bigint NOT NULL,
    espacio_id bigint NOT NULL,
    codigo character varying(255) NOT NULL,
    fecha_inicio date NOT NULL,
    fecha_fin date NOT NULL,
    monto_mensual numeric(12,2) NOT NULL,
    estado character varying(255) DEFAULT 'Vigente'::character varying NOT NULL,
    observaciones text,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    CONSTRAINT contratos_estado_check CHECK (((estado)::text = ANY ((ARRAY['Vigente'::character varying, 'Por vencer'::character varying, 'Vencido'::character varying, 'Rescindido'::character varying])::text[])))
);


ALTER TABLE public.contratos OWNER TO postgres;

--
-- Name: contratos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.contratos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.contratos_id_seq OWNER TO postgres;

--
-- Name: contratos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.contratos_id_seq OWNED BY public.contratos.id;


--
-- Name: espacios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.espacios (
    id bigint NOT NULL,
    codigo character varying(255) NOT NULL,
    piso character varying(255) NOT NULL,
    zona character varying(255),
    area_m2 numeric(8,2),
    coord_x numeric(10,2),
    coord_y numeric(10,2),
    estado character varying(255) DEFAULT 'Disponible'::character varying NOT NULL,
    locatario_id bigint,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    CONSTRAINT espacios_estado_check CHECK (((estado)::text = ANY ((ARRAY['Disponible'::character varying, 'Ocupado'::character varying, 'Mantenimiento'::character varying])::text[])))
);


ALTER TABLE public.espacios OWNER TO postgres;

--
-- Name: espacios_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.espacios_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.espacios_id_seq OWNER TO postgres;

--
-- Name: espacios_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.espacios_id_seq OWNED BY public.espacios.id;


--
-- Name: failed_jobs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.failed_jobs (
    id bigint NOT NULL,
    uuid character varying(255) NOT NULL,
    connection text NOT NULL,
    queue text NOT NULL,
    payload text NOT NULL,
    exception text NOT NULL,
    failed_at timestamp(0) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.failed_jobs OWNER TO postgres;

--
-- Name: failed_jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.failed_jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.failed_jobs_id_seq OWNER TO postgres;

--
-- Name: failed_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.failed_jobs_id_seq OWNED BY public.failed_jobs.id;


--
-- Name: incidencias; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.incidencias (
    id bigint NOT NULL,
    titulo character varying(255) NOT NULL,
    descripcion text NOT NULL,
    espacio_id bigint,
    reportado_por bigint,
    asignado_a bigint,
    prioridad character varying(255) DEFAULT 'Media'::character varying NOT NULL,
    estado character varying(255) DEFAULT 'Pendiente'::character varying NOT NULL,
    fecha_cierre timestamp(0) without time zone,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    CONSTRAINT incidencias_estado_check CHECK (((estado)::text = ANY ((ARRAY['Pendiente'::character varying, 'Asignada'::character varying, 'En proceso'::character varying, 'Resuelta'::character varying, 'Cerrada'::character varying])::text[]))),
    CONSTRAINT incidencias_prioridad_check CHECK (((prioridad)::text = ANY ((ARRAY['Baja'::character varying, 'Media'::character varying, 'Alta'::character varying, 'Critica'::character varying])::text[])))
);


ALTER TABLE public.incidencias OWNER TO postgres;

--
-- Name: incidencias_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.incidencias_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.incidencias_id_seq OWNER TO postgres;

--
-- Name: incidencias_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.incidencias_id_seq OWNED BY public.incidencias.id;


--
-- Name: job_batches; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.job_batches (
    id character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    total_jobs integer NOT NULL,
    pending_jobs integer NOT NULL,
    failed_jobs integer NOT NULL,
    failed_job_ids text NOT NULL,
    options text,
    cancelled_at integer,
    created_at integer NOT NULL,
    finished_at integer
);


ALTER TABLE public.job_batches OWNER TO postgres;

--
-- Name: jobs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.jobs (
    id bigint NOT NULL,
    queue character varying(255) NOT NULL,
    payload text NOT NULL,
    attempts smallint NOT NULL,
    reserved_at integer,
    available_at integer NOT NULL,
    created_at integer NOT NULL
);


ALTER TABLE public.jobs OWNER TO postgres;

--
-- Name: jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.jobs_id_seq OWNER TO postgres;

--
-- Name: jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.jobs_id_seq OWNED BY public.jobs.id;


--
-- Name: locatarios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.locatarios (
    id bigint NOT NULL,
    nombre character varying(255) NOT NULL,
    nit character varying(255) NOT NULL,
    representante character varying(255),
    telefono character varying(255),
    email character varying(255),
    rubro character varying(255),
    estado character varying(255) DEFAULT 'Activo'::character varying NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    deleted_at timestamp(0) without time zone,
    CONSTRAINT locatarios_estado_check CHECK (((estado)::text = ANY ((ARRAY['Activo'::character varying, 'Inactivo'::character varying, 'Suspendido'::character varying])::text[])))
);


ALTER TABLE public.locatarios OWNER TO postgres;

--
-- Name: locatarios_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.locatarios_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.locatarios_id_seq OWNER TO postgres;

--
-- Name: locatarios_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.locatarios_id_seq OWNED BY public.locatarios.id;


--
-- Name: migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.migrations (
    id integer NOT NULL,
    migration character varying(255) NOT NULL,
    batch integer NOT NULL
);


ALTER TABLE public.migrations OWNER TO postgres;

--
-- Name: migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.migrations_id_seq OWNER TO postgres;

--
-- Name: migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.migrations_id_seq OWNED BY public.migrations.id;


--
-- Name: password_reset_tokens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.password_reset_tokens (
    email character varying(255) NOT NULL,
    token character varying(255) NOT NULL,
    created_at timestamp(0) without time zone
);


ALTER TABLE public.password_reset_tokens OWNER TO postgres;

--
-- Name: sessions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sessions (
    id character varying(255) NOT NULL,
    user_id bigint,
    ip_address character varying(45),
    user_agent text,
    payload text NOT NULL,
    last_activity integer NOT NULL
);


ALTER TABLE public.sessions OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    email_verified_at timestamp(0) without time zone,
    password character varying(255) NOT NULL,
    remember_token character varying(100),
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    role character varying(255) DEFAULT 'Operador'::character varying NOT NULL,
    activo boolean DEFAULT true NOT NULL,
    CONSTRAINT users_role_check CHECK (((role)::text = ANY ((ARRAY['Administrador'::character varying, 'Supervisor'::character varying, 'Operador'::character varying, 'Seguridad'::character varying, 'Locatario'::character varying])::text[])))
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: auditoria id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auditoria ALTER COLUMN id SET DEFAULT nextval('public.auditoria_id_seq'::regclass);


--
-- Name: contratos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contratos ALTER COLUMN id SET DEFAULT nextval('public.contratos_id_seq'::regclass);


--
-- Name: espacios id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.espacios ALTER COLUMN id SET DEFAULT nextval('public.espacios_id_seq'::regclass);


--
-- Name: failed_jobs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.failed_jobs ALTER COLUMN id SET DEFAULT nextval('public.failed_jobs_id_seq'::regclass);


--
-- Name: incidencias id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.incidencias ALTER COLUMN id SET DEFAULT nextval('public.incidencias_id_seq'::regclass);


--
-- Name: jobs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jobs ALTER COLUMN id SET DEFAULT nextval('public.jobs_id_seq'::regclass);


--
-- Name: locatarios id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.locatarios ALTER COLUMN id SET DEFAULT nextval('public.locatarios_id_seq'::regclass);


--
-- Name: migrations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.migrations ALTER COLUMN id SET DEFAULT nextval('public.migrations_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: auditoria; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auditoria (id, usuario_id, tabla, registro_id, accion, datos_antes, datos_despues, ip, created_at, updated_at) FROM stdin;
1	\N	locatarios	4	crear	\N	{"nombre":"Locatario Ropa","nit":"NIT-0001","representante":"Rep Ropa","telefono":"74264612","email":"ropa@caparazon.bo","rubro":"Ropa","estado":"Activo","updated_at":"2026-10-26 06:25:28","created_at":"2026-10-26 06:25:28","id":4}	127.0.0.1	2026-10-26 06:25:28	2026-10-26 06:25:28
2	\N	locatarios	5	crear	\N	{"nombre":"Locatario Comida","nit":"NIT-0002","representante":"Rep Comida","telefono":"78321640","email":"comida@caparazon.bo","rubro":"Comida","estado":"Activo","updated_at":"2026-10-26 06:25:28","created_at":"2026-10-26 06:25:28","id":5}	127.0.0.1	2026-10-26 06:25:28	2026-10-26 06:25:28
3	\N	locatarios	6	crear	\N	{"nombre":"Locatario Tecnolog\\u00eda","nit":"NIT-0003","representante":"Rep Tecnolog\\u00eda","telefono":"74269800","email":"tecnolog\\u00eda@caparazon.bo","rubro":"Tecnolog\\u00eda","estado":"Activo","updated_at":"2026-10-26 06:25:28","created_at":"2026-10-26 06:25:28","id":6}	127.0.0.1	2026-10-26 06:25:28	2026-10-26 06:25:28
4	\N	locatarios	7	crear	\N	{"nombre":"Locatario Juguetes","nit":"NIT-0004","representante":"Rep Juguetes","telefono":"76621624","email":"juguetes@caparazon.bo","rubro":"Juguetes","estado":"Activo","updated_at":"2026-10-26 06:25:28","created_at":"2026-10-26 06:25:28","id":7}	127.0.0.1	2026-10-26 06:25:28	2026-10-26 06:25:28
5	\N	locatarios	8	crear	\N	{"nombre":"Locatario Calzado","nit":"NIT-0005","representante":"Rep Calzado","telefono":"73346691","email":"calzado@caparazon.bo","rubro":"Calzado","estado":"Activo","updated_at":"2026-10-26 06:25:28","created_at":"2026-10-26 06:25:28","id":8}	127.0.0.1	2026-10-26 06:25:28	2026-10-26 06:25:28
6	\N	locatarios	9	crear	\N	{"nombre":"Locatario Cosm\\u00e9ticos","nit":"NIT-0006","representante":"Rep Cosm\\u00e9ticos","telefono":"75084614","email":"cosm\\u00e9ticos@caparazon.bo","rubro":"Cosm\\u00e9ticos","estado":"Activo","updated_at":"2026-10-26 06:25:28","created_at":"2026-10-26 06:25:28","id":9}	127.0.0.1	2026-10-26 06:25:28	2026-10-26 06:25:28
7	\N	locatarios	10	crear	\N	{"nombre":"Locatario Librer\\u00eda","nit":"NIT-0007","representante":"Rep Librer\\u00eda","telefono":"75183479","email":"librer\\u00eda@caparazon.bo","rubro":"Librer\\u00eda","estado":"Activo","updated_at":"2026-10-26 06:25:28","created_at":"2026-10-26 06:25:28","id":10}	127.0.0.1	2026-10-26 06:25:28	2026-10-26 06:25:28
8	\N	locatarios	11	crear	\N	{"nombre":"Locatario Deportes","nit":"NIT-0008","representante":"Rep Deportes","telefono":"72231893","email":"deportes@caparazon.bo","rubro":"Deportes","estado":"Activo","updated_at":"2026-10-26 06:25:28","created_at":"2026-10-26 06:25:28","id":11}	127.0.0.1	2026-10-26 06:25:28	2026-10-26 06:25:28
9	\N	locatarios	12	crear	\N	{"nombre":"Locatario Mascotas","nit":"NIT-0009","representante":"Rep Mascotas","telefono":"75835459","email":"mascotas@caparazon.bo","rubro":"Mascotas","estado":"Activo","updated_at":"2026-10-26 06:25:28","created_at":"2026-10-26 06:25:28","id":12}	127.0.0.1	2026-10-26 06:25:28	2026-10-26 06:25:28
10	\N	locatarios	13	crear	\N	{"nombre":"Locatario Servicios","nit":"NIT-0010","representante":"Rep Servicios","telefono":"79568983","email":"servicios@caparazon.bo","rubro":"Servicios","estado":"Activo","updated_at":"2026-10-26 06:25:28","created_at":"2026-10-26 06:25:28","id":13}	127.0.0.1	2026-10-26 06:25:28	2026-10-26 06:25:28
11	\N	espacios	1	crear	\N	{"codigo":"E-01","piso":"Planta Baja","zona":"Zona 1","area_m2":78,"coord_x":216,"coord_y":306,"estado":"Disponible","updated_at":"2026-10-26 06:25:28","created_at":"2026-10-26 06:25:28","id":1}	127.0.0.1	2026-10-26 06:25:28	2026-10-26 06:25:28
12	\N	espacios	2	crear	\N	{"codigo":"E-02","piso":"Planta Baja","zona":"Zona 2","area_m2":51,"coord_x":385,"coord_y":387,"estado":"Disponible","updated_at":"2026-10-26 06:25:28","created_at":"2026-10-26 06:25:28","id":2}	127.0.0.1	2026-10-26 06:25:28	2026-10-26 06:25:28
13	\N	espacios	3	crear	\N	{"codigo":"E-03","piso":"Planta Baja","zona":"Zona 3","area_m2":70,"coord_x":194,"coord_y":206,"estado":"Disponible","updated_at":"2026-10-26 06:25:28","created_at":"2026-10-26 06:25:28","id":3}	127.0.0.1	2026-10-26 06:25:28	2026-10-26 06:25:28
14	\N	espacios	4	crear	\N	{"codigo":"E-04","piso":"Planta Baja","zona":"Zona 4","area_m2":51,"coord_x":165,"coord_y":178,"estado":"Disponible","updated_at":"2026-10-26 06:25:28","created_at":"2026-10-26 06:25:28","id":4}	127.0.0.1	2026-10-26 06:25:28	2026-10-26 06:25:28
15	\N	espacios	5	crear	\N	{"codigo":"E-05","piso":"Planta Baja","zona":"Zona 5","area_m2":77,"coord_x":480,"coord_y":164,"estado":"Disponible","updated_at":"2026-10-26 06:25:28","created_at":"2026-10-26 06:25:28","id":5}	127.0.0.1	2026-10-26 06:25:28	2026-10-26 06:25:28
16	\N	espacios	6	crear	\N	{"codigo":"E-06","piso":"Planta Baja","zona":"Zona 6","area_m2":48,"coord_x":445,"coord_y":117,"estado":"Disponible","updated_at":"2026-10-26 06:25:28","created_at":"2026-10-26 06:25:28","id":6}	127.0.0.1	2026-10-26 06:25:28	2026-10-26 06:25:28
17	\N	espacios	7	crear	\N	{"codigo":"E-07","piso":"Planta Baja","zona":"Zona 7","area_m2":40,"coord_x":789,"coord_y":438,"estado":"Disponible","updated_at":"2026-10-26 06:25:28","created_at":"2026-10-26 06:25:28","id":7}	127.0.0.1	2026-10-26 06:25:28	2026-10-26 06:25:28
18	\N	espacios	8	crear	\N	{"codigo":"E-08","piso":"Piso 1","zona":"Zona 1","area_m2":26,"coord_x":647,"coord_y":385,"estado":"Disponible","updated_at":"2026-10-26 06:25:28","created_at":"2026-10-26 06:25:28","id":8}	127.0.0.1	2026-10-26 06:25:28	2026-10-26 06:25:28
19	\N	espacios	9	crear	\N	{"codigo":"E-09","piso":"Piso 1","zona":"Zona 2","area_m2":69,"coord_x":763,"coord_y":304,"estado":"Disponible","updated_at":"2026-10-26 06:25:28","created_at":"2026-10-26 06:25:28","id":9}	127.0.0.1	2026-10-26 06:25:28	2026-10-26 06:25:28
20	\N	espacios	10	crear	\N	{"codigo":"E-10","piso":"Piso 1","zona":"Zona 3","area_m2":27,"coord_x":163,"coord_y":92,"estado":"Disponible","updated_at":"2026-10-26 06:25:28","created_at":"2026-10-26 06:25:28","id":10}	127.0.0.1	2026-10-26 06:25:28	2026-10-26 06:25:28
21	\N	espacios	11	crear	\N	{"codigo":"E-11","piso":"Piso 1","zona":"Zona 4","area_m2":67,"coord_x":503,"coord_y":230,"estado":"Disponible","updated_at":"2026-10-26 06:25:28","created_at":"2026-10-26 06:25:28","id":11}	127.0.0.1	2026-10-26 06:25:28	2026-10-26 06:25:28
22	\N	espacios	12	crear	\N	{"codigo":"E-12","piso":"Piso 1","zona":"Zona 5","area_m2":36,"coord_x":726,"coord_y":34,"estado":"Disponible","updated_at":"2026-10-26 06:25:28","created_at":"2026-10-26 06:25:28","id":12}	127.0.0.1	2026-10-26 06:25:28	2026-10-26 06:25:28
23	\N	espacios	13	crear	\N	{"codigo":"E-13","piso":"Piso 1","zona":"Zona 6","area_m2":80,"coord_x":693,"coord_y":497,"estado":"Disponible","updated_at":"2026-10-26 06:25:28","created_at":"2026-10-26 06:25:28","id":13}	127.0.0.1	2026-10-26 06:25:28	2026-10-26 06:25:28
24	\N	espacios	14	crear	\N	{"codigo":"E-14","piso":"Piso 1","zona":"Zona 7","area_m2":77,"coord_x":576,"coord_y":150,"estado":"Disponible","updated_at":"2026-10-26 06:25:28","created_at":"2026-10-26 06:25:28","id":14}	127.0.0.1	2026-10-26 06:25:28	2026-10-26 06:25:28
25	\N	espacios	15	crear	\N	{"codigo":"E-15","piso":"Piso 2","zona":"Zona 1","area_m2":69,"coord_x":127,"coord_y":90,"estado":"Disponible","updated_at":"2026-10-26 06:25:28","created_at":"2026-10-26 06:25:28","id":15}	127.0.0.1	2026-10-26 06:25:28	2026-10-26 06:25:28
26	\N	espacios	16	crear	\N	{"codigo":"E-16","piso":"Piso 2","zona":"Zona 2","area_m2":31,"coord_x":197,"coord_y":419,"estado":"Disponible","updated_at":"2026-10-26 06:25:28","created_at":"2026-10-26 06:25:28","id":16}	127.0.0.1	2026-10-26 06:25:28	2026-10-26 06:25:28
27	\N	espacios	17	crear	\N	{"codigo":"E-17","piso":"Piso 2","zona":"Zona 3","area_m2":40,"coord_x":40,"coord_y":354,"estado":"Disponible","updated_at":"2026-10-26 06:25:28","created_at":"2026-10-26 06:25:28","id":17}	127.0.0.1	2026-10-26 06:25:28	2026-10-26 06:25:28
28	\N	espacios	18	crear	\N	{"codigo":"E-18","piso":"Piso 2","zona":"Zona 4","area_m2":27,"coord_x":143,"coord_y":299,"estado":"Disponible","updated_at":"2026-10-26 06:25:28","created_at":"2026-10-26 06:25:28","id":18}	127.0.0.1	2026-10-26 06:25:28	2026-10-26 06:25:28
29	\N	espacios	19	crear	\N	{"codigo":"E-19","piso":"Piso 2","zona":"Zona 5","area_m2":54,"coord_x":627,"coord_y":285,"estado":"Disponible","updated_at":"2026-10-26 06:25:28","created_at":"2026-10-26 06:25:28","id":19}	127.0.0.1	2026-10-26 06:25:28	2026-10-26 06:25:28
30	\N	espacios	20	crear	\N	{"codigo":"E-20","piso":"Piso 2","zona":"Zona 6","area_m2":22,"coord_x":885,"coord_y":268,"estado":"Disponible","updated_at":"2026-10-26 06:25:28","created_at":"2026-10-26 06:25:28","id":20}	127.0.0.1	2026-10-26 06:25:28	2026-10-26 06:25:28
31	\N	espacios	21	crear	\N	{"codigo":"E-21","piso":"Piso 2","zona":"Zona 7","area_m2":78,"coord_x":261,"coord_y":61,"estado":"Disponible","updated_at":"2026-10-26 06:25:28","created_at":"2026-10-26 06:25:28","id":21}	127.0.0.1	2026-10-26 06:25:28	2026-10-26 06:25:28
32	\N	contratos	1	crear	\N	{"locatario_id":4,"espacio_id":1,"codigo":"C-0001","fecha_inicio":"2026-04-26 06:25:28","fecha_fin":"2027-10-26 06:25:28","monto_mensual":7932,"estado":"Vigente","updated_at":"2026-10-26 06:25:28","created_at":"2026-10-26 06:25:28","id":1}	127.0.0.1	2026-10-26 06:25:28	2026-10-26 06:25:28
33	\N	espacios	1	actualizar	{"id":1,"codigo":"E-01","piso":"Planta Baja","zona":"Zona 1","area_m2":"78.00","coord_x":"216.00","coord_y":"306.00","estado":"Disponible","locatario_id":null,"created_at":"2026-10-26T06:25:28.000000Z","updated_at":"2026-10-26T06:25:28.000000Z"}	{"estado":"Ocupado","locatario_id":4}	127.0.0.1	2026-10-26 06:25:28	2026-10-26 06:25:28
34	\N	contratos	2	crear	\N	{"locatario_id":5,"espacio_id":2,"codigo":"C-0002","fecha_inicio":"2026-04-26 06:25:28","fecha_fin":"2027-10-26 06:25:28","monto_mensual":7921,"estado":"Vigente","updated_at":"2026-10-26 06:25:28","created_at":"2026-10-26 06:25:28","id":2}	127.0.0.1	2026-10-26 06:25:28	2026-10-26 06:25:28
35	\N	espacios	2	actualizar	{"id":2,"codigo":"E-02","piso":"Planta Baja","zona":"Zona 2","area_m2":"51.00","coord_x":"385.00","coord_y":"387.00","estado":"Disponible","locatario_id":null,"created_at":"2026-10-26T06:25:28.000000Z","updated_at":"2026-10-26T06:25:28.000000Z"}	{"estado":"Ocupado","locatario_id":5}	127.0.0.1	2026-10-26 06:25:28	2026-10-26 06:25:28
36	\N	contratos	3	crear	\N	{"locatario_id":6,"espacio_id":3,"codigo":"C-0003","fecha_inicio":"2026-04-26 06:25:28","fecha_fin":"2027-10-26 06:25:28","monto_mensual":6965,"estado":"Vigente","updated_at":"2026-10-26 06:25:28","created_at":"2026-10-26 06:25:28","id":3}	127.0.0.1	2026-10-26 06:25:28	2026-10-26 06:25:28
37	\N	espacios	3	actualizar	{"id":3,"codigo":"E-03","piso":"Planta Baja","zona":"Zona 3","area_m2":"70.00","coord_x":"194.00","coord_y":"206.00","estado":"Disponible","locatario_id":null,"created_at":"2026-10-26T06:25:28.000000Z","updated_at":"2026-10-26T06:25:28.000000Z"}	{"estado":"Ocupado","locatario_id":6}	127.0.0.1	2026-10-26 06:25:28	2026-10-26 06:25:28
38	\N	contratos	4	crear	\N	{"locatario_id":7,"espacio_id":4,"codigo":"C-0004","fecha_inicio":"2026-04-26 06:25:28","fecha_fin":"2027-10-26 06:25:28","monto_mensual":7309,"estado":"Vigente","updated_at":"2026-10-26 06:25:28","created_at":"2026-10-26 06:25:28","id":4}	127.0.0.1	2026-10-26 06:25:28	2026-10-26 06:25:28
39	\N	espacios	4	actualizar	{"id":4,"codigo":"E-04","piso":"Planta Baja","zona":"Zona 4","area_m2":"51.00","coord_x":"165.00","coord_y":"178.00","estado":"Disponible","locatario_id":null,"created_at":"2026-10-26T06:25:28.000000Z","updated_at":"2026-10-26T06:25:28.000000Z"}	{"estado":"Ocupado","locatario_id":7}	127.0.0.1	2026-10-26 06:25:28	2026-10-26 06:25:28
40	\N	contratos	5	crear	\N	{"locatario_id":8,"espacio_id":5,"codigo":"C-0005","fecha_inicio":"2026-04-26 06:25:28","fecha_fin":"2027-05-26 06:25:28","monto_mensual":4249,"estado":"Vigente","updated_at":"2026-10-26 06:25:28","created_at":"2026-10-26 06:25:28","id":5}	127.0.0.1	2026-10-26 06:25:28	2026-10-26 06:25:28
41	\N	espacios	5	actualizar	{"id":5,"codigo":"E-05","piso":"Planta Baja","zona":"Zona 5","area_m2":"77.00","coord_x":"480.00","coord_y":"164.00","estado":"Disponible","locatario_id":null,"created_at":"2026-10-26T06:25:28.000000Z","updated_at":"2026-10-26T06:25:28.000000Z"}	{"estado":"Ocupado","locatario_id":8}	127.0.0.1	2026-10-26 06:25:28	2026-10-26 06:25:28
42	\N	contratos	6	crear	\N	{"locatario_id":9,"espacio_id":6,"codigo":"C-0006","fecha_inicio":"2025-11-26 06:25:28","fecha_fin":"2026-11-02 06:25:28","monto_mensual":3478,"estado":"Vigente","updated_at":"2026-10-26 06:25:28","created_at":"2026-10-26 06:25:28","id":6}	127.0.0.1	2026-10-26 06:25:28	2026-10-26 06:25:28
43	\N	espacios	6	actualizar	{"id":6,"codigo":"E-06","piso":"Planta Baja","zona":"Zona 6","area_m2":"48.00","coord_x":"445.00","coord_y":"117.00","estado":"Disponible","locatario_id":null,"created_at":"2026-10-26T06:25:28.000000Z","updated_at":"2026-10-26T06:25:28.000000Z"}	{"estado":"Ocupado","locatario_id":9}	127.0.0.1	2026-10-26 06:25:28	2026-10-26 06:25:28
44	\N	contratos	7	crear	\N	{"locatario_id":10,"espacio_id":7,"codigo":"C-0007","fecha_inicio":"2025-11-26 06:25:28","fecha_fin":"2026-11-01 06:25:28","monto_mensual":2105,"estado":"Vigente","updated_at":"2026-10-26 06:25:28","created_at":"2026-10-26 06:25:28","id":7}	127.0.0.1	2026-10-26 06:25:28	2026-10-26 06:25:28
45	\N	espacios	7	actualizar	{"id":7,"codigo":"E-07","piso":"Planta Baja","zona":"Zona 7","area_m2":"40.00","coord_x":"789.00","coord_y":"438.00","estado":"Disponible","locatario_id":null,"created_at":"2026-10-26T06:25:28.000000Z","updated_at":"2026-10-26T06:25:28.000000Z"}	{"estado":"Ocupado","locatario_id":10}	127.0.0.1	2026-10-26 06:25:28	2026-10-26 06:25:28
46	\N	contratos	8	crear	\N	{"locatario_id":11,"espacio_id":8,"codigo":"C-0008","fecha_inicio":"2025-11-26 06:25:28","fecha_fin":"2026-11-20 06:25:28","monto_mensual":2455,"estado":"Vigente","updated_at":"2026-10-26 06:25:28","created_at":"2026-10-26 06:25:28","id":8}	127.0.0.1	2026-10-26 06:25:28	2026-10-26 06:25:28
47	\N	espacios	8	actualizar	{"id":8,"codigo":"E-08","piso":"Piso 1","zona":"Zona 1","area_m2":"26.00","coord_x":"647.00","coord_y":"385.00","estado":"Disponible","locatario_id":null,"created_at":"2026-10-26T06:25:28.000000Z","updated_at":"2026-10-26T06:25:28.000000Z"}	{"estado":"Ocupado","locatario_id":11}	127.0.0.1	2026-10-26 06:25:28	2026-10-26 06:25:28
48	\N	contratos	9	crear	\N	{"locatario_id":12,"espacio_id":9,"codigo":"C-0009","fecha_inicio":"2025-08-26 06:25:28","fecha_fin":"2026-10-08 06:25:28","monto_mensual":5731,"estado":"Vigente","updated_at":"2026-10-26 06:25:28","created_at":"2026-10-26 06:25:28","id":9}	127.0.0.1	2026-10-26 06:25:28	2026-10-26 06:25:28
49	\N	espacios	9	actualizar	{"id":9,"codigo":"E-09","piso":"Piso 1","zona":"Zona 2","area_m2":"69.00","coord_x":"763.00","coord_y":"304.00","estado":"Disponible","locatario_id":null,"created_at":"2026-10-26T06:25:28.000000Z","updated_at":"2026-10-26T06:25:28.000000Z"}	{"estado":"Ocupado","locatario_id":12}	127.0.0.1	2026-10-26 06:25:28	2026-10-26 06:25:28
50	\N	contratos	10	crear	\N	{"locatario_id":13,"espacio_id":10,"codigo":"C-0010","fecha_inicio":"2025-08-26 06:25:28","fecha_fin":"2026-09-16 06:25:28","monto_mensual":4577,"estado":"Vigente","updated_at":"2026-10-26 06:25:28","created_at":"2026-10-26 06:25:28","id":10}	127.0.0.1	2026-10-26 06:25:28	2026-10-26 06:25:28
51	\N	espacios	10	actualizar	{"id":10,"codigo":"E-10","piso":"Piso 1","zona":"Zona 3","area_m2":"27.00","coord_x":"163.00","coord_y":"92.00","estado":"Disponible","locatario_id":null,"created_at":"2026-10-26T06:25:28.000000Z","updated_at":"2026-10-26T06:25:28.000000Z"}	{"estado":"Ocupado","locatario_id":13}	127.0.0.1	2026-10-26 06:25:28	2026-10-26 06:25:28
52	\N	incidencias	1	crear	\N	{"titulo":"Incidencia #1","descripcion":"Descripci\\u00f3n simulada de la incidencia 1","espacio_id":10,"reportado_por":1,"asignado_a":null,"prioridad":"Alta","estado":"Cerrada","fecha_cierre":null,"updated_at":"2026-10-26 06:25:28","created_at":"2026-10-26 06:25:28","id":1}	127.0.0.1	2026-10-26 06:25:28	2026-10-26 06:25:28
53	\N	incidencias	2	crear	\N	{"titulo":"Incidencia #2","descripcion":"Descripci\\u00f3n simulada de la incidencia 2","espacio_id":6,"reportado_por":1,"asignado_a":3,"prioridad":"Critica","estado":"Asignada","fecha_cierre":null,"updated_at":"2026-10-26 06:25:28","created_at":"2026-10-26 06:25:28","id":2}	127.0.0.1	2026-10-26 06:25:28	2026-10-26 06:25:28
54	\N	incidencias	3	crear	\N	{"titulo":"Incidencia #3","descripcion":"Descripci\\u00f3n simulada de la incidencia 3","espacio_id":11,"reportado_por":1,"asignado_a":null,"prioridad":"Baja","estado":"Cerrada","fecha_cierre":null,"updated_at":"2026-10-26 06:25:28","created_at":"2026-10-26 06:25:28","id":3}	127.0.0.1	2026-10-26 06:25:28	2026-10-26 06:25:28
55	\N	incidencias	4	crear	\N	{"titulo":"Incidencia #4","descripcion":"Descripci\\u00f3n simulada de la incidencia 4","espacio_id":21,"reportado_por":1,"asignado_a":3,"prioridad":"Alta","estado":"En proceso","fecha_cierre":null,"updated_at":"2026-10-26 06:25:28","created_at":"2026-10-26 06:25:28","id":4}	127.0.0.1	2026-10-26 06:25:28	2026-10-26 06:25:28
56	\N	incidencias	5	crear	\N	{"titulo":"Incidencia #5","descripcion":"Descripci\\u00f3n simulada de la incidencia 5","espacio_id":7,"reportado_por":1,"asignado_a":null,"prioridad":"Alta","estado":"Asignada","fecha_cierre":null,"updated_at":"2026-10-26 06:25:28","created_at":"2026-10-26 06:25:28","id":5}	127.0.0.1	2026-10-26 06:25:28	2026-10-26 06:25:28
57	\N	incidencias	6	crear	\N	{"titulo":"Incidencia #6","descripcion":"Descripci\\u00f3n simulada de la incidencia 6","espacio_id":1,"reportado_por":1,"asignado_a":3,"prioridad":"Media","estado":"Pendiente","fecha_cierre":null,"updated_at":"2026-10-26 06:25:28","created_at":"2026-10-26 06:25:28","id":6}	127.0.0.1	2026-10-26 06:25:28	2026-10-26 06:25:28
58	\N	incidencias	7	crear	\N	{"titulo":"Incidencia #7","descripcion":"Descripci\\u00f3n simulada de la incidencia 7","espacio_id":15,"reportado_por":1,"asignado_a":null,"prioridad":"Critica","estado":"Pendiente","fecha_cierre":null,"updated_at":"2026-10-26 06:25:28","created_at":"2026-10-26 06:25:28","id":7}	127.0.0.1	2026-10-26 06:25:28	2026-10-26 06:25:28
59	\N	incidencias	8	crear	\N	{"titulo":"Incidencia #8","descripcion":"Descripci\\u00f3n simulada de la incidencia 8","espacio_id":14,"reportado_por":1,"asignado_a":3,"prioridad":"Baja","estado":"Asignada","fecha_cierre":null,"updated_at":"2026-10-26 06:25:28","created_at":"2026-10-26 06:25:28","id":8}	127.0.0.1	2026-10-26 06:25:28	2026-10-26 06:25:28
60	\N	incidencias	9	crear	\N	{"titulo":"Incidencia #9","descripcion":"Descripci\\u00f3n simulada de la incidencia 9","espacio_id":17,"reportado_por":1,"asignado_a":null,"prioridad":"Media","estado":"Pendiente","fecha_cierre":null,"updated_at":"2026-10-26 06:25:28","created_at":"2026-10-26 06:25:28","id":9}	127.0.0.1	2026-10-26 06:25:28	2026-10-26 06:25:28
61	\N	incidencias	10	crear	\N	{"titulo":"Incidencia #10","descripcion":"Descripci\\u00f3n simulada de la incidencia 10","espacio_id":12,"reportado_por":1,"asignado_a":3,"prioridad":"Alta","estado":"En proceso","fecha_cierre":null,"updated_at":"2026-10-26 06:25:28","created_at":"2026-10-26 06:25:28","id":10}	127.0.0.1	2026-10-26 06:25:28	2026-10-26 06:25:28
62	\N	incidencias	11	crear	\N	{"titulo":"Incidencia #11","descripcion":"Descripci\\u00f3n simulada de la incidencia 11","espacio_id":20,"reportado_por":1,"asignado_a":null,"prioridad":"Alta","estado":"Asignada","fecha_cierre":null,"updated_at":"2026-10-26 06:25:28","created_at":"2026-10-26 06:25:28","id":11}	127.0.0.1	2026-10-26 06:25:28	2026-10-26 06:25:28
63	\N	incidencias	12	crear	\N	{"titulo":"Incidencia #12","descripcion":"Descripci\\u00f3n simulada de la incidencia 12","espacio_id":16,"reportado_por":1,"asignado_a":3,"prioridad":"Baja","estado":"En proceso","fecha_cierre":null,"updated_at":"2026-10-26 06:25:28","created_at":"2026-10-26 06:25:28","id":12}	127.0.0.1	2026-10-26 06:25:28	2026-10-26 06:25:28
64	\N	incidencias	13	crear	\N	{"titulo":"Incidencia #13","descripcion":"Descripci\\u00f3n simulada de la incidencia 13","espacio_id":7,"reportado_por":1,"asignado_a":null,"prioridad":"Media","estado":"Cerrada","fecha_cierre":null,"updated_at":"2026-10-26 06:25:28","created_at":"2026-10-26 06:25:28","id":13}	127.0.0.1	2026-10-26 06:25:28	2026-10-26 06:25:28
65	\N	incidencias	14	crear	\N	{"titulo":"Incidencia #14","descripcion":"Descripci\\u00f3n simulada de la incidencia 14","espacio_id":5,"reportado_por":1,"asignado_a":3,"prioridad":"Baja","estado":"Pendiente","fecha_cierre":null,"updated_at":"2026-10-26 06:25:28","created_at":"2026-10-26 06:25:28","id":14}	127.0.0.1	2026-10-26 06:25:28	2026-10-26 06:25:28
66	\N	incidencias	15	crear	\N	{"titulo":"Incidencia #15","descripcion":"Descripci\\u00f3n simulada de la incidencia 15","espacio_id":6,"reportado_por":1,"asignado_a":null,"prioridad":"Alta","estado":"Resuelta","fecha_cierre":null,"updated_at":"2026-10-26 06:25:28","created_at":"2026-10-26 06:25:28","id":15}	127.0.0.1	2026-10-26 06:25:28	2026-10-26 06:25:28
67	\N	incidencias	16	crear	\N	{"titulo":"Incidencia #16","descripcion":"Descripci\\u00f3n simulada de la incidencia 16","espacio_id":6,"reportado_por":1,"asignado_a":3,"prioridad":"Media","estado":"Cerrada","fecha_cierre":null,"updated_at":"2026-10-26 06:25:28","created_at":"2026-10-26 06:25:28","id":16}	127.0.0.1	2026-10-26 06:25:28	2026-10-26 06:25:28
68	\N	incidencias	17	crear	\N	{"titulo":"Incidencia #17","descripcion":"Descripci\\u00f3n simulada de la incidencia 17","espacio_id":10,"reportado_por":1,"asignado_a":null,"prioridad":"Alta","estado":"Resuelta","fecha_cierre":null,"updated_at":"2026-10-26 06:25:28","created_at":"2026-10-26 06:25:28","id":17}	127.0.0.1	2026-10-26 06:25:28	2026-10-26 06:25:28
69	\N	incidencias	18	crear	\N	{"titulo":"Incidencia #18","descripcion":"Descripci\\u00f3n simulada de la incidencia 18","espacio_id":11,"reportado_por":1,"asignado_a":3,"prioridad":"Media","estado":"Pendiente","fecha_cierre":null,"updated_at":"2026-10-26 06:25:28","created_at":"2026-10-26 06:25:28","id":18}	127.0.0.1	2026-10-26 06:25:28	2026-10-26 06:25:28
70	\N	incidencias	19	crear	\N	{"titulo":"Incidencia #19","descripcion":"Descripci\\u00f3n simulada de la incidencia 19","espacio_id":17,"reportado_por":1,"asignado_a":null,"prioridad":"Media","estado":"Pendiente","fecha_cierre":null,"updated_at":"2026-10-26 06:25:28","created_at":"2026-10-26 06:25:28","id":19}	127.0.0.1	2026-10-26 06:25:28	2026-10-26 06:25:28
71	\N	incidencias	20	crear	\N	{"titulo":"Incidencia #20","descripcion":"Descripci\\u00f3n simulada de la incidencia 20","espacio_id":13,"reportado_por":1,"asignado_a":3,"prioridad":"Alta","estado":"Cerrada","fecha_cierre":null,"updated_at":"2026-10-26 06:25:28","created_at":"2026-10-26 06:25:28","id":20}	127.0.0.1	2026-10-26 06:25:28	2026-10-26 06:25:28
72	\N	incidencias	21	crear	\N	{"titulo":"Incidencia #21","descripcion":"Descripci\\u00f3n simulada de la incidencia 21","espacio_id":2,"reportado_por":1,"asignado_a":null,"prioridad":"Critica","estado":"Asignada","fecha_cierre":null,"updated_at":"2026-10-26 06:25:28","created_at":"2026-10-26 06:25:28","id":21}	127.0.0.1	2026-10-26 06:25:28	2026-10-26 06:25:28
73	\N	incidencias	22	crear	\N	{"titulo":"Incidencia #22","descripcion":"Descripci\\u00f3n simulada de la incidencia 22","espacio_id":2,"reportado_por":1,"asignado_a":3,"prioridad":"Alta","estado":"Resuelta","fecha_cierre":null,"updated_at":"2026-10-26 06:25:28","created_at":"2026-10-26 06:25:28","id":22}	127.0.0.1	2026-10-26 06:25:28	2026-10-26 06:25:28
74	\N	incidencias	23	crear	\N	{"titulo":"Incidencia #23","descripcion":"Descripci\\u00f3n simulada de la incidencia 23","espacio_id":9,"reportado_por":1,"asignado_a":null,"prioridad":"Media","estado":"Resuelta","fecha_cierre":null,"updated_at":"2026-10-26 06:25:28","created_at":"2026-10-26 06:25:28","id":23}	127.0.0.1	2026-10-26 06:25:28	2026-10-26 06:25:28
75	\N	incidencias	24	crear	\N	{"titulo":"Incidencia #24","descripcion":"Descripci\\u00f3n simulada de la incidencia 24","espacio_id":17,"reportado_por":1,"asignado_a":3,"prioridad":"Media","estado":"Resuelta","fecha_cierre":null,"updated_at":"2026-10-26 06:25:28","created_at":"2026-10-26 06:25:28","id":24}	127.0.0.1	2026-10-26 06:25:28	2026-10-26 06:25:28
76	\N	incidencias	25	crear	\N	{"titulo":"Incidencia #25","descripcion":"Descripci\\u00f3n simulada de la incidencia 25","espacio_id":19,"reportado_por":1,"asignado_a":null,"prioridad":"Alta","estado":"Resuelta","fecha_cierre":null,"updated_at":"2026-10-26 06:25:28","created_at":"2026-10-26 06:25:28","id":25}	127.0.0.1	2026-10-26 06:25:28	2026-10-26 06:25:28
\.


--
-- Data for Name: cache; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cache (key, value, expiration) FROM stdin;
\.


--
-- Data for Name: cache_locks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cache_locks (key, owner, expiration) FROM stdin;
\.


--
-- Data for Name: contratos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.contratos (id, locatario_id, espacio_id, codigo, fecha_inicio, fecha_fin, monto_mensual, estado, observaciones, created_at, updated_at) FROM stdin;
1	4	1	C-0001	2026-04-26	2027-10-26	7932.00	Vigente	\N	2026-10-26 06:25:28	2026-10-26 06:25:28
2	5	2	C-0002	2026-04-26	2027-10-26	7921.00	Vigente	\N	2026-10-26 06:25:28	2026-10-26 06:25:28
3	6	3	C-0003	2026-04-26	2027-10-26	6965.00	Vigente	\N	2026-10-26 06:25:28	2026-10-26 06:25:28
4	7	4	C-0004	2026-04-26	2027-10-26	7309.00	Vigente	\N	2026-10-26 06:25:28	2026-10-26 06:25:28
5	8	5	C-0005	2026-04-26	2027-05-26	4249.00	Vigente	\N	2026-10-26 06:25:28	2026-10-26 06:25:28
6	9	6	C-0006	2025-11-26	2026-11-02	3478.00	Vigente	\N	2026-10-26 06:25:28	2026-10-26 06:25:28
7	10	7	C-0007	2025-11-26	2026-11-01	2105.00	Vigente	\N	2026-10-26 06:25:28	2026-10-26 06:25:28
8	11	8	C-0008	2025-11-26	2026-11-20	2455.00	Vigente	\N	2026-10-26 06:25:28	2026-10-26 06:25:28
9	12	9	C-0009	2025-08-26	2026-10-08	5731.00	Vigente	\N	2026-10-26 06:25:28	2026-10-26 06:25:28
10	13	10	C-0010	2025-08-26	2026-09-16	4577.00	Vigente	\N	2026-10-26 06:25:28	2026-10-26 06:25:28
\.


--
-- Data for Name: espacios; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.espacios (id, codigo, piso, zona, area_m2, coord_x, coord_y, estado, locatario_id, created_at, updated_at) FROM stdin;
11	E-11	Piso 1	Zona 4	67.00	503.00	230.00	Disponible	\N	2026-10-26 06:25:28	2026-10-26 06:25:28
12	E-12	Piso 1	Zona 5	36.00	726.00	34.00	Disponible	\N	2026-10-26 06:25:28	2026-10-26 06:25:28
13	E-13	Piso 1	Zona 6	80.00	693.00	497.00	Disponible	\N	2026-10-26 06:25:28	2026-10-26 06:25:28
14	E-14	Piso 1	Zona 7	77.00	576.00	150.00	Disponible	\N	2026-10-26 06:25:28	2026-10-26 06:25:28
15	E-15	Piso 2	Zona 1	69.00	127.00	90.00	Disponible	\N	2026-10-26 06:25:28	2026-10-26 06:25:28
16	E-16	Piso 2	Zona 2	31.00	197.00	419.00	Disponible	\N	2026-10-26 06:25:28	2026-10-26 06:25:28
17	E-17	Piso 2	Zona 3	40.00	40.00	354.00	Disponible	\N	2026-10-26 06:25:28	2026-10-26 06:25:28
18	E-18	Piso 2	Zona 4	27.00	143.00	299.00	Disponible	\N	2026-10-26 06:25:28	2026-10-26 06:25:28
19	E-19	Piso 2	Zona 5	54.00	627.00	285.00	Disponible	\N	2026-10-26 06:25:28	2026-10-26 06:25:28
20	E-20	Piso 2	Zona 6	22.00	885.00	268.00	Disponible	\N	2026-10-26 06:25:28	2026-10-26 06:25:28
21	E-21	Piso 2	Zona 7	78.00	261.00	61.00	Disponible	\N	2026-10-26 06:25:28	2026-10-26 06:25:28
1	E-01	Planta Baja	Zona 1	78.00	216.00	306.00	Ocupado	4	2026-10-26 06:25:28	2026-10-26 06:25:28
2	E-02	Planta Baja	Zona 2	51.00	385.00	387.00	Ocupado	5	2026-10-26 06:25:28	2026-10-26 06:25:28
3	E-03	Planta Baja	Zona 3	70.00	194.00	206.00	Ocupado	6	2026-10-26 06:25:28	2026-10-26 06:25:28
4	E-04	Planta Baja	Zona 4	51.00	165.00	178.00	Ocupado	7	2026-10-26 06:25:28	2026-10-26 06:25:28
5	E-05	Planta Baja	Zona 5	77.00	480.00	164.00	Ocupado	8	2026-10-26 06:25:28	2026-10-26 06:25:28
6	E-06	Planta Baja	Zona 6	48.00	445.00	117.00	Ocupado	9	2026-10-26 06:25:28	2026-10-26 06:25:28
7	E-07	Planta Baja	Zona 7	40.00	789.00	438.00	Ocupado	10	2026-10-26 06:25:28	2026-10-26 06:25:28
8	E-08	Piso 1	Zona 1	26.00	647.00	385.00	Ocupado	11	2026-10-26 06:25:28	2026-10-26 06:25:28
9	E-09	Piso 1	Zona 2	69.00	763.00	304.00	Ocupado	12	2026-10-26 06:25:28	2026-10-26 06:25:28
10	E-10	Piso 1	Zona 3	27.00	163.00	92.00	Ocupado	13	2026-10-26 06:25:28	2026-10-26 06:25:28
\.


--
-- Data for Name: failed_jobs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.failed_jobs (id, uuid, connection, queue, payload, exception, failed_at) FROM stdin;
\.


--
-- Data for Name: incidencias; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.incidencias (id, titulo, descripcion, espacio_id, reportado_por, asignado_a, prioridad, estado, fecha_cierre, created_at, updated_at) FROM stdin;
1	Incidencia #1	Descripción simulada de la incidencia 1	10	1	\N	Alta	Cerrada	\N	2026-10-26 06:25:28	2026-10-26 06:25:28
2	Incidencia #2	Descripción simulada de la incidencia 2	6	1	3	Critica	Asignada	\N	2026-10-26 06:25:28	2026-10-26 06:25:28
3	Incidencia #3	Descripción simulada de la incidencia 3	11	1	\N	Baja	Cerrada	\N	2026-10-26 06:25:28	2026-10-26 06:25:28
4	Incidencia #4	Descripción simulada de la incidencia 4	21	1	3	Alta	En proceso	\N	2026-10-26 06:25:28	2026-10-26 06:25:28
5	Incidencia #5	Descripción simulada de la incidencia 5	7	1	\N	Alta	Asignada	\N	2026-10-26 06:25:28	2026-10-26 06:25:28
6	Incidencia #6	Descripción simulada de la incidencia 6	1	1	3	Media	Pendiente	\N	2026-10-26 06:25:28	2026-10-26 06:25:28
7	Incidencia #7	Descripción simulada de la incidencia 7	15	1	\N	Critica	Pendiente	\N	2026-10-26 06:25:28	2026-10-26 06:25:28
8	Incidencia #8	Descripción simulada de la incidencia 8	14	1	3	Baja	Asignada	\N	2026-10-26 06:25:28	2026-10-26 06:25:28
9	Incidencia #9	Descripción simulada de la incidencia 9	17	1	\N	Media	Pendiente	\N	2026-10-26 06:25:28	2026-10-26 06:25:28
10	Incidencia #10	Descripción simulada de la incidencia 10	12	1	3	Alta	En proceso	\N	2026-10-26 06:25:28	2026-10-26 06:25:28
11	Incidencia #11	Descripción simulada de la incidencia 11	20	1	\N	Alta	Asignada	\N	2026-10-26 06:25:28	2026-10-26 06:25:28
12	Incidencia #12	Descripción simulada de la incidencia 12	16	1	3	Baja	En proceso	\N	2026-10-26 06:25:28	2026-10-26 06:25:28
13	Incidencia #13	Descripción simulada de la incidencia 13	7	1	\N	Media	Cerrada	\N	2026-10-26 06:25:28	2026-10-26 06:25:28
14	Incidencia #14	Descripción simulada de la incidencia 14	5	1	3	Baja	Pendiente	\N	2026-10-26 06:25:28	2026-10-26 06:25:28
15	Incidencia #15	Descripción simulada de la incidencia 15	6	1	\N	Alta	Resuelta	\N	2026-10-26 06:25:28	2026-10-26 06:25:28
16	Incidencia #16	Descripción simulada de la incidencia 16	6	1	3	Media	Cerrada	\N	2026-10-26 06:25:28	2026-10-26 06:25:28
17	Incidencia #17	Descripción simulada de la incidencia 17	10	1	\N	Alta	Resuelta	\N	2026-10-26 06:25:28	2026-10-26 06:25:28
18	Incidencia #18	Descripción simulada de la incidencia 18	11	1	3	Media	Pendiente	\N	2026-10-26 06:25:28	2026-10-26 06:25:28
19	Incidencia #19	Descripción simulada de la incidencia 19	17	1	\N	Media	Pendiente	\N	2026-10-26 06:25:28	2026-10-26 06:25:28
20	Incidencia #20	Descripción simulada de la incidencia 20	13	1	3	Alta	Cerrada	\N	2026-10-26 06:25:28	2026-10-26 06:25:28
21	Incidencia #21	Descripción simulada de la incidencia 21	2	1	\N	Critica	Asignada	\N	2026-10-26 06:25:28	2026-10-26 06:25:28
22	Incidencia #22	Descripción simulada de la incidencia 22	2	1	3	Alta	Resuelta	\N	2026-10-26 06:25:28	2026-10-26 06:25:28
23	Incidencia #23	Descripción simulada de la incidencia 23	9	1	\N	Media	Resuelta	\N	2026-10-26 06:25:28	2026-10-26 06:25:28
24	Incidencia #24	Descripción simulada de la incidencia 24	17	1	3	Media	Resuelta	\N	2026-10-26 06:25:28	2026-10-26 06:25:28
25	Incidencia #25	Descripción simulada de la incidencia 25	19	1	\N	Alta	Resuelta	\N	2026-10-26 06:25:28	2026-10-26 06:25:28
\.


--
-- Data for Name: job_batches; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.job_batches (id, name, total_jobs, pending_jobs, failed_jobs, failed_job_ids, options, cancelled_at, created_at, finished_at) FROM stdin;
\.


--
-- Data for Name: jobs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.jobs (id, queue, payload, attempts, reserved_at, available_at, created_at) FROM stdin;
\.


--
-- Data for Name: locatarios; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.locatarios (id, nombre, nit, representante, telefono, email, rubro, estado, created_at, updated_at, deleted_at) FROM stdin;
4	Locatario Ropa	NIT-0001	Rep Ropa	74264612	ropa@caparazon.bo	Ropa	Activo	2026-10-26 06:25:28	2026-10-26 06:25:28	\N
5	Locatario Comida	NIT-0002	Rep Comida	78321640	comida@caparazon.bo	Comida	Activo	2026-10-26 06:25:28	2026-10-26 06:25:28	\N
6	Locatario Tecnología	NIT-0003	Rep Tecnología	74269800	tecnología@caparazon.bo	Tecnología	Activo	2026-10-26 06:25:28	2026-10-26 06:25:28	\N
7	Locatario Juguetes	NIT-0004	Rep Juguetes	76621624	juguetes@caparazon.bo	Juguetes	Activo	2026-10-26 06:25:28	2026-10-26 06:25:28	\N
8	Locatario Calzado	NIT-0005	Rep Calzado	73346691	calzado@caparazon.bo	Calzado	Activo	2026-10-26 06:25:28	2026-10-26 06:25:28	\N
9	Locatario Cosméticos	NIT-0006	Rep Cosméticos	75084614	cosméticos@caparazon.bo	Cosméticos	Activo	2026-10-26 06:25:28	2026-10-26 06:25:28	\N
10	Locatario Librería	NIT-0007	Rep Librería	75183479	librería@caparazon.bo	Librería	Activo	2026-10-26 06:25:28	2026-10-26 06:25:28	\N
11	Locatario Deportes	NIT-0008	Rep Deportes	72231893	deportes@caparazon.bo	Deportes	Activo	2026-10-26 06:25:28	2026-10-26 06:25:28	\N
12	Locatario Mascotas	NIT-0009	Rep Mascotas	75835459	mascotas@caparazon.bo	Mascotas	Activo	2026-10-26 06:25:28	2026-10-26 06:25:28	\N
13	Locatario Servicios	NIT-0010	Rep Servicios	79568983	servicios@caparazon.bo	Servicios	Activo	2026-10-26 06:25:28	2026-10-26 06:25:28	\N
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.migrations (id, migration, batch) FROM stdin;
1	0001_01_01_000000_create_users_table	1
2	0001_01_01_000001_create_cache_table	1
3	0001_01_01_000002_create_jobs_table	1
4	2026_10_26_054546_add_role_to_users_table	2
5	2026_10_26_060141_create_locatarios_table	3
6	2026_10_26_060151_create_espacios_table	3
7	2026_10_26_060157_create_contratos_table	3
8	2026_10_26_060203_create_incidencias_table	3
9	2026_10_26_060207_create_auditoria_table	3
\.


--
-- Data for Name: password_reset_tokens; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.password_reset_tokens (email, token, created_at) FROM stdin;
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sessions (id, user_id, ip_address, user_agent, payload, last_activity) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, name, email, email_verified_at, password, remember_token, created_at, updated_at, role, activo) FROM stdin;
1	Administrador	administrador@caparazon.bo	\N	$2y$12$OZ1Y8gJ/Ikp.M/CmUPzTC.fx.VP9tqA56YMNTeGnDQOJniK4M47WC	\N	2026-10-26 05:58:39	2026-10-26 06:25:27	Administrador	t
2	Supervisor	supervisor@caparazon.bo	\N	$2y$12$ZVFT3brLyla9i5uaAsS5.OFUHFmKdx4X3mh7E3nzWriwrjtA3yRN2	\N	2026-10-26 05:58:39	2026-10-26 06:25:27	Supervisor	t
3	Operador	operador@caparazon.bo	\N	$2y$12$Demie1fHJqlhTdo1v3hSDuzwU3vQzw6EkM2wloVUxeD0vUvXZ5eyu	\N	2026-10-26 05:58:39	2026-10-26 06:25:28	Operador	t
4	Seguridad	seguridad@caparazon.bo	\N	$2y$12$nCRPbjkQtUHQXSpssuCEOOSgf9m9xnllYzPFnIuN/F3r6IczHxnwq	\N	2026-10-26 05:58:40	2026-10-26 06:25:28	Seguridad	t
5	Locatario	locatario@caparazon.bo	\N	$2y$12$EM4QRjFXYAK0TejxzyPc7.TE4egGJ1KBQZBfJkdHJxkkO16h9tOey	\N	2026-10-26 05:58:40	2026-10-26 06:25:28	Locatario	t
\.


--
-- Name: auditoria_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auditoria_id_seq', 76, true);


--
-- Name: contratos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.contratos_id_seq', 10, true);


--
-- Name: espacios_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.espacios_id_seq', 21, true);


--
-- Name: failed_jobs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.failed_jobs_id_seq', 1, false);


--
-- Name: incidencias_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.incidencias_id_seq', 25, true);


--
-- Name: jobs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.jobs_id_seq', 1, false);


--
-- Name: locatarios_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.locatarios_id_seq', 13, true);


--
-- Name: migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.migrations_id_seq', 9, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 5, true);


--
-- Name: auditoria auditoria_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auditoria
    ADD CONSTRAINT auditoria_pkey PRIMARY KEY (id);


--
-- Name: cache_locks cache_locks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cache_locks
    ADD CONSTRAINT cache_locks_pkey PRIMARY KEY (key);


--
-- Name: cache cache_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cache
    ADD CONSTRAINT cache_pkey PRIMARY KEY (key);


--
-- Name: contratos contratos_codigo_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contratos
    ADD CONSTRAINT contratos_codigo_unique UNIQUE (codigo);


--
-- Name: contratos contratos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contratos
    ADD CONSTRAINT contratos_pkey PRIMARY KEY (id);


--
-- Name: espacios espacios_codigo_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.espacios
    ADD CONSTRAINT espacios_codigo_unique UNIQUE (codigo);


--
-- Name: espacios espacios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.espacios
    ADD CONSTRAINT espacios_pkey PRIMARY KEY (id);


--
-- Name: failed_jobs failed_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.failed_jobs
    ADD CONSTRAINT failed_jobs_pkey PRIMARY KEY (id);


--
-- Name: failed_jobs failed_jobs_uuid_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.failed_jobs
    ADD CONSTRAINT failed_jobs_uuid_unique UNIQUE (uuid);


--
-- Name: incidencias incidencias_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.incidencias
    ADD CONSTRAINT incidencias_pkey PRIMARY KEY (id);


--
-- Name: job_batches job_batches_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job_batches
    ADD CONSTRAINT job_batches_pkey PRIMARY KEY (id);


--
-- Name: jobs jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jobs
    ADD CONSTRAINT jobs_pkey PRIMARY KEY (id);


--
-- Name: locatarios locatarios_nit_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.locatarios
    ADD CONSTRAINT locatarios_nit_unique UNIQUE (nit);


--
-- Name: locatarios locatarios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.locatarios
    ADD CONSTRAINT locatarios_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- Name: password_reset_tokens password_reset_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.password_reset_tokens
    ADD CONSTRAINT password_reset_tokens_pkey PRIMARY KEY (email);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: users users_email_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_unique UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: auditoria_tabla_registro_id_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auditoria_tabla_registro_id_index ON public.auditoria USING btree (tabla, registro_id);


--
-- Name: jobs_queue_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX jobs_queue_index ON public.jobs USING btree (queue);


--
-- Name: sessions_last_activity_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX sessions_last_activity_index ON public.sessions USING btree (last_activity);


--
-- Name: sessions_user_id_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX sessions_user_id_index ON public.sessions USING btree (user_id);


--
-- Name: auditoria auditoria_usuario_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auditoria
    ADD CONSTRAINT auditoria_usuario_id_foreign FOREIGN KEY (usuario_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: contratos contratos_espacio_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contratos
    ADD CONSTRAINT contratos_espacio_id_foreign FOREIGN KEY (espacio_id) REFERENCES public.espacios(id) ON DELETE CASCADE;


--
-- Name: contratos contratos_locatario_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contratos
    ADD CONSTRAINT contratos_locatario_id_foreign FOREIGN KEY (locatario_id) REFERENCES public.locatarios(id) ON DELETE CASCADE;


--
-- Name: espacios espacios_locatario_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.espacios
    ADD CONSTRAINT espacios_locatario_id_foreign FOREIGN KEY (locatario_id) REFERENCES public.locatarios(id) ON DELETE SET NULL;


--
-- Name: incidencias incidencias_asignado_a_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.incidencias
    ADD CONSTRAINT incidencias_asignado_a_foreign FOREIGN KEY (asignado_a) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: incidencias incidencias_espacio_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.incidencias
    ADD CONSTRAINT incidencias_espacio_id_foreign FOREIGN KEY (espacio_id) REFERENCES public.espacios(id) ON DELETE SET NULL;


--
-- Name: incidencias incidencias_reportado_por_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.incidencias
    ADD CONSTRAINT incidencias_reportado_por_foreign FOREIGN KEY (reportado_por) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- PostgreSQL database dump complete
--

\unrestrict n8AB8KqoVKQRsfHf39aqSE69bYMk7JBAvUdCBNYJVLlQDaf6YvaaHz7FMip1Lkz

