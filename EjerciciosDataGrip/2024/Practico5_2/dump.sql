--
-- PostgreSQL database dump
--

-- Dumped from database version 15.0
-- Dumped by pg_dump version 15.6 (Ubuntu 15.6-1.pgdg20.04+1)

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
-- Name: unc_esq_voluntario; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA unc_esq_voluntario;


ALTER SCHEMA unc_esq_voluntario OWNER TO postgres;

--
-- Name: SCHEMA unc_esq_voluntario; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA unc_esq_voluntario IS 'Esquema de Voluntarios de la Cátedra';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: continente; Type: TABLE; Schema: unc_esq_voluntario; Owner: postgres
--

CREATE TABLE unc_esq_voluntario.continente (
    nombre_continente character varying(25),
    id_continente numeric NOT NULL
)
WITH (autovacuum_enabled='true');


ALTER TABLE unc_esq_voluntario.continente OWNER TO postgres;

--
-- Name: direccion; Type: TABLE; Schema: unc_esq_voluntario; Owner: postgres
--

CREATE TABLE unc_esq_voluntario.direccion (
    calle character varying(40),
    codigo_postal character varying(12),
    ciudad character varying(30) NOT NULL,
    provincia character varying(25),
    id_pais character(2) NOT NULL,
    id_direccion numeric(4,0) NOT NULL
)
WITH (autovacuum_enabled='true');


ALTER TABLE unc_esq_voluntario.direccion OWNER TO postgres;

--
-- Name: historico; Type: TABLE; Schema: unc_esq_voluntario; Owner: postgres
--

CREATE TABLE unc_esq_voluntario.historico (
    fecha_inicio date NOT NULL,
    nro_voluntario numeric(6,0) NOT NULL,
    fecha_fin date NOT NULL,
    id_tarea character varying(10) NOT NULL,
    id_institucion numeric(4,0),
    CONSTRAINT historico_check CHECK ((fecha_fin > fecha_inicio))
)
WITH (autovacuum_enabled='true');


ALTER TABLE unc_esq_voluntario.historico OWNER TO postgres;

--
-- Name: institucion; Type: TABLE; Schema: unc_esq_voluntario; Owner: postgres
--

CREATE TABLE unc_esq_voluntario.institucion (
    nombre_institucion character varying(60) NOT NULL,
    id_director numeric(6,0),
    id_direccion numeric(4,0),
    id_institucion numeric(4,0) NOT NULL
)
WITH (autovacuum_enabled='true');


ALTER TABLE unc_esq_voluntario.institucion OWNER TO postgres;

--
-- Name: pais; Type: TABLE; Schema: unc_esq_voluntario; Owner: postgres
--

CREATE TABLE unc_esq_voluntario.pais (
    nombre_pais character varying(40),
    id_continente numeric NOT NULL,
    id_pais character(2) NOT NULL
)
WITH (autovacuum_enabled='true');


ALTER TABLE unc_esq_voluntario.pais OWNER TO postgres;

--
-- Name: tarea; Type: TABLE; Schema: unc_esq_voluntario; Owner: postgres
--

CREATE TABLE unc_esq_voluntario.tarea (
    nombre_tarea character varying(40) NOT NULL,
    min_horas numeric(6,0),
    id_tarea character varying(10) NOT NULL,
    max_horas numeric(6,0)
)
WITH (autovacuum_enabled='true');


ALTER TABLE unc_esq_voluntario.tarea OWNER TO postgres;

--
-- Name: voluntario; Type: TABLE; Schema: unc_esq_voluntario; Owner: postgres
--

CREATE TABLE unc_esq_voluntario.voluntario (
    nombre character varying(20),
    apellido character varying(25) NOT NULL,
    e_mail character varying(40) NOT NULL,
    telefono character varying(20),
    fecha_nacimiento date NOT NULL,
    id_tarea character varying(10) NOT NULL,
    nro_voluntario numeric(6,0) NOT NULL,
    horas_aportadas numeric(8,2),
    porcentaje numeric(2,2),
    id_institucion numeric(4,0),
    id_coordinador numeric(6,0),
    CONSTRAINT chk_hs_ap CHECK ((horas_aportadas > (0)::numeric)),
    CONSTRAINT ck_horas_aportadas CHECK (((horas_aportadas <= (24000)::numeric) AND (id_coordinador < (206)::numeric)))
)
WITH (autovacuum_enabled='true');


ALTER TABLE unc_esq_voluntario.voluntario OWNER TO postgres;

--
-- Data for Name: continente; Type: TABLE DATA; Schema: unc_esq_voluntario; Owner: postgres
--

COPY unc_esq_voluntario.continente (nombre_continente, id_continente) FROM stdin;
Europeo	1
Norte Americano	2
Asiatico	3
Africano	4
Sud Americano	5
Oceania	6
\.


--
-- Data for Name: direccion; Type: TABLE DATA; Schema: unc_esq_voluntario; Owner: postgres
--

COPY unc_esq_voluntario.direccion (calle, codigo_postal, ciudad, provincia, id_pais, id_direccion) FROM stdin;
1297 Via Cola di Rie	00989	Roma	\N	IT	1000
93091 Calle della Testa	10934	Venice	\N	IT	1100
2017 Shinjuku-ku	1689	Tokyo	Tokyo Prefecture	JP	1200
9450 Kamiya-cho	6823	Hiroshima	\N	JP	1300
2014 Jabberwocky Rd	26192	Southlake	Texas	US	1400
2011 Interiors Blvd	99236	South San Francisco	California	US	1500
2007 Zagora St	50090	South Brunswick	New Jersey	US	1600
2004 Charade Rd	98199	Seattle	Washington	US	1700
147 Spadina Ave	M5V 2L7	Toronto	Ontario	CA	1800
6092 Boxwood St	YSW 9T2	Whitehorse	Yukon	CA	1900
40-5-12 Laogianggen	190518	Beijing	\N	CN	2000
1298 Vileparle (E)	490231	Bombay	Maharashtra	IN	2100
12-98 Victoria Street	2901	Sydney	New South Wales	AU	2200
198 Clementi North	540198	Singapore	\N	SG	2300
8204 Arthur St	\N	London	\N	UK	2400
Magdalen Centre, The Oxford Science Park	OX9 9ZB	Oxford	Oxford	UK	2500
9702 Chester Road	09629850293	Stretford	Manchester	UK	2600
Schwanthalerstr. 7031	80925	Munich	Bavaria	DE	2700
Rua Frei Caneca 1360 	01307-002	Sao Paulo	Sao Paulo	BR	2800
20 Rue des Corps-Saints	1730	Geneva	Geneve	CH	2900
Murtenstrasse 921	3095	Bern	BE	CH	3000
Pieter Breughelstraat 837	3029SK	Utrecht	Utrecht	NL	3100
Mariano Escobedo 9991	11932	Mexico City	Distrito Federal,	MX	3200
\.


--
-- Data for Name: historico; Type: TABLE DATA; Schema: unc_esq_voluntario; Owner: postgres
--

COPY unc_esq_voluntario.historico (fecha_inicio, nro_voluntario, fecha_fin, id_tarea, id_institucion) FROM stdin;
1993-01-13	102	1998-07-24	IT_PROG	60
1989-09-21	101	1993-10-27	AC_ACCOUNT	110
1993-10-28	101	1997-03-15	AC_MGR	110
1996-02-17	201	1999-12-19	MK_REP	20
1998-03-24	114	1999-12-31	ST_CLERK	50
1999-01-01	122	1999-12-31	ST_CLERK	50
1987-09-17	200	1993-06-17	AD_ASST	90
1998-03-24	176	1998-12-31	SA_REP	80
1999-01-01	176	1999-12-31	SA_MAN	80
1994-07-01	200	1998-12-31	AC_ACCOUNT	90
1970-01-06	176	2019-08-28	SA_MAN	20
\.


--
-- Data for Name: institucion; Type: TABLE DATA; Schema: unc_esq_voluntario; Owner: postgres
--

COPY unc_esq_voluntario.institucion (nombre_institucion, id_director, id_direccion, id_institucion) FROM stdin;
CASA DE LA PROVIDENCIA	200	1700	10
CORPORACION URRACAS DE EMAUS	201	1800	20
FUNDACION CIVITAS	114	1700	30
FUNDACION LAS ROSAS DE AYUDA FRATERNA	203	2400	40
FUNDACION HOGAR DE CRISTO	121	1500	50
FUNDACION MI CASA	103	1400	60
CORPORACION SOLIDARIDAD Y DESARROLLO	204	2700	70
FUNDACION REGAZO	145	2500	80
FUNDACION ALERTA BOSQUES	100	1700	90
BOSQUEDUCA	108	1700	100
COMITE NACIONAL PRO DEFENSA DE LA FLORA Y LA FAUNA	205	1700	110
CONSEJO ECOLOGICO COMUNAL	\N	1700	120
CORPORACION AMBIENTAL	\N	1700	130
FUNDACION VIDA RURAL	\N	1700	140
CENTRO DE AYUDA MAPUCHE	\N	1700	150
SIERRAS PROTEGIDAS	\N	1700	160
CENTRO DE EDUCACION AMBIENTAL	\N	1700	170
RENACE- RED DE ACCION ECOLOGICA	\N	1700	180
Contracting	\N	1700	190
CONSEJO NACIONAL DE LA JUVENTUD	\N	1700	200
DEFENSA DE LOS DERECHOC DEL NIÑO	\N	1700	210
FUNDACION CHILDREN	\N	1700	220
CORPORACION ANGLICANA	\N	1700	230
CORPORACION EVANGELICA	\N	1700	240
CENTRO ECUMENICO	\N	1700	250
FUNDACION MARISTA PARA LA SOLIDARIDAD	\N	1700	260
FUNDACION VIDA	\N	1700	270
\.


--
-- Data for Name: pais; Type: TABLE DATA; Schema: unc_esq_voluntario; Owner: postgres
--

COPY unc_esq_voluntario.pais (nombre_pais, id_continente, id_pais) FROM stdin;
Italia	1	IT
Japon	3	JP
Estados Unidos	2	US
Canada	2	CA
China	3	CN
India	3	IN
Australia	3	AU
Zimbabwe	4	ZW
Singapor	3	SG
Reino Unido	1	UK
Francia	1	FR
Alemania	1	DE
Zambia	4	ZM
Egipto	4	EG
Brasil	2	BR
Suiza	1	CH
Holanda	1	NL
Mexico	2	MX
Kuwait	4	KW
Israel	4	IL
Dinamarca	1	DK
Hong Kong	3	HK
Nigeria	4	NG
Argentina	2	AR
Belgica	1	BE
\.


--
-- Data for Name: tarea; Type: TABLE DATA; Schema: unc_esq_voluntario; Owner: postgres
--

COPY unc_esq_voluntario.tarea (nombre_tarea, min_horas, id_tarea, max_horas) FROM stdin;
PROMOCION	20000	AD_PRES	40000
PREVENCION	15000	AD_VP	30000
AISTENCIA ANCIANOS	3000	AD_ASST	6000
FORESTACION	8200	FI_MGR	16000
PLANTACION	4200	FI_ACCOUNT	9000
ORG.CAMPAÑAS LIMPIEZA	8200	AC_MGR	16000
FISCALIZACION DE RECURSOS NATURALES	4200	AC_ACCOUNT	9000
CLASES ESPECIALES	10000	SA_MAN	20000
ORGANIZACION CAMPAMENTOS RECREATIVOS	6000	SA_REP	12000
ORGANIZACION DE COLECTAS	8000	PU_MAN	15000
CLASIFICACION DE ALIMENTOS	2500	PU_CLERK	5500
ATENCION DE COMEDORES	5500	ST_MAN	8500
ATENCION DE ROPERITOS	2000	ST_CLERK	5000
AYUDA DISCAPACITADOS	2500	SH_CLERK	5500
CONSTRUCTOR	4000	IT_PROG	10000
ASISTENCIA A ENFERMOS	9000	MK_MAN	15000
COCINERO	4000	MK_REP	9000
MAESTRO ESPECIAL	4000	HR_REP	9000
RELACIONES INSTITUCIONALES	4500	PR_REP	10500
Nueva Tarea	100	OT_NEW	3000
\.


--
-- Data for Name: voluntario; Type: TABLE DATA; Schema: unc_esq_voluntario; Owner: postgres
--

COPY unc_esq_voluntario.voluntario (nombre, apellido, e_mail, telefono, fecha_nacimiento, id_tarea, nro_voluntario, horas_aportadas, porcentaje, id_institucion, id_coordinador) FROM stdin;
Michael	Rogers	MRogers@OUTLOOK.COM	+41 643 165 6647	1998-08-26	ST_CLERK	134	2900.00	\N	50	122
Ki	Gee	KGee@HOTMAIL.COM	+55 357 58 9144	1999-12-12	ST_CLERK	135	2400.00	\N	50	122
Hazel	Philtanker	HPhiltanker@OUTLOOK.COM	+43 431 515 9767	2000-02-06	ST_CLERK	136	2200.00	\N	50	122
Renske	Ladwig	RLadwig@OUTLOOK.COM	+17 82 716 4661	1995-07-14	ST_CLERK	137	3600.00	\N	50	123
John	Seo	JSeo@GMAIL.COM	+1 922 272 4307	1998-02-12	ST_CLERK	139	2700.00	\N	50	123
Joshua	Patel	JPatel@HOTMAIL.COM	+25 550 381 2350	1998-04-06	ST_CLERK	140	2500.00	\N	50	123
Trenna	Rajs	TRajs@GMAIL.COM	+38 827 260 2926	1995-10-17	ST_CLERK	141	3500.00	\N	50	124
Curtis	Davies	CDavies@GMAIL.COM	+29 424 957 3791	1997-01-29	ST_CLERK	142	3100.00	\N	50	124
Randall	Matos	RMatos@HOTMAIL.COM	+47 15 294 4948	1998-03-15	ST_CLERK	143	2600.00	\N	50	124
Peter	Vargas	PVargas@OUTLOOK.COM	+27 808 472 7168	1998-07-09	ST_CLERK	144	2500.00	\N	50	124
John	Russell	JRussell@OUTLOOK.COM	+54 188 183 5634	1996-10-01	SA_MAN	145	14000.00	0.40	80	100
Karen	Partners	KPartners@GMAIL.COM	+37 59 696 6276	1997-01-05	SA_MAN	146	13500.00	0.30	80	100
Alberto	Errazuriz	AErrazuriz@HOTMAIL.COM	+59 967 59 3949	1997-03-10	SA_MAN	147	12000.00	0.30	80	100
Gerald	Cambrault	GCambrault@OUTLOOK.COM	+32 439 630 1375	1999-10-15	SA_MAN	148	11000.00	0.30	80	100
Eleni	Zlotkey	EZlotkey@GMAIL.COM	+16 889 430 7376	2000-01-29	SA_MAN	149	10500.00	0.20	80	100
Peter	Tucker	PTucker@HOTMAIL.COM	+19 387 117 950	1997-01-30	SA_REP	150	10000.00	0.30	80	145
David	Bernstein	DBernstein@OUTLOOK.COM	+25 410 590 8482	1997-03-24	SA_REP	151	9500.00	0.25	80	145
Peter	Hall	PHall@OUTLOOK.COM	+14 62 565 1080	1997-08-20	SA_REP	152	9000.00	0.25	80	145
Christopher	Olsen	COlsen@GMAIL.COM	+15 748 671 8601	1998-03-30	SA_REP	153	8000.00	0.20	80	145
Nanette	Cambrault	NCambrault@OUTLOOK.COM	+49 367 488 7873	1998-12-09	SA_REP	154	7500.00	0.20	80	145
Oliver	Tuvault	OTuvault@HOTMAIL.COM	+21 546 183 8531	1999-11-23	SA_REP	155	7000.00	0.15	80	145
Janette	King	JKing@OUTLOOK.COM	+60 812 990 2513	1996-01-30	SA_REP	156	10000.00	0.35	80	146
Patrick	Sully	PSully@GMAIL.COM	+43 421 988 149	1996-03-04	SA_REP	157	9500.00	0.35	80	146
Allan	McEwen	AMcEwen@GMAIL.COM	+49 106 110 2102	1996-08-01	SA_REP	158	9000.00	0.35	80	146
Lindsey	Smith	LSmith@OUTLOOK.COM	+31 699 59 7345	1997-03-10	SA_REP	159	8000.00	0.30	80	146
Louise	Doran	LDoran@OUTLOOK.COM	+46 623 842 99	1997-12-15	SA_REP	160	7500.00	0.30	80	146
Sarath	Sewall	SSewall@HOTMAIL.COM	+23 514 870 1783	1998-11-03	SA_REP	161	7000.00	0.25	80	146
Clara	Vishney	CVishney@GMAIL.COM	+53 358 965 2166	1997-11-11	SA_REP	162	10500.00	0.25	80	147
Danielle	Greene	DGreene@OUTLOOK.COM	+55 148 70 8885	1999-03-19	SA_REP	163	9500.00	0.15	80	147
Mattea	Marvins	MMarvins@HOTMAIL.COM	+58 61 140 6611	2000-01-24	SA_REP	164	7200.00	0.10	80	147
David	Lee	DLee@GMAIL.COM	+29 129 676 2889	2000-02-23	SA_REP	165	6800.00	0.10	80	147
Sundar	Ande	SAnde@GMAIL.COM	+15 785 499 7503	2000-03-24	SA_REP	166	6400.00	0.10	80	147
Amit	Banda	ABanda@GMAIL.COM	+30 557 485 2459	2000-04-21	SA_REP	167	6200.00	0.10	80	147
Lisa	Ozer	LOzer@OUTLOOK.COM	+11 328 256 5525	1997-03-11	SA_REP	168	11500.00	0.25	80	148
Harrison	Bloom	HBloom@GMAIL.COM	+51 126 731 7227	1998-03-23	SA_REP	169	10000.00	0.20	80	148
Tayler	Fox	TFox@HOTMAIL.COM	+30 696 939 3872	1998-01-24	SA_REP	170	9600.00	0.20	80	148
William	Smith	WSmith@GMAIL.COM	+51 9 276 8038	1999-02-23	SA_REP	171	7400.00	0.15	80	148
Elizabeth	Bates	EBates@GMAIL.COM	+5 416 465 5503	1999-03-24	SA_REP	172	7300.00	0.15	80	148
Sundita	Kumar	SKumar@HOTMAIL.COM	+33 141 839 7785	2000-04-21	SA_REP	173	6100.00	0.10	80	148
Ellen	Abel	EAbel@OUTLOOK.COM	+56 338 529 4116	1996-05-11	SA_REP	174	11000.00	0.30	80	149
Alyssa	Hutton	AHutton@GMAIL.COM	+54 14 657 766	1997-03-19	SA_REP	175	8800.00	0.25	80	149
Jonathon	Taylor	JTaylor@HOTMAIL.COM	+21 913 629 1825	1998-03-24	SA_REP	176	8600.00	0.20	80	149
Jack	Livingston	JLivingston@OUTLOOK.COM	+3 360 905 5221	1998-04-23	SA_REP	177	8400.00	0.20	80	149
Kimberely	Grant	KGrant@OUTLOOK.COM	+4 844 909 9003	1999-05-24	SA_REP	178	7000.00	0.15	\N	149
Charles	Johnson	CJohnson@GMAIL.COM	+52 185 704 9227	2000-01-04	SA_REP	179	6200.00	0.10	80	149
Winston	Taylor	WTaylor@GMAIL.COM	+37 170 473 1447	1998-01-24	SH_CLERK	180	3200.00	\N	50	120
Jean	Fleaur	JFleaur@GMAIL.COM	+19 312 923 2365	1998-02-23	SH_CLERK	181	3100.00	\N	50	120
Martha	Sullivan	MSullivan@GMAIL.COM	+40 452 648 5461	1999-06-21	SH_CLERK	182	2500.00	\N	50	120
Girard	Geoni	GGeoni@OUTLOOK.COM	+28 306 623 8066	2000-02-03	SH_CLERK	183	2800.00	\N	50	120
Nandita	Sarchand	NSarchand@HOTMAIL.COM	+14 252 989 2573	1996-01-27	SH_CLERK	184	4200.00	\N	50	121
Alexis	Bull	ABull@OUTLOOK.COM	+37 894 779 6680	1997-02-20	SH_CLERK	185	4100.00	\N	50	121
Julia	Dellinger	JDellinger@GMAIL.COM	+45 689 568 5920	1998-06-24	SH_CLERK	186	3400.00	\N	50	121
Anthony	Cabrio	ACabrio@GMAIL.COM	+53 273 515 4741	1999-02-07	SH_CLERK	187	3000.00	\N	50	121
Kelly	Chung	KChung@OUTLOOK.COM	+27 987 619 7518	1997-06-14	SH_CLERK	188	3800.00	\N	50	122
Steven	King	SKing@HOTMAIL.COM	+6 504 595 1964	1987-06-17	AD_PRES	100	24000.00	\N	90	\N
Neena	Kochhar	NKochhar@GMAIL.COM	+36 821 666 7623	1989-09-21	AD_VP	101	17000.00	\N	90	100
Lex	De Haan	LDe Haan@OUTLOOK.COM	+42 553 468 9181	1993-01-13	AD_VP	102	17000.00	\N	90	100
Alexander	Hunold	AHunold@OUTLOOK.COM	+58 489 69 4169	1990-01-03	IT_PROG	103	9000.00	\N	60	102
Bruce	Ernst	BErnst@GMAIL.COM	+38 55 437 3033	1991-05-21	IT_PROG	104	6000.00	\N	60	103
David	Austin	DAustin@HOTMAIL.COM	+60 566 179 6327	1997-06-25	IT_PROG	105	4800.00	\N	60	103
Valli	Pataballa	VPataballa@GMAIL.COM	+55 521 825 4031	1998-02-05	IT_PROG	106	4800.00	\N	60	103
Diana	Lorentz	DLorentz@GMAIL.COM	+42 923 969 7797	1999-02-07	IT_PROG	107	4200.00	\N	60	103
Nancy	Greenberg	NGreenberg@OUTLOOK.COM	+26 564 976 170	1994-08-17	FI_MGR	108	12000.00	\N	100	101
Daniel	Faviet	DFaviet@HOTMAIL.COM	+24 642 779 744	1994-08-16	FI_ACCOUNT	109	9000.00	\N	100	108
John	Chen	JChen@GMAIL.COM	+12 248 992 1593	1997-09-28	FI_ACCOUNT	110	8200.00	\N	100	108
Ismael	Sciarra	ISciarra@GMAIL.COM	+45 61 576 3699	1997-09-30	FI_ACCOUNT	111	7700.00	\N	100	108
Jose Manuel	Urman	JUrman@OUTLOOK.COM	+7 14 673 1112	1998-03-07	FI_ACCOUNT	112	7800.00	\N	100	108
Luis	Popp	LPopp@GMAIL.COM	+35 852 744 4861	1999-12-07	FI_ACCOUNT	113	6900.00	\N	100	108
Den	Raphaely	DRaphaely@GMAIL.COM	+23 569 889 598	1994-12-07	PU_MAN	114	11000.00	\N	30	100
Alexander	Khoo	AKhoo@HOTMAIL.COM	+30 858 839 9182	1995-05-18	PU_CLERK	115	3100.00	\N	30	114
Shelli	Baida	SBaida@GMAIL.COM	+26 815 935 8085	1997-12-24	PU_CLERK	116	2900.00	\N	30	114
Sigal	Tobias	STobias@HOTMAIL.COM	+28 714 882 6528	1997-07-24	PU_CLERK	117	2800.00	\N	30	114
Guy	Himuro	GHimuro@OUTLOOK.COM	+58 875 812 6986	1998-11-15	PU_CLERK	118	2600.00	\N	30	114
Karen	Colmenares	KColmenares@OUTLOOK.COM	+57 388 69 524	1999-08-10	PU_CLERK	119	2500.00	\N	30	114
Matthew	Weiss	MWeiss@GMAIL.COM	+25 742 164 9803	1996-07-18	ST_MAN	120	8000.00	\N	50	100
Adam	Fripp	AFripp@GMAIL.COM	+36 907 466 9664	1997-04-10	ST_MAN	121	8200.00	\N	50	100
Payam	Kaufling	PKaufling@OUTLOOK.COM	+29 356 27 9677	1995-05-01	ST_MAN	122	7900.00	\N	50	100
Shanta	Vollman	SVollman@HOTMAIL.COM	+13 865 886 6371	1997-10-10	ST_MAN	123	6500.00	\N	50	100
Kevin	Mourgos	KMourgos@GMAIL.COM	+41 821 446 1386	1999-11-16	ST_MAN	124	5800.00	\N	50	100
Julia	Nayer	JNayer@OUTLOOK.COM	+33 329 791 4975	1997-07-16	ST_CLERK	125	3200.00	\N	50	120
Irene	Mikkilineni	IMikkilineni@GMAIL.COM	+13 603 196 1402	1998-09-28	ST_CLERK	126	2700.00	\N	50	120
James	Landry	JLandry@GMAIL.COM	+60 265 193 3930	1999-01-14	ST_CLERK	127	2400.00	\N	50	120
Steven	Markle	SMarkle@GMAIL.COM	+1 356 373 6001	2000-03-08	ST_CLERK	128	2200.00	\N	50	120
Laura	Bissot	LBissot@HOTMAIL.COM	+16 839 567 7394	1997-08-20	ST_CLERK	129	3300.00	\N	50	121
Jennifer	Dilly	JDilly@GMAIL.COM	+18 542 988 9504	1997-08-13	SH_CLERK	189	3600.00	\N	50	122
Timothy	Gates	TGates@HOTMAIL.COM	+60 636 496 4596	1998-07-11	SH_CLERK	190	2900.00	\N	50	122
Randall	Perkins	RPerkins@HOTMAIL.COM	+57 120 266 1605	1999-12-19	SH_CLERK	191	2500.00	\N	50	122
Sarah	Bell	SBell@OUTLOOK.COM	+23 256 418 9826	1996-02-04	SH_CLERK	192	4000.00	\N	50	123
Britney	Everett	BEverett@HOTMAIL.COM	+9 198 650 8881	1997-03-03	SH_CLERK	193	3900.00	\N	50	123
Samuel	McCain	SMcCain@OUTLOOK.COM	+54 219 480 7596	1998-07-01	SH_CLERK	194	3200.00	\N	50	123
Vance	Jones	VJones@HOTMAIL.COM	+30 994 234 9333	1999-03-17	SH_CLERK	195	2800.00	\N	50	123
Alana	Walsh	AWalsh@HOTMAIL.COM	+59 852 685 2826	1998-04-24	SH_CLERK	196	3100.00	\N	50	124
Kevin	Feeney	KFeeney@OUTLOOK.COM	+24 673 233 3885	1998-05-23	SH_CLERK	197	3000.00	\N	50	124
Donald	OConnell	DOConnell@HOTMAIL.COM	+19 729 848 2518	1999-06-21	SH_CLERK	198	2600.00	\N	50	124
Douglas	Grant	DGrant@GMAIL.COM	+51 115 412 2195	2000-01-13	SH_CLERK	199	2600.00	\N	50	124
Jennifer	Whalen	JWhalen@GMAIL.COM	+23 830 202 5190	1987-09-17	AD_ASST	200	4400.00	\N	10	101
Mozhe	Atkinson	MAtkinson@GMAIL.COM	+12 593 707 4095	1997-10-30	ST_CLERK	130	2800.00	\N	50	121
James	Marlow	JMarlow@HOTMAIL.COM	+28 593 47 1396	1997-02-16	ST_CLERK	131	2500.00	\N	50	121
TJ	Olson	TOlson@OUTLOOK.COM	+25 492 278 9498	1999-04-10	ST_CLERK	132	2100.00	\N	50	121
Jason	Mallin	JMallin@GMAIL.COM	+50 70 447 246	1996-06-14	ST_CLERK	133	3300.00	\N	50	122
Michael	Hartstein	MHartstein@HOTMAIL.COM	+2 852 407 9132	1996-02-17	MK_MAN	201	13000.00	\N	20	100
Pat	Fay	PFay@GMAIL.COM	+5 887 673 5634	1997-08-17	MK_REP	202	6000.00	\N	20	201
Susan	Mavris	SMavris@GMAIL.COM	+53 906 497 8648	1994-06-07	HR_REP	203	6500.00	\N	40	101
Hermann	Baer	HBaer@OUTLOOK.COM	+46 182 148 1538	1994-06-07	PR_REP	204	10000.00	\N	70	101
Shelley	Higgins	SHiggins@OUTLOOK.COM	+52 381 542 1654	1994-06-07	AC_MGR	205	12000.00	\N	110	101
William	Gietz	WGietz@GMAIL.COM	+7 390 417 9585	1994-06-07	AC_ACCOUNT	206	8300.00	\N	110	205
Stephen	Stiles	SStiles@GMAIL.COM	+41 423 875 1325	1997-10-26	ST_CLERK	138	2100.00	\N	50	123
\.


--
-- Name: continente pk_continente; Type: CONSTRAINT; Schema: unc_esq_voluntario; Owner: postgres
--

ALTER TABLE ONLY unc_esq_voluntario.continente
    ADD CONSTRAINT pk_continente PRIMARY KEY (id_continente);


--
-- Name: direccion pk_direccion; Type: CONSTRAINT; Schema: unc_esq_voluntario; Owner: postgres
--

ALTER TABLE ONLY unc_esq_voluntario.direccion
    ADD CONSTRAINT pk_direccion PRIMARY KEY (id_direccion);


--
-- Name: historico pk_historico; Type: CONSTRAINT; Schema: unc_esq_voluntario; Owner: postgres
--

ALTER TABLE ONLY unc_esq_voluntario.historico
    ADD CONSTRAINT pk_historico PRIMARY KEY (fecha_inicio, nro_voluntario);


--
-- Name: institucion pk_institucion; Type: CONSTRAINT; Schema: unc_esq_voluntario; Owner: postgres
--

ALTER TABLE ONLY unc_esq_voluntario.institucion
    ADD CONSTRAINT pk_institucion PRIMARY KEY (id_institucion);


--
-- Name: pais pk_pais; Type: CONSTRAINT; Schema: unc_esq_voluntario; Owner: postgres
--

ALTER TABLE ONLY unc_esq_voluntario.pais
    ADD CONSTRAINT pk_pais PRIMARY KEY (id_pais);


--
-- Name: tarea pk_tarea; Type: CONSTRAINT; Schema: unc_esq_voluntario; Owner: postgres
--

ALTER TABLE ONLY unc_esq_voluntario.tarea
    ADD CONSTRAINT pk_tarea PRIMARY KEY (id_tarea);


--
-- Name: voluntario pk_voluntario; Type: CONSTRAINT; Schema: unc_esq_voluntario; Owner: postgres
--

ALTER TABLE ONLY unc_esq_voluntario.voluntario
    ADD CONSTRAINT pk_voluntario PRIMARY KEY (nro_voluntario);


--
-- Name: emp_email_uk; Type: INDEX; Schema: unc_esq_voluntario; Owner: postgres
--

CREATE UNIQUE INDEX emp_email_uk ON unc_esq_voluntario.voluntario USING btree (e_mail);


--
-- Name: pais fk_continente; Type: FK CONSTRAINT; Schema: unc_esq_voluntario; Owner: postgres
--

ALTER TABLE ONLY unc_esq_voluntario.pais
    ADD CONSTRAINT fk_continente FOREIGN KEY (id_continente) REFERENCES unc_esq_voluntario.continente(id_continente);


--
-- Name: voluntario fk_coordinador; Type: FK CONSTRAINT; Schema: unc_esq_voluntario; Owner: postgres
--

ALTER TABLE ONLY unc_esq_voluntario.voluntario
    ADD CONSTRAINT fk_coordinador FOREIGN KEY (id_coordinador) REFERENCES unc_esq_voluntario.voluntario(nro_voluntario);


--
-- Name: institucion fk_direccion; Type: FK CONSTRAINT; Schema: unc_esq_voluntario; Owner: postgres
--

ALTER TABLE ONLY unc_esq_voluntario.institucion
    ADD CONSTRAINT fk_direccion FOREIGN KEY (id_direccion) REFERENCES unc_esq_voluntario.direccion(id_direccion);


--
-- Name: institucion fk_director; Type: FK CONSTRAINT; Schema: unc_esq_voluntario; Owner: postgres
--

ALTER TABLE ONLY unc_esq_voluntario.institucion
    ADD CONSTRAINT fk_director FOREIGN KEY (id_director) REFERENCES unc_esq_voluntario.voluntario(nro_voluntario);


--
-- Name: historico fk_institucion_h; Type: FK CONSTRAINT; Schema: unc_esq_voluntario; Owner: postgres
--

ALTER TABLE ONLY unc_esq_voluntario.historico
    ADD CONSTRAINT fk_institucion_h FOREIGN KEY (id_institucion) REFERENCES unc_esq_voluntario.institucion(id_institucion);


--
-- Name: voluntario fk_institucion_v; Type: FK CONSTRAINT; Schema: unc_esq_voluntario; Owner: postgres
--

ALTER TABLE ONLY unc_esq_voluntario.voluntario
    ADD CONSTRAINT fk_institucion_v FOREIGN KEY (id_institucion) REFERENCES unc_esq_voluntario.institucion(id_institucion);


--
-- Name: direccion fk_pais; Type: FK CONSTRAINT; Schema: unc_esq_voluntario; Owner: postgres
--

ALTER TABLE ONLY unc_esq_voluntario.direccion
    ADD CONSTRAINT fk_pais FOREIGN KEY (id_pais) REFERENCES unc_esq_voluntario.pais(id_pais);


--
-- Name: historico fk_tarea_h; Type: FK CONSTRAINT; Schema: unc_esq_voluntario; Owner: postgres
--

ALTER TABLE ONLY unc_esq_voluntario.historico
    ADD CONSTRAINT fk_tarea_h FOREIGN KEY (id_tarea) REFERENCES unc_esq_voluntario.tarea(id_tarea);


--
-- Name: voluntario fk_tarea_v; Type: FK CONSTRAINT; Schema: unc_esq_voluntario; Owner: postgres
--

ALTER TABLE ONLY unc_esq_voluntario.voluntario
    ADD CONSTRAINT fk_tarea_v FOREIGN KEY (id_tarea) REFERENCES unc_esq_voluntario.tarea(id_tarea);


--
-- Name: historico fk_voluntario_h; Type: FK CONSTRAINT; Schema: unc_esq_voluntario; Owner: postgres
--

ALTER TABLE ONLY unc_esq_voluntario.historico
    ADD CONSTRAINT fk_voluntario_h FOREIGN KEY (nro_voluntario) REFERENCES unc_esq_voluntario.voluntario(nro_voluntario);


--
-- Name: SCHEMA unc_esq_voluntario; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA unc_esq_voluntario TO PUBLIC;


--
-- Name: TABLE continente; Type: ACL; Schema: unc_esq_voluntario; Owner: postgres
--

GRANT SELECT,REFERENCES ON TABLE unc_esq_voluntario.continente TO PUBLIC;


--
-- Name: TABLE direccion; Type: ACL; Schema: unc_esq_voluntario; Owner: postgres
--

GRANT SELECT,REFERENCES ON TABLE unc_esq_voluntario.direccion TO PUBLIC;


--
-- Name: TABLE historico; Type: ACL; Schema: unc_esq_voluntario; Owner: postgres
--

GRANT SELECT,REFERENCES ON TABLE unc_esq_voluntario.historico TO PUBLIC;


--
-- Name: TABLE institucion; Type: ACL; Schema: unc_esq_voluntario; Owner: postgres
--

GRANT SELECT,REFERENCES ON TABLE unc_esq_voluntario.institucion TO PUBLIC;


--
-- Name: TABLE pais; Type: ACL; Schema: unc_esq_voluntario; Owner: postgres
--

GRANT SELECT,REFERENCES ON TABLE unc_esq_voluntario.pais TO PUBLIC;


--
-- Name: TABLE tarea; Type: ACL; Schema: unc_esq_voluntario; Owner: postgres
--

GRANT SELECT,REFERENCES ON TABLE unc_esq_voluntario.tarea TO PUBLIC;


--
-- Name: TABLE voluntario; Type: ACL; Schema: unc_esq_voluntario; Owner: postgres
--

GRANT SELECT,REFERENCES ON TABLE unc_esq_voluntario.voluntario TO PUBLIC;


--
-- PostgreSQL database dump complete
--

