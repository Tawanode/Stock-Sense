--
-- PostgreSQL database dump
--

\restrict bWJVFuZaZBP2Il3kBId576UlkH7AqAqoMC01s8ip33f3illlK22tdxbiZ9eBEh3

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

--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roles (id, name, description, created_at) FROM stdin;
1	inventory_manager	Manages inventory, products, receipts, deliveries, adjustments and warehouses.	2026-09-26 12:02:22.227043+05:30
2	warehouse_staff	Performs warehouse operations including receiving, picking, transfers and stock counting.	2026-09-26 12:02:22.227043+05:30
\.


--
-- Data for Name: warehouses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.warehouses (id, name, code, address, is_active, created_at, updated_at) FROM stdin;
1	Main Warehouse	WH-MAIN	Main Inventory Facility	t	2026-09-26 12:17:15.198423+05:30	2026-09-26 12:17:15.198423+05:30
2	Warehouse 2	WH-002	Secondary Inventory Facility	t	2026-09-26 12:17:15.198423+05:30	2026-09-26 12:17:15.198423+05:30
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, name, email, password_hash, role_id, warehouse_id, is_active, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: adjustments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.adjustments (id, reference, status, reason, created_by, validated_by, validated_at, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.categories (id, name, description, created_at, updated_at) FROM stdin;
1	Raw Material	Materials used in production	2026-09-26 12:18:14.975496+05:30	2026-09-26 12:18:14.975496+05:30
2	Finished Goods	Completed products ready for delivery	2026-09-26 12:18:14.975496+05:30	2026-09-26 12:18:14.975496+05:30
3	Components	Parts used to assemble products	2026-09-26 12:18:14.975496+05:30	2026-09-26 12:18:14.975496+05:30
4	Packaging	Packaging materials	2026-09-26 12:18:14.975496+05:30	2026-09-26 12:18:14.975496+05:30
5	Consumables	Consumable inventory items	2026-09-26 12:18:14.975496+05:30	2026-09-26 12:18:14.975496+05:30
\.


--
-- Data for Name: locations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.locations (id, warehouse_id, name, code, description, is_active, created_at, updated_at) FROM stdin;
1	1	Rack A	RACK-A	\N	t	2026-09-26 12:17:32.432035+05:30	2026-09-26 12:17:32.432035+05:30
2	1	Rack B	RACK-B	\N	t	2026-09-26 12:17:32.432035+05:30	2026-09-26 12:17:32.432035+05:30
3	1	Production Area	PROD	\N	t	2026-09-26 12:17:32.432035+05:30	2026-09-26 12:17:32.432035+05:30
4	1	Dispatch Area	DISPATCH	\N	t	2026-09-26 12:17:32.432035+05:30	2026-09-26 12:17:32.432035+05:30
5	2	Rack A	RACK-A	\N	t	2026-09-26 12:17:32.432035+05:30	2026-09-26 12:17:32.432035+05:30
\.


--
-- Data for Name: units; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.units (id, name, symbol, created_at) FROM stdin;
1	Kilogram	kg	2026-09-26 12:05:27.48954+05:30
2	Gram	g	2026-09-26 12:05:27.48954+05:30
3	Piece	pcs	2026-09-26 12:05:27.48954+05:30
4	Liter	L	2026-09-26 12:05:27.48954+05:30
5	Meter	m	2026-09-26 12:05:27.48954+05:30
6	Box	box	2026-09-26 12:05:27.48954+05:30
\.


--
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.products (id, name, sku, category_id, unit_id, is_active, created_at, updated_at) FROM stdin;
1	Steel Rod	STL-001	1	1	t	2026-09-26 12:18:51.479629+05:30	2026-09-26 12:18:51.479629+05:30
2	Office Chair	CHR-001	2	3	t	2026-09-26 12:18:51.479629+05:30	2026-09-26 12:18:51.479629+05:30
3	Cardboard Box	BOX-001	4	6	t	2026-09-26 12:18:51.479629+05:30	2026-09-26 12:18:51.479629+05:30
\.


--
-- Data for Name: adjustment_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.adjustment_items (id, adjustment_id, product_id, location_id, system_quantity, counted_quantity, created_at) FROM stdin;
\.


--
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customers (id, name, email, phone, address, is_active, created_at, updated_at) FROM stdin;
1	XYZ Manufacturing	purchase@xyzmanufacturing.com	+91-9000000010	Industrial Area	t	2026-09-26 12:20:06.892156+05:30	2026-09-26 12:20:06.892156+05:30
2	Modern Furniture	orders@modernfurniture.com	+91-9000000011	City Centre	t	2026-09-26 12:20:06.892156+05:30	2026-09-26 12:20:06.892156+05:30
3	XYZ Manufacturing	purchase@xyzmanufacturing.com	+91-9000000010	Industrial Area	t	2026-09-26 12:20:30.646047+05:30	2026-09-26 12:20:30.646047+05:30
4	Modern Furniture	orders@modernfurniture.com	+91-9000000011	City Centre	t	2026-09-26 12:20:30.646047+05:30	2026-09-26 12:20:30.646047+05:30
5	XYZ Manufacturing	purchase@xyzmanufacturing.com	+91-9000000010	Industrial Area	t	2026-09-26 12:20:33.899264+05:30	2026-09-26 12:20:33.899264+05:30
6	Modern Furniture	orders@modernfurniture.com	+91-9000000011	City Centre	t	2026-09-26 12:20:33.899264+05:30	2026-09-26 12:20:33.899264+05:30
\.


--
-- Data for Name: delivery_orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.delivery_orders (id, reference, customer_id, warehouse_id, status, notes, created_by, validated_by, validated_at, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: delivery_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.delivery_items (id, delivery_id, product_id, location_id, quantity, created_at) FROM stdin;
\.


--
-- Data for Name: password_reset_otps; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.password_reset_otps (id, user_id, otp_hash, expires_at, attempts, used_at, created_at) FROM stdin;
\.


--
-- Data for Name: permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.permissions (id, code, description, created_at) FROM stdin;
1	dashboard.view	View dashboard	2026-09-26 12:03:28.449818+05:30
2	products.view	View products	2026-09-26 12:03:28.449818+05:30
3	products.create	Create products	2026-09-26 12:03:28.449818+05:30
4	products.update	Update products	2026-09-26 12:03:28.449818+05:30
5	categories.manage	Manage categories	2026-09-26 12:03:28.449818+05:30
6	reorder_rules.manage	Manage reorder rules	2026-09-26 12:03:28.449818+05:30
7	receipts.view	View receipts	2026-09-26 12:03:28.449818+05:30
8	receipts.create	Create receipts	2026-09-26 12:03:28.449818+05:30
9	receipts.update	Update receipts	2026-09-26 12:03:28.449818+05:30
10	receipts.validate	Validate receipts	2026-09-26 12:03:28.449818+05:30
11	deliveries.view	View delivery orders	2026-09-26 12:03:28.449818+05:30
12	deliveries.create	Create delivery orders	2026-09-26 12:03:28.449818+05:30
13	deliveries.update	Update delivery orders	2026-09-26 12:03:28.449818+05:30
14	deliveries.validate	Validate delivery orders	2026-09-26 12:03:28.449818+05:30
15	transfers.view	View internal transfers	2026-09-26 12:03:28.449818+05:30
16	transfers.create	Create internal transfers	2026-09-26 12:03:28.449818+05:30
17	transfers.validate	Validate internal transfers	2026-09-26 12:03:28.449818+05:30
18	adjustments.view	View stock adjustments	2026-09-26 12:03:28.449818+05:30
19	adjustments.create	Create stock adjustments	2026-09-26 12:03:28.449818+05:30
20	adjustments.validate	Validate stock adjustments	2026-09-26 12:03:28.449818+05:30
21	ledger.view	View stock ledger	2026-09-26 12:03:28.449818+05:30
22	warehouses.view	View warehouses	2026-09-26 12:03:28.449818+05:30
23	warehouses.manage	Manage warehouses	2026-09-26 12:03:28.449818+05:30
24	profile.view	View own profile	2026-09-26 12:03:28.449818+05:30
\.


--
-- Data for Name: suppliers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.suppliers (id, name, email, phone, address, is_active, created_at, updated_at) FROM stdin;
1	ABC Steel Suppliers	sales@abcsteel.com	+91-9000000001	Industrial Area	t	2026-09-26 12:19:46.628056+05:30	2026-09-26 12:19:46.628056+05:30
2	Global Packaging	sales@globalpack.com	+91-9000000002	Industrial Estate	t	2026-09-26 12:19:46.628056+05:30	2026-09-26 12:19:46.628056+05:30
\.


--
-- Data for Name: receipts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.receipts (id, reference, supplier_id, warehouse_id, status, notes, created_by, validated_by, validated_at, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: receipt_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.receipt_items (id, receipt_id, product_id, location_id, quantity, created_at) FROM stdin;
\.


--
-- Data for Name: reorder_rules; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.reorder_rules (id, product_id, location_id, minimum_quantity, maximum_quantity, reorder_quantity, is_active, created_at, updated_at) FROM stdin;
1	1	1	50.000	200.000	150.000	t	2026-09-26 12:19:27.885617+05:30	2026-09-26 12:19:27.885617+05:30
2	2	1	10.000	50.000	40.000	t	2026-09-26 12:19:27.885617+05:30	2026-09-26 12:19:27.885617+05:30
3	3	4	25.000	150.000	100.000	t	2026-09-26 12:19:27.885617+05:30	2026-09-26 12:19:27.885617+05:30
\.


--
-- Data for Name: role_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.role_permissions (role_id, permission_id) FROM stdin;
1	1
1	2
1	3
1	4
1	5
1	6
1	7
1	8
1	9
1	10
1	11
1	12
1	13
1	14
1	15
1	16
1	17
1	18
1	19
1	20
1	21
1	22
1	23
1	24
2	1
2	2
2	7
2	8
2	9
2	10
2	11
2	12
2	13
2	14
2	15
2	16
2	17
2	18
2	19
2	20
2	21
2	22
2	24
\.


--
-- Data for Name: stock; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.stock (id, product_id, location_id, quantity, reserved_quantity, created_at, updated_at) FROM stdin;
1	1	1	100.000	0.000	2026-09-26 12:19:05.328958+05:30	2026-09-26 12:19:05.328958+05:30
2	1	2	50.000	0.000	2026-09-26 12:19:05.328958+05:30	2026-09-26 12:19:05.328958+05:30
3	2	1	25.000	0.000	2026-09-26 12:19:05.328958+05:30	2026-09-26 12:19:05.328958+05:30
4	3	4	100.000	0.000	2026-09-26 12:19:05.328958+05:30	2026-09-26 12:19:05.328958+05:30
\.


--
-- Data for Name: stock_ledger; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.stock_ledger (id, product_id, operation_type, reference_type, reference_id, from_location_id, to_location_id, quantity, performed_by, created_at) FROM stdin;
\.


--
-- Data for Name: transfers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.transfers (id, reference, status, notes, created_by, validated_by, validated_at, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: transfer_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.transfer_items (id, transfer_id, product_id, from_location_id, to_location_id, quantity, created_at) FROM stdin;
\.


--
-- Name: adjustment_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.adjustment_items_id_seq', 1, false);


--
-- Name: adjustments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.adjustments_id_seq', 1, false);


--
-- Name: categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.categories_id_seq', 5, true);


--
-- Name: customers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.customers_id_seq', 6, true);


--
-- Name: delivery_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.delivery_items_id_seq', 1, false);


--
-- Name: delivery_orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.delivery_orders_id_seq', 1, false);


--
-- Name: locations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.locations_id_seq', 6, true);


--
-- Name: password_reset_otps_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.password_reset_otps_id_seq', 1, false);


--
-- Name: permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.permissions_id_seq', 24, true);


--
-- Name: products_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.products_id_seq', 4, true);


--
-- Name: receipt_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.receipt_items_id_seq', 1, false);


--
-- Name: receipts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.receipts_id_seq', 1, false);


--
-- Name: reorder_rules_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.reorder_rules_id_seq', 3, true);


--
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.roles_id_seq', 3, true);


--
-- Name: stock_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.stock_id_seq', 5, true);


--
-- Name: stock_ledger_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.stock_ledger_id_seq', 1, false);


--
-- Name: suppliers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.suppliers_id_seq', 2, true);


--
-- Name: transfer_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.transfer_items_id_seq', 1, true);


--
-- Name: transfers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.transfers_id_seq', 1, false);


--
-- Name: units_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.units_id_seq', 6, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 1, false);


--
-- Name: warehouses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.warehouses_id_seq', 2, true);


--
-- PostgreSQL database dump complete
--

\unrestrict bWJVFuZaZBP2Il3kBId576UlkH7AqAqoMC01s8ip33f3illlK22tdxbiZ9eBEh3

