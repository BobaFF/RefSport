--
-- PostgreSQL database dump
--

-- Dumped from database version 15.3
-- Dumped by pg_dump version 15.3

-- Started on 2023-06-09 20:00:43 CEST

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
-- TOC entry 3765 (class 1262 OID 5)
-- Name: postgres; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE postgres WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'C';


ALTER DATABASE postgres OWNER TO postgres;

\connect postgres

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
-- TOC entry 3766 (class 0 OID 0)
-- Dependencies: 3765
-- Name: DATABASE postgres; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON DATABASE postgres IS 'default administrative connection database';


--
-- TOC entry 2 (class 3079 OID 16384)
-- Name: adminpack; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS adminpack WITH SCHEMA pg_catalog;


--
-- TOC entry 3767 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION adminpack; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION adminpack IS 'administrative functions for PostgreSQL';


--
-- TOC entry 907 (class 1247 OID 20612)
-- Name: colori; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.colori AS ENUM (
    'Nero',
    'Giallo',
    'Rosso',
    'Giallo-Nero',
    'Verde'
);


ALTER TYPE public.colori OWNER TO postgres;

--
-- TOC entry 913 (class 1247 OID 39110)
-- Name: pagamenti; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.pagamenti AS ENUM (
    'Bonifico Bancario',
    'Carta di Credito',
    'PayPal'
);


ALTER TYPE public.pagamenti OWNER TO postgres;

--
-- TOC entry 910 (class 1247 OID 39039)
-- Name: ruoli; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.ruoli AS ENUM (
    'Direttore',
    'Magazziniere',
    'Commesso'
);


ALTER TYPE public.ruoli OWNER TO postgres;

--
-- TOC entry 916 (class 1247 OID 39118)
-- Name: stati; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.stati AS ENUM (
    'in elaborazione',
    'spedito',
    'consegnato'
);


ALTER TYPE public.stati OWNER TO postgres;

--
-- TOC entry 883 (class 1247 OID 20062)
-- Name: stato_ferie; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.stato_ferie AS ENUM (
    'Approvata',
    'Rifiutata',
    'In attesa'
);


ALTER TYPE public.stato_ferie OWNER TO postgres;

--
-- TOC entry 919 (class 1247 OID 20816)
-- Name: superfici; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.superfici AS ENUM (
    'terra',
    'sintetico',
    'indoor'
);


ALTER TYPE public.superfici OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 225 (class 1259 OID 55358)
-- Name: cliente; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cliente (
    mail character varying(50) NOT NULL,
    "città" character varying(30),
    nome character varying(30) NOT NULL,
    cognome character varying(30) NOT NULL,
    telefono character varying(15),
    sezioneaia boolean DEFAULT false NOT NULL
);


ALTER TABLE public.cliente OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 55334)
-- Name: contratto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.contratto (
    dipendente character(16) NOT NULL,
    inizio date NOT NULL,
    stipendio numeric(8,2) NOT NULL,
    fine date,
    CONSTRAINT contratto_check CHECK ((fine > inizio)),
    CONSTRAINT contratto_stipendio_check CHECK ((stipendio > (0)::numeric))
);


ALTER TABLE public.contratto OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 55393)
-- Name: dettagli_ordine; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dettagli_ordine (
    ordinep integer NOT NULL,
    prodottop integer NOT NULL,
    "quantità" integer NOT NULL,
    CONSTRAINT "dettagli_ordine_quantità_check" CHECK (("quantità" > 0))
);


ALTER TABLE public.dettagli_ordine OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 55409)
-- Name: dettagli_ordine_f; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dettagli_ordine_f (
    ordinef integer NOT NULL,
    prodottof integer NOT NULL,
    colore public.colori NOT NULL,
    "quantità" integer NOT NULL,
    CONSTRAINT "dettagli_ordine_f_quantità_check" CHECK (("quantità" > 0))
);


ALTER TABLE public.dettagli_ordine_f OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 55425)
-- Name: dettagli_ordine_s; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dettagli_ordine_s (
    ordines integer NOT NULL,
    prodottos integer NOT NULL,
    numero numeric(2,0) NOT NULL,
    superficie public.superfici NOT NULL,
    "quantità" integer NOT NULL,
    CONSTRAINT "dettagli_ordine_s_quantità_check" CHECK (("quantità" > 0))
);


ALTER TABLE public.dettagli_ordine_s OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 55441)
-- Name: dettagli_ordine_v; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dettagli_ordine_v (
    ordinev integer NOT NULL,
    prodottov integer NOT NULL,
    taglia character(1) NOT NULL,
    colore public.colori NOT NULL,
    "quantità" integer NOT NULL,
    CONSTRAINT "dettagli_ordine_v_quantità_check" CHECK (("quantità" > 0))
);


ALTER TABLE public.dettagli_ordine_v OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 55320)
-- Name: dipendente; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dipendente (
    cf character(16) NOT NULL,
    nome character varying(30) NOT NULL,
    cognome character varying(30) NOT NULL,
    telefono character varying(15) NOT NULL,
    mail character varying(30),
    ruolo public.ruoli,
    sedelavorativa integer NOT NULL
);


ALTER TABLE public.dipendente OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 55346)
-- Name: ferie; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ferie (
    dipendente character(16) NOT NULL,
    inizio date NOT NULL,
    fine date NOT NULL,
    stato public.stato_ferie DEFAULT 'In attesa'::public.stato_ferie NOT NULL,
    CONSTRAINT ferie_check CHECK ((inizio <= fine))
);


ALTER TABLE public.ferie OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 55289)
-- Name: fischietto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fischietto (
    codice integer NOT NULL,
    colore public.colori NOT NULL,
    materiale character varying(20) NOT NULL,
    decibel numeric(3,0) NOT NULL
);


ALTER TABLE public.fischietto OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 55367)
-- Name: ordine; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ordine (
    ricevuta integer NOT NULL,
    data date NOT NULL,
    gestore character(16) NOT NULL
);


ALTER TABLE public.ordine OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 55378)
-- Name: ordine_online; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ordine_online (
    ricevuta integer NOT NULL,
    cliente character varying(50) NOT NULL,
    indirizzo character varying(50) NOT NULL,
    cap character varying(10) NOT NULL,
    "città" character varying(20) NOT NULL,
    pagamento public.pagamenti,
    corriere character varying(30),
    stato public.stati
);


ALTER TABLE public.ordine_online OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 55366)
-- Name: ordine_ricevuta_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ordine_ricevuta_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ordine_ricevuta_seq OWNER TO postgres;

--
-- TOC entry 3768 (class 0 OID 0)
-- Dependencies: 226
-- Name: ordine_ricevuta_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ordine_ricevuta_seq OWNED BY public.ordine.ricevuta;


--
-- TOC entry 218 (class 1259 OID 55281)
-- Name: prodotto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.prodotto (
    codice integer NOT NULL,
    nome character varying(40) NOT NULL,
    marca character varying(30) NOT NULL,
    costo numeric(5,2) NOT NULL,
    punteggio numeric(2,1),
    CONSTRAINT prodotto_punteggio_check CHECK (((punteggio <= (5)::numeric) AND (punteggio >= (0)::numeric)))
);


ALTER TABLE public.prodotto OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 55280)
-- Name: prodotto_codice_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.prodotto_codice_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.prodotto_codice_seq OWNER TO postgres;

--
-- TOC entry 3769 (class 0 OID 0)
-- Dependencies: 217
-- Name: prodotto_codice_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.prodotto_codice_seq OWNED BY public.prodotto.codice;


--
-- TOC entry 233 (class 1259 OID 55457)
-- Name: recensione; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.recensione (
    ordiner integer NOT NULL,
    prodottor integer NOT NULL,
    voto integer NOT NULL,
    testo character varying(500),
    data date NOT NULL,
    CONSTRAINT recensione_voto_check CHECK (((voto > 0) AND (voto < 6)))
);


ALTER TABLE public.recensione OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 55299)
-- Name: scarpa; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.scarpa (
    codice integer NOT NULL,
    numero numeric(2,0) NOT NULL,
    superficie public.superfici NOT NULL
);


ALTER TABLE public.scarpa OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 55269)
-- Name: sede; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sede (
    codice integer NOT NULL,
    indirizzo character varying(50) NOT NULL,
    "città" character varying(20) NOT NULL,
    mail character varying(50) NOT NULL,
    telefono character varying(15) NOT NULL,
    CONSTRAINT sede_mail_check CHECK (((mail)::text ~~ '%_@__%.__%'::text))
);


ALTER TABLE public.sede OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 55268)
-- Name: sede_codice_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sede_codice_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sede_codice_seq OWNER TO postgres;

--
-- TOC entry 3770 (class 0 OID 0)
-- Dependencies: 215
-- Name: sede_codice_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sede_codice_seq OWNED BY public.sede.codice;


--
-- TOC entry 221 (class 1259 OID 55309)
-- Name: vestiario; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vestiario (
    codice integer NOT NULL,
    taglia character(1) NOT NULL,
    colore public.colori NOT NULL,
    CONSTRAINT vestiario_taglia_check CHECK ((taglia = ANY (ARRAY['S'::bpchar, 'M'::bpchar, 'L'::bpchar])))
);


ALTER TABLE public.vestiario OWNER TO postgres;

--
-- TOC entry 3524 (class 2604 OID 55370)
-- Name: ordine ricevuta; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ordine ALTER COLUMN ricevuta SET DEFAULT nextval('public.ordine_ricevuta_seq'::regclass);


--
-- TOC entry 3521 (class 2604 OID 55284)
-- Name: prodotto codice; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prodotto ALTER COLUMN codice SET DEFAULT nextval('public.prodotto_codice_seq'::regclass);


--
-- TOC entry 3520 (class 2604 OID 55272)
-- Name: sede codice; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sede ALTER COLUMN codice SET DEFAULT nextval('public.sede_codice_seq'::regclass);


--
-- TOC entry 3751 (class 0 OID 55358)
-- Dependencies: 225
-- Data for Name: cliente; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.cliente VALUES ('vicenza@aia.it', 'Vicenza', 'Giacomo', 'Piccioni', '0444321233', true);
INSERT INTO public.cliente VALUES ('pescara@aia.it', 'Pescara', 'Simone', 'Venuti', '094321122', true);
INSERT INTO public.cliente VALUES ('roma1@aia.it', 'Roma', 'Ilaria', 'Andatti', '019875231', true);
INSERT INTO public.cliente VALUES ('roma2@aia.it', 'Roma', 'Daniele', 'Doveri', '019875232', true);
INSERT INTO public.cliente VALUES ('napoli@aia.it', 'Napoli', 'Fabio', 'Maresca', '041297352', true);
INSERT INTO public.cliente VALUES ('nicrossi@gmail.com', 'Roma', 'Nicola', 'Rossi', '3356464820', false);
INSERT INTO public.cliente VALUES ('ettore.musatti@hotmail.com', 'Piacenza', 'Ettore', 'Musatti', '3289568338', false);
INSERT INTO public.cliente VALUES ('cristina.grana@inwind.it', 'Pescara', 'Cristina', 'Granatelli', '3476135624', false);
INSERT INTO public.cliente VALUES ('dona.brugnaro@libero.it', 'Vicenza', 'Donatello', 'Brugnaro', '3746464664', false);
INSERT INTO public.cliente VALUES ('costanzo.spada@gmail.com', 'Milano', 'Costanzo', 'Spadafora', '3475130650', false);
INSERT INTO public.cliente VALUES ('gabry.mazzo@gmail.it', 'Treviso', 'Gabriele', 'Mazzocchi', '3289461250', false);
INSERT INTO public.cliente VALUES ('stefy.florio@hotmail.com', 'Catania', 'Stefania', 'Florio', '3695946450', false);
INSERT INTO public.cliente VALUES ('gioele.ruffini@tiscali.it', 'Verona', 'Gioele', 'Ruffini', '3665674225', false);


--
-- TOC entry 3749 (class 0 OID 55334)
-- Dependencies: 223
-- Data for Name: contratto; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.contratto VALUES ('FRNFNC02T00L840I', '2022-01-01', 5000.00, NULL);
INSERT INTO public.contratto VALUES ('CNNMNL02B08L840I', '2022-01-01', 5000.00, NULL);
INSERT INTO public.contratto VALUES ('SCLFLO20C63A214B', '2022-06-01', 4000.00, NULL);
INSERT INTO public.contratto VALUES ('GRBDTL98D26C627T', '2022-01-01', 1400.00, NULL);
INSERT INTO public.contratto VALUES ('PRLCPN79E03H569B', '2023-02-01', 1300.00, '2023-05-31');
INSERT INTO public.contratto VALUES ('LSTMNN62E43I391M', '2022-01-01', 1600.00, NULL);
INSERT INTO public.contratto VALUES ('GLSTMR66H43A551D', '2023-06-01', 1600.00, '2023-12-31');
INSERT INTO public.contratto VALUES ('VGLRSN80E01G482O', '2022-01-01', 1400.00, NULL);
INSERT INTO public.contratto VALUES ('BTTMHL78E08G482Y', '2023-06-01', 1450.00, '2023-06-30');
INSERT INTO public.contratto VALUES ('MNLLRD92D09G713J', '2023-04-02', 1650.00, '2023-08-31');
INSERT INTO public.contratto VALUES ('BRFTZN89A06G482B', '2022-01-01', 1650.00, NULL);
INSERT INTO public.contratto VALUES ('SPNSFN85T57H501X', '2022-09-01', 1400.00, NULL);
INSERT INTO public.contratto VALUES ('SCLDNC79P09H501J', '2023-03-01', 1400.00, '2023-03-31');
INSERT INTO public.contratto VALUES ('PSNPSC95L46H501J', '2022-07-01', 1400.00, NULL);
INSERT INTO public.contratto VALUES ('CMCLVI93T13G811T', '2022-07-09', 1700.00, NULL);
INSERT INTO public.contratto VALUES ('RGNCRL89M71D773M', '2023-06-01', 1700.00, '2023-06-30');
INSERT INTO public.contratto VALUES ('REINNA93P27C000K', '2022-08-01', 1700.00, NULL);


--
-- TOC entry 3755 (class 0 OID 55393)
-- Dependencies: 229
-- Data for Name: dettagli_ordine; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.dettagli_ordine VALUES (1, 1, 10);
INSERT INTO public.dettagli_ordine VALUES (3, 1, 10);
INSERT INTO public.dettagli_ordine VALUES (4, 1, 12);
INSERT INTO public.dettagli_ordine VALUES (7, 1, 20);
INSERT INTO public.dettagli_ordine VALUES (9, 1, 20);
INSERT INTO public.dettagli_ordine VALUES (13, 1, 20);
INSERT INTO public.dettagli_ordine VALUES (35, 1, 2);
INSERT INTO public.dettagli_ordine VALUES (37, 1, 2);


--
-- TOC entry 3756 (class 0 OID 55409)
-- Dependencies: 230
-- Data for Name: dettagli_ordine_f; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.dettagli_ordine_f VALUES (1, 2, 'Nero', 20);
INSERT INTO public.dettagli_ordine_f VALUES (1, 3, 'Rosso', 10);
INSERT INTO public.dettagli_ordine_f VALUES (2, 2, 'Giallo', 10);
INSERT INTO public.dettagli_ordine_f VALUES (2, 3, 'Giallo-Nero', 10);
INSERT INTO public.dettagli_ordine_f VALUES (3, 2, 'Rosso', 10);
INSERT INTO public.dettagli_ordine_f VALUES (4, 2, 'Nero', 10);
INSERT INTO public.dettagli_ordine_f VALUES (5, 3, 'Giallo-Nero', 10);
INSERT INTO public.dettagli_ordine_f VALUES (5, 3, 'Nero', 10);
INSERT INTO public.dettagli_ordine_f VALUES (6, 2, 'Giallo', 10);
INSERT INTO public.dettagli_ordine_f VALUES (6, 2, 'Rosso', 10);
INSERT INTO public.dettagli_ordine_f VALUES (7, 3, 'Nero', 15);
INSERT INTO public.dettagli_ordine_f VALUES (8, 2, 'Rosso', 10);
INSERT INTO public.dettagli_ordine_f VALUES (8, 2, 'Nero', 20);
INSERT INTO public.dettagli_ordine_f VALUES (9, 2, 'Giallo', 10);
INSERT INTO public.dettagli_ordine_f VALUES (10, 2, 'Rosso', 10);
INSERT INTO public.dettagli_ordine_f VALUES (10, 3, 'Nero', 30);
INSERT INTO public.dettagli_ordine_f VALUES (10, 3, 'Rosso', 10);
INSERT INTO public.dettagli_ordine_f VALUES (11, 3, 'Giallo-Nero', 15);
INSERT INTO public.dettagli_ordine_f VALUES (11, 3, 'Nero', 20);
INSERT INTO public.dettagli_ordine_f VALUES (12, 2, 'Nero', 10);
INSERT INTO public.dettagli_ordine_f VALUES (12, 2, 'Giallo', 10);
INSERT INTO public.dettagli_ordine_f VALUES (12, 2, 'Rosso', 15);
INSERT INTO public.dettagli_ordine_f VALUES (12, 3, 'Giallo', 10);
INSERT INTO public.dettagli_ordine_f VALUES (12, 3, 'Giallo-Nero', 10);
INSERT INTO public.dettagli_ordine_f VALUES (12, 3, 'Nero', 10);
INSERT INTO public.dettagli_ordine_f VALUES (12, 3, 'Rosso', 10);
INSERT INTO public.dettagli_ordine_f VALUES (13, 2, 'Nero', 10);
INSERT INTO public.dettagli_ordine_f VALUES (13, 3, 'Nero', 20);
INSERT INTO public.dettagli_ordine_f VALUES (14, 4, 'Nero', 1);
INSERT INTO public.dettagli_ordine_f VALUES (16, 6, 'Nero', 1);
INSERT INTO public.dettagli_ordine_f VALUES (18, 5, 'Giallo-Nero', 1);
INSERT INTO public.dettagli_ordine_f VALUES (20, 7, 'Nero', 1);
INSERT INTO public.dettagli_ordine_f VALUES (22, 8, 'Nero', 1);
INSERT INTO public.dettagli_ordine_f VALUES (25, 5, 'Nero', 1);
INSERT INTO public.dettagli_ordine_f VALUES (26, 4, 'Giallo-Nero', 1);
INSERT INTO public.dettagli_ordine_f VALUES (28, 3, 'Giallo', 1);
INSERT INTO public.dettagli_ordine_f VALUES (32, 3, 'Rosso', 1);
INSERT INTO public.dettagli_ordine_f VALUES (32, 3, 'Nero', 1);
INSERT INTO public.dettagli_ordine_f VALUES (35, 2, 'Nero', 1);
INSERT INTO public.dettagli_ordine_f VALUES (37, 8, 'Nero', 1);


--
-- TOC entry 3757 (class 0 OID 55425)
-- Dependencies: 231
-- Data for Name: dettagli_ordine_s; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.dettagli_ordine_s VALUES (16, 9, 42, 'terra', 1);
INSERT INTO public.dettagli_ordine_s VALUES (16, 10, 42, 'sintetico', 1);
INSERT INTO public.dettagli_ordine_s VALUES (19, 11, 38, 'indoor', 1);
INSERT INTO public.dettagli_ordine_s VALUES (20, 13, 45, 'terra', 1);
INSERT INTO public.dettagli_ordine_s VALUES (23, 12, 43, 'sintetico', 1);
INSERT INTO public.dettagli_ordine_s VALUES (23, 13, 43, 'terra', 1);
INSERT INTO public.dettagli_ordine_s VALUES (24, 11, 42, 'indoor', 1);
INSERT INTO public.dettagli_ordine_s VALUES (27, 9, 41, 'terra', 1);
INSERT INTO public.dettagli_ordine_s VALUES (27, 12, 41, 'sintetico', 1);
INSERT INTO public.dettagli_ordine_s VALUES (28, 9, 43, 'terra', 1);
INSERT INTO public.dettagli_ordine_s VALUES (28, 10, 43, 'sintetico', 1);
INSERT INTO public.dettagli_ordine_s VALUES (29, 11, 39, 'indoor', 1);
INSERT INTO public.dettagli_ordine_s VALUES (31, 9, 44, 'terra', 1);
INSERT INTO public.dettagli_ordine_s VALUES (34, 9, 40, 'terra', 1);
INSERT INTO public.dettagli_ordine_s VALUES (34, 11, 40, 'indoor', 1);
INSERT INTO public.dettagli_ordine_s VALUES (36, 12, 42, 'sintetico', 1);
INSERT INTO public.dettagli_ordine_s VALUES (36, 13, 42, 'terra', 1);
INSERT INTO public.dettagli_ordine_s VALUES (38, 11, 41, 'indoor', 1);
INSERT INTO public.dettagli_ordine_s VALUES (40, 13, 44, 'terra', 1);


--
-- TOC entry 3758 (class 0 OID 55441)
-- Dependencies: 232
-- Data for Name: dettagli_ordine_v; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.dettagli_ordine_v VALUES (1, 14, 'M', 'Nero', 10);
INSERT INTO public.dettagli_ordine_v VALUES (1, 14, 'L', 'Nero', 15);
INSERT INTO public.dettagli_ordine_v VALUES (2, 14, 'S', 'Giallo', 10);
INSERT INTO public.dettagli_ordine_v VALUES (2, 14, 'M', 'Verde', 10);
INSERT INTO public.dettagli_ordine_v VALUES (3, 14, 'L', 'Giallo', 10);
INSERT INTO public.dettagli_ordine_v VALUES (4, 14, 'L', 'Nero', 15);
INSERT INTO public.dettagli_ordine_v VALUES (5, 14, 'S', 'Giallo', 10);
INSERT INTO public.dettagli_ordine_v VALUES (5, 14, 'M', 'Giallo', 10);
INSERT INTO public.dettagli_ordine_v VALUES (5, 14, 'L', 'Giallo', 10);
INSERT INTO public.dettagli_ordine_v VALUES (5, 14, 'M', 'Verde', 10);
INSERT INTO public.dettagli_ordine_v VALUES (5, 14, 'M', 'Nero', 15);
INSERT INTO public.dettagli_ordine_v VALUES (6, 14, 'L', 'Nero', 15);
INSERT INTO public.dettagli_ordine_v VALUES (6, 14, 'M', 'Giallo', 10);
INSERT INTO public.dettagli_ordine_v VALUES (6, 14, 'L', 'Giallo', 10);
INSERT INTO public.dettagli_ordine_v VALUES (8, 14, 'S', 'Giallo', 10);
INSERT INTO public.dettagli_ordine_v VALUES (8, 14, 'L', 'Verde', 10);
INSERT INTO public.dettagli_ordine_v VALUES (8, 14, 'L', 'Nero', 15);
INSERT INTO public.dettagli_ordine_v VALUES (9, 14, 'M', 'Nero', 15);
INSERT INTO public.dettagli_ordine_v VALUES (10, 14, 'S', 'Giallo', 10);
INSERT INTO public.dettagli_ordine_v VALUES (10, 14, 'M', 'Giallo', 10);
INSERT INTO public.dettagli_ordine_v VALUES (10, 14, 'L', 'Giallo', 10);
INSERT INTO public.dettagli_ordine_v VALUES (10, 14, 'M', 'Verde', 10);
INSERT INTO public.dettagli_ordine_v VALUES (10, 14, 'L', 'Nero', 15);
INSERT INTO public.dettagli_ordine_v VALUES (11, 14, 'S', 'Giallo', 10);
INSERT INTO public.dettagli_ordine_v VALUES (11, 14, 'L', 'Verde', 10);
INSERT INTO public.dettagli_ordine_v VALUES (11, 14, 'M', 'Nero', 15);
INSERT INTO public.dettagli_ordine_v VALUES (12, 14, 'L', 'Nero', 15);
INSERT INTO public.dettagli_ordine_v VALUES (12, 14, 'M', 'Verde', 10);
INSERT INTO public.dettagli_ordine_v VALUES (13, 14, 'S', 'Giallo', 10);
INSERT INTO public.dettagli_ordine_v VALUES (13, 14, 'M', 'Giallo', 10);
INSERT INTO public.dettagli_ordine_v VALUES (13, 14, 'L', 'Giallo', 10);
INSERT INTO public.dettagli_ordine_v VALUES (13, 14, 'M', 'Nero', 15);
INSERT INTO public.dettagli_ordine_v VALUES (13, 14, 'L', 'Verde', 10);
INSERT INTO public.dettagli_ordine_v VALUES (14, 15, 'L', 'Nero', 1);
INSERT INTO public.dettagli_ordine_v VALUES (14, 17, 'L', 'Nero', 1);
INSERT INTO public.dettagli_ordine_v VALUES (15, 16, 'S', 'Nero', 1);
INSERT INTO public.dettagli_ordine_v VALUES (17, 15, 'S', 'Nero', 1);
INSERT INTO public.dettagli_ordine_v VALUES (18, 15, 'S', 'Nero', 1);
INSERT INTO public.dettagli_ordine_v VALUES (19, 16, 'M', 'Nero', 1);
INSERT INTO public.dettagli_ordine_v VALUES (21, 17, 'M', 'Nero', 1);
INSERT INTO public.dettagli_ordine_v VALUES (22, 16, 'L', 'Nero', 1);
INSERT INTO public.dettagli_ordine_v VALUES (26, 14, 'M', 'Giallo', 1);
INSERT INTO public.dettagli_ordine_v VALUES (28, 14, 'L', 'Nero', 1);
INSERT INTO public.dettagli_ordine_v VALUES (30, 15, 'M', 'Nero', 1);
INSERT INTO public.dettagli_ordine_v VALUES (33, 16, 'S', 'Nero', 1);
INSERT INTO public.dettagli_ordine_v VALUES (36, 14, 'L', 'Verde', 1);
INSERT INTO public.dettagli_ordine_v VALUES (39, 17, 'S', 'Nero', 1);


--
-- TOC entry 3748 (class 0 OID 55320)
-- Dependencies: 222
-- Data for Name: dipendente; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.dipendente VALUES ('FRNFNC02T00L840I', 'Francesco', 'Furno', '3498853544', 'francesco@furno.it', 'Direttore', 1);
INSERT INTO public.dipendente VALUES ('CNNMNL02B08L840I', 'Manuel', 'Cinnirella', '3358493211', 'manuel@cinnirella.it', 'Direttore', 2);
INSERT INTO public.dipendente VALUES ('SCLFLO20C63A214B', 'Ofelia', 'Scalmani', '3422288774', 'ofelia.scalmani@hotmail.it', 'Direttore', 3);
INSERT INTO public.dipendente VALUES ('GRBDTL98D26C627T', 'Donatello', 'Garbino', '3408232081', 'donatello.garbino@hotmail.com', 'Commesso', 1);
INSERT INTO public.dipendente VALUES ('PRLCPN79E03H569B', 'Iacopone', 'Parolari', '3426317634', 'iacopone.parolari@gmail.com', 'Commesso', 1);
INSERT INTO public.dipendente VALUES ('LSTMNN62E43I391M', 'Marianna', 'Listri', '3472321850', 'marianna.listri@virgilio.it', 'Magazziniere', 1);
INSERT INTO public.dipendente VALUES ('GLSTMR66H43A551D', 'Tamara', 'Galasso', '3482617296', 'tamara.galasso@tiscali.it', 'Magazziniere', 1);
INSERT INTO public.dipendente VALUES ('VGLRSN80E01G482O', 'Arsenio', 'Vigliotti', '3478814956', 'arsenio.viglio@libero.it', 'Commesso', 2);
INSERT INTO public.dipendente VALUES ('BTTMHL78E08G482Y', 'Michelotto', 'Battaglia', '3662568942', 'michelotto.battaglia@gmail.com', 'Commesso', 2);
INSERT INTO public.dipendente VALUES ('MNLLRD92D09G713J', 'Leonardo', 'Manolesso', '3206159435', 'leo.mano@virgilio.it', 'Magazziniere', 2);
INSERT INTO public.dipendente VALUES ('BRFTZN89A06G482B', 'Tiziana', 'Baroffio', '3201435865', 'tiziana.baroffio@gmail.com', 'Magazziniere', 2);
INSERT INTO public.dipendente VALUES ('SPNSFN85T57H501X', 'Stefania', 'Spanevello', '3279728634', 'ste.spanevello@libero.it', 'Commesso', 3);
INSERT INTO public.dipendente VALUES ('SCLDNC79P09H501J', 'Domenico', 'Scalfaro', '3665686956', 'dome.scalfaro@hotmail.com', 'Commesso', 3);
INSERT INTO public.dipendente VALUES ('PSNPSC95L46H501J', 'Priscilla', 'Pisani', '3282036450', 'priscilla.pisani@libero.it', 'Commesso', 3);
INSERT INTO public.dipendente VALUES ('CMCLVI93T13G811T', 'Livio', 'Camuccini', '3409486335', 'livio.camuccini@gmail.com', 'Magazziniere', 3);
INSERT INTO public.dipendente VALUES ('RGNCRL89M71D773M', 'Carlo', 'Argento', '3425624615', 'carlo.argenti@inwind.it', 'Magazziniere', 3);
INSERT INTO public.dipendente VALUES ('REINNA93P27C000K', 'Anna', 'Rei', '3203491450', 'anna.rei@tiscali.it', 'Magazziniere', 3);


--
-- TOC entry 3750 (class 0 OID 55346)
-- Dependencies: 224
-- Data for Name: ferie; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.ferie VALUES ('FRNFNC02T00L840I', '2023-02-10', '2023-02-15', 'Approvata');
INSERT INTO public.ferie VALUES ('CNNMNL02B08L840I', '2023-09-24', '2023-09-29', 'Approvata');
INSERT INTO public.ferie VALUES ('SCLFLO20C63A214B', '2022-12-28', '2023-01-02', 'Approvata');
INSERT INTO public.ferie VALUES ('GRBDTL98D26C627T', '2023-10-30', '2023-11-03', 'In attesa');
INSERT INTO public.ferie VALUES ('LSTMNN62E43I391M', '2023-06-15', '2023-06-25', 'Rifiutata');
INSERT INTO public.ferie VALUES ('VGLRSN80E01G482O', '2023-08-12', '2023-08-19', 'In attesa');
INSERT INTO public.ferie VALUES ('BRFTZN89A06G482B', '2023-06-08', '2023-06-15', 'Rifiutata');
INSERT INTO public.ferie VALUES ('PSNPSC95L46H501J', '2022-06-10', '2022-06-20', 'Rifiutata');
INSERT INTO public.ferie VALUES ('REINNA93P27C000K', '2022-06-10', '2022-06-20', 'Approvata');


--
-- TOC entry 3745 (class 0 OID 55289)
-- Dependencies: 219
-- Data for Name: fischietto; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.fischietto VALUES (2, 'Nero', 'Plastica', 115);
INSERT INTO public.fischietto VALUES (2, 'Giallo', 'Plastica', 115);
INSERT INTO public.fischietto VALUES (2, 'Rosso', 'Plastica', 115);
INSERT INTO public.fischietto VALUES (3, 'Giallo', 'Plastica e gomma', 115);
INSERT INTO public.fischietto VALUES (3, 'Giallo-Nero', 'Plastica e gomma', 115);
INSERT INTO public.fischietto VALUES (3, 'Nero', 'Plastica e gomma', 115);
INSERT INTO public.fischietto VALUES (3, 'Rosso', 'Plastica e gomma', 115);
INSERT INTO public.fischietto VALUES (4, 'Nero', 'Plastica', 120);
INSERT INTO public.fischietto VALUES (4, 'Giallo-Nero', 'Plastica', 120);
INSERT INTO public.fischietto VALUES (5, 'Nero', 'Plastica e gomma', 120);
INSERT INTO public.fischietto VALUES (5, 'Giallo-Nero', 'Plastica e gomma', 120);
INSERT INTO public.fischietto VALUES (6, 'Nero', 'Plastica', 116);
INSERT INTO public.fischietto VALUES (7, 'Nero', 'Acciaio', 120);
INSERT INTO public.fischietto VALUES (8, 'Nero', 'Acciaio', 125);


--
-- TOC entry 3753 (class 0 OID 55367)
-- Dependencies: 227
-- Data for Name: ordine; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.ordine VALUES (1, '2022-09-01', 'LSTMNN62E43I391M');
INSERT INTO public.ordine VALUES (2, '2022-11-01', 'LSTMNN62E43I391M');
INSERT INTO public.ordine VALUES (3, '2023-06-06', 'GLSTMR66H43A551D');
INSERT INTO public.ordine VALUES (4, '2022-07-25', 'BRFTZN89A06G482B');
INSERT INTO public.ordine VALUES (5, '2023-05-01', 'MNLLRD92D09G713J');
INSERT INTO public.ordine VALUES (6, '2022-08-27', 'REINNA93P27C000K');
INSERT INTO public.ordine VALUES (7, '2023-05-29', 'RGNCRL89M71D773M');
INSERT INTO public.ordine VALUES (8, '2023-06-05', 'RGNCRL89M71D773M');
INSERT INTO public.ordine VALUES (9, '2022-08-17', 'CMCLVI93T13G811T');
INSERT INTO public.ordine VALUES (10, '2022-11-28', 'CMCLVI93T13G811T');
INSERT INTO public.ordine VALUES (11, '2023-06-06', 'RGNCRL89M71D773M');
INSERT INTO public.ordine VALUES (12, '2023-03-25', 'REINNA93P27C000K');
INSERT INTO public.ordine VALUES (13, '2023-05-30', 'CMCLVI93T13G811T');
INSERT INTO public.ordine VALUES (14, '2022-02-01', 'GRBDTL98D26C627T');
INSERT INTO public.ordine VALUES (15, '2022-11-07', 'GRBDTL98D26C627T');
INSERT INTO public.ordine VALUES (16, '2023-03-11', 'GRBDTL98D26C627T');
INSERT INTO public.ordine VALUES (17, '2023-02-05', 'PRLCPN79E03H569B');
INSERT INTO public.ordine VALUES (18, '2023-04-16', 'PRLCPN79E03H569B');
INSERT INTO public.ordine VALUES (19, '2022-02-18', 'VGLRSN80E01G482O');
INSERT INTO public.ordine VALUES (20, '2023-06-07', 'VGLRSN80E01G482O');
INSERT INTO public.ordine VALUES (21, '2023-05-09', 'VGLRSN80E01G482O');
INSERT INTO public.ordine VALUES (22, '2023-06-03', 'BTTMHL78E08G482Y');
INSERT INTO public.ordine VALUES (23, '2023-06-06', 'BTTMHL78E08G482Y');
INSERT INTO public.ordine VALUES (24, '2022-10-29', 'SPNSFN85T57H501X');
INSERT INTO public.ordine VALUES (25, '2023-01-17', 'SPNSFN85T57H501X');
INSERT INTO public.ordine VALUES (26, '2023-03-19', 'SCLDNC79P09H501J');
INSERT INTO public.ordine VALUES (27, '2022-12-10', 'PSNPSC95L46H501J');
INSERT INTO public.ordine VALUES (28, '2023-02-28', 'PSNPSC95L46H501J');
INSERT INTO public.ordine VALUES (29, '2023-04-04', 'PSNPSC95L46H501J');
INSERT INTO public.ordine VALUES (30, '2022-07-15', 'CMCLVI93T13G811T');
INSERT INTO public.ordine VALUES (31, '2022-12-08', 'REINNA93P27C000K');
INSERT INTO public.ordine VALUES (32, '2023-02-02', 'LSTMNN62E43I391M');
INSERT INTO public.ordine VALUES (33, '2022-08-10', 'BRFTZN89A06G482B');
INSERT INTO public.ordine VALUES (34, '2023-06-04', 'MNLLRD92D09G713J');
INSERT INTO public.ordine VALUES (35, '2023-06-08', 'GLSTMR66H43A551D');
INSERT INTO public.ordine VALUES (36, '2023-03-11', 'LSTMNN62E43I391M');
INSERT INTO public.ordine VALUES (37, '2023-06-03', 'GLSTMR66H43A551D');
INSERT INTO public.ordine VALUES (38, '2022-11-24', 'LSTMNN62E43I391M');
INSERT INTO public.ordine VALUES (39, '2023-06-07', 'REINNA93P27C000K');
INSERT INTO public.ordine VALUES (40, '2023-02-01', 'LSTMNN62E43I391M');


--
-- TOC entry 3754 (class 0 OID 55378)
-- Dependencies: 228
-- Data for Name: ordine_online; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.ordine_online VALUES (1, 'vicenza@aia.it', 'Via Lello 14', '36100', 'Vicenza', 'Bonifico Bancario', 'GLS', 'consegnato');
INSERT INTO public.ordine_online VALUES (2, 'vicenza@aia.it', 'Via Lello 14', '36100', 'Vicenza', 'Bonifico Bancario', 'GLS', 'consegnato');
INSERT INTO public.ordine_online VALUES (3, 'vicenza@aia.it', 'Via Lello 14', '36100', 'Vicenza', 'Bonifico Bancario', 'SDA', 'in elaborazione');
INSERT INTO public.ordine_online VALUES (4, 'pescara@aia.it', 'Via F.Rossi 21', '65121', 'Pescara', 'Bonifico Bancario', 'BRT', 'consegnato');
INSERT INTO public.ordine_online VALUES (5, 'pescara@aia.it', 'Via F.Rossi 21', '65121', 'Pescara', 'Bonifico Bancario', 'BRT', 'consegnato');
INSERT INTO public.ordine_online VALUES (6, 'roma1@aia.it', 'Via Garibaldi 55', '00118', 'Roma', 'Bonifico Bancario', 'DHL', 'consegnato');
INSERT INTO public.ordine_online VALUES (7, 'roma1@aia.it', 'Via Garibaldi 55', '00118', 'Roma', 'Bonifico Bancario', 'TNT', 'spedito');
INSERT INTO public.ordine_online VALUES (8, 'roma1@aia.it', 'Via Garibaldi 55', '00118', 'Roma', 'Bonifico Bancario', 'DHL', 'in elaborazione');
INSERT INTO public.ordine_online VALUES (9, 'roma2@aia.it', 'Via Rossini 17', '00118', 'Roma', 'Bonifico Bancario', 'GLS', 'consegnato');
INSERT INTO public.ordine_online VALUES (10, 'roma2@aia.it', 'Via Rossini 17', '00118', 'Roma', 'Bonifico Bancario', 'GLS', 'consegnato');
INSERT INTO public.ordine_online VALUES (11, 'roma2@aia.it', 'Via Rossini 17', '00118', 'Roma', 'Bonifico Bancario', 'GLS', 'in elaborazione');
INSERT INTO public.ordine_online VALUES (12, 'napoli@aia.it', 'Via Brombeis 10', '80013', 'Napoli', 'Bonifico Bancario', 'BRT', 'consegnato');
INSERT INTO public.ordine_online VALUES (13, 'napoli@aia.it', 'Via Brombeis 10', '80013', 'Napoli', 'Bonifico Bancario', 'SDA', 'spedito');
INSERT INTO public.ordine_online VALUES (30, 'nicrossi@gmail.com', 'Via Molinari 20', '00123', 'Roma', 'Carta di Credito', 'TNT', 'consegnato');
INSERT INTO public.ordine_online VALUES (31, 'nicrossi@gmail.com', 'Via Molinari 20', '00123', 'Roma', 'Carta di Credito', 'SDA', 'consegnato');
INSERT INTO public.ordine_online VALUES (32, 'ettore.musatti@hotmail.com', 'Via Oreste 6', '29121', 'Piacenza', 'Bonifico Bancario', 'SDA', 'consegnato');
INSERT INTO public.ordine_online VALUES (33, 'cristina.grana@inwind.it', 'Via B.Gaetano 9', '65123', 'Pescara', 'Bonifico Bancario', 'BRT', 'consegnato');
INSERT INTO public.ordine_online VALUES (34, 'cristina.grana@inwind.it', 'Via B.Gaetano 9', '65123', 'Pescara', 'Bonifico Bancario', 'DHL', 'spedito');
INSERT INTO public.ordine_online VALUES (35, 'dona.brugnaro@libero.it', 'Viale Crispi 16', '36100', 'Vicenza', 'PayPal', 'GLS', 'in elaborazione');
INSERT INTO public.ordine_online VALUES (36, 'costanzo.spada@gmail.com', 'Via Albertini 42', '20021', 'Milano', 'Bonifico Bancario', 'SDA', 'consegnato');
INSERT INTO public.ordine_online VALUES (37, 'costanzo.spada@gmail.com', 'Via Albertini 42', '20021', 'Milano', 'Bonifico Bancario', 'GLS', 'spedito');
INSERT INTO public.ordine_online VALUES (38, 'gabry.mazzo@gmail.it', 'Via S.Daniele 25', '31100', 'Treviso', 'Bonifico Bancario', 'TNT', 'consegnato');
INSERT INTO public.ordine_online VALUES (39, 'stefy.florio@hotmail.com', 'Via Androne 4', '95121', 'Catania', 'Bonifico Bancario', 'TNT', 'in elaborazione');
INSERT INTO public.ordine_online VALUES (40, 'gioele.ruffini@tiscali.it', 'Via Cantore 8', '37100', 'Verona', 'Bonifico Bancario', 'GLS', 'consegnato');


--
-- TOC entry 3744 (class 0 OID 55281)
-- Dependencies: 218
-- Data for Name: prodotto; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.prodotto VALUES (1, 'Bandierina standard', 'Refs', 9.99, 2.7);
INSERT INTO public.prodotto VALUES (2, 'Foxe 40', 'Foxe', 4.99, 3.2);
INSERT INTO public.prodotto VALUES (3, 'Foxe 40 CMG', 'Foxe', 6.99, 4.0);
INSERT INTO public.prodotto VALUES (4, 'Ultra Sonik', 'Foxe', 7.99, NULL);
INSERT INTO public.prodotto VALUES (5, 'Ultra Sonik CMG', 'Foxe', 9.99, NULL);
INSERT INTO public.prodotto VALUES (6, 'Dolphin', 'Moltin', 14.99, NULL);
INSERT INTO public.prodotto VALUES (7, 'Blazer', 'Moltin', 39.99, NULL);
INSERT INTO public.prodotto VALUES (8, 'Pro', 'Moltin', 49.99, NULL);
INSERT INTO public.prodotto VALUES (9, 'TopRef', 'FTech', 119.99, 5.0);
INSERT INTO public.prodotto VALUES (10, 'TT', 'FTech', 109.99, NULL);
INSERT INTO public.prodotto VALUES (11, 'FFutsal', 'FTech', 99.99, 5.0);
INSERT INTO public.prodotto VALUES (12, 'Mundialito', 'Copas', 79.99, 4.0);
INSERT INTO public.prodotto VALUES (13, 'Mundial', 'Copas', 99.99, 4.0);
INSERT INTO public.prodotto VALUES (14, 'Divisa gara', 'Gioma', 69.99, 4.3);
INSERT INTO public.prodotto VALUES (15, 'Felpa allenamento', 'Gioma', 29.99, 3.0);
INSERT INTO public.prodotto VALUES (16, 'K-way', 'Gioma', 14.99, 5.0);
INSERT INTO public.prodotto VALUES (17, 'Pantalone tuta', 'Gioma', 19.99, NULL);


--
-- TOC entry 3759 (class 0 OID 55457)
-- Dependencies: 233
-- Data for Name: recensione; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.recensione VALUES (1, 1, 3, 'Non è sta gran bandierina.', '2022-09-25');
INSERT INTO public.recensione VALUES (1, 3, 5, 'Suono eccellente.', '2022-09-25');
INSERT INTO public.recensione VALUES (1, 14, 5, NULL, '2022-09-25');
INSERT INTO public.recensione VALUES (2, 2, 4, NULL, '2022-11-23');
INSERT INTO public.recensione VALUES (2, 3, 5, NULL, '2022-11-23');
INSERT INTO public.recensione VALUES (2, 14, 5, NULL, '2022-11-23');
INSERT INTO public.recensione VALUES (4, 1, 2, 'Mi aspettavo di meglio.', '2022-08-15');
INSERT INTO public.recensione VALUES (4, 2, 4, 'Buono.', '2022-08-15');
INSERT INTO public.recensione VALUES (4, 14, 5, 'Veste molto bene.', '2022-08-15');
INSERT INTO public.recensione VALUES (5, 3, 5, 'Ottimo come sempre', '2023-06-02');
INSERT INTO public.recensione VALUES (5, 14, 5, NULL, '2023-06-02');
INSERT INTO public.recensione VALUES (6, 2, 3, NULL, '2022-09-12');
INSERT INTO public.recensione VALUES (6, 14, 4, NULL, '2022-09-12');
INSERT INTO public.recensione VALUES (9, 1, 3, 'Si trova di meglio.', '2022-09-04');
INSERT INTO public.recensione VALUES (9, 2, 3, NULL, '2022-09-04');
INSERT INTO public.recensione VALUES (9, 14, 4, NULL, '2022-09-04');
INSERT INTO public.recensione VALUES (10, 2, 3, NULL, '2022-12-20');
INSERT INTO public.recensione VALUES (10, 3, 4, NULL, '2022-12-20');
INSERT INTO public.recensione VALUES (10, 14, 4, 'Vestono giuste.', '2022-12-20');
INSERT INTO public.recensione VALUES (12, 2, 2, NULL, '2023-04-16');
INSERT INTO public.recensione VALUES (12, 3, 4, NULL, '2023-04-16');
INSERT INTO public.recensione VALUES (12, 14, 4, NULL, '2023-04-16');
INSERT INTO public.recensione VALUES (30, 15, 3, NULL, '2022-08-05');
INSERT INTO public.recensione VALUES (31, 9, 5, 'Calzano perfettamente.', '2023-01-04');
INSERT INTO public.recensione VALUES (32, 3, 1, 'Pessimo suono.', '2023-02-27');
INSERT INTO public.recensione VALUES (33, 16, 5, NULL, '2022-09-03');
INSERT INTO public.recensione VALUES (36, 12, 4, NULL, '2023-04-02');
INSERT INTO public.recensione VALUES (36, 13, 4, 'Soddifatto.', '2023-04-02');
INSERT INTO public.recensione VALUES (36, 14, 3, NULL, '2023-04-02');
INSERT INTO public.recensione VALUES (38, 11, 5, 'Belle scarpe.', '2022-12-18');
INSERT INTO public.recensione VALUES (40, 13, 4, 'Buon rapporto qualità-prezzo.', '2023-02-28');


--
-- TOC entry 3746 (class 0 OID 55299)
-- Dependencies: 220
-- Data for Name: scarpa; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.scarpa VALUES (9, 40, 'terra');
INSERT INTO public.scarpa VALUES (9, 41, 'terra');
INSERT INTO public.scarpa VALUES (9, 42, 'terra');
INSERT INTO public.scarpa VALUES (9, 43, 'terra');
INSERT INTO public.scarpa VALUES (9, 44, 'terra');
INSERT INTO public.scarpa VALUES (10, 41, 'sintetico');
INSERT INTO public.scarpa VALUES (10, 42, 'sintetico');
INSERT INTO public.scarpa VALUES (10, 43, 'sintetico');
INSERT INTO public.scarpa VALUES (11, 38, 'indoor');
INSERT INTO public.scarpa VALUES (11, 39, 'indoor');
INSERT INTO public.scarpa VALUES (11, 40, 'indoor');
INSERT INTO public.scarpa VALUES (11, 41, 'indoor');
INSERT INTO public.scarpa VALUES (11, 42, 'indoor');
INSERT INTO public.scarpa VALUES (12, 41, 'sintetico');
INSERT INTO public.scarpa VALUES (12, 42, 'sintetico');
INSERT INTO public.scarpa VALUES (12, 43, 'sintetico');
INSERT INTO public.scarpa VALUES (13, 42, 'terra');
INSERT INTO public.scarpa VALUES (13, 43, 'terra');
INSERT INTO public.scarpa VALUES (13, 44, 'terra');
INSERT INTO public.scarpa VALUES (13, 45, 'terra');


--
-- TOC entry 3742 (class 0 OID 55269)
-- Dependencies: 216
-- Data for Name: sede; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.sede VALUES (1, 'Via dello Sport 13', 'Vicenza', 'vicenza@refsport.it', '0444314873');
INSERT INTO public.sede VALUES (2, 'Via Aldo Moro 22', 'Pescara', 'pescara@refsport.it', '085248371');
INSERT INTO public.sede VALUES (3, 'Via Luigi Luzzati 2', 'Roma', 'roma@refsport.it', '06880652');


--
-- TOC entry 3747 (class 0 OID 55309)
-- Dependencies: 221
-- Data for Name: vestiario; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.vestiario VALUES (14, 'S', 'Giallo');
INSERT INTO public.vestiario VALUES (14, 'M', 'Giallo');
INSERT INTO public.vestiario VALUES (14, 'L', 'Giallo');
INSERT INTO public.vestiario VALUES (14, 'M', 'Verde');
INSERT INTO public.vestiario VALUES (14, 'L', 'Verde');
INSERT INTO public.vestiario VALUES (14, 'M', 'Nero');
INSERT INTO public.vestiario VALUES (14, 'L', 'Nero');
INSERT INTO public.vestiario VALUES (15, 'S', 'Nero');
INSERT INTO public.vestiario VALUES (15, 'M', 'Nero');
INSERT INTO public.vestiario VALUES (15, 'L', 'Nero');
INSERT INTO public.vestiario VALUES (16, 'S', 'Nero');
INSERT INTO public.vestiario VALUES (16, 'M', 'Nero');
INSERT INTO public.vestiario VALUES (16, 'L', 'Nero');
INSERT INTO public.vestiario VALUES (17, 'S', 'Nero');
INSERT INTO public.vestiario VALUES (17, 'M', 'Nero');
INSERT INTO public.vestiario VALUES (17, 'L', 'Nero');


--
-- TOC entry 3771 (class 0 OID 0)
-- Dependencies: 226
-- Name: ordine_ricevuta_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ordine_ricevuta_seq', 40, true);


--
-- TOC entry 3772 (class 0 OID 0)
-- Dependencies: 217
-- Name: prodotto_codice_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.prodotto_codice_seq', 17, true);


--
-- TOC entry 3773 (class 0 OID 0)
-- Dependencies: 215
-- Name: sede_codice_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sede_codice_seq', 3, true);


--
-- TOC entry 3562 (class 2606 OID 55363)
-- Name: cliente cliente_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT cliente_pkey PRIMARY KEY (mail);


--
-- TOC entry 3564 (class 2606 OID 55365)
-- Name: cliente cliente_telefono_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT cliente_telefono_key UNIQUE (telefono);


--
-- TOC entry 3558 (class 2606 OID 55340)
-- Name: contratto contratto_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contratto
    ADD CONSTRAINT contratto_pkey PRIMARY KEY (dipendente, inizio);


--
-- TOC entry 3572 (class 2606 OID 55414)
-- Name: dettagli_ordine_f dettagli_ordine_f_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dettagli_ordine_f
    ADD CONSTRAINT dettagli_ordine_f_pkey PRIMARY KEY (ordinef, prodottof, colore);


--
-- TOC entry 3570 (class 2606 OID 55398)
-- Name: dettagli_ordine dettagli_ordine_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dettagli_ordine
    ADD CONSTRAINT dettagli_ordine_pkey PRIMARY KEY (ordinep, prodottop);


--
-- TOC entry 3574 (class 2606 OID 55430)
-- Name: dettagli_ordine_s dettagli_ordine_s_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dettagli_ordine_s
    ADD CONSTRAINT dettagli_ordine_s_pkey PRIMARY KEY (ordines, prodottos, numero, superficie);


--
-- TOC entry 3576 (class 2606 OID 55446)
-- Name: dettagli_ordine_v dettagli_ordine_v_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dettagli_ordine_v
    ADD CONSTRAINT dettagli_ordine_v_pkey PRIMARY KEY (ordinev, prodottov, taglia, colore);


--
-- TOC entry 3552 (class 2606 OID 55328)
-- Name: dipendente dipendente_mail_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dipendente
    ADD CONSTRAINT dipendente_mail_key UNIQUE (mail);


--
-- TOC entry 3554 (class 2606 OID 55324)
-- Name: dipendente dipendente_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dipendente
    ADD CONSTRAINT dipendente_pkey PRIMARY KEY (cf);


--
-- TOC entry 3556 (class 2606 OID 55326)
-- Name: dipendente dipendente_telefono_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dipendente
    ADD CONSTRAINT dipendente_telefono_key UNIQUE (telefono);


--
-- TOC entry 3560 (class 2606 OID 55352)
-- Name: ferie ferie_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ferie
    ADD CONSTRAINT ferie_pkey PRIMARY KEY (dipendente, inizio, fine);


--
-- TOC entry 3546 (class 2606 OID 55293)
-- Name: fischietto fischietto_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fischietto
    ADD CONSTRAINT fischietto_pkey PRIMARY KEY (codice, colore);


--
-- TOC entry 3568 (class 2606 OID 55382)
-- Name: ordine_online ordine_online_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ordine_online
    ADD CONSTRAINT ordine_online_pkey PRIMARY KEY (ricevuta);


--
-- TOC entry 3566 (class 2606 OID 55372)
-- Name: ordine ordine_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ordine
    ADD CONSTRAINT ordine_pkey PRIMARY KEY (ricevuta);


--
-- TOC entry 3544 (class 2606 OID 55287)
-- Name: prodotto prodotto_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prodotto
    ADD CONSTRAINT prodotto_pkey PRIMARY KEY (codice);


--
-- TOC entry 3579 (class 2606 OID 55464)
-- Name: recensione recensione_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recensione
    ADD CONSTRAINT recensione_pkey PRIMARY KEY (ordiner, prodottor);


--
-- TOC entry 3548 (class 2606 OID 55303)
-- Name: scarpa scarpa_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scarpa
    ADD CONSTRAINT scarpa_pkey PRIMARY KEY (codice, numero, superficie);


--
-- TOC entry 3537 (class 2606 OID 55277)
-- Name: sede sede_mail_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sede
    ADD CONSTRAINT sede_mail_key UNIQUE (mail);


--
-- TOC entry 3539 (class 2606 OID 55275)
-- Name: sede sede_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sede
    ADD CONSTRAINT sede_pkey PRIMARY KEY (codice);


--
-- TOC entry 3541 (class 2606 OID 55279)
-- Name: sede sede_telefono_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sede
    ADD CONSTRAINT sede_telefono_key UNIQUE (telefono);


--
-- TOC entry 3550 (class 2606 OID 55314)
-- Name: vestiario vestiario_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vestiario
    ADD CONSTRAINT vestiario_pkey PRIMARY KEY (codice, taglia, colore);


--
-- TOC entry 3542 (class 1259 OID 55288)
-- Name: idx_codice; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_codice ON public.prodotto USING btree (nome);


--
-- TOC entry 3577 (class 1259 OID 55475)
-- Name: prodotti_recensioni; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX prodotti_recensioni ON public.recensione USING btree (prodottor, voto);


--
-- TOC entry 3584 (class 2606 OID 55341)
-- Name: contratto contratto_dipendente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contratto
    ADD CONSTRAINT contratto_dipendente_fkey FOREIGN KEY (dipendente) REFERENCES public.dipendente(cf);


--
-- TOC entry 3591 (class 2606 OID 55415)
-- Name: dettagli_ordine_f dettagli_ordine_f_ordinef_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dettagli_ordine_f
    ADD CONSTRAINT dettagli_ordine_f_ordinef_fkey FOREIGN KEY (ordinef) REFERENCES public.ordine(ricevuta);


--
-- TOC entry 3592 (class 2606 OID 55420)
-- Name: dettagli_ordine_f dettagli_ordine_f_prodottof_colore_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dettagli_ordine_f
    ADD CONSTRAINT dettagli_ordine_f_prodottof_colore_fkey FOREIGN KEY (prodottof, colore) REFERENCES public.fischietto(codice, colore);


--
-- TOC entry 3589 (class 2606 OID 55399)
-- Name: dettagli_ordine dettagli_ordine_ordinep_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dettagli_ordine
    ADD CONSTRAINT dettagli_ordine_ordinep_fkey FOREIGN KEY (ordinep) REFERENCES public.ordine(ricevuta);


--
-- TOC entry 3590 (class 2606 OID 55404)
-- Name: dettagli_ordine dettagli_ordine_prodottop_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dettagli_ordine
    ADD CONSTRAINT dettagli_ordine_prodottop_fkey FOREIGN KEY (prodottop) REFERENCES public.prodotto(codice);


--
-- TOC entry 3593 (class 2606 OID 55431)
-- Name: dettagli_ordine_s dettagli_ordine_s_ordines_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dettagli_ordine_s
    ADD CONSTRAINT dettagli_ordine_s_ordines_fkey FOREIGN KEY (ordines) REFERENCES public.ordine(ricevuta);


--
-- TOC entry 3594 (class 2606 OID 55436)
-- Name: dettagli_ordine_s dettagli_ordine_s_prodottos_numero_superficie_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dettagli_ordine_s
    ADD CONSTRAINT dettagli_ordine_s_prodottos_numero_superficie_fkey FOREIGN KEY (prodottos, numero, superficie) REFERENCES public.scarpa(codice, numero, superficie);


--
-- TOC entry 3595 (class 2606 OID 55447)
-- Name: dettagli_ordine_v dettagli_ordine_v_ordinev_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dettagli_ordine_v
    ADD CONSTRAINT dettagli_ordine_v_ordinev_fkey FOREIGN KEY (ordinev) REFERENCES public.ordine(ricevuta);


--
-- TOC entry 3596 (class 2606 OID 55452)
-- Name: dettagli_ordine_v dettagli_ordine_v_prodottov_taglia_colore_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dettagli_ordine_v
    ADD CONSTRAINT dettagli_ordine_v_prodottov_taglia_colore_fkey FOREIGN KEY (prodottov, taglia, colore) REFERENCES public.vestiario(codice, taglia, colore);


--
-- TOC entry 3583 (class 2606 OID 55329)
-- Name: dipendente dipendente_sedelavorativa_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dipendente
    ADD CONSTRAINT dipendente_sedelavorativa_fkey FOREIGN KEY (sedelavorativa) REFERENCES public.sede(codice);


--
-- TOC entry 3585 (class 2606 OID 55353)
-- Name: ferie ferie_dipendente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ferie
    ADD CONSTRAINT ferie_dipendente_fkey FOREIGN KEY (dipendente) REFERENCES public.dipendente(cf);


--
-- TOC entry 3580 (class 2606 OID 55294)
-- Name: fischietto fischietto_codice_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fischietto
    ADD CONSTRAINT fischietto_codice_fkey FOREIGN KEY (codice) REFERENCES public.prodotto(codice);


--
-- TOC entry 3586 (class 2606 OID 55373)
-- Name: ordine ordine_gestore_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ordine
    ADD CONSTRAINT ordine_gestore_fkey FOREIGN KEY (gestore) REFERENCES public.dipendente(cf);


--
-- TOC entry 3587 (class 2606 OID 55388)
-- Name: ordine_online ordine_online_cliente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ordine_online
    ADD CONSTRAINT ordine_online_cliente_fkey FOREIGN KEY (cliente) REFERENCES public.cliente(mail);


--
-- TOC entry 3588 (class 2606 OID 55383)
-- Name: ordine_online ordine_online_ricevuta_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ordine_online
    ADD CONSTRAINT ordine_online_ricevuta_fkey FOREIGN KEY (ricevuta) REFERENCES public.ordine(ricevuta);


--
-- TOC entry 3597 (class 2606 OID 55465)
-- Name: recensione recensione_ordiner_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recensione
    ADD CONSTRAINT recensione_ordiner_fkey FOREIGN KEY (ordiner) REFERENCES public.ordine_online(ricevuta);


--
-- TOC entry 3598 (class 2606 OID 55470)
-- Name: recensione recensione_prodottor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recensione
    ADD CONSTRAINT recensione_prodottor_fkey FOREIGN KEY (prodottor) REFERENCES public.prodotto(codice);


--
-- TOC entry 3581 (class 2606 OID 55304)
-- Name: scarpa scarpa_codice_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scarpa
    ADD CONSTRAINT scarpa_codice_fkey FOREIGN KEY (codice) REFERENCES public.prodotto(codice);


--
-- TOC entry 3582 (class 2606 OID 55315)
-- Name: vestiario vestiario_codice_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vestiario
    ADD CONSTRAINT vestiario_codice_fkey FOREIGN KEY (codice) REFERENCES public.prodotto(codice);


-- Completed on 2023-06-09 20:00:44 CEST

--
-- PostgreSQL database dump complete
--

