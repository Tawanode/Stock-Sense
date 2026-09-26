--
-- PostgreSQL database dump
--

\restrict HQfWMkjiMsENbFRPeMtbIhn2e1fygdgDhCFvYagacdOZyrGDo1EnjVaqhgHc99Y

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
-- Name: citext; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS citext WITH SCHEMA public;


--
-- Name: EXTENSION citext; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION citext IS 'data type for case-insensitive character strings';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: operation_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.operation_status AS ENUM (
    'draft',
    'waiting',
    'ready',
    'done',
    'cancelled'
);


ALTER TYPE public.operation_status OWNER TO postgres;

--
-- Name: update_updated_at(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_updated_at() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: adjustment_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.adjustment_items (
    id bigint NOT NULL,
    adjustment_id bigint NOT NULL,
    product_id bigint NOT NULL,
    location_id bigint NOT NULL,
    system_quantity numeric(14,3) NOT NULL,
    counted_quantity numeric(14,3) NOT NULL,
    difference numeric(14,3) GENERATED ALWAYS AS ((counted_quantity - system_quantity)) STORED,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT adjustment_items_counted_quantity_check CHECK ((counted_quantity >= (0)::numeric)),
    CONSTRAINT adjustment_items_system_quantity_check CHECK ((system_quantity >= (0)::numeric))
);


ALTER TABLE public.adjustment_items OWNER TO postgres;

--
-- Name: adjustment_items_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.adjustment_items ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.adjustment_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: adjustments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.adjustments (
    id bigint NOT NULL,
    reference character varying(50) NOT NULL,
    status public.operation_status DEFAULT 'draft'::public.operation_status NOT NULL,
    reason text NOT NULL,
    created_by bigint NOT NULL,
    validated_by bigint,
    validated_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.adjustments OWNER TO postgres;

--
-- Name: adjustments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.adjustments ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.adjustments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.categories (
    id bigint NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.categories OWNER TO postgres;

--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.categories ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: customers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customers (
    id bigint NOT NULL,
    name character varying(150) NOT NULL,
    email public.citext,
    phone character varying(30),
    address text,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.customers OWNER TO postgres;

--
-- Name: customers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.customers ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.customers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: delivery_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.delivery_items (
    id bigint NOT NULL,
    delivery_id bigint NOT NULL,
    product_id bigint NOT NULL,
    location_id bigint NOT NULL,
    quantity numeric(14,3) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT delivery_items_quantity_check CHECK ((quantity > (0)::numeric))
);


ALTER TABLE public.delivery_items OWNER TO postgres;

--
-- Name: delivery_items_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.delivery_items ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.delivery_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: delivery_orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.delivery_orders (
    id bigint NOT NULL,
    reference character varying(50) NOT NULL,
    customer_id bigint NOT NULL,
    warehouse_id bigint NOT NULL,
    status public.operation_status DEFAULT 'draft'::public.operation_status NOT NULL,
    notes text,
    created_by bigint NOT NULL,
    validated_by bigint,
    validated_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.delivery_orders OWNER TO postgres;

--
-- Name: delivery_orders_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.delivery_orders ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.delivery_orders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: locations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.locations (
    id bigint NOT NULL,
    warehouse_id bigint NOT NULL,
    name character varying(120) NOT NULL,
    code character varying(50) NOT NULL,
    description text,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.locations OWNER TO postgres;

--
-- Name: locations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.locations ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.locations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: password_reset_otps; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.password_reset_otps (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    otp_hash text NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    attempts integer DEFAULT 0 NOT NULL,
    used_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT password_reset_otps_attempts_check CHECK ((attempts >= 0))
);


ALTER TABLE public.password_reset_otps OWNER TO postgres;

--
-- Name: password_reset_otps_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.password_reset_otps ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.password_reset_otps_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.permissions (
    id bigint NOT NULL,
    code character varying(100) NOT NULL,
    description text,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.permissions OWNER TO postgres;

--
-- Name: permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.permissions ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.products (
    id bigint NOT NULL,
    name character varying(150) NOT NULL,
    sku character varying(80) NOT NULL,
    category_id bigint NOT NULL,
    unit_id bigint NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.products OWNER TO postgres;

--
-- Name: products_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.products ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: receipt_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.receipt_items (
    id bigint NOT NULL,
    receipt_id bigint NOT NULL,
    product_id bigint NOT NULL,
    location_id bigint NOT NULL,
    quantity numeric(14,3) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT receipt_items_quantity_check CHECK ((quantity > (0)::numeric))
);


ALTER TABLE public.receipt_items OWNER TO postgres;

--
-- Name: receipt_items_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.receipt_items ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.receipt_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: receipts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.receipts (
    id bigint NOT NULL,
    reference character varying(50) NOT NULL,
    supplier_id bigint NOT NULL,
    warehouse_id bigint NOT NULL,
    status public.operation_status DEFAULT 'draft'::public.operation_status NOT NULL,
    notes text,
    created_by bigint NOT NULL,
    validated_by bigint,
    validated_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.receipts OWNER TO postgres;

--
-- Name: receipts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.receipts ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.receipts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: reorder_rules; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reorder_rules (
    id bigint NOT NULL,
    product_id bigint NOT NULL,
    location_id bigint NOT NULL,
    minimum_quantity numeric(14,3) NOT NULL,
    maximum_quantity numeric(14,3),
    reorder_quantity numeric(14,3) NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT reorder_rules_check CHECK (((maximum_quantity IS NULL) OR (maximum_quantity >= minimum_quantity))),
    CONSTRAINT reorder_rules_minimum_quantity_check CHECK ((minimum_quantity >= (0)::numeric)),
    CONSTRAINT reorder_rules_reorder_quantity_check CHECK ((reorder_quantity > (0)::numeric))
);


ALTER TABLE public.reorder_rules OWNER TO postgres;

--
-- Name: reorder_rules_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.reorder_rules ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.reorder_rules_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: role_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.role_permissions (
    role_id bigint NOT NULL,
    permission_id bigint NOT NULL
);


ALTER TABLE public.role_permissions OWNER TO postgres;

--
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    id bigint NOT NULL,
    name character varying(50) NOT NULL,
    description text,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.roles ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: stock; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stock (
    id bigint NOT NULL,
    product_id bigint NOT NULL,
    location_id bigint NOT NULL,
    quantity numeric(14,3) DEFAULT 0 NOT NULL,
    reserved_quantity numeric(14,3) DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT chk_reserved_not_greater_than_stock CHECK ((reserved_quantity <= quantity)),
    CONSTRAINT chk_reserved_quantity CHECK ((reserved_quantity >= (0)::numeric)),
    CONSTRAINT chk_stock_quantity CHECK ((quantity >= (0)::numeric))
);


ALTER TABLE public.stock OWNER TO postgres;

--
-- Name: stock_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.stock ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.stock_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: stock_ledger; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stock_ledger (
    id bigint NOT NULL,
    product_id bigint NOT NULL,
    operation_type character varying(30) NOT NULL,
    reference_type character varying(30) NOT NULL,
    reference_id bigint NOT NULL,
    from_location_id bigint,
    to_location_id bigint,
    quantity numeric(14,3) NOT NULL,
    performed_by bigint NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT stock_ledger_operation_type_check CHECK (((operation_type)::text = ANY ((ARRAY['receipt'::character varying, 'delivery'::character varying, 'transfer'::character varying, 'adjustment'::character varying, 'initial_stock'::character varying])::text[]))),
    CONSTRAINT stock_ledger_quantity_check CHECK ((quantity > (0)::numeric))
);


ALTER TABLE public.stock_ledger OWNER TO postgres;

--
-- Name: stock_ledger_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.stock_ledger ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.stock_ledger_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: suppliers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.suppliers (
    id bigint NOT NULL,
    name character varying(150) NOT NULL,
    email public.citext,
    phone character varying(30),
    address text,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.suppliers OWNER TO postgres;

--
-- Name: suppliers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.suppliers ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.suppliers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: transfer_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transfer_items (
    id bigint NOT NULL,
    transfer_id bigint NOT NULL,
    product_id bigint NOT NULL,
    from_location_id bigint NOT NULL,
    to_location_id bigint NOT NULL,
    quantity numeric(14,3) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT transfer_items_check CHECK ((from_location_id <> to_location_id)),
    CONSTRAINT transfer_items_quantity_check CHECK ((quantity > (0)::numeric))
);


ALTER TABLE public.transfer_items OWNER TO postgres;

--
-- Name: transfer_items_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.transfer_items ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.transfer_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: transfers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transfers (
    id bigint NOT NULL,
    reference character varying(50) NOT NULL,
    status public.operation_status DEFAULT 'draft'::public.operation_status NOT NULL,
    notes text,
    created_by bigint NOT NULL,
    validated_by bigint,
    validated_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.transfers OWNER TO postgres;

--
-- Name: transfers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.transfers ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.transfers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: units; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.units (
    id bigint NOT NULL,
    name character varying(50) NOT NULL,
    symbol character varying(20) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.units OWNER TO postgres;

--
-- Name: units_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.units ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.units_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    name character varying(120) NOT NULL,
    email public.citext NOT NULL,
    password_hash text NOT NULL,
    role_id bigint NOT NULL,
    warehouse_id bigint,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.users ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: warehouses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.warehouses (
    id bigint NOT NULL,
    name character varying(120) NOT NULL,
    code character varying(50) NOT NULL,
    address text,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.warehouses OWNER TO postgres;

--
-- Name: warehouses_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.warehouses ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.warehouses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: adjustment_items adjustment_items_adjustment_id_product_id_location_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adjustment_items
    ADD CONSTRAINT adjustment_items_adjustment_id_product_id_location_id_key UNIQUE (adjustment_id, product_id, location_id);


--
-- Name: adjustment_items adjustment_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adjustment_items
    ADD CONSTRAINT adjustment_items_pkey PRIMARY KEY (id);


--
-- Name: adjustments adjustments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adjustments
    ADD CONSTRAINT adjustments_pkey PRIMARY KEY (id);


--
-- Name: adjustments adjustments_reference_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adjustments
    ADD CONSTRAINT adjustments_reference_key UNIQUE (reference);


--
-- Name: categories categories_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_name_key UNIQUE (name);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (id);


--
-- Name: delivery_items delivery_items_delivery_id_product_id_location_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.delivery_items
    ADD CONSTRAINT delivery_items_delivery_id_product_id_location_id_key UNIQUE (delivery_id, product_id, location_id);


--
-- Name: delivery_items delivery_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.delivery_items
    ADD CONSTRAINT delivery_items_pkey PRIMARY KEY (id);


--
-- Name: delivery_orders delivery_orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.delivery_orders
    ADD CONSTRAINT delivery_orders_pkey PRIMARY KEY (id);


--
-- Name: delivery_orders delivery_orders_reference_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.delivery_orders
    ADD CONSTRAINT delivery_orders_reference_key UNIQUE (reference);


--
-- Name: locations locations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (id);


--
-- Name: locations locations_warehouse_id_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT locations_warehouse_id_code_key UNIQUE (warehouse_id, code);


--
-- Name: locations locations_warehouse_id_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT locations_warehouse_id_name_key UNIQUE (warehouse_id, name);


--
-- Name: password_reset_otps password_reset_otps_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.password_reset_otps
    ADD CONSTRAINT password_reset_otps_pkey PRIMARY KEY (id);


--
-- Name: permissions permissions_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_code_key UNIQUE (code);


--
-- Name: permissions permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: products products_sku_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_sku_key UNIQUE (sku);


--
-- Name: receipt_items receipt_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receipt_items
    ADD CONSTRAINT receipt_items_pkey PRIMARY KEY (id);


--
-- Name: receipt_items receipt_items_receipt_id_product_id_location_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receipt_items
    ADD CONSTRAINT receipt_items_receipt_id_product_id_location_id_key UNIQUE (receipt_id, product_id, location_id);


--
-- Name: receipts receipts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receipts
    ADD CONSTRAINT receipts_pkey PRIMARY KEY (id);


--
-- Name: receipts receipts_reference_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receipts
    ADD CONSTRAINT receipts_reference_key UNIQUE (reference);


--
-- Name: reorder_rules reorder_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reorder_rules
    ADD CONSTRAINT reorder_rules_pkey PRIMARY KEY (id);


--
-- Name: reorder_rules reorder_rules_product_id_location_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reorder_rules
    ADD CONSTRAINT reorder_rules_product_id_location_id_key UNIQUE (product_id, location_id);


--
-- Name: role_permissions role_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_pkey PRIMARY KEY (role_id, permission_id);


--
-- Name: roles roles_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_name_key UNIQUE (name);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: stock_ledger stock_ledger_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_ledger
    ADD CONSTRAINT stock_ledger_pkey PRIMARY KEY (id);


--
-- Name: stock stock_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock
    ADD CONSTRAINT stock_pkey PRIMARY KEY (id);


--
-- Name: suppliers suppliers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.suppliers
    ADD CONSTRAINT suppliers_pkey PRIMARY KEY (id);


--
-- Name: transfer_items transfer_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transfer_items
    ADD CONSTRAINT transfer_items_pkey PRIMARY KEY (id);


--
-- Name: transfer_items transfer_items_transfer_id_product_id_from_location_id_to_l_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transfer_items
    ADD CONSTRAINT transfer_items_transfer_id_product_id_from_location_id_to_l_key UNIQUE (transfer_id, product_id, from_location_id, to_location_id);


--
-- Name: transfers transfers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transfers
    ADD CONSTRAINT transfers_pkey PRIMARY KEY (id);


--
-- Name: transfers transfers_reference_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transfers
    ADD CONSTRAINT transfers_reference_key UNIQUE (reference);


--
-- Name: units units_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.units
    ADD CONSTRAINT units_name_key UNIQUE (name);


--
-- Name: units units_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.units
    ADD CONSTRAINT units_pkey PRIMARY KEY (id);


--
-- Name: units units_symbol_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.units
    ADD CONSTRAINT units_symbol_key UNIQUE (symbol);


--
-- Name: stock uq_stock_product_location; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock
    ADD CONSTRAINT uq_stock_product_location UNIQUE (product_id, location_id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: warehouses warehouses_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.warehouses
    ADD CONSTRAINT warehouses_code_key UNIQUE (code);


--
-- Name: warehouses warehouses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.warehouses
    ADD CONSTRAINT warehouses_pkey PRIMARY KEY (id);


--
-- Name: idx_adjustments_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_adjustments_created_at ON public.adjustments USING btree (created_at DESC);


--
-- Name: idx_adjustments_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_adjustments_status ON public.adjustments USING btree (status);


--
-- Name: idx_delivery_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_delivery_created_at ON public.delivery_orders USING btree (created_at DESC);


--
-- Name: idx_delivery_customer; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_delivery_customer ON public.delivery_orders USING btree (customer_id);


--
-- Name: idx_delivery_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_delivery_status ON public.delivery_orders USING btree (status);


--
-- Name: idx_ledger_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_ledger_created_at ON public.stock_ledger USING btree (created_at DESC);


--
-- Name: idx_ledger_from_location; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_ledger_from_location ON public.stock_ledger USING btree (from_location_id);


--
-- Name: idx_ledger_product; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_ledger_product ON public.stock_ledger USING btree (product_id);


--
-- Name: idx_ledger_reference; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_ledger_reference ON public.stock_ledger USING btree (reference_type, reference_id);


--
-- Name: idx_ledger_to_location; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_ledger_to_location ON public.stock_ledger USING btree (to_location_id);


--
-- Name: idx_password_reset_otps_expiry; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_password_reset_otps_expiry ON public.password_reset_otps USING btree (expires_at);


--
-- Name: idx_password_reset_otps_user; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_password_reset_otps_user ON public.password_reset_otps USING btree (user_id);


--
-- Name: idx_products_category; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_products_category ON public.products USING btree (category_id);


--
-- Name: idx_products_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_products_name ON public.products USING btree (name);


--
-- Name: idx_products_sku; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_products_sku ON public.products USING btree (sku);


--
-- Name: idx_receipts_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_receipts_created_at ON public.receipts USING btree (created_at DESC);


--
-- Name: idx_receipts_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_receipts_status ON public.receipts USING btree (status);


--
-- Name: idx_receipts_supplier; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_receipts_supplier ON public.receipts USING btree (supplier_id);


--
-- Name: idx_stock_location; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_stock_location ON public.stock USING btree (location_id);


--
-- Name: idx_stock_product; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_stock_product ON public.stock USING btree (product_id);


--
-- Name: idx_stock_product_location; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_stock_product_location ON public.stock USING btree (product_id, location_id);


--
-- Name: idx_transfers_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_transfers_created_at ON public.transfers USING btree (created_at DESC);


--
-- Name: idx_transfers_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_transfers_status ON public.transfers USING btree (status);


--
-- Name: adjustments trg_adjustments_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_adjustments_updated_at BEFORE UPDATE ON public.adjustments FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();


--
-- Name: categories trg_categories_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_categories_updated_at BEFORE UPDATE ON public.categories FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();


--
-- Name: customers trg_customers_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_customers_updated_at BEFORE UPDATE ON public.customers FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();


--
-- Name: delivery_orders trg_delivery_orders_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_delivery_orders_updated_at BEFORE UPDATE ON public.delivery_orders FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();


--
-- Name: locations trg_locations_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_locations_updated_at BEFORE UPDATE ON public.locations FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();


--
-- Name: products trg_products_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_products_updated_at BEFORE UPDATE ON public.products FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();


--
-- Name: receipts trg_receipts_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_receipts_updated_at BEFORE UPDATE ON public.receipts FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();


--
-- Name: reorder_rules trg_reorder_rules_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_reorder_rules_updated_at BEFORE UPDATE ON public.reorder_rules FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();


--
-- Name: stock trg_stock_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_stock_updated_at BEFORE UPDATE ON public.stock FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();


--
-- Name: suppliers trg_suppliers_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_suppliers_updated_at BEFORE UPDATE ON public.suppliers FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();


--
-- Name: transfers trg_transfers_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_transfers_updated_at BEFORE UPDATE ON public.transfers FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();


--
-- Name: users trg_users_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_users_updated_at BEFORE UPDATE ON public.users FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();


--
-- Name: warehouses trg_warehouses_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_warehouses_updated_at BEFORE UPDATE ON public.warehouses FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();


--
-- Name: adjustment_items adjustment_items_adjustment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adjustment_items
    ADD CONSTRAINT adjustment_items_adjustment_id_fkey FOREIGN KEY (adjustment_id) REFERENCES public.adjustments(id) ON DELETE CASCADE;


--
-- Name: adjustment_items adjustment_items_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adjustment_items
    ADD CONSTRAINT adjustment_items_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.locations(id) ON DELETE RESTRICT;


--
-- Name: adjustment_items adjustment_items_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adjustment_items
    ADD CONSTRAINT adjustment_items_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE RESTRICT;


--
-- Name: adjustments adjustments_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adjustments
    ADD CONSTRAINT adjustments_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE RESTRICT;


--
-- Name: adjustments adjustments_validated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adjustments
    ADD CONSTRAINT adjustments_validated_by_fkey FOREIGN KEY (validated_by) REFERENCES public.users(id) ON DELETE RESTRICT;


--
-- Name: delivery_items delivery_items_delivery_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.delivery_items
    ADD CONSTRAINT delivery_items_delivery_id_fkey FOREIGN KEY (delivery_id) REFERENCES public.delivery_orders(id) ON DELETE CASCADE;


--
-- Name: delivery_items delivery_items_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.delivery_items
    ADD CONSTRAINT delivery_items_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.locations(id) ON DELETE RESTRICT;


--
-- Name: delivery_items delivery_items_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.delivery_items
    ADD CONSTRAINT delivery_items_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE RESTRICT;


--
-- Name: delivery_orders delivery_orders_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.delivery_orders
    ADD CONSTRAINT delivery_orders_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE RESTRICT;


--
-- Name: delivery_orders delivery_orders_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.delivery_orders
    ADD CONSTRAINT delivery_orders_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(id) ON DELETE RESTRICT;


--
-- Name: delivery_orders delivery_orders_validated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.delivery_orders
    ADD CONSTRAINT delivery_orders_validated_by_fkey FOREIGN KEY (validated_by) REFERENCES public.users(id) ON DELETE RESTRICT;


--
-- Name: delivery_orders delivery_orders_warehouse_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.delivery_orders
    ADD CONSTRAINT delivery_orders_warehouse_id_fkey FOREIGN KEY (warehouse_id) REFERENCES public.warehouses(id) ON DELETE RESTRICT;


--
-- Name: users fk_users_warehouse; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_users_warehouse FOREIGN KEY (warehouse_id) REFERENCES public.warehouses(id) ON DELETE SET NULL;


--
-- Name: locations locations_warehouse_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT locations_warehouse_id_fkey FOREIGN KEY (warehouse_id) REFERENCES public.warehouses(id) ON DELETE RESTRICT;


--
-- Name: password_reset_otps password_reset_otps_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.password_reset_otps
    ADD CONSTRAINT password_reset_otps_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: products products_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.categories(id) ON DELETE RESTRICT;


--
-- Name: products products_unit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_unit_id_fkey FOREIGN KEY (unit_id) REFERENCES public.units(id) ON DELETE RESTRICT;


--
-- Name: receipt_items receipt_items_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receipt_items
    ADD CONSTRAINT receipt_items_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.locations(id) ON DELETE RESTRICT;


--
-- Name: receipt_items receipt_items_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receipt_items
    ADD CONSTRAINT receipt_items_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE RESTRICT;


--
-- Name: receipt_items receipt_items_receipt_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receipt_items
    ADD CONSTRAINT receipt_items_receipt_id_fkey FOREIGN KEY (receipt_id) REFERENCES public.receipts(id) ON DELETE CASCADE;


--
-- Name: receipts receipts_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receipts
    ADD CONSTRAINT receipts_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE RESTRICT;


--
-- Name: receipts receipts_supplier_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receipts
    ADD CONSTRAINT receipts_supplier_id_fkey FOREIGN KEY (supplier_id) REFERENCES public.suppliers(id) ON DELETE RESTRICT;


--
-- Name: receipts receipts_validated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receipts
    ADD CONSTRAINT receipts_validated_by_fkey FOREIGN KEY (validated_by) REFERENCES public.users(id) ON DELETE RESTRICT;


--
-- Name: receipts receipts_warehouse_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receipts
    ADD CONSTRAINT receipts_warehouse_id_fkey FOREIGN KEY (warehouse_id) REFERENCES public.warehouses(id) ON DELETE RESTRICT;


--
-- Name: reorder_rules reorder_rules_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reorder_rules
    ADD CONSTRAINT reorder_rules_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.locations(id) ON DELETE CASCADE;


--
-- Name: reorder_rules reorder_rules_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reorder_rules
    ADD CONSTRAINT reorder_rules_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- Name: role_permissions role_permissions_permission_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_permission_id_fkey FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE;


--
-- Name: role_permissions role_permissions_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;


--
-- Name: stock_ledger stock_ledger_from_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_ledger
    ADD CONSTRAINT stock_ledger_from_location_id_fkey FOREIGN KEY (from_location_id) REFERENCES public.locations(id) ON DELETE RESTRICT;


--
-- Name: stock_ledger stock_ledger_performed_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_ledger
    ADD CONSTRAINT stock_ledger_performed_by_fkey FOREIGN KEY (performed_by) REFERENCES public.users(id) ON DELETE RESTRICT;


--
-- Name: stock_ledger stock_ledger_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_ledger
    ADD CONSTRAINT stock_ledger_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE RESTRICT;


--
-- Name: stock_ledger stock_ledger_to_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_ledger
    ADD CONSTRAINT stock_ledger_to_location_id_fkey FOREIGN KEY (to_location_id) REFERENCES public.locations(id) ON DELETE RESTRICT;


--
-- Name: stock stock_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock
    ADD CONSTRAINT stock_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.locations(id) ON DELETE RESTRICT;


--
-- Name: stock stock_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock
    ADD CONSTRAINT stock_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE RESTRICT;


--
-- Name: transfer_items transfer_items_from_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transfer_items
    ADD CONSTRAINT transfer_items_from_location_id_fkey FOREIGN KEY (from_location_id) REFERENCES public.locations(id) ON DELETE RESTRICT;


--
-- Name: transfer_items transfer_items_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transfer_items
    ADD CONSTRAINT transfer_items_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE RESTRICT;


--
-- Name: transfer_items transfer_items_to_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transfer_items
    ADD CONSTRAINT transfer_items_to_location_id_fkey FOREIGN KEY (to_location_id) REFERENCES public.locations(id) ON DELETE RESTRICT;


--
-- Name: transfer_items transfer_items_transfer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transfer_items
    ADD CONSTRAINT transfer_items_transfer_id_fkey FOREIGN KEY (transfer_id) REFERENCES public.transfers(id) ON DELETE CASCADE;


--
-- Name: transfers transfers_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transfers
    ADD CONSTRAINT transfers_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE RESTRICT;


--
-- Name: transfers transfers_validated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transfers
    ADD CONSTRAINT transfers_validated_by_fkey FOREIGN KEY (validated_by) REFERENCES public.users(id) ON DELETE RESTRICT;


--
-- Name: users users_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id);


--
-- PostgreSQL database dump complete
--

\unrestrict HQfWMkjiMsENbFRPeMtbIhn2e1fygdgDhCFvYagacdOZyrGDo1EnjVaqhgHc99Y

