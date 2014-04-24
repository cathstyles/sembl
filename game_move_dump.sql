--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: boards; Type: TABLE; Schema: public; Owner: narinda; Tablespace: 
--

CREATE TABLE boards (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    number_of_players integer NOT NULL,
    creator_id integer,
    updator_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    nodes_attributes json DEFAULT '[{"round": 0}]'::json NOT NULL,
    links_attributes json DEFAULT '[]'::json NOT NULL
);


ALTER TABLE public.boards OWNER TO narinda;

--
-- Name: boards_id_seq; Type: SEQUENCE; Schema: public; Owner: narinda
--

CREATE SEQUENCE boards_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.boards_id_seq OWNER TO narinda;

--
-- Name: boards_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: narinda
--

ALTER SEQUENCE boards_id_seq OWNED BY boards.id;


--
-- Name: games; Type: TABLE; Schema: public; Owner: narinda; Tablespace: 
--

CREATE TABLE games (
    id integer NOT NULL,
    board_id integer,
    title character varying(255) NOT NULL,
    description text,
    creator_id integer,
    updator_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    invite_only boolean DEFAULT false,
    uploads_allowed boolean DEFAULT false,
    theme character varying(255),
    allow_keyword_search boolean DEFAULT false,
    state character varying(255) DEFAULT NULL::character varying,
    current_round integer DEFAULT 1,
    random_seed integer,
    number_of_players integer,
    filter_content_by json
);


ALTER TABLE public.games OWNER TO narinda;

--
-- Name: games_id_seq; Type: SEQUENCE; Schema: public; Owner: narinda
--

CREATE SEQUENCE games_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.games_id_seq OWNER TO narinda;

--
-- Name: games_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: narinda
--

ALTER SEQUENCE games_id_seq OWNED BY games.id;


--
-- Name: links; Type: TABLE; Schema: public; Owner: narinda; Tablespace: 
--

CREATE TABLE links (
    id integer NOT NULL,
    source_id integer,
    target_id integer,
    game_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.links OWNER TO narinda;

--
-- Name: links_id_seq; Type: SEQUENCE; Schema: public; Owner: narinda
--

CREATE SEQUENCE links_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.links_id_seq OWNER TO narinda;

--
-- Name: links_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: narinda
--

ALTER SEQUENCE links_id_seq OWNED BY links.id;


--
-- Name: nodes; Type: TABLE; Schema: public; Owner: narinda; Tablespace: 
--

CREATE TABLE nodes (
    id integer NOT NULL,
    game_id integer,
    round integer,
    state character varying(255),
    allocated_to_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    x integer DEFAULT 0 NOT NULL,
    y integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.nodes OWNER TO narinda;

--
-- Name: nodes_id_seq; Type: SEQUENCE; Schema: public; Owner: narinda
--

CREATE SEQUENCE nodes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.nodes_id_seq OWNER TO narinda;

--
-- Name: nodes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: narinda
--

ALTER SEQUENCE nodes_id_seq OWNED BY nodes.id;


--
-- Name: placements; Type: TABLE; Schema: public; Owner: narinda; Tablespace: 
--

CREATE TABLE placements (
    id integer NOT NULL,
    state character varying(255) NOT NULL,
    thing_id integer,
    node_id integer,
    creator_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    title character varying(255),
    score double precision
);


ALTER TABLE public.placements OWNER TO narinda;

--
-- Name: placements_id_seq; Type: SEQUENCE; Schema: public; Owner: narinda
--

CREATE SEQUENCE placements_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.placements_id_seq OWNER TO narinda;

--
-- Name: placements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: narinda
--

ALTER SEQUENCE placements_id_seq OWNED BY placements.id;


--
-- Name: players; Type: TABLE; Schema: public; Owner: narinda; Tablespace: 
--

CREATE TABLE players (
    id integer NOT NULL,
    game_id integer,
    user_id integer,
    score double precision DEFAULT 0 NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    state character varying(255) DEFAULT NULL::character varying NOT NULL,
    email character varying(255),
    move_state character varying(255)
);


ALTER TABLE public.players OWNER TO narinda;

--
-- Name: players_id_seq; Type: SEQUENCE; Schema: public; Owner: narinda
--

CREATE SEQUENCE players_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.players_id_seq OWNER TO narinda;

--
-- Name: players_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: narinda
--

ALTER SEQUENCE players_id_seq OWNED BY players.id;


--
-- Name: profiles; Type: TABLE; Schema: public; Owner: narinda; Tablespace: 
--

CREATE TABLE profiles (
    id integer NOT NULL,
    user_id integer,
    name character varying(255),
    bio text,
    avatar character varying(255)
);


ALTER TABLE public.profiles OWNER TO narinda;

--
-- Name: profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: narinda
--

CREATE SEQUENCE profiles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.profiles_id_seq OWNER TO narinda;

--
-- Name: profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: narinda
--

ALTER SEQUENCE profiles_id_seq OWNED BY profiles.id;


--
-- Name: ratings; Type: TABLE; Schema: public; Owner: narinda; Tablespace: 
--

CREATE TABLE ratings (
    id integer NOT NULL,
    rating double precision,
    resemblance_id integer,
    creator_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.ratings OWNER TO narinda;

--
-- Name: ratings_id_seq; Type: SEQUENCE; Schema: public; Owner: narinda
--

CREATE SEQUENCE ratings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ratings_id_seq OWNER TO narinda;

--
-- Name: ratings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: narinda
--

ALTER SEQUENCE ratings_id_seq OWNED BY ratings.id;


--
-- Name: resemblances; Type: TABLE; Schema: public; Owner: narinda; Tablespace: 
--

CREATE TABLE resemblances (
    id integer NOT NULL,
    description text NOT NULL,
    state character varying(255) NOT NULL,
    score double precision,
    link_id integer,
    creator_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    source_id integer,
    target_id integer
);


ALTER TABLE public.resemblances OWNER TO narinda;

--
-- Name: resemblances_id_seq; Type: SEQUENCE; Schema: public; Owner: narinda
--

CREATE SEQUENCE resemblances_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.resemblances_id_seq OWNER TO narinda;

--
-- Name: resemblances_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: narinda
--

ALTER SEQUENCE resemblances_id_seq OWNED BY resemblances.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: narinda; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


ALTER TABLE public.schema_migrations OWNER TO narinda;

--
-- Name: things; Type: TABLE; Schema: public; Owner: narinda; Tablespace: 
--

CREATE TABLE things (
    id integer NOT NULL,
    title character varying(255),
    description text DEFAULT ''::text,
    creator_id integer,
    updator_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    image character varying(255),
    attribution character varying(255),
    item_url character varying(255),
    copyright character varying(255),
    general_attributes json DEFAULT '[]'::json NOT NULL,
    import_row_id character varying(255),
    access_via character varying(255),
    random_seed integer,
    suggested_seed boolean DEFAULT false
);


ALTER TABLE public.things OWNER TO narinda;

--
-- Name: things_id_seq; Type: SEQUENCE; Schema: public; Owner: narinda
--

CREATE SEQUENCE things_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.things_id_seq OWNER TO narinda;

--
-- Name: things_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: narinda
--

ALTER SEQUENCE things_id_seq OWNED BY things.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: narinda; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    email character varying(255) DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying(255) DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying(255),
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying(255),
    last_sign_in_ip character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    role integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.users OWNER TO narinda;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: narinda
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO narinda;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: narinda
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: narinda
--

ALTER TABLE ONLY boards ALTER COLUMN id SET DEFAULT nextval('boards_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: narinda
--

ALTER TABLE ONLY games ALTER COLUMN id SET DEFAULT nextval('games_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: narinda
--

ALTER TABLE ONLY links ALTER COLUMN id SET DEFAULT nextval('links_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: narinda
--

ALTER TABLE ONLY nodes ALTER COLUMN id SET DEFAULT nextval('nodes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: narinda
--

ALTER TABLE ONLY placements ALTER COLUMN id SET DEFAULT nextval('placements_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: narinda
--

ALTER TABLE ONLY players ALTER COLUMN id SET DEFAULT nextval('players_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: narinda
--

ALTER TABLE ONLY profiles ALTER COLUMN id SET DEFAULT nextval('profiles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: narinda
--

ALTER TABLE ONLY ratings ALTER COLUMN id SET DEFAULT nextval('ratings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: narinda
--

ALTER TABLE ONLY resemblances ALTER COLUMN id SET DEFAULT nextval('resemblances_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: narinda
--

ALTER TABLE ONLY things ALTER COLUMN id SET DEFAULT nextval('things_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: narinda
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Data for Name: boards; Type: TABLE DATA; Schema: public; Owner: narinda
--

COPY boards (id, title, number_of_players, creator_id, updator_id, created_at, updated_at, nodes_attributes, links_attributes) FROM stdin;
2	Lotus 4	4	3	\N	2013-10-22 05:39:20.507982	2013-10-22 05:39:20.507982	[{"round": 0}]	[]
3	Lotus 5	4	3	\N	2013-10-22 05:39:20.510088	2013-10-22 05:39:20.510088	[{"round": 0}]	[]
4	Lotus 6	4	3	\N	2013-10-22 05:39:20.511643	2013-10-22 05:39:20.511643	[{"round": 0}]	[]
1	Lotus 3	3	3	\N	2013-10-22 05:39:20.504136	2014-03-12 03:23:50.303252	[{"y":600.0,"x":412.4031007751938,"fixed":1,"round":0},{"y":424.03846153846155,"x":800.0,"fixed":1,"round":1},{"y":288.46153846153845,"x":257.36434108527135,"fixed":1,"round":1},{"y":400.96153846153845,"x":0.0,"fixed":1,"round":1},{"y":0.0,"x":741.0852713178296,"fixed":1,"round":2},{"y":14.423076923076923,"x":120.93023255813954,"fixed":1,"round":2},{"y":279.8076923076923,"x":579.8449612403101,"fixed":1,"round":3}]	[{"source":0,"target":1},{"source":0,"target":2},{"source":0,"target":3},{"source":1,"target":4},{"source":2,"target":4},{"source":2,"target":5},{"source":3,"target":5},{"source":4,"target":6},{"source":5,"target":6},{"source":6,"target":0}]
\.


--
-- Name: boards_id_seq; Type: SEQUENCE SET; Schema: public; Owner: narinda
--

SELECT pg_catalog.setval('boards_id_seq', 4, true);


--
-- Data for Name: games; Type: TABLE DATA; Schema: public; Owner: narinda
--

COPY games (id, board_id, title, description, creator_id, updator_id, created_at, updated_at, invite_only, uploads_allowed, theme, allow_keyword_search, state, current_round, random_seed, number_of_players, filter_content_by) FROM stdin;
2	2	Test		3	3	2014-01-15 23:18:52.685891	2014-01-15 23:18:52.685891	f	f		f	draft	1	109731733	4	\N
3	1	Michael's test game	\N	6	6	2014-01-15 23:38:45.996985	2014-03-04 22:21:32.30389	f	f	\N	f	joining	1	720276317	3	\N
4	1	Test Rating		3	3	2014-03-12 01:19:23.198701	2014-03-26 05:01:53.33909	f	f	\N	f	playing	3	2129148400	3	\N
6	1	New test		9	9	2014-03-27 06:49:12.610206	2014-04-01 01:09:31.299271	f	f	\N	f	playing	2	622590554	3	\N
7	1	Test joining	dasdsad	3	3	2014-04-03 04:37:15.857607	2014-04-03 04:51:33.628574	f	f	\N	f	joining	1	940369394	3	\N
8	1	Tooltips		10	10	2014-04-15 04:54:58.499402	2014-04-22 01:57:41.842208	f	f	\N	f	playing	1	1426908242	3	\N
9	1	Terrified		12	12	2014-04-22 02:03:27.29708	2014-04-22 03:32:20.53935	t	f	\N	f	draft	1	1866213587	3	\N
\.


--
-- Name: games_id_seq; Type: SEQUENCE SET; Schema: public; Owner: narinda
--

SELECT pg_catalog.setval('games_id_seq', 9, true);


--
-- Data for Name: links; Type: TABLE DATA; Schema: public; Owner: narinda
--

COPY links (id, source_id, target_id, game_id, created_at, updated_at) FROM stdin;
1	2	3	3	2014-01-15 23:38:46.32979	2014-01-15 23:38:46.32979
2	2	4	3	2014-01-15 23:38:46.410298	2014-01-15 23:38:46.410298
3	2	5	3	2014-01-15 23:38:46.440673	2014-01-15 23:38:46.440673
4	3	6	3	2014-01-15 23:38:46.475681	2014-01-15 23:38:46.475681
5	4	6	3	2014-01-15 23:38:46.505428	2014-01-15 23:38:46.505428
6	4	7	3	2014-01-15 23:38:46.561101	2014-01-15 23:38:46.561101
7	5	7	3	2014-01-15 23:38:46.593913	2014-01-15 23:38:46.593913
8	6	8	3	2014-01-15 23:38:46.616202	2014-01-15 23:38:46.616202
9	7	8	3	2014-01-15 23:38:46.693715	2014-01-15 23:38:46.693715
10	8	2	3	2014-01-15 23:38:46.750942	2014-01-15 23:38:46.750942
11	9	10	4	2014-03-12 01:19:23.222421	2014-03-12 01:19:23.222421
12	9	11	4	2014-03-12 01:19:23.228245	2014-03-12 01:19:23.228245
13	9	12	4	2014-03-12 01:19:23.229951	2014-03-12 01:19:23.229951
14	10	13	4	2014-03-12 01:19:23.231589	2014-03-12 01:19:23.231589
15	11	13	4	2014-03-12 01:19:23.233251	2014-03-12 01:19:23.233251
16	11	14	4	2014-03-12 01:19:23.234913	2014-03-12 01:19:23.234913
17	12	14	4	2014-03-12 01:19:23.236619	2014-03-12 01:19:23.236619
18	13	15	4	2014-03-12 01:19:23.238191	2014-03-12 01:19:23.238191
19	14	15	4	2014-03-12 01:19:23.239793	2014-03-12 01:19:23.239793
20	15	9	4	2014-03-12 01:19:23.241367	2014-03-12 01:19:23.241367
31	23	24	6	2014-03-27 06:49:12.649886	2014-03-27 06:49:12.649886
32	23	25	6	2014-03-27 06:49:12.654352	2014-03-27 06:49:12.654352
33	23	26	6	2014-03-27 06:49:12.656178	2014-03-27 06:49:12.656178
34	24	27	6	2014-03-27 06:49:12.657938	2014-03-27 06:49:12.657938
35	25	27	6	2014-03-27 06:49:12.659696	2014-03-27 06:49:12.659696
36	25	28	6	2014-03-27 06:49:12.661602	2014-03-27 06:49:12.661602
37	26	28	6	2014-03-27 06:49:12.663339	2014-03-27 06:49:12.663339
38	27	29	6	2014-03-27 06:49:12.665069	2014-03-27 06:49:12.665069
39	28	29	6	2014-03-27 06:49:12.666714	2014-03-27 06:49:12.666714
40	29	23	6	2014-03-27 06:49:12.668203	2014-03-27 06:49:12.668203
41	30	31	7	2014-04-03 04:37:15.919107	2014-04-03 04:37:15.919107
42	30	32	7	2014-04-03 04:37:15.923823	2014-04-03 04:37:15.923823
43	30	33	7	2014-04-03 04:37:15.926752	2014-04-03 04:37:15.926752
44	31	34	7	2014-04-03 04:37:15.929494	2014-04-03 04:37:15.929494
45	32	34	7	2014-04-03 04:37:15.996214	2014-04-03 04:37:15.996214
46	32	35	7	2014-04-03 04:37:15.999215	2014-04-03 04:37:15.999215
47	33	35	7	2014-04-03 04:37:16.00136	2014-04-03 04:37:16.00136
48	34	36	7	2014-04-03 04:37:16.003826	2014-04-03 04:37:16.003826
49	35	36	7	2014-04-03 04:37:16.006087	2014-04-03 04:37:16.006087
50	36	30	7	2014-04-03 04:37:16.007652	2014-04-03 04:37:16.007652
51	37	38	8	2014-04-15 04:54:58.5468	2014-04-15 04:54:58.5468
52	37	39	8	2014-04-15 04:54:58.552461	2014-04-15 04:54:58.552461
53	37	40	8	2014-04-15 04:54:58.554903	2014-04-15 04:54:58.554903
54	38	41	8	2014-04-15 04:54:58.557596	2014-04-15 04:54:58.557596
55	39	41	8	2014-04-15 04:54:58.560184	2014-04-15 04:54:58.560184
56	39	42	8	2014-04-15 04:54:58.562354	2014-04-15 04:54:58.562354
57	40	42	8	2014-04-15 04:54:58.564572	2014-04-15 04:54:58.564572
58	41	43	8	2014-04-15 04:54:58.566825	2014-04-15 04:54:58.566825
59	42	43	8	2014-04-15 04:54:58.568443	2014-04-15 04:54:58.568443
60	43	37	8	2014-04-15 04:54:58.570157	2014-04-15 04:54:58.570157
61	44	45	9	2014-04-22 02:03:27.348083	2014-04-22 02:03:27.348083
62	44	46	9	2014-04-22 02:03:27.352574	2014-04-22 02:03:27.352574
63	44	47	9	2014-04-22 02:03:27.354739	2014-04-22 02:03:27.354739
64	45	48	9	2014-04-22 02:03:27.356779	2014-04-22 02:03:27.356779
65	46	48	9	2014-04-22 02:03:27.358654	2014-04-22 02:03:27.358654
66	46	49	9	2014-04-22 02:03:27.360386	2014-04-22 02:03:27.360386
67	47	49	9	2014-04-22 02:03:27.361912	2014-04-22 02:03:27.361912
68	48	50	9	2014-04-22 02:03:27.363854	2014-04-22 02:03:27.363854
69	49	50	9	2014-04-22 02:03:27.365981	2014-04-22 02:03:27.365981
70	50	44	9	2014-04-22 02:03:27.368181	2014-04-22 02:03:27.368181
\.


--
-- Name: links_id_seq; Type: SEQUENCE SET; Schema: public; Owner: narinda
--

SELECT pg_catalog.setval('links_id_seq', 70, true);


--
-- Data for Name: nodes; Type: TABLE DATA; Schema: public; Owner: narinda
--

COPY nodes (id, game_id, round, state, allocated_to_id, created_at, updated_at, x, y) FROM stdin;
1	2	0	filled	\N	2014-01-15 23:18:52.701162	2014-01-15 23:18:52.701162	0	0
2	3	0	filled	\N	2014-01-15 23:38:46.029111	2014-01-15 23:38:46.029111	348	341
4	3	1	in_play	\N	2014-01-15 23:38:46.215709	2014-01-15 23:38:46.215709	298	233
5	3	1	in_play	\N	2014-01-15 23:38:46.273538	2014-01-15 23:38:46.273538	215	272
6	3	2	locked	\N	2014-01-15 23:38:46.27734	2014-01-15 23:38:46.27734	454	133
7	3	2	locked	\N	2014-01-15 23:38:46.305453	2014-01-15 23:38:46.305453	254	138
8	3	3	locked	\N	2014-01-15 23:38:46.324406	2014-01-15 23:38:46.324406	402	230
3	3	1	in_play	8	2014-01-15 23:38:46.166031	2014-03-04 22:21:32.28965	473	280
9	4	0	filled	\N	2014-03-12 01:19:23.207286	2014-03-12 01:19:23.207286	348	341
10	4	1	filled	10	2014-03-12 01:19:23.210873	2014-03-26 00:18:15.569428	473	280
11	4	1	filled	9	2014-03-12 01:19:23.21277	2014-03-26 00:18:15.589828	298	233
12	4	1	filled	11	2014-03-12 01:19:23.214675	2014-03-26 00:18:15.608929	215	272
13	4	2	filled	\N	2014-03-12 01:19:23.216527	2014-03-26 05:01:53.217564	454	133
14	4	2	filled	\N	2014-03-12 01:19:23.21827	2014-03-26 05:01:53.269266	254	138
15	4	3	in_play	\N	2014-03-12 01:19:23.220175	2014-03-26 05:01:53.35108	402	230
23	6	0	filled	\N	2014-03-27 06:49:12.618944	2014-03-27 06:49:12.618944	412	600
29	6	3	locked	\N	2014-03-27 06:49:12.647383	2014-03-27 06:49:12.647383	579	279
24	6	1	filled	10	2014-03-27 06:49:12.637169	2014-04-01 01:09:31.120334	800	424
25	6	1	filled	11	2014-03-27 06:49:12.639424	2014-04-01 01:09:31.15322	257	288
26	6	1	filled	12	2014-03-27 06:49:12.641401	2014-04-01 01:09:31.176655	0	400
27	6	2	in_play	\N	2014-03-27 06:49:12.643522	2014-04-01 01:09:31.31207	741	0
28	6	2	in_play	\N	2014-03-27 06:49:12.645446	2014-04-01 01:09:31.320274	120	14
30	7	0	filled	\N	2014-04-03 04:37:15.870477	2014-04-03 04:37:15.870477	412	600
34	7	2	locked	\N	2014-04-03 04:37:15.905586	2014-04-03 04:37:15.905586	741	0
35	7	2	locked	\N	2014-04-03 04:37:15.90902	2014-04-03 04:37:15.90902	120	14
36	7	3	locked	\N	2014-04-03 04:37:15.913822	2014-04-03 04:37:15.913822	579	279
31	7	1	in_play	\N	2014-04-03 04:37:15.895933	2014-04-14 03:51:27.941137	800	424
32	7	1	in_play	\N	2014-04-03 04:37:15.899421	2014-04-14 03:52:44.31761	257	288
33	7	1	in_play	10	2014-04-03 04:37:15.902519	2014-04-14 03:53:01.754411	0	400
37	8	0	filled	\N	2014-04-15 04:54:58.510934	2014-04-15 04:54:58.510934	412	600
41	8	2	locked	\N	2014-04-15 04:54:58.538172	2014-04-15 04:54:58.538172	741	0
42	8	2	locked	\N	2014-04-15 04:54:58.540527	2014-04-15 04:54:58.540527	120	14
43	8	3	locked	\N	2014-04-15 04:54:58.543183	2014-04-15 04:54:58.543183	579	279
38	8	1	in_play	11	2014-04-15 04:54:58.53036	2014-04-15 04:58:28.373588	800	424
39	8	1	in_play	10	2014-04-15 04:54:58.533517	2014-04-17 03:56:19.853545	257	288
40	8	1	in_play	12	2014-04-15 04:54:58.535735	2014-04-22 01:57:41.833896	0	400
44	9	0	filled	\N	2014-04-22 02:03:27.307646	2014-04-22 02:03:27.307646	412	600
45	9	1	in_play	\N	2014-04-22 02:03:27.332429	2014-04-22 02:03:27.332429	800	424
46	9	1	in_play	\N	2014-04-22 02:03:27.33487	2014-04-22 02:03:27.33487	257	288
47	9	1	in_play	\N	2014-04-22 02:03:27.336663	2014-04-22 02:03:27.336663	0	400
48	9	2	locked	\N	2014-04-22 02:03:27.338698	2014-04-22 02:03:27.338698	741	0
49	9	2	locked	\N	2014-04-22 02:03:27.342477	2014-04-22 02:03:27.342477	120	14
50	9	3	locked	\N	2014-04-22 02:03:27.345036	2014-04-22 02:03:27.345036	579	279
\.


--
-- Name: nodes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: narinda
--

SELECT pg_catalog.setval('nodes_id_seq', 50, true);


--
-- Data for Name: placements; Type: TABLE DATA; Schema: public; Owner: narinda
--

COPY placements (id, state, thing_id, node_id, creator_id, created_at, updated_at, title, score) FROM stdin;
1	final	386	1	3	2014-01-15 23:18:52.715309	2014-01-15 23:18:52.715309	\N	\N
2	final	516	2	6	2014-01-15 23:38:46.054192	2014-01-15 23:38:46.054192	\N	\N
3	final	446	9	3	2014-03-12 03:12:27.849051	2014-03-12 03:14:05.944742	\N	\N
6	final	362	10	10	2014-03-12 03:39:49.071707	2014-03-26 00:18:15.563639	\N	0.317500000000000004
5	final	340	11	9	2014-03-12 03:38:03.197529	2014-03-26 00:18:15.587667	\N	0.408333333333333492
7	final	340	12	11	2014-03-25 04:44:54.335146	2014-03-26 00:18:15.606024	\N	0.241666666666666502
9	proposed	386	13	10	2014-03-26 00:32:54.609556	2014-03-26 05:01:53.210272	\N	0.270000000000000018
8	final	355	13	11	2014-03-26 00:21:57.514308	2014-03-26 05:01:53.213318	\N	0.335833333333333539
11	proposed	341	14	10	2014-03-26 00:38:30.226245	2014-03-26 05:01:53.260771	\N	0.307499999999999274
10	final	343	14	9	2014-03-26 00:36:19.942071	2014-03-26 05:01:53.264452	\N	0.608333333333333282
12	proposed	372	15	11	2014-03-26 05:07:18.33602	2014-03-26 05:07:18.33602	\N	\N
13	proposed	342	15	10	2014-03-27 03:29:42.428356	2014-03-27 03:29:42.428356	\N	\N
14	proposed	361	15	9	2014-03-27 05:18:09.22922	2014-03-27 05:18:09.22922	\N	\N
15	final	366	23	9	2014-03-27 06:49:12.624004	2014-03-27 06:49:12.624004	\N	\N
21	final	376	24	10	2014-04-01 00:41:11.495473	2014-04-01 01:09:31.115862	\N	0.311666666666666481
17	final	343	25	11	2014-04-01 00:02:31.940708	2014-04-01 01:09:31.149726	\N	0.484999999999999987
18	final	385	26	12	2014-04-01 00:09:27.923293	2014-04-01 01:09:31.173199	\N	0.328333333333333477
22	proposed	355	27	12	2014-04-01 04:44:29.424369	2014-04-01 04:44:29.424369	\N	\N
23	proposed	362	27	10	2014-04-01 04:54:39.962311	2014-04-01 04:54:39.962311	\N	\N
24	proposed	343	28	10	2014-04-01 04:59:59.797398	2014-04-01 04:59:59.797398	\N	\N
28	final	378	37	10	2014-04-15 04:54:58.515779	2014-04-15 04:54:58.515779	\N	\N
31	proposed	361	38	11	2014-04-15 06:08:00.556792	2014-04-15 06:08:00.556792	\N	\N
32	proposed	343	39	10	2014-04-17 04:11:55.810181	2014-04-17 04:11:55.810181	\N	\N
33	final	466	44	12	2014-04-22 02:03:27.313705	2014-04-22 03:32:20.54265	\N	\N
\.


--
-- Name: placements_id_seq; Type: SEQUENCE SET; Schema: public; Owner: narinda
--

SELECT pg_catalog.setval('placements_id_seq', 33, true);


--
-- Data for Name: players; Type: TABLE DATA; Schema: public; Owner: narinda
--

COPY players (id, game_id, user_id, score, created_at, updated_at, state, email, move_state) FROM stdin;
1	3	8	0	2014-03-04 22:21:32.261587	2014-03-12 00:43:35.115143	playing_turn	\N	open
6	6	11	0.484999999999999987	2014-04-01 00:00:58.481985	2014-04-01 01:09:31.335124	playing_turn	\N	open
7	6	12	0.328333333333332977	2014-04-01 00:05:47.536172	2014-04-01 04:44:35.623289	waiting	\N	created
5	6	10	0.311666666666665981	2014-03-31 23:59:04.158522	2014-04-02 04:07:55.376892	waiting	\N	created
3	4	9	0.508333333333332971	2014-03-12 03:26:25.438642	2014-04-03 05:56:09.403104	waiting	\N	created
8	7	9	0	2014-04-03 04:51:33.580045	2014-04-10 05:20:38.558115	playing_turn	\N	created
4	4	11	0.288750000000000007	2014-03-18 01:43:58.817487	2014-03-26 05:07:33.164093	waiting	\N	created
2	4	10	0.298333333333333006	2014-03-12 03:24:20.674382	2014-03-27 00:59:06.528613	playing_turn	\N	created
20	8	11	0	2014-04-15 06:06:55.573492	2014-04-15 06:09:26.458533	waiting	\N	created
21	8	10	0	2014-04-17 03:56:19.830146	2014-04-22 01:55:51.293991	waiting	\N	created
22	8	12	0	2014-04-22 01:57:41.817969	2014-04-22 01:57:41.817969	playing_turn	\N	open
\.


--
-- Name: players_id_seq; Type: SEQUENCE SET; Schema: public; Owner: narinda
--

SELECT pg_catalog.setval('players_id_seq', 22, true);


--
-- Data for Name: profiles; Type: TABLE DATA; Schema: public; Owner: narinda
--

COPY profiles (id, user_id, name, bio, avatar) FROM stdin;
1	1	hi	\N	\N
2	2	user	\N	\N
3	3	admin	\N	\N
4	4	narinda	\N	\N
5	5	cath.styles	\N	\N
6	6	michael	\N	\N
7	7	trsell	\N	\N
8	8	andy	\N	\N
9	9	rating_test	\N	\N
11	11	rating_test3	\N	\N
12	12	rating_test4	\N	\N
13	13	test_sign	\N	\N
14	14	test_sign2	\N	\N
15	15	test_sign5	\N	\N
16	16	test_sign4	\N	\N
10	10	Testing Rating		\N
\.


--
-- Name: profiles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: narinda
--

SELECT pg_catalog.setval('profiles_id_seq', 16, true);


--
-- Data for Name: ratings; Type: TABLE DATA; Schema: public; Owner: narinda
--

COPY ratings (id, rating, resemblance_id, creator_id, created_at, updated_at) FROM stdin;
22	0.280000000000000027	7	11	2014-03-26 05:01:32.369038	2014-03-26 05:01:32.369038
23	0.223333333333333328	6	11	2014-03-26 05:01:36.480415	2014-03-26 05:01:36.480415
24	0.806666666666666643	9	11	2014-03-26 05:01:40.894262	2014-03-26 05:01:40.894262
25	0.813333333333333353	8	11	2014-03-26 05:01:44.544442	2014-03-26 05:01:44.544442
26	0.606666666666666687	11	11	2014-03-26 05:01:47.407449	2014-03-26 05:01:47.407449
27	0.16333333333333333	10	11	2014-03-26 05:01:50.421471	2014-03-26 05:01:52.221344
28	0.103333333333333333	33	10	2014-04-01 00:43:50.191899	2014-04-01 00:43:50.191899
29	0.446666666666666656	34	10	2014-04-01 00:43:57.641191	2014-04-01 00:43:57.641191
30	0.209999999999999992	34	11	2014-04-01 01:07:06.300147	2014-04-01 01:07:06.300147
31	0.160000000000000003	37	11	2014-04-01 01:07:15.388545	2014-04-01 01:07:15.388545
32	0.866666666666666696	33	12	2014-04-01 01:07:56.25898	2014-04-01 01:07:56.25898
33	0.463333333333333319	37	12	2014-04-01 01:08:01.675686	2014-04-01 01:08:01.675686
34	0.365300000000000014	39	10	2014-04-02 03:54:23.185083	2014-04-02 03:55:32.179071
35	0.483999999999999986	38	10	2014-04-02 04:07:15.243576	2014-04-02 04:07:15.243576
37	0.397299999999999986	40	12	2014-04-02 23:28:09.33023	2014-04-02 23:28:09.33023
38	0.536599999999999966	43	12	2014-04-02 23:28:46.303489	2014-04-03 03:42:42.959935
8	0.153333333333333321	2	9	2014-03-18 01:15:49.605464	2014-03-18 01:35:57.838567
9	0.445000000000000007	1	11	2014-03-18 01:45:46.830006	2014-03-19 03:01:17.892754
10	0.481666666666666687	2	11	2014-03-18 03:10:19.765387	2014-03-19 04:39:49.767624
11	0.458333333333333315	3	9	2014-03-25 05:46:26.58795	2014-03-25 05:46:26.58795
12	0.371666666666666645	1	10	2014-03-25 05:47:18.185731	2014-03-25 05:47:18.185731
13	0.0250000000000000014	3	10	2014-03-25 05:47:22.378925	2014-03-25 05:47:23.691584
36	0.648499999999999965	41	12	2014-04-02 23:27:14.660636	2014-04-03 03:57:58.854015
39	0.513699999999999934	42	12	2014-04-03 03:58:13.441571	2014-04-03 03:58:13.441571
14	\N	5	10	2014-03-26 00:39:59.872941	2014-03-26 04:21:25.003623
15	\N	9	10	2014-03-26 00:40:27.994741	2014-03-26 04:21:25.024069
19	0.130000000000000004	5	9	2014-03-26 04:52:06.869137	2014-03-26 04:52:06.869137
16	0.606666666666666687	4	9	2014-03-26 03:40:49.037151	2014-03-26 04:52:48.233972
20	0.316666666666666652	7	9	2014-03-26 04:53:06.988387	2014-03-26 04:53:06.988387
17	0.260000000000000009	6	9	2014-03-26 03:50:46.633507	2014-03-26 04:53:20.305335
21	0.396666666666666667	11	9	2014-03-26 04:53:24.967543	2014-03-26 04:53:24.967543
18	0.0633333333333333387	10	9	2014-03-26 03:52:55.450442	2014-03-26 04:53:30.020811
\.


--
-- Name: ratings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: narinda
--

SELECT pg_catalog.setval('ratings_id_seq', 39, true);


--
-- Data for Name: resemblances; Type: TABLE DATA; Schema: public; Owner: narinda
--

COPY resemblances (id, description, state, score, link_id, creator_id, created_at, updated_at, source_id, target_id) FROM stdin;
12	Old school	proposed	\N	18	11	2014-03-26 05:07:18.344395	2014-03-26 05:07:18.344395	8	12
13	Dunno	proposed	\N	19	11	2014-03-26 05:07:18.348255	2014-03-26 05:07:18.348255	10	12
28	as	proposed	\N	18	10	2014-03-27 03:47:50.287597	2014-03-27 03:47:50.287597	8	13
29	as	proposed	\N	19	10	2014-03-27 03:47:50.293267	2014-03-27 03:47:50.293267	10	13
30	Babes	proposed	\N	18	9	2014-03-27 05:18:09.2338	2014-03-27 05:18:09.2338	8	14
31	Babes	proposed	\N	19	9	2014-03-27 05:18:09.241803	2014-03-27 05:18:09.241803	10	14
41	asd	proposed	0.648499999999999965	35	10	2014-04-01 04:54:39.966877	2014-04-03 03:57:58.863808	17	23
42	asd	proposed	0.513700000000000045	36	10	2014-04-01 04:59:59.800248	2014-04-03 03:58:13.453515	17	24
2	Floral	final	0.317500000000000004	11	10	2014-03-12 03:39:49.082221	2014-04-03 02:29:54.843352	3	6
1	Pets and fruits	final	0.408333333333332993	12	9	2014-03-12 03:38:03.211297	2014-04-03 02:29:54.852399	3	5
3	Not even sure	final	0.241666666666667002	13	11	2014-03-25 04:46:22.669852	2014-04-03 02:29:54.867393	3	7
6	Environmental understanding	proposed	0.241666666666667002	14	10	2014-03-26 00:32:54.61739	2014-04-03 02:29:54.872066	6	9
7	Where is that possum?	proposed	0.298333333333333006	15	10	2014-03-26 00:32:54.621785	2014-04-03 02:29:54.876716	5	9
10	Carrying	proposed	0.113333333333332995	16	10	2014-03-26 00:38:30.22942	2014-04-03 02:29:54.881268	5	11
11	Caring	proposed	0.501666666666667038	17	10	2014-03-26 00:38:30.232392	2014-04-03 02:29:54.885441	7	11
4	Pretty	final	0.60666666666666702	14	11	2014-03-26 00:21:57.521129	2014-04-03 02:29:54.889553	6	8
5	Boy with nature	final	0.130000000000000004	15	11	2014-03-26 00:21:57.525945	2014-04-03 02:29:54.893856	5	8
8	Heavy load	final	0.81333333333333302	16	9	2014-03-26 00:36:19.950235	2014-04-03 02:29:54.899167	5	10
9	Native pets	final	0.806666666666666976	17	9	2014-03-26 00:36:19.953562	2014-04-03 02:29:54.906653	7	10
37	Thirsty	final	0.31166666666666698	31	10	2014-04-01 00:41:11.498307	2014-04-03 02:29:54.978162	15	21
33	Cuddles	final	0.484999999999999987	32	11	2014-04-01 00:02:31.943578	2014-04-03 02:29:54.983989	15	17
34	Boys club	final	0.328333333333332977	33	12	2014-04-01 00:09:27.925772	2014-04-03 02:29:54.989977	15	18
38	asd	proposed	0.483999999999999986	34	12	2014-04-01 04:44:29.429342	2014-04-03 02:29:54.995588	21	22
39	asd	proposed	0.365300000000000014	35	12	2014-04-01 04:44:29.433131	2014-04-03 02:29:55.001056	17	22
40	asd	proposed	0.397299999999999986	34	10	2014-04-01 04:54:39.964739	2014-04-03 02:29:55.034887	21	23
43	asd	proposed	0.0434000000000000011	37	10	2014-04-01 04:59:59.802578	2014-04-03 02:29:55.049367	18	24
48	Boomerang babies	proposed	\N	51	11	2014-04-15 06:08:00.560328	2014-04-15 06:08:00.560328	28	31
49	Something	proposed	\N	52	10	2014-04-17 04:11:55.816998	2014-04-17 04:11:55.816998	28	32
\.


--
-- Name: resemblances_id_seq; Type: SEQUENCE SET; Schema: public; Owner: narinda
--

SELECT pg_catalog.setval('resemblances_id_seq', 49, true);


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: narinda
--

COPY schema_migrations (version) FROM stdin;
20131014050440
20131015002355
20131015025606
20131015051929
20131015070339
20131017044414
20131017044432
20131017044440
20131017044451
20131029040046
20131030040144
20131017045438
20131017045458
20131017231832
20131018043025
20131018051741
20131017060345
20131022055830
20131120045222
20131120045237
20131121002730
20131121032603
20131121040600
20131127020914
20131127020944
20131127045113
20131127230252
20131204035049
20131204052618
20131204234506
20131205035026
20131210034401
20131212030054
20131217042024
20140205010520
20140211225733
20140224031647
20140226011705
20140318231306
20140415064148
\.


--
-- Data for Name: things; Type: TABLE DATA; Schema: public; Owner: narinda
--

COPY things (id, title, description, creator_id, updator_id, created_at, updated_at, image, attribution, item_url, copyright, general_attributes, import_row_id, access_via, random_seed, suggested_seed) FROM stdin;
340	Pet possum	A woman from the shoulders up. A taut string rope is visible behind her ears, suggesting she is carrying a bag, and a baby possum is sitting on her head.	\N	3	2014-01-08 00:23:53.656982	2014-02-25 21:44:22.970934	800d7b2f.jpg	Herbert Basedow	http://www.nma.gov.au/collections-search/display?app=tlf&irn=11728	CC BY-NC-SA	{"Date/s":["1922"],"Places":["Australia","Northern Territory","Victoria River"],"Node type":["photograph"],"Keywords":["possum","woman","Indigenous"]}	NMA1	National Museum of Australia	1870541549	t
341	Week-old baby asleep in a wooden container	A very young baby, sleeping in a wooden bowl resting on sandy ground. A foot is visible, suggesting the baby is being gently rocked.	\N	\N	2014-01-08 00:24:00.82912	2014-02-25 21:44:22.987097	daaf6b31.jpg	Herbert Basedow	http://www.nma.gov.au/collections-search/display?app=tlf&irn=12543	CC BY-NC-SA	{"Date/s":["1919"],"Places":["Australia","South Australia"],"Node type":["photograph"],"Keywords":["baby","Indigenous","sleeping","family"]}	NMA2	National Museum of Australia	305779120	f
342	Young man on a raft	A young man sits cross-legged, holding a paddle, on a wooden raft in a body of water with trees and other vegetation.	\N	\N	2014-01-08 00:24:08.365429	2014-02-25 21:44:22.993576	e3b5abc8.jpg	Herbert Basedow	http://www.nma.gov.au/collections-search/display?app=tlf&irn=11791	CC BY-NC-SA	{"Date/s":["1916"],"Places":["Australia","Western Australia","Kimberley"],"Node type":["photograph"],"Keywords":["man","raft","mangrove","Indigenous"]}	NMA3	National Museum of Australia	1733600035	f
343	Women carrying large baskets and a child	Two thin young women stand, each carrying a woven basket with the strap around their head. One also carries a child. To the right of the frame a thin dog stands, alert, facing away from the camera.	\N	\N	2014-01-08 00:24:16.767316	2014-02-25 21:44:23.001492	7883ec94.jpg	Herbert Basedow	http://www.nma.gov.au/collections-search/display?app=tlf&irn=12829	CC BY-NC-SA	{"Date/s":["1928"],"Places":["Australia","Northern Territory","Arnhem Land"],"Node type":["photograph"],"Keywords":["women","baskets","baby","dog","dingo","Indigenous","family"]}	NMA4	National Museum of Australia	1273702373	f
355	Invincible sailor	Bust of a sailor boy with "Invincible" printed on his hat band. Sourrounding is an underwater scene of fish, shells and coral. Printed at the base: Manufactured by Heinecke & Fox, Melbourne.	\N	\N	2014-01-08 00:28:25.004684	2014-02-25 21:44:23.090161	115ade2c.jpg	Heinecke & Fox	http://handle.slv.vic.gov.au/10381/53335	public domain	{"Date/s":["1884"],"Places":["Australia","Victoria"],"Node type":["print"],"Keywords":["sailor","boy","invincible","advertisement","lithograph","propaganda"]}	SLV009	State Library of Victoria	1760644444	f
361	Three women, nine babies	The first nursery group at the Australian Greek Welfare Society Child Care and Community Centre	\N	\N	2014-01-08 00:29:17.731852	2014-02-25 21:44:23.136282	ff5cade2.jpg	Australia, Victoria, Richmond, 8 Corsair St, Australian Greek Welfare Society Child Care and Community Centre, Greece	http://handle.slv.vic.gov.au/10381/122506	public domain	{"Date/s":["1988"],"Places":["Australia","Victoria","Richmond"],"Node type":["photograph"],"Keywords":["babies","nursery","Greek","community"]}	SLV016	State Library of Victoria	832819423	f
362	Two drawings of a passion flower	A drawing of two passionfruit flowers	\N	\N	2014-01-08 00:29:24.360133	2014-02-25 21:44:23.14552	0f8a1afb.jpg	Christian Marjory Emily Carlyle Waller	http://handle.slv.vic.gov.au/10381/114008	public domain	{"Date/s":["1920"],"Places":["Australia","Victoria"],"Node type":["drawing"],"Keywords":["passionfruit","flowers","botany"]}	SLV017	State Library of Victoria	626532591	f
363	Woman holding baby in front of a house	Free-standing weatherboard house with corrugated iron roof and porch, woman standing on front path, wearing an apron, holding a baby, picket fence in front (possibly Wederburn)	\N	\N	2014-01-08 00:29:30.905913	2014-02-25 21:44:23.157503	73c14f60.jpg	\N	http://handle.slv.vic.gov.au/10381/45639	public domain	{"Date/s":["c1880-1890"],"Places":["Australia","Victoria","Wederburn"],"Node type":["photograph"],"Keywords":["weatherboard","house","picket fence","mother","baby","woman","holding","home","family"]}	SLV018	State Library of Victoria	1716933903	f
364	Bath war hospital, ward no.4	Shows a hospital ward with a line of beds on right and left, patients, some sitting up, nurses standing beside some of the beds.	\N	\N	2014-01-08 00:29:38.275351	2014-02-25 21:44:23.166045	2a526337.jpg	\N	http://handle.slv.vic.gov.au/10381/16420	public domain	{"Date/s":["1918"],"Places":["England","Bath"],"Node type":["photograph"],"Keywords":["hospital","war","wounded","nurses","beds","ward","men","aftermath","World War I"]}	SLV019	State Library of Victoria	901583244	f
365	Bush grave	Bush grave – the headstone reads "In loving memory of out dear father James Hamilton, died 8th May 1865 aged 50 years"	\N	\N	2014-01-08 00:29:45.353972	2014-02-25 21:44:23.175611	94a4aa13.jpg	James Hamilton	http://handle.slv.vic.gov.au/10381/41281	public domain	{"Date/s":["c1914���1937"],"Places":["Australia","Victoria"],"Node type":["photograph"],"Keywords":["grave","gravestone","fence","bush","James Hamilton","death"]}	SLV020	State Library of Victoria	361091783	f
376	Anatomy of a horse	Original drawing of the anatomy of the horse. Some areas of the horse are highlighted with numbered pointers, but there is no key to the numbers.	\N	\N	2014-01-08 00:31:16.190325	2014-02-25 21:44:23.255096	0acf731d.jpg	David Brown	http://handle.slv.vic.gov.au/10381/53302	public domain	{"Date/s":["1879"],"Places":["Australia","Victoria"],"Node type":["print"],"Keywords":["horse","illustration","anatomy","animals"]}	SLV031	State Library of Victoria	208194531	f
372	Empty exhibition building interior	Interior of an empty exhibition building, with detailed patterning.	\N	\N	2014-01-08 00:30:41.896918	2014-02-25 21:44:23.228976	fbaaad98.jpg	\N	http://handle.slv.vic.gov.au/10381/54833	public domain	{"Date/s":["1871"],"Places":["Australia","Victoria","Melbourne"],"Node type":["photograph"],"Keywords":["exhibition","building","empty","ornate","interior"]}	SLV027	State Library of Victoria	1042898762	f
373	The Melbourne and Hobson's Bay Limited Railway Company's pier	A busy wharf scene with many sailing ships tied up at the wharf.	\N	3	2014-01-08 00:30:51.232268	2014-02-25 21:44:23.235407	513a26b7.jpg	Charles Nettleton	http://handle.slv.vic.gov.au/10381/29509	public domain	{"Date/s":["c1900���1954"],"Places":["Australia","Victoria","Melbourne"],"Node type":["photograph"],"Keywords":["railway","pier","steamboats","boats","travel"]}	SLV028	State Library of Victoria	2097705110	t
374	Dead shot worm candy	Advertisement for childrens' worm treatment. Text reads: Safe, sure & simple, Dead shot worm candy, 25 cents, registered, for children, directions inside, specially adapted for domestic convenience, by J Kendrick, Brooklyn, New York.	\N	\N	2014-01-08 00:30:58.348188	2014-02-25 21:44:23.241386	91ef6035.jpg	\N	http://handle.slv.vic.gov.au/10381/53054	public domain	{"Date/s":["1880"],"Places":["Australia","Victoria","United States of America","New York","Brooklyn"],"Node type":["print"],"Keywords":["candy","children","worms","treatment","lithograph","parasites","medicine","health"]}	SLV029	State Library of Victoria	1249528450	f
375	Replica of Ned Kelly’s armour	Studio photograph of a replica of Ned Kelly's suit of armour made by photographer, William Burman, for his own publication purposes.	\N	\N	2014-01-08 00:31:06.772303	2014-02-25 21:44:23.247242	e29b991a.jpg	WIlliam J Burman	http://handle.slv.vic.gov.au/10381/52783	public domain	{"Date/s":["1880"],"Places":["Australia","Victoria"],"Node type":["photograph"],"Keywords":["armour","Kelly gang","bushrangers","studio"]}	SLV030	State Library of Victoria	344845755	f
378	Boomerang brand	Encircled image of an Australian Aboriginal man against a background of lake and mountains, spear and shield in hand, about to throw a boomerang.	\N	\N	2014-01-08 00:31:29.556695	2014-02-25 21:44:23.270439	8f47d3a8.jpg	Troedel & Co	http://handle.slv.vic.gov.au/10381/54222	public domain	{"Date/s":["1881"],"Places":["Australia","Victoria"],"Node type":["print"],"Keywords":["man","shield","boomerang","Indigenous","label","advertisement","symbol","emblem"]}	SLV033	State Library of Victoria	2118003381	f
384	Bush surgeon	Shows bushland in background, a woman, two men and a child outside a bark hut. One man is seated and reading a book below a sign reading: "Dr Smith / Surgeon"	\N	\N	2014-01-08 00:32:15.099096	2014-02-25 21:44:23.311251	c7afa9b8.jpg	Thomas J Washbourne	http://handle.slv.vic.gov.au/10381/54106	public domain	{"Date/s":["1870"],"Places":["Australia","Victoria"],"Node type":["photograph"],"Keywords":["building","surgeon","bushland","bark hut","Dr Smith"]}	SLV040	State Library of Victoria	270999684	f
385	A prospector's claim on the summit of the Australian Alps	Two men and a boy at their claim at Dargo River, Victoria. Two men lean on a log hut and a boy sits on an overturned bucket, with logs and axes. A wooden pulley loaded with rock can be seen and the remains of an animal carcass hangs from a branch.	\N	\N	2014-01-08 00:32:22.779805	2014-02-25 21:44:23.31748	26689102.jpg	Thomas J Washbourne	http://handle.slv.vic.gov.au/10381/53670	public domain	{"Date/s":["1870"],"Places":["Australia","Victoria","Dargo River"],"Node type":["photograph"],"Keywords":["gold","men","boy","claim","prospect","alps"]}	SLV041	State Library of Victoria	1593281810	f
386	Black trackers	A posed studio photograph of two Aboriginal Australian men against a backdrop of trees and bush. They both look to a spot on the ground, with one kneeling down and pointing, and the other leaning over.	\N	\N	2014-01-08 00:32:29.815035	2014-02-25 21:44:23.325205	3d9ca42f.jpg	Henry Goldman	http://handle.slv.vic.gov.au/10381/53295	public domain	{"Date/s":["1902"],"Places":["Australia","Victoria"],"Node type":["photograph"],"Keywords":["Indigenous","men","trackers","studio"]}	SLV042	State Library of Victoria	1679453681	f
387	Block of granite for Burke & Wills monument	Procession of people in Elizabeth Street, with horses and carts and the granite for the Burke and Wills cemetery monument, Melbourne, 1863. Shows Dean's premises at 67 Elizabeth Street. The Age offices are next door.	\N	\N	2014-01-08 00:32:36.325242	2014-02-25 21:44:23.333345	3a6684c0.jpg	George Dean	http://handle.slv.vic.gov.au/10381/54552	public domain	{"Date/s":["1906"],"Places":["Australia","Victoria","Melbourne","Elizabeth St"],"Node type":["photograph"],"Keywords":["memorial","commemoration","granite","Burke \\u0026 Wills","Melbourne","street","horse","crowd","spectacle","monument","The Age","remembrance","monument","explorers"]}	SLV043	State Library of Victoria	1340868489	f
399	After the ball	An Aboriginal Australian woman in a floral dress and white gloves, seated on a wicker chair. Her hair is greying and she wears a small headpiece, whilst looking down at a card held in her right hand and holds a fan in her left. Some wilting flowers are in her lap and behind her are two potted palms. To her left is a wooden chair (only partially visible).	\N	\N	2014-01-08 00:34:03.611108	2014-02-25 21:44:23.447733	7122aab4.jpg	Thomas Cleary	http://handle.slv.vic.gov.au/10381/53253	public domain	{"Date/s":["1896"],"Places":["Australia"],"Node type":["photograph"],"Keywords":["studio","Indigenous","fan","gloves","flowers","palms","wicker","women"]}	SLV056	State Library of Victoria	1777923854	f
349	Child with shells	Unidentified boy or girl seated on the ground with pile of shells -- In her cradle carved out of a cotton wood tree	\N	\N	2014-01-08 00:27:37.720457	2014-02-25 21:44:23.04193	785d6570.jpg	Cyril Grant Lane	http://handle.slv.vic.gov.au/10381/53034	public domain	{"Date/s":["c1900���1928"],"Places":["Australia","Queensland"],"Node type":["photograph"],"Keywords":["child","shells","cubby","trees","Aboriginal"]}	SLV003	State Library of Victoria	1713045546	f
394	Inflating a bicycle tyre with a pair of bellows	A cyclist pumping up a bicycle tyre with a set of bellows. The bicycle is turned upside down and rests on a wooden pole whilst the man is down on one knee, using both hands to operate bellows. His face is blackened and he wears a bowler hat. Shot appears to have been taken in someone's backyard, with an old picket fence to the upper left and a wooden fence at the back.	\N	\N	2014-01-08 00:33:28.898996	2014-02-25 21:44:23.394094	3d3d50f9.jpg	Henry Short	http://handle.slv.vic.gov.au/10381/52788	public domain	{"Date/s":["1897"],"Places":["Australia","Victoria"],"Node type":["photograph"],"Keywords":["bicycle","pneumatic tyre","bellows","picket fence","yard","man","smiling","smile","repair","home","travel"]}	SLV051	State Library of Victoria	1085176973	f
395	Japanese woman and cherry blossom	Stereograph of a Japanese woman wearing a hat and holding an umbrella, with cherry blossom in front of her.	\N	\N	2014-01-08 00:33:36.242522	2014-02-25 21:44:23.409166	ddea8322.jpg	George Rose	http://handle.slv.vic.gov.au/10381/53832	public domain	{"Date/s":["1905"],"Places":["Japan","Australia","Victoria"],"Node type":["photograph"],"Keywords":["cherry","blossoms","Japan","flowers","woman","umbrella","parasol","stereograph","festivals"]}	SLV052	State Library of Victoria	641302462	f
396	Dance card	White card with silver print, folded, and heading "Engagements." Inside it lists numbers 1 - 22 and types of dances, quadrille, etc	\N	\N	2014-01-08 00:33:42.562335	2014-02-25 21:44:23.421055	97720e43.jpg	\N	http://handle.slv.vic.gov.au/10381/54239	public domain	{"Date/s":["1872"],"Places":["Australia"],"Node type":["print"],"Keywords":["dances","card","list","engagements","leisure"]}	SLV053	State Library of Victoria	2010847309	f
397	Aboriginal Australian boys with juggling balls	Studio photograph of two Aboriginal Australian boys seated on floor and partially covered by animal furs. Both boys are looking upwards and watching balls in mid air above the older boy's head. He holds soap with the inscription: "Pears Size 1 Inventor."	\N	\N	2014-01-08 00:33:48.673101	2014-02-25 21:44:23.428887	ab7b1113.jpg	Thomas Cleary	http://handle.slv.vic.gov.au/10381/54208	public domain	{"Date/s":["1896"],"Places":["Australia"],"Node type":["photograph"],"Keywords":["Indigenous","boys","children","juggling","soap","advertisement","studio"]}	SLV054	State Library of Victoria	1582838523	f
398	Diagonal copy sheet	Lithograph of examples for practice in cursive handwriting.	\N	\N	2014-01-08 00:33:56.727562	2014-02-25 21:44:23.440352	7f4dfc49.jpg	Robert Jones	http://handle.slv.vic.gov.au/10381/53371	public domain	{"Date/s":["1878"],"Places":["Australia"],"Node type":["print"],"Keywords":["cursive","handwriting","practice","diagonal","penmanship","writing","letters"]}	SLV055	State Library of Victoria	1982051562	f
347	Babies, one sleeping, one sitting	Two babies, whole-length, one lying asleep, the other sitting up, necklace of shells around neck.	\N	\N	2014-01-08 00:27:24.871947	2014-02-25 21:44:23.028759	ffee319e.jpg	Cyril Grant Lane	http://handle.slv.vic.gov.au/10381/53034	public domain	{"Date/s":["c1900���1928"],"Places":["Australia","Queensland"],"Node type":["photograph"],"Keywords":["babies","sleeping","sitting","shells","necklace","family","Aboriginal"]}	SLV001	State Library of Victoria	154646933	f
348	Baby in a wooden bowl	Baby, whole-length, naked, lying in a coolamon	\N	\N	2014-01-08 00:27:31.341089	2014-02-25 21:44:23.035342	630e8fe8.jpg	Cyril Grant Lane	http://handle.slv.vic.gov.au/10381/53034	public domain	{"Date/s":["c1900���1928"],"Places":["Australia","Queensland"],"Node type":["photograph"],"Keywords":["baby","Indigenous","sleeping"]}	SLV002	State Library of Victoria	937884791	f
401	Potatoes	Two piles of potatoes on a hessian cloth	\N	\N	2014-01-08 00:34:19.996759	2014-02-25 21:44:23.4635	cf939446.jpg	George Seymour	http://handle.slv.vic.gov.au/10381/54501	public domain	{"Date/s":["1905"],"Places":["Australia","Victoria"],"Node type":["photograph"],"Keywords":["potatoes","pile","wrinkly","food"]}	SLV058	State Library of Victoria	1419732968	f
405	Please take this Circular	Print of woman in a ball gown, holding a fan, words printed on fan: Please take this CIRCULAR	\N	\N	2014-01-08 00:34:52.591354	2014-02-25 21:44:23.49639	48419429.jpg	\N	http://handle.slv.vic.gov.au/10381/54378	public domain	{"Date/s":["1871"],"Places":["Australia","Victoria"],"Node type":["print"],"Keywords":["circulars","woman","fan","ball gown","communications"]}	SLV062	State Library of Victoria	1118043920	f
406	Buffon's Celebrated Cockroach, Bed Bug, Ant, & Rat Exterminator [	Printed advertisement for Buffon's Celebrated Cockroach, Bed Bug, Ant and Rat Exterminator. Shows image of large cockroach with text below, including directions for use of product.	\N	\N	2014-01-08 00:35:00.442964	2014-02-25 21:44:23.503227	b731f486.jpg	\N	http://handle.slv.vic.gov.au/10381/55020	public domain	{"Date/s":["1876"],"Places":["Australia","Victoria"],"Node type":["print"],"Keywords":["cockroaches","bed bugs","ants","rats","extermination","advertisement","instruction","pests","homes","houses"]}	SLV063	State Library of Victoria	2104759140	f
407	Coining presses at the Royal Mint	Coining presses in coining hall at the Royal Mint, Melbourne. Shows row of machines attached to wheel devices on wall behind them.	\N	\N	2014-01-08 00:35:07.457686	2014-02-25 21:44:23.510846	52633c0e.jpg	Charles Nettleton	http://handle.slv.vic.gov.au/10381/54757	public domain	{"Date/s":["1873"],"Places":["Australia","Victoria","Melbourne"],"Node type":["photograph"],"Keywords":["mint","coins","machinery","presses","industry","industrial revolution"]}	SLV065	State Library of Victoria	1167232302	f
408	Kitten	A kitten sitting in a cane basket.	\N	\N	2014-01-08 00:35:14.913565	2014-02-25 21:44:23.518132	66353af4.jpg	John Bee	http://handle.slv.vic.gov.au/10381/54044	public domain	{"Date/s":["1901"],"Places":["Australia","Victoria","Melbourne","Kew"],"Node type":["photograph"],"Keywords":["kitten","basket","portrait"]}	SLV066	State Library of Victoria	648907167	f
409	Japanese girl reading a love-letter	Stereograph of two young Japanese women at a teahouse. They kneel on floor matting with a tea try in front of them and girl on right holds a scrolled letter.	\N	\N	2014-01-08 00:35:23.719572	2014-02-25 21:44:23.526713	049ff4cd.jpg	George Rose	http://handle.slv.vic.gov.au/10381/53982	public domain	{"Date/s":["1905"],"Places":["Japan","Australia"],"Node type":["photograph","stereograph"],"Keywords":["love letter","girls","women","stereograph","writing"]}	SLV067	State Library of Victoria	538614846	f
426	Scene from Sydney Town Hall tower looking towards the Heads	Shows Sydney buildings and Sydney Harbour in the distance. Shop signs in view include: "HS Gibson's horse & carriage bazaar", "Blind WP Watch maker", "HRH Duke Edinburgh", "Stewart's horse bazaar", "Lee & Ross steam printers".	\N	\N	2014-01-08 00:52:53.970732	2014-02-25 21:44:23.666364	624cdb2c.jpg	NJ Caire	http://handle.slv.vic.gov.au/10381/52837	public domain	{"Date/s":["1877"],"Places":["Australia","Sydney","New South Wales"],"Node type":["photograph"],"Keywords":["Sydney Harbour","Town Hall","view","buildings","coast","ocean","headland","landscape","urban"]}	SLV085	State Library of Victoria	946688047	f
437	Cumberland River Lorne	Shows a river running over rocks, with bushland on either side. in foreground is a still pool of water.	\N	\N	2014-01-08 00:54:16.586374	2014-02-25 21:44:23.759045	57c3601f.jpg	WS Anderson	http://handle.slv.vic.gov.au/10381/54233	public domain	{"Date/s":["1906"],"Places":["Australia","Victoria","Lorne","Cumberland River"],"Node type":["photograph"],"Keywords":["river","stones","forest","trees","water","landscape","bushland"]}	SLV096	State Library of Victoria	1612676074	f
441	Hume Weir	View of weir under construction.	\N	\N	2014-01-08 00:54:43.896212	2014-02-25 21:44:23.788361	de43b9cb.jpg	\N	http://handle.slv.vic.gov.au/10381/45291	public domain	{"Date/s":["1929"],"Places":["Australia","Victoria","Murray River","Hume Weir"],"Node type":["photograph"],"Keywords":["Hume weir","construction","engineering"]}	SLV100	State Library of Victoria	202784094	f
455	The drought in the far north, Sout Australia:\t An out station	Illustration of a barren landscape with animal carcasses, dead trees and damaged buildings.	\N	\N	2014-01-08 00:56:23.64456	2014-02-25 21:44:23.882078	65a50b17.jpg	Robert Bruce, Richard Ernest Minchin	http://handle.slv.vic.gov.au/10381/43095	public domain	{"Date/s":["1865"],"Places":["Australia","South Australia"],"Node type":["print"],"Keywords":["drought","animals","landscape","carcasses","smoke"]}	SLV114	State Library of Victoria	710910852	f
512	The Sphinx with the pyramids	Behind the sphinx two pyramids are visible. To the right of the frame is a lone camel rider.	\N	\N	2014-01-08 01:08:11.893738	2014-02-25 21:44:24.289685	027dcf0b.jpg	L Heldring	http://hdl.handle.net/10934/RM0001.COLLECT.438152	public domain	{"Date/s":["1898"],"Places":["Giza Plateau","Egypt"],"Node type":["photograph"],"Keywords":["pyramids","sphinx"]}	RKM044	Rijksmuseum	1649952530	f
522	Master of the Amsterdam bodegón (kitchen)	The smiling kitchen master stands behind a table with a large bowl of red wine in his hands. On display are all kinds of food: poultry, quail, a duck, turkey, fish, mackerel, cheese, pies, pastries, sausages, hams, a dove, red sea bream and a pork chop. In front is a deck of cards and a few coins.	\N	\N	2014-01-08 01:09:27.189114	2014-02-25 21:44:24.357437	6aaabb4b.jpg	Alejandro de Loarte, Diego Rodriguez de Silva y Velázquez	http://hdl.handle.net/10934/RM0001.collect.8921	public domain	{"Date/s":["c1610-1625"],"Places":["Spain","Netherlands"],"Node type":["painting"],"Keywords":["food","pantry","kitchen","cooking","meals"]}	RKM054	Rijksmuseum	1810256532	f
354	Interior of Saint Paul's Church, Ballarat	Photograph of a drawing by J. D. Ryland of Saint Paul's Church interior, Ballarat. Features internal columns, church pews, stained glass window and a priest at far end, with a man and a woman holding a baby in foreground. Signed by artist l.r. corner.	\N	\N	2014-01-08 00:28:17.715051	2014-02-25 21:44:23.08161	9c3ba169.jpg	DJ Ryland, George Richards	http://handle.slv.vic.gov.au/10381/69480	public domain	{"Places":["Australia","Victoria","Ballarat"],"Node type":["drawing","photograph"],"Keywords":["church","cathedral","interior","man","woman","baby","priest"]}	SLV008	State Library of Victoria	302261352	f
344	Women carrying water	Four women in the middle distance, each carrying a wooden bowl at their hip, walk toward the camera through a grassy woodland.	\N	\N	2014-01-08 00:24:23.6216	2014-02-25 21:44:23.009007	c25dff90.jpg	Herbert Basedow	http://www.nma.gov.au/collections-search/display?app=tlf&irn=12516	CC BY-NC-SA	{"Date/s":["1922"],"Places":["Australia","Northern Territory","Victoria River"],"Node type":["photograph"],"Keywords":["women","walking","water","Indigenous"]}	NMA5	National Museum of Australia	852351163	f
345	Boys in a dugout and two bark canoes	Three watercraft – two bark canoes and a wooden dugout – float parallel near the shore. The dugout carries five children, the bark canoes two each. In each canoe, two children have one paddle each.	\N	\N	2014-01-08 00:24:32.131354	2014-02-25 21:44:23.015732	4e0488dd.jpg	Herbert Basedow	http://www.nma.gov.au/collections-search/display?app=tlf&irn=12596	CC BY-NC-SA	{"Date/s":["1911"],"Places":["Australia","Northern Territory","Bathurst Island","Melville Island"],"Node type":["photograph"],"Keywords":["children","canoes","dugout","bark","Indigenous"]}	NMA6	National Museum of Australia	1509642141	f
346	Expedition guides next to wet-weather huts	Four men sit together in front of a low bark-covered shelter in an open grassy woodland. A child is seated on the shoulders of one of the men.	\N	\N	2014-01-08 00:24:39.933709	2014-02-25 21:44:23.022931	6e99daa5.jpg	Herbert Basedow	http://www.nma.gov.au/collections-search/display?app=tlf&irn=12806	CC BY-NC-SA	{"Date/s":["1928"],"Places":["Australia","Northern Territory","Arnhem Land"],"Node type":["photograph"],"Keywords":["hut","shelter","guides","seated","Indigenous"]}	NMA7	National Museum of Australia	366477215	f
350	Fire at Terang	Rubble of buildings destroyed by fire, showing stack of corrugated iron and other rubble, sign still standing reads: Bennett's Pharmacy / Temporary Premises / next / Romney Studios. Man standing among rubble in background, other buildings in background	\N	\N	2014-01-08 00:27:45.795773	2014-02-25 21:44:23.048377	b9ec6746.jpg	\N	http://handle.slv.vic.gov.au/10381/200019	public domain	{"Date/s":["1916"],"Places":["Australia","Victoria","Terang"],"Node type":["photograph"],"Keywords":["fire","corrugated iron","sign","buildings"]}	SLV004	State Library of Victoria	1390490099	f
351	French postcard depicting a girl thinking of a soldier	Girl standing on a bench with a bouquet of flowers, thinking of a solder. Printed at the base: C’est en pensant a lui j'ai cueilli ces fleurs / C'est a lui que s'en vont mes souhaits les meilleurs	\N	\N	2014-01-08 00:27:54.379107	2014-02-25 21:44:23.05554	99e5f8ea.jpg	M Boulanger	http://handle.slv.vic.gov.au/10381/25485	public domain	{"Places":["Australia","France"],"Node type":["postcard","photograph","print"],"Keywords":["postcards","war","French","France","girls","flowers","soldiers","World War I"]}	SLV005	State Library of Victoria	200304607	f
352	Historic shipwrecks of Victoria	Poster, Victoria Archaeological Survey, Ministry for Planning and Environment, showing the Victorian coastline and a number of shipwreck sites.	\N	\N	2014-01-08 00:28:02.254451	2014-02-25 21:44:23.064586	26e29c9e.jpg	Victoria Archaeological Survey	http://handle.slv.vic.gov.au/10381/118618	public domain	{"Date/s":["1986"],"Places":["Australia","Victoria"],"Node type":["print"],"Keywords":["shipwrecks","Victoria"]}	SLV006	State Library of Victoria	254527567	f
353	Immigrants from Malta arrive in Sydney having disembarked from the SS Partizanka	Shows Father Robert Cassar who came to Australia with his parents in the 1920s then returned to Malta to train as a priest. Father Cassar then re-migrated to Australia in 1948 to serve Maltese immigrants.	\N	\N	2014-01-08 00:28:10.210937	2014-02-25 21:44:23.075041	34c279db.jpg	Father Robert Cassar	http://handle.slv.vic.gov.au/10381/77281	public domain	{"Date/s":["1948"],"Places":["Australia","Sydney","New South Wales","Malta"],"Node type":["photograph"],"Keywords":["immigrants","Maltese","ship","disembarking","gangplank","arrivals"]}	SLV007	State Library of Victoria	167121035	f
556	Test	Upload test	3	\N	2014-02-04 05:14:29.469644	2014-02-25 21:44:24.595166	1ea88801.jpg	\N	\N		{}	\N		457413110	f
356	Platypus	Photograph of a platypus. Printed beneath title: AUSTRALIA'S MOST UNIQUE CREATURE, HAS A FURRED BODY, BEAVER'S TAIL, DUCK'S BILL & CLAW-WEBBED FEET; IT LAYS EGGS & SUCKLES ITS YOUNG & LIVES IN A NEST BUILT IN THE BANK OF A STREAM, BEING QUITE AT HOME EITHER IN OR OUT OF THE WATER.	\N	\N	2014-01-08 00:28:34.231394	2014-02-25 21:44:23.097881	a60e1687.jpg	\N	http://handle.slv.vic.gov.au/10381/60968	public domain	{"Date/s":["c1920-1954"],"Places":["Australia"],"Node type":["photograph","postcard"],"Keywords":["platypus","wildlife","duck","egg","river","bank","webbed feet","animals"]}	SLV010	State Library of Victoria	838866480	f
357	Purple iris	Drawing of a purple iris	\N	\N	2014-01-08 00:28:41.755084	2014-02-25 21:44:23.105634	338fb34b.jpg	Christian Marjory Emily Carlyle Waller	http://handle.slv.vic.gov.au/10381/113991	public domain	{"Date/s":["1920"],"Places":["Australia","Victoria"],"Node type":["drawing"],"Keywords":["purple","iris","flowers","botany"]}	SLV011	State Library of Victoria	1390524073	f
358	Silhouette of a bearded man	Silhouette drawing of a bearded man	\N	\N	2014-01-08 00:28:48.820803	2014-02-25 21:44:23.112529	8263ba0e.jpg	\N	http://handle.slv.vic.gov.au/10381/154250	public domain	{"Date/s":["c1850���1870"],"Places":["Australia","Victoria"],"Node type":["drawing"],"Keywords":["silhouette","man","beard","gent","gentry","class"]}	SLV013	State Library of Victoria	406411337	f
359	Six men, cross-legged	Six men, whole-length, seated cross legged on the ground, scarification on chest and arms, bushland behind them	\N	\N	2014-01-08 00:28:58.257944	2014-02-25 21:44:23.119934	77fef8ec.jpg	Cyril Grant Lane	http://handle.slv.vic.gov.au/10381/53034	public domain	{"Date/s":["c1900���1928"],"Places":["Australia","Queensland"],"Node type":["photograph"],"Keywords":["men","seated","Aboriginal"]}	SLV014	State Library of Victoria	1849056800	f
360	Theatre patron	Man, standing, whole-length, to right, holding cane in left hand, poster on the wall behind him advertising the play Hamlet.	\N	\N	2014-01-08 00:29:09.978285	2014-02-25 21:44:23.126875	bcf945d7.jpg	Will Dyson	http://handle.slv.vic.gov.au/10381/147062	public domain	{"Date/s":["1911"],"Places":["Australia","London","England"],"Node type":["drawing"],"Keywords":["theatre","top hat","man","suit","Hamlet","arts"]}	SLV015	State Library of Victoria	1530041718	f
366	Men and boys at a communal water pump;	Men and boys at a communal water pump; several have the gourds in which they carry water.	\N	\N	2014-01-08 00:29:53.506074	2014-02-25 21:44:23.182227	ac0fca1d.jpg	George Rose	http://handle.slv.vic.gov.au/10381/57828	public domain	{"Date/s":["c1909"],"Places":["Ceylon","Sri Lanka","Australia","Victoria"],"Node type":["photograph"],"Keywords":["men","boys","water","pump","gourds","community"]}	SLV021	State Library of Victoria	1010711819	f
367	Woman on a verandah, birdcage on the ground	Well-dressed woman standing with a tea setting on the verandah of a weatherboard house. In the foreground is a wicker bird cage.	\N	\N	2014-01-08 00:30:00.629929	2014-02-25 21:44:23.191718	d8d52327.jpg	\N	http://handle.slv.vic.gov.au/10381/23543	public domain	{"Date/s":["c1893"],"Places":["Australia","Victoria"],"Node type":["photograph"],"Keywords":["woman","verandah","house","weatherboard","birdcage","home"]}	SLV022	State Library of Victoria	1482618636	f
368	Burnt house	The burnt-out remains of a house. Charred posts and parts of the corrugated iron roof remain in place but there are no walls and the floor is littered with scraps of metal and furniture.	\N	\N	2014-01-08 00:30:07.4818	2014-02-25 21:44:23.201503	f0cbc231.jpg	\N	http://handle.slv.vic.gov.au/10381/45194	public domain	{"Date/s":["1910"],"Places":["Australia","Victoria"],"Node type":["photograph"],"Keywords":["fire","corrugated iron","furniture","ruin","soot","dwelling","burnt"]}	SLV023	State Library of Victoria	1378206777	f
369	Queen Victoria	Slightly cracked photograph of a marble bust of Queen Victoria. crowned and unsmiling, on a low plinth showing the dates 1831–1897.	\N	\N	2014-01-08 00:30:14.332881	2014-02-25 21:44:23.208337	d1e8d0ab.jpg	Percival Ball	http://handle.slv.vic.gov.au/10381/52764	public domain	{"Date/s":["1897"],"Places":["Australia","Victoria"],"Node type":["sculpture"],"Keywords":["Queen Victoria","marble","bust","sculpture"]}	SLV024	State Library of Victoria	965798386	f
370	Goldfields winch	Scene showing a sheltered winch on a mound above a small railway, with a large building in the background. A group of bearded men with hats stand or sit looking at the camera. More men are visible in the background.	\N	\N	2014-01-08 00:30:24.532879	2014-02-25 21:44:23.216001	b2abfa00.jpg	Gibbs & Bloch	http://handle.slv.vic.gov.au/10381/54349	public domain	{"Date/s":["1872"],"Places":["Australia","Victoria","Gippsland","Stockyard Creek"],"Node type":["photograph"],"Keywords":["gold","men","claims","winch","shelter","railway","gold rush"]}	SLV025	State Library of Victoria	864922933	f
371	Wool-washing on the Yarra	A wide river is in the foreground. On the opposite side of the river is a pair of open-sided buildings where people are working. On the bank there are piles of wool and other buildings.	\N	\N	2014-01-08 00:30:32.401426	2014-02-25 21:44:23.221753	c36b6f4c.jpg	\N	http://handle.slv.vic.gov.au/10381/54421	public domain	{"Date/s":["1872"],"Places":["Australia","Victoria","South Yarra"],"Node type":["photograph"],"Keywords":["wool","river","men","washing","work","industry"]}	SLV026	State Library of Victoria	1161688158	f
377	Portrait of Edward De Lacy Evans in male and female attire.	Split, full length portraits of Edward De Lacy Evans, dressed in a long gown as a woman on the left and in a suit as a man on the right. Edward De Lacy Evans was born female with the name Ellen Tremaye and impersonated a man for 23 years between 1856-1879.	\N	\N	2014-01-08 00:31:22.895336	2014-02-25 21:44:23.264006	4937fd3c.jpg	Nicholas White	http://handle.slv.vic.gov.au/10381/53298	public domain	{"Date/s":["1879"],"Places":["Australia","Victoria"],"Node type":["photograph"],"Keywords":["Edward de Lacy Evans","Ellen Tamaye","cross-dressing","passing","incognito","gender","women"]}	SLV032	State Library of Victoria	66099887	f
379	Chinese giant Chonkwicsee	Full-length portrait photograph of Chonkwicsee the Chinese giant, in Chinese costume with hat and holding fan, standing next to a Western man in a suit.	\N	\N	2014-01-08 00:31:36.715011	2014-02-25 21:44:23.276966	9a1b5242.jpg	AW Burman	http://handle.slv.vic.gov.au/10381/55131	public domain	{"Date/s":["1876"],"Places":["Australia","Victoria"],"Node type":["photograph"],"Keywords":["Chinese","giant","men","studio","fan","costume","Chonkwicsee"]}	SLV035	State Library of Victoria	1559536075	f
380	Great Wall of China	Stereograph of the Great Wall of China, taken from lower viewpoint on side of mountain. Photographer notes that it is "...about 15 feet wide and averaging 30 feet in height, up the sides of steep mountains, down deep valleys, for over 3,500 miles."	\N	\N	2014-01-08 00:31:43.655164	2014-02-25 21:44:23.283926	5f92abb2.jpg	George Rose	http://handle.slv.vic.gov.au/10381/54075	public domain	{"Date/s":["1905"],"Places":["China","Australia","Victoria"],"Node type":["photograph"],"Keywords":["Great Wall of China","stereograph","landscape"]}	SLV036	State Library of Victoria	535157785	f
381	Royal visit to Melbourne, 1901	Collage of multiple images of countries that are part of the British Commonwealth. In centre is a portrait photograph of King George V and Queen Mary.	\N	\N	2014-01-08 00:31:51.337794	2014-02-25 21:44:23.29035	d2d29311.jpg	Davies & Co	http://handle.slv.vic.gov.au/10381/53912	public domain	{"Date/s":["1901"],"Places":["Australia","Victoria","Melbourne"],"Node type":["photograph"],"Keywords":["King George V","Queen Mary","royal","visit","Melbourne","collage","Britain","Federation"]}	SLV037	State Library of Victoria	924748618	f
382	Commonwealth celebrities	A drawing in two sections depicting the process and those involved in Australian Federation. Top part shows two men and two flags, the Union Jack and Australian, with a crown and half a barrel in between them. Lower part depicts Duke of Cornwall and York, his wife, a judge and a fourth man. The half barrel between them has a bottle and glasses on top.	\N	\N	2014-01-08 00:31:58.920464	2014-02-25 21:44:23.296362	2b54783e.jpg	Thomas Bradley	http://handle.slv.vic.gov.au/10381/54244	public domain	{"Date/s":["1901"],"Places":["Australia","Victoria","Melbourne"],"Node type":["drawing","photograph"],"Keywords":["Union Jack","flag","Britain","royal","highness","barrel","drinks","Federation"]}	SLV038	State Library of Victoria	732038040	f
383	Opening the first Commonwealth Parliament by HRH Duke of York	Shows a large gathering of people in official dress, in the Exhibition Building, Melbourne. The stage is decorated with a crown and flags and many people stand with books in their hands.	\N	\N	2014-01-08 00:32:06.749718	2014-02-25 21:44:23.302541	14c3f73b.jpg	Johnstone, O’Shannessy & Co	http://handle.slv.vic.gov.au/10381/53736	public domain	{"Date/s":["09/05/1901"],"Places":["Australia","Victoria","Melbourne"],"Node type":["photograph"],"Keywords":["parliament","Federation","Melbourne","ceremony"]}	SLV039	State Library of Victoria	590595884	f
388	Stump of a mammoth tree	A large, hollow tree stump with wooden planks over top as roof, at Foster, Gippsland. Tree has horse saddled standing in the entrance and a man with outstretched arms at other side.	\N	\N	2014-01-08 00:32:43.379451	2014-02-25 21:44:23.339963	a1c7f6a6.jpg	JC Flynn	http://handle.slv.vic.gov.au/10381/54528	public domain	{"Date/s":["1906"],"Places":["Australia","Victoria","Gippsland","Foster"],"Node type":["photograph","postcard"],"Keywords":["tree","stump","horse","man","bushland","roof","shelter"]}	SLV045	State Library of Victoria	1345805971	f
389	Goodness and evil in peace and war	A drawing of a conflict between divine figures representing good and evil. Four demonic, warlike figures are on the left and the poem below them reads: "I am the imperfection of the whole; The great negation of the universe; The pitch profoundest of the fallible; Myself the all of evil which exists. Evil and sin are twin with time and man. Sin from a selfish sensual source proceeds. Bailey." On the right are three winged, angelic figures, one holding a crucifix. The poem below them reads: "Oh beauteous Peace! Sweet union of a state! What else but though gives safety, strength and glory to a people! Who, by the immovable basis of God's throne, Takes her perpetual place, and of herself prophetic, lengthens age by age her sceptre. Bailey"	\N	\N	2014-01-08 00:32:50.229864	2014-02-25 21:44:23.349887	0ed6b955.jpg	William Pearce Richards	http://handle.slv.vic.gov.au/10381/53019	public domain	{"Date/s":["1894"],"Places":["Australia","Victoria"],"Node type":["drawing"],"Keywords":["good","evil","art","text","moral","Christianity","angels","war","peace","conflict",""]}	SLV046	State Library of Victoria	1782155196	f
390	Original Cinchona bitters	Printed in gold leaf and black: The Original Cinchona Bitters, a very pleasant and invigorating tonic, most valuable in all cases of disorder of the stomach dyspepsia flatulence, & C. a wineglassfull occasionally will prove an agreeable restorative and an excellent appetiser.	\N	\N	2014-01-08 00:32:58.467637	2014-02-25 21:44:23.358312	d2753476.jpg	Charles Troedel	http://handle.slv.vic.gov.au/10381/54202	public domain	{"Date/s":["1872"],"Places":["Australia","Victoria","Melbourne"],"Node type":["print"],"Keywords":["bitters","label","promotion","flatulence","dyspepsia","illness","tonic","digestion","health"]}	SLV047	State Library of Victoria	591829763	f
391	Shearing the rams	Photograph of a painting entitled "Shearing the Rams" by Tom Roberts. Shows men and boys working in shearing shed.	\N	\N	2014-01-08 00:33:06.326369	2014-02-25 21:44:23.369991	f84cfaad.jpg	Robertson & Moffatt	http://handle.slv.vic.gov.au/10381/53996	public domain	{"Date/s":["1901"],"Places":["Australia","Victoria"],"Node type":["photograph","painting"],"Keywords":["shearing","sheep","rams","shed","men","fleece","interior","painting","Tom Roberts","artists"]}	SLV048	State Library of Victoria	818944207	f
392	First Commonwealth Parliament assembled	First meeting of the Commonwealth Parliament, 1901. The politicians are seated on wooden benches, or standing, and pillars can be seen at far end of room.	\N	\N	2014-01-08 00:33:14.704903	2014-02-25 21:44:23.377125	35460752.jpg	Humphrey & Co	http://handle.slv.vic.gov.au/10381/54038	public domain	{"Date/s":["1901"],"Places":["Australia","Victoria","Melbourne"],"Node type":["photograph"],"Keywords":["parliament","Federation","Melbourne","Barton","Reid","men","suits","moustaches","prime ministers"]}	SLV049	State Library of Victoria	248591945	f
393	US Minstrels	Lithographic engraving entitled US Minstrels, showing United States' coat of arms.	\N	\N	2014-01-08 00:33:21.546857	2014-02-25 21:44:23.383537	dc763c17.jpg	\N	http://handle.slv.vic.gov.au/10381/55021	public domain	{"Date/s":["1876"],"Places":["Australia","Victoria","United States of America"],"Node type":["print"],"Keywords":["United States of America","minstrels","banjo","violin","African Americans","coat of arms","tambourine"]}	SLV050	State Library of Victoria	1397508807	f
400	Wilmot's mia mia	Aboriginal Australian man dressed in suit and hat, seated on ground in front of shelter made from branches and twigs. He smokes a pipe and looks toward billy cans nearby. Behind him is bushland. Wilmot Abraham (Corwhorong) was a well-known identity in the Warrnambool area, and this photograph was used as a postcard. He was frequently photographed and was popularly, if not necessarily correctly, referred to as "the last of his tribe".	\N	\N	2014-01-08 00:34:10.5165	2014-02-25 21:44:23.453642	d937486e.jpg	Joseph Jordan	http://handle.slv.vic.gov.au/10381/54338	public domain	{"Date/s":["1907"],"Places":["Australia","Victoria","Warrnambool"],"Node type":["photograph"],"Keywords":["Indigenous","shelter","pipe","bushland","shelter","suit","hat","Wilmot Abraham (Corwhorong)","billy"]}	SLV057	State Library of Victoria	1754733579	f
402	George Houston Reid	Portrait photograph (bust) of Sir George Houston Reid, who served as a barrister, Premier of New South Wales and Prime Minister of Australia. He wears a monocle and looks to his right.	\N	\N	2014-01-08 00:34:29.891195	2014-02-25 21:44:23.471356	42eea435.jpg	Inez Hicks, George Reid	http://handle.slv.vic.gov.au/10381/53720	public domain	{"Date/s":["1903"],"Places":["Australia","New South Wales"],"Node type":["photograph"],"Keywords":["George Reid","prime minister","portrait"]}	SLV059	State Library of Victoria	984350676	f
403	The India & China Tea Company's Mandarin's Choice tea	Purple-printed tea label showing a Chinese man carrying large buckets and another brandishing a sword.	\N	\N	2014-01-08 00:34:37.43568	2014-02-25 21:44:23.477129	92177c98.jpg	\N	http://handle.slv.vic.gov.au/10381/54786	public domain	{"Date/s":["1875"],"Places":["Australia","Victoria"],"Node type":["print"],"Keywords":["tea","label","China","packet","purple","food","trade"]}	SLV060	state Library of Victoria	595962483	f
404	Angel stamp	Small stamp or label, black and white, with angel emblem and floral border. Item stuck to lined paper.	\N	\N	2014-01-08 00:34:45.636429	2014-02-25 21:44:23.48789	bf979f41.jpg	\N	http://handle.slv.vic.gov.au/10381/54593	public domain	{"Date/s":["1872"],"Places":["Australia","Victoria"],"Node type":["print"],"Keywords":["stamp","angel","garland"]}	SLV061	state Library of Victoria	1318997948	f
410	Spectacle of a dead bushranger	A man's body is propped up against a brick wall, while a photographer standing with camera and tripod, his head under a hood, takes a picture. A group of men and two boys look on from the left.	\N	\N	2014-01-08 00:35:30.869112	2014-02-25 21:44:23.533908	7ac5e8af.jpg	JW Lindt	http://handle.slv.vic.gov.au/10381/111638	public domain	{"Date/s":["1880"],"Places":["Australia","Victoria"],"Node type":["photograph"],"Keywords":["photography","death","Joe Byrne","Ned Kelly","gang","children","spectacle","tripod","bushrangers"]}	SLV068	State Library of Victoria	270969033	f
411	Negretti Falls	Depicts a waterfall dropping into a pool. Trees stand on a hill in the background.	\N	\N	2014-01-08 00:51:03.586598	2014-02-25 21:44:23.540245	986d37c9.jpg	Thomas J Washbourne	http://handle.slv.vic.gov.au/10381/53188	public domain	{"Date/s":["1875"],"Places":["Australia","Victoria","Wannon River","Negretti Falls"],"Node type":["photograph"],"Keywords":["Negretti Falls","waterfall","landscapes"]}	SLV069	State Library of Victoria	1594584855	f
412	Great Comet of 1882	A comet with a long tail in the night sky.	\N	\N	2014-01-08 00:51:13.319785	2014-02-25 21:44:23.549182	f4707939.jpg	TW McAlpine	http://handle.slv.vic.gov.au/10381/52906	public domain	{"Date/s":["1882"],"Places":["Australia","Victoria"],"Node type":["photograph"],"Keywords":["comet","astronomy","science","scientists"]}	SLV070	State Library of Victoria	1942510253	f
413	Returned soldier with doll	Soldier holding up small doll, flags behind.	\N	\N	2014-01-08 00:51:20.750898	2014-02-25 21:44:23.554981	00b52e7b.jpg	\N	http://handle.slv.vic.gov.au/10381/50456	public domain	{"Date/s":["c1914���1920"],"Places":["Australia","VIctoria","Burwood"],"Node type":["photograph"],"Keywords":["repatriation","hospital","doll","man","soldiers","aftermath"]}	SLV071	State Library of Victoria	1379145819	f
414	Marum Grass planting. 1st year's growth & showing state of sand hills before planting.	Men planting grass on side and along ridge of hill.	\N	\N	2014-01-08 00:51:28.74323	2014-02-25 21:44:23.561731	4f0c2da1.jpg	Stanley Hotham Chidley	http://handle.slv.vic.gov.au/10381/53730	public domain	{"Date/s":["1899"],"Places":["Australia","Victoria"],"Node type":["photograph"],"Keywords":["grass","planting","hills","men","hats","landscape","sustainability"]}	SLV072	State Library of Victoria	327833793	f
415	Commemoration of the First Parliament of Federated Australia	A painting or drawing depicting the British coat of arms, sailing ships, a kangaroo and emu, and British and Australian flags. Enclosed in vignettes are pictures of Queen Victoria, the Earl of Hopetoun and the Duke of York.	\N	\N	2014-01-08 00:51:35.526227	2014-02-25 21:44:23.570994	f8417af1.jpg	Barnett Freedman	http://handle.slv.vic.gov.au/10381/53784	public domain	{"Date/s":["1900"],"Places":["Australia","Victoria"],"Node type":["drawing"],"Keywords":["Federation","commemoration","royalty","parliament","emu","kangaroo","flags","ship","coat of arms","Britain","Queen Victoria","Earl of Hopetoun","Duke of York","symbols","emblems"]}	SLV073	State Library of Victoria	1982914104	f
416	Universal Household Medicine Paregoric Elixir	Printed notice for The Universal Household Medicine / PAREGORIC elixir / CAUTION / This Preparation contains Opium. It is a Popular and Excellent Pectoral and Anodyne. / DOSE–20 to 60 drops in troublesome Coughs, &c. / Prepared by CHAS. HOOPER & SONS, Chemists and Druggists, London.	\N	\N	2014-01-08 00:51:41.736222	2014-02-25 21:44:23.578842	942e3ffa.jpg	Charles Troedel	http://handle.slv.vic.gov.au/10381/54769	public domain	{"Date/s":["1876"],"Places":["Australia","Victoria"],"Node type":["print"],"Keywords":["elixir","paregoric","opium","medicine","label","health"]}	SLV074	State Library of Victoria	937477826	f
417	Magic Carte de Visite	Carte de visite with circular mirror in centre. Text in purple reads: "Breathe on the glass and you will see much that will astonish and amuse." When breathed upon, the words "I love thee" appear on the glass.	\N	\N	2014-01-08 00:51:48.396032	2014-02-25 21:44:23.586	58647fe3.jpg	\N	http://handle.slv.vic.gov.au/10381/54935	public domain	{"Date/s":["1875"],"Places":["Australia","Victoria"],"Node type":["print"],"Keywords":["magic","carte de visite","breath","window","trick","love","leisure"]}	SLV075	State Library of Victoria	2036399373	f
418	Snowy River scene	A selector's camp in the bush on the Snowy River, with a tent and makeshift kitchen under a large tree. Two men, a horse, a foal and a small dog can be seen.	\N	\N	2014-01-08 00:51:55.635381	2014-02-25 21:44:23.592662	f8cda869.jpg	NJ Caire	http://handle.slv.vic.gov.au/10381/53869	public domain	{"Date/s":["1886"],"Places":["Australia","Victoria","Gippsland","Snowy River"],"Node type":["photograph"],"Keywords":["camp","tent","horse","foal","dog","men","shelter","selection","selector","landscape"]}	SLV077	State Library of Victoria	1949634014	f
419	Aboriginal Australian woman and baby outside shelter	An Aboriginal Australian woman standing outside a shelter made from wood and leaves. She carries a baby in a woolen shawl on her back.	\N	\N	2014-01-08 00:52:02.92378	2014-02-25 21:44:23.59931	e60e3925.jpg	NJ Caire	http://handle.slv.vic.gov.au/10381/53809	public domain	{"Date/s":["1886"],"Places":["Australia","Victoria","Lake Tyers"],"Node type":["photograph"],"Keywords":["Indigenous","woman","baby","shelter","bushland","blanket","carrying","family"]}	SLV078	State Library of Victoria	241523228	f
420	Childers Tram Saw-Mill	Childers Tram Saw-Mill, Gippsland, 1886. Shows a bullock team lined up in in front of wooden shelter, with tall gum tress and wooden huts behind it.	\N	\N	2014-01-08 00:52:12.131164	2014-02-25 21:44:23.607064	30bda220.jpg	NJ Caire	http://handle.slv.vic.gov.au/10381/54057	public domain	{"Date/s":["1886"],"Places":["Australia","Victoria"],"Node type":["photograph"],"Keywords":["sawmill","bushland","bullock","timber","mill","shelter","huts","industry"]}	SLV079	State Library of Victoria	430299511	f
421	Whaling in Twofold Bay	Stererograph showing a dead whale near the shore with a group of men cutting it open.	\N	\N	2014-01-08 00:52:19.632444	2014-02-25 21:44:23.614439	b0a816b3.jpg	Charles Walter	http://handle.slv.vic.gov.au/10381/53917	public domain	{"Date/s":["1870"],"Places":["Australia","New South Wales","Twofold Bay"],"Node type":["photograph"],"Keywords":["whale","dead","whaling","men","cutting","animals","industry"]}	SLV080	State Library of Victoria	1063065724	f
422	Horse-riders	A painting entitled "Diana Vernon and Francis Osbaldeston." Shows upper class man and woman on horseback, wearing riding attire. They have stopped on country road and woman points to something off the track.	\N	\N	2014-01-08 00:52:25.7255	2014-02-25 21:44:23.632119	9349a44d.jpg	JM Nelson	http://handle.slv.vic.gov.au/10381/55111	public domain	{"Date/s":["1877"],"Places":["Australia","Victoria"],"Node type":["painting","photograph"],"Keywords":["horses","horseriding","gentry","road","Diana Vernon","Francis Osbaldeston","animals"]}	SLV081	State Library of Victoria	2104261457	f
423	Howard's hut	A wooden bush hut with a man with beard seated, and reading a paper document. Shows various items such as a saw, billy and frying pan, and "Howard" is painted above doorway.	\N	\N	2014-01-08 00:52:33.41526	2014-02-25 21:44:23.644304	a89a2090.jpg	NJ Caire	http://handle.slv.vic.gov.au/10381/54198	public domain	{"Date/s":["1891"],"Places":["Australia","Victoria","Fernshaw"],"Node type":["photograph"],"Keywords":["hut","man","reading","shelter","billy","frying pan","bushland","landscape"]}	SLV082	State Library of Victoria	1871809408	f
424	Miss. Kellerman	Collage of portrait photographs of Annette Kellerman in bathing costumes, diver, long distance swimmer, and entertainer. She took up swimming to strengthen her legs after having developed rickets as a child and became famous in Australia and internationally for swimming feats as well as performing.	\N	\N	2014-01-08 00:52:40.543237	2014-02-25 21:44:23.651434	80b7c68c.jpg	Sears Studies	http://handle.slv.vic.gov.au/10381/54279	public domain	{"Date/s":["1906"],"Places":["Australia","Victoria"],"Node type":["photograph"],"Keywords":["Annette Kellerman","swimming","diving","swimmers","collage","costume","sports","women"]}	SLV083	State Library of Victoria	1586117589	f
425	Aboriginal Australians at Lake Tyers	Group portrait photograph of Aboriginal Australians in European dress at Lake Tyers, 1886. Taken outdoors, picture shows women, children, and some men seated, with other men and a boy standing behind them. Man standing far left holds a pole in right hand and a child in the other arm.	\N	\N	2014-01-08 00:52:47.331678	2014-02-25 21:44:23.658547	1d07e8c3.jpg	NJ Caire	http://handle.slv.vic.gov.au/10381/54071	public domain	{"Date/s":["1886"],"Places":["Australia","Victoria","Lake Tyers"],"Node type":["photograph"],"Keywords":["Indigenous","men","women","children","shelter","spear","family"]}	SLV084	State Library of Victoria	600376375	f
427	View of Fukushima	Stereograph, elevated view, of Fukushima, a large town extending along both banks of the Kisa-gawa. Rugged forest can be seen in distance, and a bridge over river in foreground.	\N	\N	2014-01-08 00:53:00.808996	2014-02-25 21:44:23.673045	295a7e4b.jpg	George Rose	http://handle.slv.vic.gov.au/10381/54053	public domain	{"Date/s":["1905"],"Places":["Australia","Japan","Fukushima"],"Node type":["photograph"],"Keywords":["Fukushima","river","forest","houses","banks","bridge","town","landscape","urban"]}	SLV086	State Library of Victoria	648731192	f
428	John W Parsons on a bicycle	A man dressed in white athletic clothing riding a bicycle. The inscription on the mount reads: Jack Parsons, cyclist.	\N	\N	2014-01-08 00:53:07.82365	2014-02-25 21:44:23.688388	f864b51d.jpg	\N	http://handle.slv.vic.gov.au/10381/52887	public domain	{"Date/s":["1895"],"Places":["Australia","Victoria"],"Node type":["photograph"]}	SLV087	State Library of Victoria	1682647892	f
429	Eucalyptus oil	Printed in green ink on white paper, trademark two branches of wattle with parrot sitting centre, title above trademark, list of prize medals awarded on left of trademark, a note on the right, "This is the genuine eucalyptus oil as distilled by J Bosisto & Co's patent process, and all bearing the signature and trademarks of our firm may be relied on." Below the trademark is printed "Introduced, patented and steam distilled by J Bosisto & Co, manufacturing chemists & distillers of essential oils from Australian vegetation, Richmond - Melbourne, wholesale agents - Messrs. Felton, Grimwade & Co, Melbourne."	\N	\N	2014-01-08 00:53:16.266157	2014-02-25 21:44:23.698111	273c0d63.jpg	\N	http://handle.slv.vic.gov.au/10381/56300	public domain	{"Date/s":["1871"],"Places":["Australia"],"Node type":["print",""],"Keywords":["eucalyptus","oil","J Bosisto","Felton Grimwade \\u0026 Co"]}	SLV088	State Library of Victoria	1717445184	f
430	Wool barge "Nelson" on the River Murray	Shows a barge laden with bales of wool on the Murray River. Two men sit at the bow and another vessel is tied alongside. Trees grow along the banks in the background.	\N	\N	2014-01-08 00:53:23.934269	2014-02-25 21:44:23.706809	75018e03.jpg	Thomas Cleary	http://handle.slv.vic.gov.au/10381/53111	public domain	{"Date/s":["1893"],"Places":["Australia","Victoria","Murray River"],"Node type":["photograph"],"Keywords":["wool","barge","river","rope","water","transport","industry"]}	SLV089	State Library of Victoria	221119625	f
431	Market women resting in a wayside teahouse	Stereograph of six women seated at a teahouse in Nikko. Photographer notes that after they have delivered their produce, they ride home on their horses.	\N	\N	2014-01-08 00:53:29.814271	2014-02-25 21:44:23.714101	4804a320.jpg	George Rose	http://handle.slv.vic.gov.au/10381/53942	public domain	{"Date/s":["1905"],"Places":["Australia","Nikko","Japan"],"Node type":["photograph"],"Keywords":["women","market","tea","rest","horseriding","stereograph"]}	SLV090	State Library of Victoria	799022959	f
432	Design for alphabet	Photograph of a printing design for letters of the English alphabet.	\N	\N	2014-01-08 00:53:35.412211	2014-02-25 21:44:23.721031	71679823.jpg	Joseph Laughton	http://handle.slv.vic.gov.au/10381/53799	public domain	{"Date/s":["1901"],"Places":["Australia","","Victoria"],"Node type":["print"],"Keywords":["letters","alphabet","typography","writing","text"]}	SLV091	State Library of Victoria	390834764	f
433	Bush hut	A man sits reading outside a bush hut surrounded by trees and ferns.	\N	\N	2014-01-08 00:53:50.425545	2014-02-25 21:44:23.727416	7c6844c3.jpg	NJ Caire	http://handle.slv.vic.gov.au/10381/54042	public domain	{"Date/s":["1893"],"Places":["Australia","Victoria"],"Node type":["photograph"],"Keywords":["man","hut","reading","ferns","bushland","landscape","vegetation"]}	SLV092	State Library of Victoria	1486073658	f
434	Main entrance to the City of Seoul,	Stereograph, elevated view, of the main entrance to Seoul. Shows stone wall and houses next to narrow street, with two-tiered building and brick wall with arch. Mountains can be seen in the distance. Photographer notes: "Seoul has numerous gates, each having a pagoda varying in architecture according to its importance."	\N	\N	2014-01-08 00:53:57.718298	2014-02-25 21:44:23.735086	756c5fd2.jpg	George Rose	http://handle.slv.vic.gov.au/10381/53689	public domain	{"Date/s":["1905"],"Places":["Korea","Seoul","Australia","Victoria"],"Node type":["photograph"],"Keywords":["Seoul","Korea","gates","city","roof","wall","mountains","Asia","stereograph","urban"]}	SLV093	State Library of Victoria	2037903842	f
435	The Commonwealth picture	Lieutenant Colonel Cameron sitting for the artist, Tom Roberts. Shows Roberts' large painting entitled 'Opening of the Commonwealth Parliament', to his left. The Artist sits on a stool and smokes a pipe, with Cameron seated in front of drapes and canvases, to his right.	\N	\N	2014-01-08 00:54:04.392453	2014-02-25 21:44:23.74197	0fb4bdb4.jpg	Tom Roberts	http://handle.slv.vic.gov.au/10381/53667	public domain	{"Date/s":["1902"],"Places":["Australia","Victoria"],"Node type":["photograph"],"Keywords":["parliament","painting","painter","artwork","Tom Roberts","artists"]}	SLV094	State Library of Victoria	522977465	f
436	A group of officers	Four officers in uniform, three seated, one standing, outside a tent pitched in a square or vacant block. Brick buildings can be seen in distance.	\N	\N	2014-01-08 00:54:10.496091	2014-02-25 21:44:23.751702	e9220fc0.jpg	Robert William Harvie	http://handle.slv.vic.gov.au/10381/53950	public domain	{"Date/s":["1899"],"Places":["Australia"],"Node type":["photograph"],"Keywords":["officers","tent","seated"]}	SLV095	State Library of Victoria	1599649124	f
438	Group of police with Joe Byrne's horse	Shows a number of men, including one Indigenous man, standing with a horse. Joe Byrne was a member of the Kelly Gang and died in the final confrontation with the police.	\N	\N	2014-01-08 00:54:22.328833	2014-02-25 21:44:23.767884	68ce50de.jpg	John Brae	http://handle.slv.vic.gov.au/10381/53131	public domain	{"Date/s":["1880"],"Places":["Australia","Victoria"],"Node type":["photograph"],"Keywords":["horse","police","guns","Indigenous","men","Ned Kelly","gang","Joe Byrne","bushrangers"]}	SLV097	State Library of Victoria	925140088	f
471	Shipwreck on a rocky shore	Painting of a coastal shipwreck in a storm. Survivors are recovering on shore.	\N	\N	2014-01-08 01:03:12.073773	2014-02-25 21:44:23.995243	405201be.jpg	Wijnand Nuijen	http://hdl.handle.net/10934/RM0001.COLLECT.4867	public domain	{"Date/s":["1837"],"Places":["Netherlands"],"Node type":["painting"],"Keywords":["shipwreck","cliffs","survivors","storm","journey","travel","coast","marine"]}	RKM003	Rijksmuseum	1373270973	f
439	Bulmer's Old Crossing place and Campbell's Cove,	A lake surrounded by bush, and a man standing on bank with a stick in his left hand at Bulmer's Old Crossing place.	\N	\N	2014-01-08 00:54:29.398657	2014-02-25 21:44:23.774801	14cc5997.jpg	NJ Caire	http://handle.slv.vic.gov.au/10381/54148	public domain	{"Date/s":["1886"],"Places":["Australia","Victoria","Lake Tyers"],"Node type":["photograph"],"Keywords":["lake","crossing","rowboat","forest","bushland","trees","water","landscape"]}	SLV098	State Library of Victoria	1935180308	f
440	Come out! Come out and fight	Shows British and Australian flags crossed over an anchor, a bulldog inside a circle. A verse printed beneath image.	\N	3	2014-01-08 00:54:36.64529	2014-02-25 21:44:23.781176	aca99dad.jpg	\N	http://handle.slv.vic.gov.au/10381/16539	public domain	{"Date/s":["c1914���1918"],"Places":["Australia","Victoria"],"Node type":["print"],"Keywords":["fight","encouragement","war","propaganda"]}	SLV099	State Library of Victoria	423771218	t
442	Caravan accident	Caravan being pulled up an embankment by a truck on a country road, line of cars behind held up by accident.	\N	\N	2014-01-08 00:54:51.850369	2014-02-25 21:44:23.794672	51c406ca.jpg	Ursula Powys-Lybbe	http://handle.slv.vic.gov.au/10381/159575	public domain	{"Date/s":["1947"],"Places":["Australia","New South Wales","Peats Ferry"],"Node type":["photograph"],"Keywords":["caravan","accident","winch","cars","road","travel","leisure"]}	SLV101	State Library of Victoria	342645004	f
443	Mick Mangos in Perth with a friend before he went to Kalgoorlie which he had to leave after the race riots 1916	Two men in suits, one seated in a wicker chair, the other standing with his hand on the shoulder of the first man.	\N	\N	2014-01-08 00:54:59.058659	2014-02-25 21:44:23.801429	7b0e5f10.jpg	\N	http://handle.slv.vic.gov.au/10381/111651	public domain	{"Date/s":["1916"],"Places":["Australia","Western Australia","Perth","Kalgoorlie","Greece"],"Node type":["photograph"],"Keywords":["friend","Kalgoorlie","race","riot","Mick Mangos","Greek","community","conflict"]}	SLV102	State Library of Victoria	1978282785	f
444	Ship Lindfield	Large ship "Lindfield" in calm waters	\N	\N	2014-01-08 00:55:06.273937	2014-02-25 21:44:23.807055	4ab60f95.jpg	\N	http://handle.slv.vic.gov.au/10381/53288	public domain	{"Date/s":["1896"],"Places":["Australia","Victoria"],"Node type":["photograph"],"Keywords":["ship"]}	SLV103	State Library of Victoria	329512019	f
445	Miss Victoria's love puzzle	Picture puzzle of a lady standing beside a tree and containing hidden images. Text below reads: A native scene, the accepted, the rejected, find the three.	\N	\N	2014-01-08 00:55:12.821587	2014-02-25 21:44:23.814314	4ffd22ae.jpg	William Short, Charles Grey Bird	http://handle.slv.vic.gov.au/10381/52839	public domain	{"Date/s":["1878"],"Places":["Australia","Victoria"],"Node type":["print"],"Keywords":["puzzle","engraving"]}	SLV104	State Library of Victoria	700155758	f
446	Virginia	Advertisement for tobacco products depicting a native girl in a tropical setting sitting in a hammock	\N	\N	2014-01-08 00:55:21.164727	2014-02-25 21:44:23.823625	1d594e05.jpg	Fergusson & Mitchell lithographers, Heinecke & Fox	http://handle.slv.vic.gov.au/10381/53166	public domain	{"Date/s":["1882"],"Places":["Australia","Victoria"],"Node type":["print"],"Keywords":["cigarettes","advertising","tobacco","hammock","smoking","lithograph"]}	SLV105	State Library of Victoria	228329670	f
447	Wool steamer and barges, Echuca Wharf on the River Murray	Steam ship "Rodney" and two barges loaded with bales of wool. They are tied to a wharf and more vessels can be seen in the background. 	\N	\N	2014-01-08 00:55:27.715616	2014-02-25 21:44:23.830266	32946f48.jpg	Thomas Cleary	http://handle.slv.vic.gov.au/10381/53261	public domain	{"Date/s":["1893"],"Places":["Australia","Victoria","Murray River","Echuca"],"Node type":["photograph"],"Keywords":["wool","barges","river","winch","Echuca","wharf"]}	SLV106	State Library of Victoria	2031096963	f
448	A new game of Quartettes, Uncle Tom's Cabin, or an hour with the slaves in America	Appears to be an advertisement for a card game based on the novel "Uncle Tom's Cabin", by Harriet Beecher Stowe. Has an illustration in the centre of a black man sitting on a bench with a white child and a black child.	\N	\N	2014-01-08 00:55:34.762232	2014-02-25 21:44:23.836898	2341c4b3.jpg	HG de Gruchy & Co	http://handle.slv.vic.gov.au/10381/53337	public domain	{"Date/s":["1878"],"Places":["Australia","Victoria","Melbourne","United States of America"],"Node type":["print"],"Keywords":["lithograph","game","cards","slavery","novel"]}	SLV107	State Library of Victoria	1483417139	f
449	American Fleet in Australia	A stern view of the splendid U.S. battleship Kansas	\N	\N	2014-01-08 00:55:41.445014	2014-02-25 21:44:23.842672	8619e155.jpg	George Rose	http://handle.slv.vic.gov.au/10381/53567	public domain	{"Date/s":["1908"],"Places":["United States of America","Australia","Victoria","Melbourne"],"Node type":["photograph"],"Keywords":["fleet","navy","warship","stereograph","war"]}	SLV108	State Library of Victoria	1146971450	f
450	"Killing day" out bush	Shows several men hoisting two carcasses up a tree in the bush. A cart and several termite mounds are also in the frame.	\N	\N	2014-01-08 00:55:48.287461	2014-02-25 21:44:23.848753	644861a9.jpg	\N	http://handle.slv.vic.gov.au/10381/24659	public domain	{"Date/s":["c1890���1900"],"Places":["Australia","Victoria"],"Node type":["photograph"],"Keywords":["slaughter","killing","death","animals","cattle","men","landscape","termites","cart"]}	SLV109	State Library of Victoria	393900905	f
451	Looking out of Thunder Cave, Port Campbell	Rock formations, coastal cliffs, ocean	\N	\N	2014-01-08 00:55:54.896233	2014-02-25 21:44:23.855681	957df55b.jpg	Rose Stereograph Co	http://handle.slv.vic.gov.au/10381/60156	public domain	{"Date/s":["c1920���1954"],"Places":["Australia","Victoria","Port Campbell"],"Node type":["photograph"],"Keywords":["cave","lookout","view","cliffs","water","rocks","landscape","natural features","water","coast","marine"]}	SLV110	State Library of Victoria	1073296749	f
452	Soldier at Hethersett Private Repatriation Hospital,	Soldier outdoors in a wheelchair holding a cane.	\N	\N	2014-01-08 00:56:00.995107	2014-02-25 21:44:23.862558	3448eb33.jpg	\N	http://handle.slv.vic.gov.au/10381/50479	public domain	{"Date/s":["c1914���1920"],"Places":["Australia","VIctoria","Burwood"],"Node type":["photograph"],"Keywords":["soldier","recovery","blanket","hospital","repatriation","aftermath"]}	SLV111	State Library of Victoria	2087423904	f
453	Confectionery packaging line - MacRobertson Chocolate factory	Overhead view of women seated at tables packing chocolates, men standing at trolleys in background	\N	\N	2014-01-08 00:56:07.968676	2014-02-25 21:44:23.868635	5a616baa.jpg	\N	http://handle.slv.vic.gov.au/10381/32350	public domain	{"Date/s":["c1910���1940"],"Places":["Australia","Victoria","Fitzroy"],"Node type":["photograph"],"Keywords":["chocolate","factory","production","packaging","industrial revolution"]}	SLV112	State Library of Victoria	879376747	f
454	Family group sitting on wooden bench on verandah	Four women, one man and four children seated on and standing around a bench under a covered, tiled verandah	\N	\N	2014-01-08 00:56:15.766807	2014-02-25 21:44:23.875648	c173c733.jpg	\N	http://handle.slv.vic.gov.au/10381/16297	public domain	{"Date/s":["c1890���1910"],"Places":["Australia","Victoria"],"Node type":["photograph"],"Keywords":["family","verandah","bench","children","women","men","Mary Lloyd Anderson","Lloyd Tayler"]}	SLV113	State Library of Victoria	182742063	f
456	Dugout canoe, drum net, cod fish	Man standing in a dugout canoe holding a fish	\N	\N	2014-01-08 00:56:31.110551	2014-02-25 21:44:23.889605	1141a6ee.jpg	Arthur Herbert Evelyn Mattingley	http://handle.slv.vic.gov.au/10381/42250	public domain	{"Date/s":["c1934���1935"],"Places":["Australia","Victoria","Riverina","Edwards River","Riverina"],"Node type":["photograph"],"Keywords":["canoe","fish","water","trees","landscape","food"]}	SLV115	State Library of Victoria	795586928	f
457	Farm house and out buildings beside a river with mountains in background	Shows small farm house on edge of river possibly in Tasmania, mountain in background possibly Mt. Wellington.	\N	\N	2014-01-08 00:56:39.022769	2014-02-25 21:44:23.900425	dbbabec0.jpg	Alexander Sutherland	http://handle.slv.vic.gov.au/10381/52702	public domain	{"Date/s":["c1870���1880"],"Places":["Australia","Tasmania","Victoria"],"Node type":["painting"],"Keywords":["painting","farmhouse","mountains","fence","landscape","watecolour","art"]}	SLV116	State Library of Victoria	148498706	f
458	The olive green & primrose	Jockey riding galloping horse on racetrack, crowd sketched in in background. Verse beneath title: Here's a health to every sportsman / be he stableman or lord / If his heart be true I care not what his pocket may afford / and may he ever pleasantly each gallant sport pursue / if he takes his liquor fairly, and his fences fairly too. 	\N	\N	2014-01-08 00:56:45.528376	2014-02-25 21:44:23.906639	56d4ed25.jpg	RG Carew	http://handle.slv.vic.gov.au/10381/72251	public domain	{"Date/s":["1892"],"Places":["Australia","Victoria"],"Node type":["drawing","ink"],"Keywords":["olive","green","primrose","horse","sketch","sports","animals","racing"]}	SLV117	State Library of Victoria	1565483140	f
459	At Millers Point	Shows view down Ferry Lane to Pottinger Street, The Rocks, Sydney, ships at anchor in distance. Ferry Lane was the site of the first case of plague in 1900.	\N	\N	2014-01-08 00:56:51.904053	2014-02-25 21:44:23.912688	7138c163.jpg	John Henry Harvey	http://handle.slv.vic.gov.au/10381/46472	public domain	{"Date/s":["1936"],"Places":["Australia","New South Wales","Sydney","MIllers Point"],"Node type":["photograph"],"Keywords":["street","Sydney","urban","landscape","plague"]}	SLV118	State Library of Victoria	545551722	f
460	Woman with a baby sitting on a cushion	Shows a women, sitting on a chair, leaning forward with hands holding a baby seated on a cushion.	\N	\N	2014-01-08 00:56:57.277487	2014-02-25 21:44:23.919519	70304302.jpg	Charles Edward Boyles	http://handle.slv.vic.gov.au/10381/16983	public domain	{"Date/s":["c1930���1950"],"Places":["Australia","Victoria"],"Node type":["photograph"],"Keywords":["woman","baby","cushion","family","chair"]}	SLV119	State Library of Victoria	1800845618	f
461	Pet rabbits	Three girls sitting and boy kneeling on ground holding food out to one of two white rabbits, mother entering house on left, rabbit hutch on right.	\N	\N	2014-01-08 00:57:03.127615	2014-02-25 21:44:23.927688	0701e798.jpg	Le Blond & Co, Elizabeth Severne	http://handle.slv.vic.gov.au/10381/55881	public domain	{"Date/s":["c1857���1870"],"Places":["England","Australia","Victoria"],"Node type":["print"],"Keywords":["rabbits","pets. maid","chimney","cottage","animals"]}	SLV120	State Library of Victoria	1994803663	f
462	King’s Chamber – Buchan Caves	Printed on stereograph mount: The Walden Stereograph / Buchan Cave Series	\N	\N	2014-01-08 00:57:09.632447	2014-02-25 21:44:23.934863	ebe62fae.jpg	JHA MacDougall	http://handle.slv.vic.gov.au/10381/53497	public domain	{"Date/s":["c1909"],"Places":["Australia","Victoria","Gippsland","Buchan Caves"],"Node type":["photograph"],"Keywords":["cave","cavern","chamber","stalactites","stalagmites","natural features","landscape"]}	SLV121	State Library of Victoria	1644081886	f
463	Mysteries – Buchan Caves	Printed on stereograph mount: The Walden Stereograph / Buchan Cave Series	\N	\N	2014-01-08 00:57:16.097462	2014-02-25 21:44:23.943892	33d36879.jpg	JHA MacDougall	http://handle.slv.vic.gov.au/10381/53461	public domain	{"Date/s":["c1909"],"Places":["Australia","Victoria","Gippsland","Buchan Caves"],"Node type":["photograph"],"Keywords":["stalacmites","cave","weird","natural features","landscape"]}	SLV122	State Library of Victoria	981908719	f
464	Sawmiller at home	Man seated outside a makeshift home with a cat on his lap. Various homely accoutrements surround him, such as a tray of fruit, a fish, a saddle, a wheelbarrow. 	\N	\N	2014-01-08 00:57:22.365991	2014-02-25 21:44:23.949771	28da7aca.jpg	NJ Caire	http://handle.slv.vic.gov.au/10381/54057	public domain	{"Date/s":["1886"],"Places":["Australia","Victoria","Gippsland"],"Node type":["photograph"],"Keywords":["cat","peaches","washboard","fish","saw","saddle","shelter","bark hut","man","pipe","fence","bushland","wheelbarrow","barrel","axe","tools","miller","industry","home"]}	SLV123	State Library of Victoria	1209879784	f
465	Cape Otway lighthouse	Lighthouse on a hill overlooking the ocean	\N	\N	2014-01-08 00:57:28.699985	2014-02-25 21:44:23.955509	f40020f1.jpg	\N	http://handle.slv.vic.gov.au/10381/107139	public domain	{"Date/s":["1985"],"Places":["Australia","Victoria","Cape Otway"],"Node type":["photograph"],"Keywords":["cape otway","lighthouse","hill"]}	SLV124	State Library of Victoria	1903332888	f
466	The librarian	Painting of a librarian where each feature is composed of books and other material related to the librarian’s profession.	\N	\N	2014-01-08 01:01:51.755497	2014-02-25 21:44:23.961754	b5bdec4d.jpg	Giuseppe Arcimboldo	https://en.wikipedia.org/wiki/The_Librarian_(painting)	public domain	{"Date/s":["c1570"],"Places":["Sweden","Vienna"],"Node type":["painting"],"Keywords":["books","librarian","curtain","figure","portrait","art"]}	WMC1	Wikimedia Commons, Skokloster Castle	194732315	f
467	The thinker	Photograph of a sculpture of a muscular, nude man seated, chin resting in one hand	\N	\N	2014-01-08 01:02:03.376789	2014-02-25 21:44:23.968042	2988a146.jpg	Auguste Rodin, Hansjorn	http://commons.wikimedia.org/wiki/File:Auguste_Rodin_-_Grubleren_2005-02.jpg	public domain	{"Date/s":["1904"],"Places":["France"],"Node type":["sculpture","photograph","bronze"],"Keywords":["man","sitting","thinking","thought","pensive","bronze","art"]}	WMC2	Wikimedia Commons	1275504734	f
468	Emperor Rudolf II as Vertumnus, the Roman god of the seasons, growth, plants and fruit.	Painting of a bearded man’s head and shoulders where all the features are composed of fruit and vegetables	\N	\N	2014-01-08 01:02:14.42337	2014-02-25 21:44:23.974365	d49aef75.jpg	Giuseppe Arcimboldo	https://commons.wikimedia.org/wiki/File:Portr%C3%A4tt,_Rudolf_II_som_Vertumnus._Guiseppe_Arcimboldo_-_Skoklosters_slott_-_87582.tif	public domain	{"Date/s":["1590"],"Places":["Sweden","Prague","Milan"],"Node type":["painting"],"Keywords":["fruit","vegetables","food","art"]}	WMC3	Wikimedia Commons, Skokloster Castle	1624647342	f
469	Emu	Drawing of an emu, attributed to George Raper. Part of RJ Gordon's collection of images of African birds.	\N	\N	2014-01-08 01:02:58.617562	2014-02-25 21:44:23.980659	1f551fb7.jpg	George Raper	http://hdl.handle.net/10934/RM0001.COLLECT.436499	public domain	{"Date/s":["c1770-1780"],"Places":["New Holland","Australia","New South Wales"],"Node type":["ink","watercolour","paper"],"Keywords":["emu","illustration","animals","wildlife","perception","George Raper","RJ Gordon"]}	RKM001	Rijksmuseum	1567001165	f
470	Map of southern lands	The first map to depict the continent of Australia.	\N	\N	2014-01-08 01:03:05.29142	2014-02-25 21:44:23.987312	dc338e75.jpg	Willem Janszoon	http://hdl.handle.net/10934/RM0001.COLLECT.295154	public domain	{"Date/s":["1635"],"Places":["Netherlands","India","Sri Lanka","Southeast Asia","Indonesia","Papua New Guinea","Borneo","Australia"],"Node type":["map"],"Keywords":["Willem Janszoon","Australia","discovery","exploration","maps","southern land","continents","Dutch"]}	RKM002	Rijksmuseum	180114038	f
472	William Dampier near Aceh, Indonesia	Drawing of a small sailing boat on a large wave and in strong wind. Eight people are on board; one is bailing water out with a bucket.	\N	\N	2014-01-08 01:03:18.695262	2014-02-25 21:44:24.006393	51da1c43.jpg	Caspar Luyken	http://hdl.handle.net/10934/RM0001.COLLECT.144326	public domain	{"Date/s":["1896"],"Places":["Netherlands","Aceh","Indonesia"],"Node type":["paper","engraving"],"Keywords":["William Dampier","ship","journey","travel"]}	RKM004	Rijksmuseum	1686720483	f
473	Queensland Aboriginals at the Crystal Palace	A man, woman and child dressed in non-traditional animal skins, shell necklaces, pose for a studio photograph. The man has a bone through his nose and holds boomerangs. All three look fiercely unhappy.	\N	\N	2014-01-08 01:03:26.179968	2014-02-25 21:44:24.013324	21b67bd9.jpg	\N	http://hdl.handle.net/10934/RM0001.COLLECT.64490	public domain	{"Date/s":["c1870-1880"],"Places":["London","England","Australia","Queensland"],"Node type":["photograph"],"Keywords":["Aboriginals","Crystal Palace","capture","removal","exhibition","contact","British Empire","colonies"]}	RKM005	Rijksmuseum	468224476	f
474	Captain Cook lands in New Holland (Australia)	A print of a clash between five Eurpoean men with two guns and a sword, and two Aboriginal men with a spear and a shield. One man fires a gun over the head of another man who has a spear pointed at the chest of the first man. A third man holds the spearwielding man by the hair. Another man holds a sword to the spear-wielder's back. The other Aboriginal man is crouched in the foreground looking away from the action at what could be a mirror.	\N	\N	2014-01-08 01:03:32.747699	2014-02-25 21:44:24.020305	a74e6531.jpg	Antonius Claessens, Jacques Kuyper	http://hdl.handle.net/10934/RM0001.collect.95827	public domain	{"Date/s":["1803"],"Places":["Amsterdam","Netherlands","New Holland"],"Node type":["etching","illustration"],"Keywords":["Captain Cook","landing","New Holland","Indigenous","contact","frontier conflict","colonies","British Empire",""]}	RKM006	Rijksmuseum	2144338303	f
475	Teapot	Teapot on foot ring. Flattened, round body with low edge and flat lid with knob. Straight spout and curled handle. Decorated in underglaze blue with leaf-shaped fields that depend on the shoulders and rise of the foot, filled with flower tendrils against a blue background are saved. Between these fields some blossoms. Marked on the bottom with the character 'yu', without the circle.	\N	\N	2014-01-08 01:03:39.907036	2014-02-25 21:44:24.026604	8cb8ec25.jpg	\N	http://hdl.handle.net/10934/RM0001.COLLECT.24623	public domain	{"Date/s":["c1700-1720"],"Places":["China"],"Node type":["object","porcelain","enamel"],"Keywords":["tea","teapot","food","trade","yu"]}	RKM007	Rijksmuseum	1231841624	f
476	Yulan Kwanyin, the Goddess of Love and Charity	Yulan Kwanyin, the Goddess of Love and Charity with a basket containing a carp. In the air: Wei-to, the guard-guard of the Kugu-Uin temples.	\N	\N	2014-01-08 01:03:46.158947	2014-02-25 21:44:24.032778	87a9f109.jpg	\N	http://hdl.handle.net/10934/RM0001.COLLECT.411673	public domain	{"Date/s":["c1600-1699"],"Places":["China"],"Node type":["woodcut","print",""],"Keywords":["gods","goddess","fish","animals","carp",""]}	RKM008	Rijksmuseum	1618285227	f
477	Three Dutch merchants in a dinghy	Ivory plaque with a representation of three men loading goods into a boat. The left figure has both hands raised in a gesture of caution reminding toward the middle figure. It has a large vase in hand. The right figure lifts a bag of soil. The edges of the boat are red and blue.	\N	\N	2014-01-08 01:03:53.084514	2014-02-25 21:44:24.038726	d33ef49e.jpg	\N	http://hdl.handle.net/10934/RM0001.COLLECT.312636	public domain	{"Date/s":["c1725-1750"],"Places":["China","Netherlands"],"Node type":["ivory","plaque","object",""],"Keywords":["merchants","trade","boat","goods","load"]}	RKM009	Rijksmuseum	740988133	f
478	Two Chinese prisoners with their heads in wooden boards	Two men seated, leaning against a wall, with their wrists cuffed together (?) and their heads locked into a wooden board. Around three edges of each board is paper with Chinese writing on it.	\N	\N	2014-01-08 01:04:00.053825	2014-02-25 21:44:24.047455	10986689.jpg	Baron Raimund von Stillfried und Ratenitz	http://hdl.handle.net/10934/RM0001.COLLECT.349832	public domain	{"Date/s":["c1850-1880"],"Places":["China"],"Node type":["photograph"],"Keywords":["prisoners","men","boards","stocks","convicts"]}	RKM010	Rijksmuseum	1809674387	f
479	Cannon	Lewuke, the disawa (district chief) of the Four Korales, presented this costly cannon to the King of Kandy in 1745. The cannon displays the king’s symbols: a sun, a half moon and a Sinhalese lion. Salutes were fired from it to welcome visitors. The Dutch took it as booty during the military campaign in 1765.	\N	\N	2014-01-08 01:04:07.474167	2014-02-25 21:44:24.056017	20d30b7f.jpg	\N	http://hdl.handle.net/10934/RM0001.COLLECT.201394	public domain	{"Date/s":["pre-1745"],"Places":["Sri Lanka","Ceylon","Netherlands"],"Node type":["object","gold","silver"],"Keywords":["cannon","gift","lion","sun","moon","Sinhalese","symbols"]}	RKM011	Rijksmuseum	1116134858	f
480	Cup with an abolitionist scene	Slavery in Dutch colonies was abolished only in 1863. In areas under British rule, this had taken place in 1833. One abolitionist in England was the well-known porcelain manufacturer Josiah Wedgwood. A design by him served as the model for the decoration of this cup and saucer, made at his ceramics factory, Etruria Works. It was probably commissioned by an anti-slavery committee of Dutch women.	\N	\N	2014-01-08 01:04:14.386326	2014-02-25 21:44:24.064423	86609c0d.jpg	Etruria Works	http://hdl.handle.net/10934/RM0001.COLLECT.316164	public domain	{"Date/s":["c1853-1863"],"Places":["England","Netherlands"],"Node type":["object","porcelain"],"Keywords":["cup","slavery","abolition","Surinam","Dutch"]}	RKM012	Rijksmuseum	635837906	f
481	Railway Bridge over the Lek	Schönscheidt had already photographed the new railway bridge over the Rhine in Cologne, when he was asked to photograph the railway bridge over the River Lek at Kuilenburg. Spanning 150 metres, it was then the longest railway bridge in Europe. It had just been completed in 1868, when this photograph was taken. The cropping, which heightens the perspectival effect of the steel girders, is surprisingly modern.	\N	\N	2014-01-08 01:04:21.13373	2014-02-25 21:44:24.071368	6d4c5b4e.jpg	Johann Heinrich Schönscheidt	http://hdl.handle.net/10934/RM0001.COLLECT.312322	public domain	{"Date/s":["30/08/1868"],"Places":["Kuilenburg","Culemborg","Netherlands"],"Node type":["photograph"],"Keywords":["bridge","rail","travel","industrial revolution","transport"]}	RKM013	Rijksmuseum	1141081202	f
482	Prayer nut	During the Middle Ages, prayer nuts were luxury ‘toys’ for the faithful. This one was made for a wealthy Delft citizen. Kept in a copper case inside a red velvet pouch suspended from the owner’s belt, it could be opened whenever he wished to contemplate Christ’s suffering. Depicted inside are scenes of Christ Carrying the Cross and The Crucifixion.	\N	\N	2014-01-08 01:04:27.64869	2014-02-25 21:44:24.081207	0c786366.jpg	Adam Theodrici	http://hdl.handle.net/10934/RM0001.COLLECT.24407	public domain	{"Date/s":["c1500-1525"],"Places":["Delft","Netherlands"],"Node type":["object","wood",""],"Keywords":["middle ages","medieval","prayer","carving","nut","case","Christ","Christianity","cross","crucifixion"]}	RKM014	Rijksmuseum	383185623	f
497	Greek slave	Photograph of a marble sculpture of a woman standing, leaning against a post. Her wrists are cuffed and a chain hangs between them.	\N	\N	2014-01-08 01:06:14.000187	2014-02-25 21:44:24.186764	4309472a.jpg	\N	http://hdl.handle.net/10934/RM0001.COLLECT.276571	public domain	{"Date/s":["1851"],"Places":["Greece","London","England"],"Node type":["photograph","statue","sculpture","marble"],"Keywords":["women","slaves","slavery","sculpture","chains"]}	RKM029	Rijksmuseum	224009797	f
483	The Crucifixion	For his depiction of Golgotha, the mountain on which Christ was crucified, the artist chose a high viewpoint. In doing so, he created a vast landscape in which to represent successive episodes of the Passion of Christ simultaneously. This narrative convention was often used in medieval painting.	\N	\N	2014-01-08 01:04:34.606635	2014-02-25 21:44:24.090506	5baf7abf.jpg	Jacob Cornelisz. van Oostsanen	http://hdl.handle.net/10934/RM0001.collect.8173	public domain	{"Date/s":["c1507-1510"],"Places":["Amsterdam","Netherlands"],"Node type":["painting"],"Keywords":["middle ages","medieval","christianity","jesus","crucifixion","cross","mountains","angels"]}	RKM015	RIjksmuseum	913550372	f
484	The Virgin and child with four holy virgins	This painting is an ode to chastity. The Virgin sits in an enclosed garden, a symbol of virginity, surrounded by four other virgins (‘virgo inter virgines’). From attributes on their necklaces, they are identifiable as Saint Catherine with a wheel and sword, Saint Cecilia with an organ, Saint Barbara with a tower and Saint Ursula with a heart and arrow.	\N	\N	2014-01-08 01:04:42.535195	2014-02-25 21:44:24.097291	ae44a0d5.jpg	Master of the Virgo inter Virgines	http://hdl.handle.net/10934/RM0001.COLLECT.9034	public domain	{"Date/s":["c1495-1500"],"Places":["Delft","Netherlands"],"Node type":["painting"],"Keywords":["virgins","christianity","jesus","catherine","ursula","barbara","ceclia","saints","chastity","symbols"]}	RKM016	RIjksmuseum	333360128	f
485	Tomb of Shams-ud-din Altamash	Tomb in an ornately-decorated chamber	\N	\N	2014-01-08 01:04:49.369041	2014-02-25 21:44:24.103716	b434bc10.jpg	\N	http://hdl.handle.net/10934/RM0001.COLLECT.462119	public domain	{"Date/s":["c1895-1915","1236"],"Places":["Delhi","India"],"Node type":["photograph"],"Keywords":["tomb","Shams-ud-din Altamash","ornate","dynasty","sultan"]}	RKM017	RIjksmuseum	290806384	f
486	Gladiators	Engraving of gladiators ready to fight in an arena full of people.	\N	\N	2014-01-08 01:04:57.681517	2014-02-25 21:44:24.10967	0fdad718.jpg	Jan Luyken	http://hdl.handle.net/10934/RM0001.COLLECT.145276	public domain	{"Date/s":["1701"],"Places":["Amsterdam","Netherlands"],"Node type":["print"],"Keywords":["rome","gladiators"]}	RKM018	RIjksmuseum	472397731	f
487	Taj Mahal	The Taj Mahal from an elevated distance, showing the landscape around.	\N	\N	2014-01-08 01:05:04.832255	2014-02-25 21:44:24.115849	bf648e7e.jpg	\N	http://hdl.handle.net/10934/RM0001.COLLECT.462155	public domain	{"Date/s":["c1895-1915","1236"],"Places":["Agra","Uttar Pradesh","India"],"Node type":["photograph"],"Keywords":["Taj Mahal","tomb","love","dedication","palace","mausoleum","emperor","Shah Jahan","Mumtaz Mahal","landscape"]}	RKM019	Rijksmuseum	844941940	f
488	Going to the temple	A robed woman on a horse led by a robed girl in sandals, holding a blossom branch. Mountains are in the distance.	\N	\N	2014-01-08 01:05:12.158134	2014-02-25 21:44:24.123859	44f9643d.jpg	Kubo Shumman	http://hdl.handle.net/10934/RM0001.COLLECT.45515	public domain	{"Date/s":["c1810-1819"],"Places":["Japan"],"Node type":["print"],"Keywords":["temple","women","servant","horse","travel","worship",""]}	RKM020	Rijksmuseum	1360277402	f
489	Sultan Süleyman	The most famous Sultan of the Ottoman dynasty Süleyman I the Great was nicknamed 'the legislator' or 'great'. He reigned from 1520 to 1566 and was known as a tolerant man with a great cultural interest. In 1566 and 1567 the Danish engraver Lorch stayed in Constantinople. From these years are a face of the city and some Turkish portraits known. The sultan was portrayed twice in 1559, at the feet of his palace and as a bust.	\N	\N	2014-01-08 01:05:19.116448	2014-02-25 21:44:24.129527	c52b16ab.jpg	Melchior Lorch	http://hdl.handle.net/10934/RM0001.COLLECT.141924	public domain	{"Date/s":["1559"],"Places":["Constantinople","Istanbul","Turkey","Europe","Denmark"],"Node type":["engraving","print"],"Keywords":["Ottoman","sultan","S��leyman"]}	RKM021	Rijksmuseum	1350054362	f
490	Mary Magdalene	The woman is Mary Magdalene. She can be identified by her jar of ointment, which she used to anoint Jesus’s feet. Van Scorel painted her as a seductive, luxuriously dressed courtesan, a reference to her reputed past as a prostitute. Her clothing shows the influence of Italian painting, to which Van Scorel was introduced during his trip to Rome.	\N	\N	2014-01-08 01:05:26.217443	2014-02-25 21:44:24.135668	c21e05d5.jpg	Jan van Scorel	http://hdl.handle.net/10934/RM0001.COLLECT.5444	public domain	{"Date/s":["c1530"],"Places":["Haarlem","Netherlands","Europe"],"Node type":["painting"],"Keywords":["Mary Magdalene","bible","women","saint","immorality"]}	RKM022	Rijksmuseum	1116726933	f
507	Lid of the mummy coffin of King Ramses II	Close-up of the face of Ramses II, which could be carved from wood (?) – his ears are pierced and there is an ankh (?) under his chin.	\N	\N	2014-01-08 01:07:28.939752	2014-02-25 21:44:24.25647	bc23b7f3.jpg	\N	http://hdl.handle.net/10934/RM0001.COLLECT.451781	public domain	{"Date/s":["c1888-1898"],"Places":["Cairo","Egypt"],"Node type":["photograph"],"Keywords":["Ramses","leaders","death","mummification","coffin"]}	RKM039	Rijksmuseum	1861771455	f
491	Merrimack Co. Insane Asylum	Printed in the annual report of the State Board of Health of the State of New Hampshire. The image shows a set of buildings, one with a very tall chimney, in a grassy setting with hills in the background.	\N	\N	2014-01-08 01:05:32.845912	2014-02-25 21:44:24.141693	22110989.jpg	John B. Clarke	http://hdl.handle.net/10934/RM0001.COLLECT.493389	public domain	{"Date/s":["1889"],"Places":["North Boscawen","New Hampshire","United States of America"],"Node type":["photograph","cyanotype"],"Keywords":["madness","insanity","asylum","institutions","buildings","lunacy"]}	RKM023	Rijksmuseum	1786798563	f
492	Ancient Temple in Kashmir	Stone temple in a mountainous setting. Three robed figures are visible.	\N	\N	2014-01-08 01:05:40.616037	2014-02-25 21:44:24.148064	c0629198.jpg	Samuel Bourne	http://hdl.handle.net/10934/RM0001.COLLECT.350204	public domain	{"Date/s":["c1862-1874"],"Places":["Kashmir","India","Asia"],"Node type":["photograph"],"Keywords":["temple","religion","stone","mountains"]}	RKM024	Rijksmuseum	607012363	f
493	Tiffin party at a wealthy Chinesian's house in Annoy	Group of Europeans and Chinese adults and children posing on a patio of a Chinese house.	\N	\N	2014-01-08 01:05:47.363082	2014-02-25 21:44:24.156963	7e1f1c79.jpg	\N	http://hdl.handle.net/10934/RM0001.COLLECT.459988	public domain	{"Date/s":["c1879-1890"],"Places":["Annoy","China","Britain"],"Node type":["photograph"],"Keywords":["Chinese","European","men","women","children"]}	RKM025	Rijksmuseum	1458724104	f
494	Ichikawa Danjuro and a goddess	Janjuro actor with a woman standing behind him	\N	\N	2014-01-08 01:05:54.56164	2014-02-25 21:44:24.167246	3088edb6.jpg	Katsukawa Shuntei	http://hdl.handle.net/10934/RM0001.COLLECT.46262	public domain	{"Date/s":["1819"],"Places":["Japan"],"Node type":["print"],"Keywords":["Japan","goddess","actor","costume"]}	RKM026	Rijksmuseum	317091352	f
495	Horse galloping	Sequence of photographs of a galloping horse	\N	\N	2014-01-08 01:06:01.107631	2014-02-25 21:44:24.173212	df8bad48.jpg	Eadweard Muybridge	http://hdl.handle.net/10934/RM0001.COLLECT.250777	public domain	{"Date/s":["1887"],"Places":["Philadelphia","United States of America"],"Node type":["photograph"],"Keywords":["horses","animals","locomotion"]}	RKM027	Rijksmuseum	1637116903	f
496	Life belt life buoy kangaroo	Large oval drive belt made ​​of cloth with a wooden frame, probably filled with cork and straw. Two cables run parallel between the extremes of the oval, and across the cables run two boards to which a net is secured. At the bottom of the net a cone-shaped float, with the point hanging down. A man can stand with his feet on the flat side of the cone-shaped float. This lifebelt was named by the inventor "Kangaroo Life Buoy".	\N	\N	2014-01-08 01:06:08.176137	2014-02-25 21:44:24.179486	97816abc.jpg	HW Burman	http://hdl.handle.net/10934/RM0001.COLLECT.245258	public domain	{"Date/s":["1870-1885"],"Places":["Melbourne","Victoria","Australia"],"Node type":["object","cloth","wood","cork"],"Keywords":["water","floating","drowning","lifesaving","buoy","flotation",""]}	RKM028	Rijksmuseum	992727439	f
498	Jacobus Johannes Eliza Capitein	Portrait of a well-dressed Capitein reading a book. Along the bottom is printed a lengthy text in Dutch.	\N	\N	2014-01-08 01:06:20.37061	2014-02-25 21:44:24.192797	f6418812.jpg	Pieter Tanje	http://hdl.handle.net/10934/RM0001.COLLECT.384124	public domain	{"Date/s":["c1740-1745"],"Places":["Netherlands","Ghana","Africa"],"Node type":["print"],"Keywords":["slavery","Africa","education","reformer","leaders","Christianity","freedom","literacy"]}	RKM030	Rijksmuseum	260599857	f
499	Mexican calendar with hieroglyphics	Calendar of Mexicans, based on the era of the Egyptians. The outer circle represents the Mexican century and the inner circle the Mexican year. Among the show an explanation of the use and meaning of the calendar in French. Top right numbered 83.	\N	\N	2014-01-08 01:06:27.500212	2014-02-25 21:44:24.199497	a2b6438e.jpg	Bernard Picart	http://hdl.handle.net/10934/RM0001.COLLECT.309713	public domain	{"Date/s":["1723"],"Places":["Mexico","Egypt","Netherlands"],"Node type":["print","etching","engraving"],"Keywords":["calendar","time","cycle","seasons"]}	RKM031	Rijksmuseum	613224359	f
500	Horse and slave	Photograph of a sculpture of a muscular, bare-breasted woman standing with a rearing horse, holding it by the reins.  	\N	\N	2014-01-08 01:06:34.479324	2014-02-25 21:44:24.207385	8be71c17.jpg	CM Ferrier, F von Martens	http://hdl.handle.net/10934/RM0001.COLLECT.276537	public domain	{"Date/s":["1851"],"Places":["London","England"],"Node type":["photograph","statue"],"Keywords":["slavery","slaves","women","horses"]}	RKM032	Rijksmuseum	1856879223	f
501	Courtyard of a house in Cairo	Courtyard of a house in Cairo in Egypt. In the doorway of an old house is a veiled mother with child in conversation with a man with a horse.Some children are watching.	\N	\N	2014-01-08 01:06:40.557486	2014-02-25 21:44:24.215281	6a2d6591.jpg	Willem de Famars Testas	http://hdl.handle.net/10934/RM0001.COLLECT.7204	public domain	{"Date/s":["c1868-1881"],"Places":["Cairo","Egypt"],"Node type":["painting"],"Keywords":["houses","homes","Egypt","horses","cats","animals","women","children"]}	RKM033	Rijksmuseum	1410938014	f
502	Death of Cleopatra	To avoid being captured by the Romans, Cleopatra, Queen of Egypt, put an end to her life by being bitten by a poisonous snake. She stands naked beside the bed. In her hands are two snakes. The print has a signature Latin and is part of a series on famous suicides of antiquity.	\N	\N	2014-01-08 01:06:47.580131	2014-02-25 21:44:24.221485	366c108f.jpg	Jan Collaert (II), Philips Galle	http://hdl.handle.net/10934/RM0001.collect.97311	public domain	{"Date/s":["c1576-1628"],"Places":["Egypt","Netherlands"],"Node type":["print","engraving"],"Keywords":["leaders","women","snakes","animals","poison","resistance","death"]}	RKM034	Rijksmuseum	980114229	f
503	Entrance to the Temple of Isis on the island of Philae	Three men appear on the ramp leading up to the entrance. Walls on each side of the entrance each have a massive relief sculptures of an Egyptian figure. 	\N	\N	2014-01-08 01:06:54.721666	2014-02-25 21:44:24.229181	f10f4e4b.jpg	Antonio Beato	http://hdl.handle.net/10934/RM0001.COLLECT.451851	public domain	{"Date/s":["c1895-1915"],"Places":["Philae","Egypt"],"Node type":["photograph"],"Keywords":["temple","Isis","religion"]}	RKM035	Rijksmuseum	1991642644	f
504	National opinions on Napoleon	Two rows of men representing people from 15 different places. Each one is uttering some words.	\N	\N	2014-01-08 01:07:02.805346	2014-02-25 21:44:24.235102	fcf2a7c1.jpg	Charles Williams, Thomas Tegg	http://hdl.handle.net/10934/RM0001.COLLECT.431544	public domain	{"Date/s":["1808"],"Places":["London","England"],"Node type":["print","cartoon"],"Keywords":["leaders","men","Napoleon Bonaparte","politics","satire"]}	RKM036	Rijksmuseum	770213184	f
505	A statue of Ramses II	The figure is standing between two pillars of a large stone building.	\N	\N	2014-01-08 01:07:12.976186	2014-02-25 21:44:24.24103	39b66d24.jpg	Antonio Beato	http://hdl.handle.net/10934/RM0001.COLLECT.451911	public domain	{"Date/s":["c1895-1915"],"Places":["Egypt"],"Node type":["photograph"],"Keywords":["Ramses","leaders"]}	RKM037	Rijksmuseum	1543855424	f
506	A group of women taking water from the Nile.	Seven women stand in shallow waters. On the opposite bank are palm trees and buildings. Six of the women each has a large clay pot on her head: four of the pots are upright; two are sideways. The seventh woman is bending down to fill her pot.	\N	\N	2014-01-08 01:07:21.220809	2014-02-25 21:44:24.248007	f0b1b746.jpg	Bonfils	http://hdl.handle.net/10934/RM0001.COLLECT.451862	public domain	{"Date/s":["c1895-1915"],"Places":["Egypt"],"Node type":["photograph"],"Keywords":["rivers","women","water","Nile","pottery"]}	RKM038	Rijksmuseum	1511349496	f
508	Reliefs and sculpture in the temple of Ramses III	A room in a tomb with relief sculptures and hieroglyphics on the walls. Leaning against the doorway is a man in a turban. 	\N	\N	2014-01-08 01:07:38.273607	2014-02-25 21:44:24.26327	69556bb2.jpg	Bonfils	http://hdl.handle.net/10934/RM0001.collect.457803	public domain	{"Date/s":["1872"],"Places":["Egypt","Paris","France"],"Node type":["photograph"],"Keywords":["Ramses","leaders","tomb","death","inscription","hieroglyphics","men"]}	RKM040	Rijksmuseum	843421297	f
509	Two men with three camels	One man is facing the line of three camels, the other faces the camera. The camels are laden with what appears to be sticks, and in the lower-right corner the shadow of the photographer is visible.	\N	\N	2014-01-08 01:07:47.375084	2014-02-25 21:44:24.269351	96f7fd06.jpg	L Heldringstraat	http://hdl.handle.net/10934/RM0001.COLLECT.438147	public domain	{"Date/s":["1898"],"Places":["Egypt"],"Node type":["photograph"],"Keywords":["camels","animals","men","desert"]}	RKM041	Rijksmuseum	1907196663	f
510	Girgeh after a flood	The bottom third of the photograph is a calm river, the middle third has stone buildings and three spires. The central building has debris washed up against it. The top third of the photograph is a featureless sky.	\N	\N	2014-01-08 01:07:54.722244	2014-02-25 21:44:24.276208	de24a8d1.jpg	Maxime Du Camp,  Louis-Désiré Blanquart-Evrard, Gide et J Baudry	http://hdl.handle.net/10934/RM0001.COLLECT.363497	public domain	{"Date/s":["c1849-1851"],"Places":["Girgeh","Egypt"],"Node type":["photograph"],"Keywords":["rivers","Nile","floods"]}	RKM042	Rijksmuseum	1143338555	f
511	Portrait of a young woman in Egypt	The woman has her hair in braids, with a scarf covering the top half of her head. She is also wearing a choker necklace and large earrings.	\N	\N	2014-01-08 01:08:04.930131	2014-02-25 21:44:24.283464	9284daa3.jpg	Nadar	http://hdl.handle.net/10934/RM0001.COLLECT.453327	public domain	{"Date/s":["c1870-1900"],"Places":["Egypt"],"Node type":["photograph"],"Keywords":["women","jewellry","fashion"]}	RKM043	Rijksmuseum	155161822	f
513	A mosque	Sandy landscape with two large buildings. People are walking in groups from one to the other; another pair of people is toward the foreground.	\N	\N	2014-01-08 01:08:19.620479	2014-02-25 21:44:24.296614	267fd8d9.jpg	L Heldringstraat	http://hdl.handle.net/10934/RM0001.COLLECT.438133	public domain	{"Date/s":["1898"],"Places":["Egypt"],"Node type":["photograph"],"Keywords":["mosques","religion"]}	RKM045	Rijksmuseum	1969930817	f
514	Market scene and the rest on the Flight into Egypt	Fruit sellers – on the left is a man with a chicken and a basket of eggs. In the background the rest on the Flight into Egypt (Matt. 2:14).Print from a series of five prints with kitchen and market pieces combined with biblical scenes in the background.	\N	\N	2014-01-08 01:08:26.919105	2014-02-25 21:44:24.302985	1bb2fe2e.jpg	Jacob Matham	http://hdl.handle.net/10934/RM0001.collect.150654	public domain	{"Date/s":["c1603-1631"],"Places":["Netherlands","Egypt"],"Node type":["print","engraving"],"Keywords":["bible","religion","food"]}	RKM046	Rijksmuseum	1865692830	f
515	Rest on the Flight into Egypt	Holy family – on the right is Joseph with an axe in both hands, tools on the ground. Opposite him is Mary, with yarn. In the center is Christ with a lamb. In the background are Zacchaeus in the fig tree, Jacob's ladder and a church.with Mary and Joseph.	\N	\N	2014-01-08 01:08:35.428433	2014-02-25 21:44:24.310756	4e48ad62.jpg	Monogrammist AC	http://hdl.handle.net/10934/RM0001.COLLECT.37762	public domain	{"Date/s":["c1520-1562"],"Places":["Netherlands","Egypt"],"Node type":["print","engraving"],"Keywords":["bible","religion","tools","yarn","animals"]}	RKM047	Rijksmuseum	166086709	f
516	Pyramids of Egypt	Several Egyptian pyramids and obelisks. Slaves create clay from the river, which is then baked into stones for the construction. In the foreground is Pharaoh Psammetiches on a stone block. He looks at an eagle with a sandal in his mouth (a reference to a fable of Aesop about the relationship between Rhodopis, a young Egyptian woman, and the Pharaoh). In the margin is a signature in Latin. Print from a series of the Seven Wonders of the World.	\N	\N	2014-01-08 01:08:43.143768	2014-02-25 21:44:24.317022	c7d51371.jpg	Magdalena de Passe, Crispin van de Passe (I)	http://hdl.handle.net/10934/RM0001.collect.160805	public domain	{"Date/s":["c1610-1638"],"Places":["Egypt","Netherlands"],"Node type":["print","engraving"],"Keywords":["pyramids","slaves","slavery","engineering","mythology"]}	RKM048	Rijksmuseum	1976013788	f
517	Tile panel with tile and pottery in Bolsward	This large tableau was made to commemorate the founding of the Bolswardse tile and pottery in 1737. The panel shows a cross-sectional view of a factory, with the bottom of the stokers, the painting and the pug mill. In addition, the shifter attic for pottery and brick makers attic for the tiles to see. Over the entire length of the panel is the big furnace.	\N	\N	2014-01-08 01:08:51.783166	2014-02-25 21:44:24.32355	cc81ef16.jpg	\N	http://hdl.handle.net/10934/RM0001.COLLECT.53389	public domain	{"Date/s":["c1745-1765"],"Places":["Bolsward","Friesland","Netherlands"],"Node type":["painting","ceramic"],"Keywords":["pottery","tiles","painting",""]}	RKM049	Rijksmuseum	398032122	f
518	Fireworks in Covent Garden	Night scene with fireworks in Covent Garden in London on 10 September, 1690 at the celebration of the return of King William III in Ireland. To the right, on the facade of St Paul's, are the illuminated monogram letters W, M and R of William and Mary Rex.	\N	\N	2014-01-08 01:08:59.240074	2014-02-25 21:44:24.329669	19371beb.jpg	Bernard Lens (II)	http://hdl.handle.net/10934/RM0001.COLLECT.386641	public domain	{"Date/s":["1690"],"Places":["London","England","Ireland"],"Node type":["print"],"Keywords":["conquest","entertainment","celebrations","Britainsymbo"]}	RKM050	Rijksmuseum	1642233330	f
519	Camel and dromedary	A Dutchman and two servants with a camel and dromedary. According to the text, the animals were offered to the shogun in Edo in 1821 to mark the court journey. The text also mentions some interesting facts about the animals and how they were introduced to Japan. (Nagasaki-e)	\N	\N	2014-01-08 01:09:06.300961	2014-02-25 21:44:24.336408	e8b3c373.jpg	Bunkindo	http://hdl.handle.net/10934/RM0001.collect.47603	public domain	{"Date/s":["c1800-1850"],"Places":["Nagasaki","Japan","Netherlands"],"Node type":["print"],"Keywords":["animals","camels","dromedaries","servants"]}	RKM051	Rijksmuseum	2084819545	f
520	The explosion of the Spanish flagship during the Battle of Gibraltar	On 25 April, 1607, thirty Dutch ships surprised the Spanish fleet in the Bay of Gibraltar. The Spanish ships, which posed a threat to the Dutch trade, were destroyed. It was the first major victory for the Dutch sea. The painter brought the triumphant victory to the picture. The Spanish admiral ship explodes and dozens of crew fly into the air.	\N	\N	2014-01-08 01:09:13.339178	2014-02-25 21:44:24.345343	e4609885.jpg	Cornelis Claesz van Wieringen, Hendrik Cornelisz Vroom	http://hdl.handle.net/10934/RM0001.COLLECT.6503	public domain	{"Date/s":["c1621"],"Places":["Gibraltar","Spain","Netherlands"],"Node type":["painting"],"Keywords":["ships","battle","war"]}	RKM052	Rijksmuseum	1125321235	f
521	Two men in winter clothing	Two men standing, happily, wearing thick padded outfits.	\N	\N	2014-01-08 01:09:20.367035	2014-02-25 21:44:24.351408	8584d576.jpg	\N	http://hdl.handle.net/10934/RM0001.COLLECT.460062	public domain	{"Date/s":["c1879-1890"],"Places":["China"],"Node type":["photograph"],"Keywords":["men","fashion","seasons"]}	RKM053	Rijksmuseum	1999583908	f
523	Dervish meal	Dervishes lived together in a tekke that included, in addition to the prayer hall, a living area, a library, a dining room and a kitchen. The dervishes wear the distinctive cylindrical hat, sikke, and long woollen garments.	\N	\N	2014-01-08 01:09:34.158814	2014-02-25 21:44:24.363037	c62c8b3e.jpg	Jean Baptiste Vanmour,	http://hdl.handle.net/10934/RM0001.COLLECT.5666	public domain	{"Date/s":["c1720-1737"],"Places":["Istanbul","Constantinople","Turkey"],"Node type":["painting"],"Keywords":["religion","sufism","fashion","food"]}	RKM055	Rijksmuseum	311512248	f
524	The meal in honour of Ambassador Cornelis Calkoen	The meal, on 14 September, 1727, is presided over by the grand vizier of Sultan Ahmed III. He sits at the centre of the table, with the Ambassador opposite him, on a low stool, with two interpreters either side. The sultan could listen in unnoticed behind the barred window above.	\N	\N	2014-01-08 01:09:41.057153	2014-02-25 21:44:24.369323	f0dd6ab9.jpg	Jean Baptiste Vanmour,	http://hdl.handle.net/10934/RM0001.COLLECT.5649	public domain	{"Date/s":["c1727-1730"],"Places":["Istanbul","Constantinople","Turkey","Netherlands"],"Node type":["painting"],"Keywords":["diplomacy","international relations","food","leaders"]}	RKM056	Rijksmuseum	570064683	f
525	Guanyin	The Buddhist deity Guanyin, saviour of those in need, is pictured meditating, sitting on a rock. According to legend, he was ever found in this posture, meditating on the reflection of the moon in the water, in Buddhism a symbol of illusion and impermanence. His attitude and facial embody inner peace and concentration. This wooden Guanyin has traces of paint and gilding. Guanyin is in a relaxed position: one knee is raised and the right arm is resting loosely on it.	\N	\N	2014-01-08 01:09:47.881378	2014-02-25 21:44:24.375868	1d7837b0.jpg	\N	http://hdl.handle.net/10934/RM0001.collect.935	public domain	{"Date/s":["c1100-1200"],"Places":["Shanxi","China","Asia"],"Node type":["sculpture","wood"],"Keywords":["androgyny","religion","compassion","bodhisattva"]}	RKM057	Rijksmuseum	940858946	f
526	Sutra box	At the end of the 13th century in Korea a government project began to create boxes for sutras, Buddhist texts. Of these boxes, there are very few left, all adorned with a dense leaf decoration work and inlaid with mother of pearl and silver thread.	\N	\N	2014-01-08 01:09:54.447149	2014-02-25 21:44:24.38355	d7b60fee.jpg	\N	http://hdl.handle.net/10934/RM0001.COLLECT.2263	public domain	{"Date/s":["c1200-1300"],"Places":["Korea","Asia"],"Node type":["object","box","wood"],"Keywords":["religion","Buddhism"]}	RKM058	Rijksmuseum	961258924	f
527	Painting of Guanyin seated on a rock	The painting is on a hanger and shows Guanyin seated. A small figure is at the bottom left in a gesture of supplication.	\N	\N	2014-01-08 01:10:00.795089	2014-02-25 21:44:24.392307	acba184c.jpg	\N	http://hdl.handle.net/10934/RM0001.COLLECT.1916	public domain	{"Date/s":["c1300-1400"],"Places":["Korea","Asia"],"Node type":["painting","silk","dye"],"Keywords":["androgyny","religion","compassion","bodhisattva"]}	RKM059	Rijksmuseum	2081124822	f
528	Table screen	Small ornamental ceramic screen, glazed in pale green, with a design of birds and lotus.	\N	\N	2014-01-08 01:10:06.646704	2014-02-25 21:44:24.406736	4cb93756.jpg	\N	http://hdl.handle.net/10934/RM0001.collect.64640	public domain	{"Date/s":["c1100-1200"],"Places":["China","Asia"],"Node type":["object","ceramic"],"Keywords":["animals","vegetation","design","pottery"]}	RKM060	Rijksmuseum	183298828	f
529	Plate with a map of Japan	Dish with map of Japan, two foreign ships off the coast and a round and rectangular cartouche with text characters. Mount Fuji is indicated by a pair of lines. On narrow, blue cartouches are the names of the provinces. In blue on a white background are the names of the daimyaten. Korea and the Ryukyu Islands are also indicated, plus two fictitious countries. The dish is rectangular with scalloped edge. Inscription, on shelf in Japanese characters: Vessels of foreign countries, day and night fill our hearts with care with respect to the rest of the people, Ye barberen returns immediately on the spot back! You know our country, the country where the gods are, but why do you want to attack! (in Chinese characters). Dated, at bottom: from the period of Tempo (1833-1844).	\N	\N	2014-01-08 01:10:13.324826	2014-02-25 21:44:24.41419	adcacca6.jpg	\N	http://hdl.handle.net/10934/RM0001.COLLECT.326657	public domain	{"Date/s":["c1830-1844"],"Places":["Japan","Asia"],"Node type":["object","porcelain"],"Keywords":["conflict","attack","international relations",""]}	RKM061	Rijksmuseum	99225098	f
530	Tomb gift horse	These objects were originally painted and had rigging of wood and fabric or leather. They were buried in the tomb to accompany the deceased in the afterlife. A West Asian influence is apparent in the faces and headwear of the riders. Their presence in the tomb of a high-ranking Chinese person reflects the booming international contacts during that time.	\N	\N	2014-01-08 01:10:19.967303	2014-02-25 21:44:24.420387	22b2daf4.jpg	\N	http://hdl.handle.net/10934/RM0001.COLLECT.648	public domain	{"Date/s":["c1650-750"],"Places":["China","Asia"],"Node type":["object","pottery"],"Keywords":["international relations","death","tomb","afterlife"]}	RKM062	Rijksmuseum	1896262032	f
531	Elephant combat	This single-leaf painting of elephants in combat was executed in India during the thirteenth century AH / nineteenth CE in an archaizing style referencing Mughal traditions of the eleventh century AH / seventeenth CE. The image of the mounted mahout, a person who drives an elephant, reproduces a popular theme in court painting in South Asia.	\N	3	2014-01-08 01:12:48.208467	2014-02-25 21:44:24.426423	a1893582.jpg	Walters Art Museum	http://purl.stanford.edu/ww260wz5115	CC-BY-SA	{"Date/s":["c1800-1899"],"Places":["India","Asia"],"Node type":["Manuscript"],"Keywords":["elephants","fighting","combat","rider"]}	SWA002	Stanford University	1962272765	t
532	A M\\ughal emperor with a document	This painting depicts a Mughal emperor, yet to be identified, seated in an inlaid chair of European design, on the bank of a brook in a rocky landscape. He is reading an unrolled document which may have been presented to him by the figure standing to his left. The standing figure bears some physiognomic resemblance to portraits of the Mughal emperor Akbar (r. 963-1014 AH / 1556-1605 CE). On the ground between the two figures is a crown and garment. A figure on horseback makes the gesture of surprise in the background.	\N	\N	2014-01-08 01:12:55.493516	2014-02-25 21:44:24.432301	510a961c.jpg	Walters Art Museum	http://purl.stanford.edu/xv778rq3496	CC-BY-SA	{"Date/s":["c1700-1899"],"Places":["India","Asia"],"Node type":["Manuscript"],"Keywords":["emperor","Mughal","leaders"]}	SWA003	Stanford University	1956351185	f
533	Nayaka and attendants in leafy bowers	This painting, dating to the twelfth century AH / eighteenth CE, depicts three women seated within two leafy bowers. The Nayaka (female lover or heroine) sits alone, while her two female companions, known as sakhis, converse in the other bower. The painting may represent Utka nayaka, a classification for heroines who are awaiting or yearning for their lovers. Often, they are shown on a bed of flowers or leaves that they have prepared in expectation of meeting their lovers. In the landscape are animals engaged in various activities. An outcrop of rocks in the distance forms a horizon, above which is a blue sky streaked with light gray or white washes to suggest a thin layer of high clouds.	\N	\N	2014-01-08 01:13:02.823601	2014-02-25 21:44:24.438262	72bf781f.jpg	Walters Art Museum	http://purl.stanford.edu/pt978bf9455	CC-BY-SA	{"Date/s":["c1750"],"Places":["Delhi","India","Asia"],"Node type":["Manuscript"],"Keywords":["heroines","lovers","women","bowers","landscape","art"]}	SWA004	Stanford University	466761669	f
534	A pleasure pavilion	This single leaf shows a gathering of pleasure-seeking men outside a pavilion, where a number of women sit. The painting, which dates to the middle of the twelfth century AH / eighteenth CE, was executed in northern India, possibly Lucknow. Some of the awaiting women drink wine while others attend to the hookahs. In the right corner, a man in yellow dress sits with betel quids, watching two men embroiled in a dispute, one with a dagger drawn. A second pair, at the far end and close to the pavilion, seems also to be enraged enough to draw blood. The rest wait in anticipation, smoking and conversing.	\N	\N	2014-01-08 01:13:10.313698	2014-02-25 21:44:24.444004	81efceca.jpg	Walters Art Museum	http://purl.stanford.edu/st215kx5842	CC-BY-SA	{"Date/s":["c1750"],"Places":["Lucknow","India","Asia"],"Node type":["Manuscript"],"Keywords":["pleasure","men","women"]}	SWA005	Stanford University	1399447284	f
535	Dancing girls	This painting, which represents a mixture of Mughal and Rajput styles, depicts two Indian girls dancing.	\N	\N	2014-01-08 01:13:20.317338	2014-02-25 21:44:24.450109	e18e16aa.jpg	Walters Art Museum	http://purl.stanford.edu/hz017yn6723	CC-BY-SA	{"Date/s":["c1750"],"Places":["India","Asia"],"Node type":["Manuscript"],"Keywords":["dancing","women"]}	SWA006	Stanford University	1119808296	f
536	Prince and holy man	According to inscriptions written in nastaʿlīq script, this painting depicts the Mughal prince Dārā Shikōh (b. 1024 AH / 1615 CE) and the holy man Shāh Sarma seated under a tree. Behind the wise man stands an attendant with a peacock-feather fan. A celebrated scholar, sufi, and ruler, Dārā Shikōh was the eldest son of Shāh Jahān.	\N	\N	2014-01-08 01:13:29.366979	2014-02-25 21:44:24.458504	da28960d.jpg	Walters Art Museum	http://purl.stanford.edu/xk566cg9484	CC-BY-SA	{"Date/s":["c1750"],"Places":["India","Persia","Asia"],"Node type":["Manuscript"],"Keywords":["sufi","religion","prince","tree","attendant","fan","leaders"]}	SWA007	Stanford University	293098150	f
537	Nilgai	This painting of a nilgai (also called a blue bull or Boselaphus tragocamelus), which is an antelope indigenous to Asia, is attributable to the reign of the Mughal emperor Shah Jahan (r. 1037-1068 AH / 1627-1658 CE). Such animal studies were popular commissions among the Mughal emperors, who showed a marked curiosity about the natural world in their royal histories. Patronage of paintings of flora, fauna, and animals received a particular impetus under the Mughal emperor Jahangir (r. 1014-1037 AH / 1605-27 CE) and was continued under later Mughals. The detailed foliage in the foreground and the light green background are comparable to other studies of single animals dating to c. 1049 AH / 1640 CE.	\N	\N	2014-01-08 01:13:37.427611	2014-02-25 21:44:24.467016	4dfe1724.jpg	Walters Art Museum	http://purl.stanford.edu/vq488gk4739	CC-BY-SA	{"Date/s":["c1625-1650"],"Places":["India","Asia"],"Node type":["Manuscript"],"Keywords":["antelope","animals"]}	SWA008	Stanford University	612263084	f
538	The prophet Muhammad praying at the Kaʿbah	The prophet Muhammad praying at the Kaʿbah	\N	\N	2014-01-08 01:13:44.738497	2014-02-25 21:44:24.473983	5e6566eb.jpg	Walters Art Museum	http://purl.stanford.edu/nj519tp3268	CC-BY-SA	{"Date/s":["c1650"],"Places":["Turkey","Persia","Asia"],"Node type":["Manuscript"],"Keywords":["Ottoman","Islam","prophet","Muhammad","Turkish","prayer","religion"]}	SWA009	Stanford University	1520468245	f
539	Man with flower	This single-leaf painting of a young man in a blue robe and red undergarment was produced in Safavid Iran in the eleventh century AH / seventeenth CE. The youth sits in a landscape smelling a flower. Images of elegantly dressed men and women were exceedingly popular in Safavid Iran. They circulated as loose leaves and were collected into albums (muraqqaʿ). The work is painted in opaque watercolor and gold.	\N	\N	2014-01-08 01:13:51.873388	2014-02-25 21:44:24.48025	f2cba114.jpg	Walters Art Museum	http://purl.stanford.edu/gq065mc9480	CC-BY-SA	{"Date/s":["c1650"],"Places":["Iran","Asia"],"Node type":["Manuscript"],"Keywords":["men","flowers"]}	SWA010	Stanford University	1893674895	f
540	Falconer on horseback	This is an Ottoman Turkish colored drawing of a falconer on horseback produced in the eleventh century AH / seventeenth CE. The central work is framed by two additional drawings: a lion in the upper register and a lion killing a deer in the lower register. Both reference earlier Persian compositions. The verses above are written in small nastaʿlīq script, the first two in Persian and the third in Ottoman Turkish.	\N	\N	2014-01-08 01:13:58.018698	2014-02-25 21:44:24.486594	d4d6ada3.jpg	Walters Art Museum	http://purl.stanford.edu/tm876zh3307	CC-BY-SA	{"Places":["Turkey","Persia","Asia"],"Node type":["Manuscript"],"Keywords":["falconers","falcons","men","horses","lions"]}	SWA011	Stanford University	2050808735	f
541	The Archangel rescuing the child from drowning	Folio 28r of a book on the miracles of the Archangel Michael.  The inscription at the top left reads "ባሕር፡," or "Body of water." The inscription at the top right reads "ቅዱስ፡ ሚካኤል፡ ዘከመ፡ አውፅኦ፡ በእደ፡ ኖትያዊ፡ ዘተገፍዓ፡ ለ፩፡ ሕፃን፡ እምሣፁን፡," or "Saint Michael: how he brought out the oppressed child from a box in the hand of a sailor." The inscription at the middle right reads "ዘከመ፡ አሕቀፎ፡ ቅዱስ፡ ሚካኤል፡ ለውእቱ፡ ሕፃን፡ በሕፅነ፡ ጸላእቱ፡ በኀይለ፡ ቅዱስ፡ ሚካኤል፡," or "How Saint Michael caused, by his power, the child to be embraced in the bosom of his enemy." The inscription at the bottom left reads "ዘከመ፡ ተቀረመት፡ ገራህተ፡ እሙ፡ ለተላፍኖስ፡ በዘመነ፡ ንዴት፡ ወዓፀባ፡ ኀዚላ፡ ሕፃና፡," or "How the mother of (the child) Tälafnos gleaned the farm field in the time of want and hardship carrying a baby on her back."	\N	\N	2014-01-08 01:14:04.913995	2014-02-25 21:44:24.492592	7eb5d0b9.jpg	Walters Art Museum	http://purl.stanford.edu/xq497gx4970	CC-BY-SA	{"Date/s":["c1650-1700"],"Places":["Gondar","Ethiopia","Africa"],"Node type":["Manuscript"],"Keywords":["angels","archangels","Michael","Z��m��nf��s Q��ddus"]}	SWA013	Stanford University	496178175	f
542	Saint Michael: how he appeared to Constantine in the city of [New] Rome and gave him power over all his enemies	Folio 85v of a book on the miracles of the Archangel Michael. 	\N	\N	2014-01-08 01:14:11.483369	2014-02-25 21:44:24.498646	6dd97d1b.jpg	Walters Art Museum	http://purl.stanford.edu/xq497gx4970	CC-BY-SA	{"Date/s":["c1650-1700"],"Places":["Gondar","Ethiopia","Africa"],"Node type":["Manuscript"],"Keywords":["angels","archangels","Michael","Constantine","enemies","Z��m��nf��s Q��ddus"]}	SWA014	Stanford University	433816695	f
543	The Archangel helping Samson to kill his enemies	Folio 33r of a book on the miracles of the Archangel Michael. The inscription reads "ወዘከመ፡ ተራድኦ፡ ከመ፡ ይቅትል፡ ብዙኃነ፡ በአሐቲ፡ መንከሰ፡ አድግ፡," or "And how he helped him kill multitudes with a jaw bone of an ass."	\N	\N	2014-01-08 01:14:18.523528	2014-02-25 21:44:24.50508	bae9747b.jpg	Walters Art Museum	http://purl.stanford.edu/xq497gx4970	CC-BY-SA	{"Date/s":["c1650-1700"],"Places":["Gondar","Ethiopia","Africa"],"Node type":["Manuscript"],"Keywords":["angels","archangels","Michael","Constantine","enemies","Z��m��nf��s Q��ddus"]}	SWA015	Stanford University	61811839	f
544	Crucifixion	A simple but expressive drawing of the crucified Christ, which may be connected to another important figure from the time, as it is believed to be the work of an artist from the circle of Hans Holbein the Elder.	\N	\N	2014-01-08 01:14:24.814844	2014-02-25 21:44:24.511306	e8318a5a.jpg	Walters Art Museum	http://purl.stanford.edu/kh867ky1669	CC-BY-SA	{"Date/s":["1516"],"Places":["Augsburg","Germany","Europe"],"Node type":["Manuscript"],"Keywords":["christ","christianity","religion","crucifixion","cross","jesus"]}	SWA016	Stanford University	348094950	f
545	Battle scene from the Baburnamah (Memoirs of Babur)	Illustration for a text on how Sayyidim, Qulī Bābā, and several warriors were unhorsed in battle and how news of their fate reached Sultan Ḥusayn Mīrzā.	\N	\N	2014-01-08 01:14:31.888253	2014-02-25 21:44:24.519773	85e6614a.jpg	Walters Art Museum	http://purl.stanford.edu/wy949sx9229	CC-BY-SA	{"Date/s":["c1550"],"Places":["India","Asia"],"Node type":["Manuscript"],"Keywords":["battles","horses","Babur","mughal"]}	SWA017	Stanford University	898999825	f
546	Execution by elephant	This Mughal painting is originally from a copy of the Akbarnāmah, the official history of the reign of the Mughal Emperor Akbar (r. 964-1015 AH / 1556-1605 CE), written by Abū al-Faẓl ibn Mubārak (d. 1011 AH / 1602 CE).	\N	\N	2014-01-08 01:14:40.116943	2014-02-25 21:44:24.526466	1b7c766f.jpg	Walters Art Museum	http://purl.stanford.edu/mp943zr3844	CC-BY-SA	{"Date/s":["c1551-1602"],"Places":["Persia","India","Asia"],"Node type":["Manuscript"],"Keywords":["emperor","Mughal","Akbar","leaders"]}	SWA018	Stanford University	534871505	f
547	The hanging of Shāh ʿAbd al-Maʿalī	This Mughal painting is originally from a copy of the Akbarnāmah, the official history of the reign of the Mughal Emperor Akbar (r. 964-1015 AH / 1556-1605 CE), written by Abū al-Faẓl ibn Mubārak (d. 1011 AH / 1602 CE). It has the inscription: Shāh ʿAbd al-Maʿlī being hanged on the order of Mīrzā Muḥammad Ḥakīm	\N	\N	2014-01-08 01:14:48.300195	2014-02-25 21:44:24.532343	2edc8aa4.jpg	Walters Art Museum	http://purl.stanford.edu/mp943zr3844	CC-BY-SA	{"Date/s":["c1551-1602"],"Places":["Persia","India","Asia"],"Node type":["Manuscript"],"Keywords":["emperor","Mughal","Akbar","leaders"]}	SWA019	Stanford University	948649827	f
548	An elephant with mahout attacking four men	This Mughal painting depicts an elephant with a mahout attacking four men. Depictions of elephants became increasingly common in the Mughal period. Stylistically this example may be attributed to sometime in the late tenth century AH / sixteenth CE, although the Persian inscription on the page states that it was completed in Bukhārā on the last day of Ṣafar 731 AH / 1330 CE. There are a few numbers inscribed on the page: 4500, 9, and 18. The work is framed by marbled paper and a border illuminated with animal and floral motifs.	\N	\N	2014-01-08 01:14:55.14093	2014-02-25 21:44:24.540646	fd141571.jpg	Walters Art Museum	http://purl.stanford.edu/yd697qd2340	CC-BY-SA	{"Date/s":["c1550"],"Places":["India","Asia"],"Node type":["Manuscript"],"Keywords":["elephants","attacks","men","Mughal"]}	SWA020	Stanford University	1311090918	f
549	Man spinning cotton	This is a drawing depicting a man spinning cotton. It was executed in the mid tenth century AH / sixteenth CE in Iran, possibly in Qazwīn. The drawing is framed by verses in nastaʿlīq script inscribed in panels, and the whole is surrounded by an outer border with animals and vegetal decoration on a blue background.	\N	\N	2014-01-08 01:15:02.250596	2014-02-25 21:44:24.547524	4f0ae23c.jpg	Walters Art Museum	http://purl.stanford.edu/ss177kf8454	CC-BY-SA	{"Date/s":["c1550"],"Places":["Persia","Iran","Asia"],"Node type":["Manuscript"],"Keywords":["cotton","spinning","men"]}	SWA021	Stanford University	1789029239	f
550	A fatal quarrel over a prostitute	This leaf depicting the scene of a fatal quarrel over a prostitute comes from a manuscript of Akbarnāmah (a biography of the Mughal Emperor Akbar [r. 963 AH / 1556 CE -- 1014 AH / 1605 CE]) by his prime minster Abū al- Faz̤l ibn Mubārak (d. 1011 AH / 1602 CE).	\N	\N	2014-01-08 01:15:09.207033	2014-02-25 21:44:24.555398	a22bf508.jpg	Walters Art Museum	http://purl.stanford.edu/zg501xg8463	CC-BY-SA	{"Date/s":["c1550"],"Places":["Persia","Iran","Asia"],"Node type":["Manuscript"],"Keywords":["quarrels","prostitutes","men","death"]}	SWA022	Stanford University	911210834	f
551	Christ’s entombment	a shrouded Christ is carried to the tomb by Joseph and Nicodemus.	\N	\N	2014-01-08 01:15:19.733082	2014-02-25 21:44:24.562351	77e6503e.jpg	Walters Art Museum	http://purl.stanford.edu/wh356ht7239	CC-BY-SA	{"Date/s":["c1350-1399"],"Places":["Lake Tana","Ethiopia","Africa"],"Node type":["Manuscript"],"Keywords":["shroud","Christ","tomb","death"]}	SWA023	Stanford University	660760920	f
552	Christ’s resurrection	the resurrected Christ, accompanied by the Archangel Michael, appearing before Mary Magdalene, St. John, and St. Peter.	\N	\N	2014-01-08 01:15:26.7845	2014-02-25 21:44:24.568095	faabdcca.jpg	Walters Art Museum	http://purl.stanford.edu/wh356ht7239	CC-BY-SA	{"Date/s":["c1350-1399"],"Places":["Lake Tana","Ethiopia","Africa"],"Node type":["Manuscript"],"Keywords":["Mary Magdalene","St John","St Peter","saints","Christ","resurrection","religion","Christianity"]}	SWA024	Stanford University	2101793549	f
553	Medicine men	This is a single leaf from a dispersed manuscript (Aya Sofya 3703, later Top Kapi Seray 2147) of the Arabic version of De materia medica by Dioscorides (fl. ca. 65 CE) that was copied in 621 AH / 1224 CE in Baghdad. Two doctors preparing medicine. A funnel is set on a tripod over a vessel. The two men preparing the medicinal draught stand on either side of the tripod beside two fruit trees. The text is written in partially vocalized naskh script in brownish-black and red ink.	\N	\N	2014-01-08 01:15:33.492866	2014-02-25 21:44:24.575225	224d3cde.jpg	Walters Art Museum	http://purl.stanford.edu/dx161mc8937	CC-BY-SA	{"Date/s":["1224"],"Places":["Baghdad","Iraq","Asia"],"Node type":["Manuscript"],"Keywords":["medicine","men","trees","health","medieval","Arabic"]}	SWA025	Stanford University	808524129	f
554	Funeral procession	This Timurid leaf depicting a funeral procession is from a copy of Manṭiq al-ṭayr (The language of the birds) by the Persian Sufi poet Farīd al-Dīn ʿAṭṭār (d. 618 AH / 1221 CE). It represents a son’s lamentation at his father’s funeral.	\N	\N	2014-01-08 01:15:39.940516	2014-02-25 21:44:24.582055	bf18f460.jpg	Walters Art Museum	http://purl.stanford.edu/wf782mz0073	CC-BY-SA	{"Date/s":["c1450"],"Places":["Persia","Asia"],"Node type":["Manuscript"],"Keywords":["funeral","death","lament","Bihz��d"]}	SWA026	Stanford University	1346344390	f
555	Writer pausing to reflect	This author portrait once preceded the Lenten readings (mostly taken from the Gospel of Mark) in a Gospel lectionary now in Athens, National Library of Greece MS 2552. The Evangelist has momentarily paused writing and raises a hand to his chin in a conventional gesture signifying thought. On the desk in front of him lie a pair of compasses, used for ruling the parchment pages before writing on them, and an inkwell.	\N	\N	2014-01-08 01:15:46.551862	2014-02-25 21:44:24.588675	0184a4a5.jpg	Walters Art Museum	http://purl.stanford.edu/ch617yk2621	CC-BY-SA	{"Date/s":["c1000-1040"],"Places":["Greece","Constantinople","Istanbul","Turkey","Europe"],"Node type":["Manuscript"],"Keywords":["gospel","writing","author","ink"]}	SWA027	Stanford University	350828645	f
\.


--
-- Name: things_id_seq; Type: SEQUENCE SET; Schema: public; Owner: narinda
--

SELECT pg_catalog.setval('things_id_seq', 556, true);


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: narinda
--

COPY users (id, email, encrypted_password, reset_password_token, reset_password_sent_at, remember_created_at, sign_in_count, current_sign_in_at, last_sign_in_at, current_sign_in_ip, last_sign_in_ip, created_at, updated_at, role) FROM stdin;
1	hi@hi.com	$2a$10$CXCh41Q61mjF6MLH9FlrRe6PpD9mKIErzVapd5udliPlnFNLVj0K.	\N	\N	\N	0	\N	\N	\N	\N	2013-10-18 05:34:37.280739	2013-10-18 05:34:37.280739	1
4	narinda@icelab.com.au	$2a$10$JsGOqeUWtzXOL5MlnMRUieOem9Xd1rZwwzVxcWLLFBah5HOPqZ8fW	\N	\N	\N	1	2013-10-29 05:49:19.725369	2013-10-29 05:49:19.725369	127.0.0.1	127.0.0.1	2013-10-29 05:49:19.713569	2013-10-29 05:49:19.726813	1
5	cath.styles@gmail.com	$2a$10$HVuiGe/MLC4KMK6mY.bSBOyIMRyDNJRp9bA4gJaeZuZYYycmgKf0y	\N	\N	2013-11-23 04:10:23.982203	1	2013-11-23 04:10:24.008544	2013-11-23 04:10:24.008544	203.129.33.55	203.129.33.55	2013-11-23 02:19:27.146311	2013-11-23 04:10:24.01442	1
2	user@example.com	$2a$10$ed5xwOOhk23Jtiv78GJ/Q.habTxE7kryvo3lLx08DKdqSetilM7Dy	\N	\N	\N	7	2014-03-11 07:25:31.471025	2014-03-03 23:32:40.90389	203.217.59.47	203.217.59.47	2013-10-22 05:39:20.396895	2014-03-11 07:25:31.474615	1
7	trsell@gmail.com	$2a$10$CTXiVG77uGY/rbSxH37O5.Yfhol/DBLdXrgMDe/gahXIyxYjaQFVe	\N	\N	2014-03-12 00:49:28.399329	4	2014-03-12 00:49:28.415854	2014-03-12 00:42:21.551976	59.167.193.117	59.167.193.117	2014-02-03 03:36:38.003684	2014-03-12 00:52:41.523904	10
6	michael@icelab.com.au	$2a$10$rxzRcTNpW1Q3.dOJ3PW15.H5Bat3M7UsuVFU6p2wy0OVfXdUG5kcu	\N	\N	\N	5	2014-01-16 06:20:23.934028	2014-01-16 03:07:04.018817	203.217.59.47	203.217.59.47	2013-11-23 02:20:42.655707	2014-01-16 06:20:23.938768	1
8	andy@icelab.com.au	$2a$10$W4MXmNG5sHJ0yHdJPnydveW//GaMuuHLVqeBnQMx/tCoQfeCxCuvO	\N	\N	\N	1	2014-03-04 22:21:15.932959	2014-03-04 22:21:15.932959	203.217.59.47	203.217.59.47	2014-03-04 22:21:15.904203	2014-03-04 22:21:15.937013	1
10	rating_test2@example.com	$2a$10$Pu98bQlOw.S7iCZgO726vuixnM7AYYzyxpr5MsuWu5AzBDgnYiVHa	\N	\N	\N	18	2014-04-22 01:55:34.111567	2014-04-17 00:49:18.024576	127.0.0.1	127.0.0.1	2014-03-12 03:22:04.787124	2014-04-22 01:55:34.11524	1
11	rating_test3@example.com	$2a$10$Kbc9CiJuTkyB6w5E/MizYOWF/Hk7RnULJVudBBmV6apTHTGCDiE5G	\N	\N	\N	12	2014-04-22 01:56:49.638854	2014-04-15 04:58:09.230339	127.0.0.1	127.0.0.1	2014-03-18 01:43:47.103698	2014-04-22 01:56:49.64168	1
12	rating_test4@example.com	$2a$10$msubTv.P5Cvdh1HRaXrbW.b57eYO.uminJ7c6l0Rvws9kX36mx5a2	\N	\N	\N	7	2014-04-24 00:48:59.196562	2014-04-23 06:43:39.489644	127.0.0.1	127.0.0.1	2014-04-01 00:05:35.340759	2014-04-24 00:48:59.201259	1
3	admin@example.com	$2a$10$AE4h2KD6bV/FrlL6cRzsWuT/9PAmmiJa5LCRA3fIfPIllPy0EVSkO	\N	\N	\N	17	2014-04-03 04:49:10.067387	2014-04-03 04:33:13.241493	127.0.0.1	127.0.0.1	2013-10-22 05:39:20.472899	2014-04-03 04:49:10.13053	10
9	rating_test@example.com	$2a$10$KONl6zdFE1ZlkE/Hld62n.MyY8f894oK7lKn34LdQU990j/Od2PvW	\N	\N	\N	16	2014-04-10 04:48:57.965701	2014-04-09 04:21:24.217622	127.0.0.1	127.0.0.1	2014-03-12 03:21:26.879834	2014-04-10 04:48:57.968698	1
13	test_sign@example.com	$2a$10$RGXZAFasH9tuAnnMTGjn6OEwCxtoHQQSXvk/gz9nVtMum9HbCiZ7u	\N	\N	\N	1	2014-04-16 02:45:58.055838	2014-04-16 02:45:58.055838	127.0.0.1	127.0.0.1	2014-04-16 02:45:57.950478	2014-04-16 02:45:58.059698	1
14	test_sign2@example.com	$2a$10$VMGGn4bzIWbOLzFKxI8n4.Uq0l2.W4VEQMGAV52gJAIjhMEsEbnH6	\N	\N	\N	1	2014-04-16 02:49:48.499177	2014-04-16 02:49:48.499177	127.0.0.1	127.0.0.1	2014-04-16 02:49:48.411913	2014-04-16 02:49:48.503005	1
15	test_sign5@example.com	$2a$10$6feIViGgzSPl40CCZrGM9ecLMeAToF9ZGyJOOvtxdKKYqx8KD0Ati	\N	\N	\N	1	2014-04-16 05:47:35.346136	2014-04-16 05:47:35.346136	127.0.0.1	127.0.0.1	2014-04-16 05:47:35.328054	2014-04-16 05:47:35.349504	1
16	test_sign4@example.com	$2a$10$UXIMtV.AKmeuj7fRhR7Y7eyyApbc6FRoNbN0fawVk5y7YrCxtabgq	\N	\N	\N	1	2014-04-16 05:48:40.409145	2014-04-16 05:48:40.409145	127.0.0.1	127.0.0.1	2014-04-16 05:48:40.366177	2014-04-16 05:48:40.412555	1
\.


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: narinda
--

SELECT pg_catalog.setval('users_id_seq', 16, true);


--
-- Name: boards_pkey; Type: CONSTRAINT; Schema: public; Owner: narinda; Tablespace: 
--

ALTER TABLE ONLY boards
    ADD CONSTRAINT boards_pkey PRIMARY KEY (id);


--
-- Name: games_pkey; Type: CONSTRAINT; Schema: public; Owner: narinda; Tablespace: 
--

ALTER TABLE ONLY games
    ADD CONSTRAINT games_pkey PRIMARY KEY (id);


--
-- Name: links_pkey; Type: CONSTRAINT; Schema: public; Owner: narinda; Tablespace: 
--

ALTER TABLE ONLY links
    ADD CONSTRAINT links_pkey PRIMARY KEY (id);


--
-- Name: nodes_pkey; Type: CONSTRAINT; Schema: public; Owner: narinda; Tablespace: 
--

ALTER TABLE ONLY nodes
    ADD CONSTRAINT nodes_pkey PRIMARY KEY (id);


--
-- Name: placements_pkey; Type: CONSTRAINT; Schema: public; Owner: narinda; Tablespace: 
--

ALTER TABLE ONLY placements
    ADD CONSTRAINT placements_pkey PRIMARY KEY (id);


--
-- Name: players_pkey; Type: CONSTRAINT; Schema: public; Owner: narinda; Tablespace: 
--

ALTER TABLE ONLY players
    ADD CONSTRAINT players_pkey PRIMARY KEY (id);


--
-- Name: profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: narinda; Tablespace: 
--

ALTER TABLE ONLY profiles
    ADD CONSTRAINT profiles_pkey PRIMARY KEY (id);


--
-- Name: ratings_pkey; Type: CONSTRAINT; Schema: public; Owner: narinda; Tablespace: 
--

ALTER TABLE ONLY ratings
    ADD CONSTRAINT ratings_pkey PRIMARY KEY (id);


--
-- Name: resemblances_pkey; Type: CONSTRAINT; Schema: public; Owner: narinda; Tablespace: 
--

ALTER TABLE ONLY resemblances
    ADD CONSTRAINT resemblances_pkey PRIMARY KEY (id);


--
-- Name: things_pkey; Type: CONSTRAINT; Schema: public; Owner: narinda; Tablespace: 
--

ALTER TABLE ONLY things
    ADD CONSTRAINT things_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: narinda; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_boards_on_creator_id; Type: INDEX; Schema: public; Owner: narinda; Tablespace: 
--

CREATE INDEX index_boards_on_creator_id ON boards USING btree (creator_id);


--
-- Name: index_boards_on_updator_id; Type: INDEX; Schema: public; Owner: narinda; Tablespace: 
--

CREATE INDEX index_boards_on_updator_id ON boards USING btree (updator_id);


--
-- Name: index_games_on_creator_id; Type: INDEX; Schema: public; Owner: narinda; Tablespace: 
--

CREATE INDEX index_games_on_creator_id ON games USING btree (creator_id);


--
-- Name: index_games_on_updator_id; Type: INDEX; Schema: public; Owner: narinda; Tablespace: 
--

CREATE INDEX index_games_on_updator_id ON games USING btree (updator_id);


--
-- Name: index_links_on_game_id; Type: INDEX; Schema: public; Owner: narinda; Tablespace: 
--

CREATE INDEX index_links_on_game_id ON links USING btree (game_id);


--
-- Name: index_links_on_source_id; Type: INDEX; Schema: public; Owner: narinda; Tablespace: 
--

CREATE INDEX index_links_on_source_id ON links USING btree (source_id);


--
-- Name: index_links_on_target_id; Type: INDEX; Schema: public; Owner: narinda; Tablespace: 
--

CREATE INDEX index_links_on_target_id ON links USING btree (target_id);


--
-- Name: index_placements_on_creator_id; Type: INDEX; Schema: public; Owner: narinda; Tablespace: 
--

CREATE INDEX index_placements_on_creator_id ON placements USING btree (creator_id);


--
-- Name: index_ratings_on_creator_id; Type: INDEX; Schema: public; Owner: narinda; Tablespace: 
--

CREATE INDEX index_ratings_on_creator_id ON ratings USING btree (creator_id);


--
-- Name: index_ratings_on_resemblance_id; Type: INDEX; Schema: public; Owner: narinda; Tablespace: 
--

CREATE INDEX index_ratings_on_resemblance_id ON ratings USING btree (resemblance_id);


--
-- Name: index_resemblances_on_creator_id; Type: INDEX; Schema: public; Owner: narinda; Tablespace: 
--

CREATE INDEX index_resemblances_on_creator_id ON resemblances USING btree (creator_id);


--
-- Name: index_resemblances_on_link_id; Type: INDEX; Schema: public; Owner: narinda; Tablespace: 
--

CREATE INDEX index_resemblances_on_link_id ON resemblances USING btree (link_id);


--
-- Name: index_resemblances_on_source_id; Type: INDEX; Schema: public; Owner: narinda; Tablespace: 
--

CREATE INDEX index_resemblances_on_source_id ON resemblances USING btree (source_id);


--
-- Name: index_resemblances_on_target_id; Type: INDEX; Schema: public; Owner: narinda; Tablespace: 
--

CREATE INDEX index_resemblances_on_target_id ON resemblances USING btree (target_id);


--
-- Name: index_things_on_creator_id; Type: INDEX; Schema: public; Owner: narinda; Tablespace: 
--

CREATE INDEX index_things_on_creator_id ON things USING btree (creator_id);


--
-- Name: index_things_on_updator_id; Type: INDEX; Schema: public; Owner: narinda; Tablespace: 
--

CREATE INDEX index_things_on_updator_id ON things USING btree (updator_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: narinda; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: narinda; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: narinda; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

