--
-- PostgreSQL database dump
--

-- Dumped from database version 16.9
-- Dumped by pg_dump version 16.9

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: address; Type: TABLE; Schema: public; Owner: vendure
--

CREATE TABLE public.address (
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL,
    "fullName" character varying DEFAULT ''::character varying NOT NULL,
    company character varying DEFAULT ''::character varying NOT NULL,
    "streetLine1" character varying NOT NULL,
    "streetLine2" character varying DEFAULT ''::character varying NOT NULL,
    city character varying DEFAULT ''::character varying NOT NULL,
    province character varying DEFAULT ''::character varying NOT NULL,
    "postalCode" character varying DEFAULT ''::character varying NOT NULL,
    "phoneNumber" character varying DEFAULT ''::character varying NOT NULL,
    "defaultShippingAddress" boolean DEFAULT false NOT NULL,
    "defaultBillingAddress" boolean DEFAULT false NOT NULL,
    id integer NOT NULL,
    "customerId" integer,
    "countryId" integer
);


ALTER TABLE public.address OWNER TO vendure;

--
-- Name: address_id_seq; Type: SEQUENCE; Schema: public; Owner: vendure
--

CREATE SEQUENCE public.address_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.address_id_seq OWNER TO vendure;

--
-- Name: address_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vendure
--

ALTER SEQUENCE public.address_id_seq OWNED BY public.address.id;


--
-- Name: administrator; Type: TABLE; Schema: public; Owner: vendure
--

CREATE TABLE public.administrator (
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL,
    "deletedAt" timestamp without time zone,
    "firstName" character varying NOT NULL,
    "lastName" character varying NOT NULL,
    "emailAddress" character varying NOT NULL,
    id integer NOT NULL,
    "userId" integer
);


ALTER TABLE public.administrator OWNER TO vendure;

--
-- Name: administrator_id_seq; Type: SEQUENCE; Schema: public; Owner: vendure
--

CREATE SEQUENCE public.administrator_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.administrator_id_seq OWNER TO vendure;

--
-- Name: administrator_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vendure
--

ALTER SEQUENCE public.administrator_id_seq OWNED BY public.administrator.id;


--
-- Name: asset; Type: TABLE; Schema: public; Owner: vendure
--

CREATE TABLE public.asset (
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL,
    name character varying NOT NULL,
    type character varying NOT NULL,
    "mimeType" character varying NOT NULL,
    width integer DEFAULT 0 NOT NULL,
    height integer DEFAULT 0 NOT NULL,
    "fileSize" integer NOT NULL,
    source character varying NOT NULL,
    preview character varying NOT NULL,
    "focalPoint" text,
    id integer NOT NULL
);


ALTER TABLE public.asset OWNER TO vendure;

--
-- Name: asset_channels_channel; Type: TABLE; Schema: public; Owner: vendure
--

CREATE TABLE public.asset_channels_channel (
    "assetId" integer NOT NULL,
    "channelId" integer NOT NULL
);


ALTER TABLE public.asset_channels_channel OWNER TO vendure;

--
-- Name: asset_id_seq; Type: SEQUENCE; Schema: public; Owner: vendure
--

CREATE SEQUENCE public.asset_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.asset_id_seq OWNER TO vendure;

--
-- Name: asset_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vendure
--

ALTER SEQUENCE public.asset_id_seq OWNED BY public.asset.id;


--
-- Name: asset_tags_tag; Type: TABLE; Schema: public; Owner: vendure
--

CREATE TABLE public.asset_tags_tag (
    "assetId" integer NOT NULL,
    "tagId" integer NOT NULL
);


ALTER TABLE public.asset_tags_tag OWNER TO vendure;

--
-- Name: authentication_method; Type: TABLE; Schema: public; Owner: vendure
--

CREATE TABLE public.authentication_method (
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL,
    identifier character varying,
    "passwordHash" character varying,
    "verificationToken" character varying,
    "passwordResetToken" character varying,
    "identifierChangeToken" character varying,
    "pendingIdentifier" character varying,
    strategy character varying,
    "externalIdentifier" character varying,
    metadata text,
    id integer NOT NULL,
    type character varying NOT NULL,
    "userId" integer
);


ALTER TABLE public.authentication_method OWNER TO vendure;

--
-- Name: authentication_method_id_seq; Type: SEQUENCE; Schema: public; Owner: vendure
--

CREATE SEQUENCE public.authentication_method_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.authentication_method_id_seq OWNER TO vendure;

--
-- Name: authentication_method_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vendure
--

ALTER SEQUENCE public.authentication_method_id_seq OWNED BY public.authentication_method.id;


--
-- Name: channel; Type: TABLE; Schema: public; Owner: vendure
--

CREATE TABLE public.channel (
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL,
    code character varying NOT NULL,
    token character varying NOT NULL,
    description character varying DEFAULT ''::character varying,
    "defaultLanguageCode" character varying NOT NULL,
    "availableLanguageCodes" text,
    "defaultCurrencyCode" character varying NOT NULL,
    "availableCurrencyCodes" text,
    "trackInventory" boolean DEFAULT true NOT NULL,
    "outOfStockThreshold" integer DEFAULT 0 NOT NULL,
    "pricesIncludeTax" boolean NOT NULL,
    id integer NOT NULL,
    "sellerId" integer,
    "defaultTaxZoneId" integer,
    "defaultShippingZoneId" integer
);


ALTER TABLE public.channel OWNER TO vendure;

--
-- Name: channel_id_seq; Type: SEQUENCE; Schema: public; Owner: vendure
--

CREATE SEQUENCE public.channel_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.channel_id_seq OWNER TO vendure;

--
-- Name: channel_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vendure
--

ALTER SEQUENCE public.channel_id_seq OWNED BY public.channel.id;


--
-- Name: collection; Type: TABLE; Schema: public; Owner: vendure
--

CREATE TABLE public.collection (
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL,
    "isRoot" boolean DEFAULT false NOT NULL,
    "position" integer NOT NULL,
    "isPrivate" boolean DEFAULT false NOT NULL,
    filters text NOT NULL,
    "inheritFilters" boolean DEFAULT true NOT NULL,
    id integer NOT NULL,
    "parentId" integer,
    "featuredAssetId" integer
);


ALTER TABLE public.collection OWNER TO vendure;

--
-- Name: collection_asset; Type: TABLE; Schema: public; Owner: vendure
--

CREATE TABLE public.collection_asset (
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL,
    "assetId" integer NOT NULL,
    "position" integer NOT NULL,
    "collectionId" integer NOT NULL,
    id integer NOT NULL
);


ALTER TABLE public.collection_asset OWNER TO vendure;

--
-- Name: collection_asset_id_seq; Type: SEQUENCE; Schema: public; Owner: vendure
--

CREATE SEQUENCE public.collection_asset_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.collection_asset_id_seq OWNER TO vendure;

--
-- Name: collection_asset_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vendure
--

ALTER SEQUENCE public.collection_asset_id_seq OWNED BY public.collection_asset.id;


--
-- Name: collection_channels_channel; Type: TABLE; Schema: public; Owner: vendure
--

CREATE TABLE public.collection_channels_channel (
    "collectionId" integer NOT NULL,
    "channelId" integer NOT NULL
);


ALTER TABLE public.collection_channels_channel OWNER TO vendure;

--
-- Name: collection_closure; Type: TABLE; Schema: public; Owner: vendure
--

CREATE TABLE public.collection_closure (
    id_ancestor integer NOT NULL,
    id_descendant integer NOT NULL
);


ALTER TABLE public.collection_closure OWNER TO vendure;

--
-- Name: collection_id_seq; Type: SEQUENCE; Schema: public; Owner: vendure
--

CREATE SEQUENCE public.collection_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.collection_id_seq OWNER TO vendure;

--
-- Name: collection_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vendure
--

ALTER SEQUENCE public.collection_id_seq OWNED BY public.collection.id;


--
-- Name: collection_product_variants_product_variant; Type: TABLE; Schema: public; Owner: vendure
--

CREATE TABLE public.collection_product_variants_product_variant (
    "collectionId" integer NOT NULL,
    "productVariantId" integer NOT NULL
);


ALTER TABLE public.collection_product_variants_product_variant OWNER TO vendure;

--
-- Name: collection_translation; Type: TABLE; Schema: public; Owner: vendure
--

CREATE TABLE public.collection_translation (
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL,
    "languageCode" character varying NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    description text NOT NULL,
    id integer NOT NULL,
    "baseId" integer
);


ALTER TABLE public.collection_translation OWNER TO vendure;

--
-- Name: collection_translation_id_seq; Type: SEQUENCE; Schema: public; Owner: vendure
--

CREATE SEQUENCE public.collection_translation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.collection_translation_id_seq OWNER TO vendure;

--
-- Name: collection_translation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vendure
--

ALTER SEQUENCE public.collection_translation_id_seq OWNED BY public.collection_translation.id;


--
-- Name: customer; Type: TABLE; Schema: public; Owner: vendure
--

CREATE TABLE public.customer (
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL,
    "deletedAt" timestamp without time zone,
    title character varying,
    "firstName" character varying NOT NULL,
    "lastName" character varying NOT NULL,
    "phoneNumber" character varying,
    "emailAddress" character varying NOT NULL,
    id integer NOT NULL,
    "userId" integer
);


ALTER TABLE public.customer OWNER TO vendure;

--
-- Name: customer_channels_channel; Type: TABLE; Schema: public; Owner: vendure
--

CREATE TABLE public.customer_channels_channel (
    "customerId" integer NOT NULL,
    "channelId" integer NOT NULL
);


ALTER TABLE public.customer_channels_channel OWNER TO vendure;

--
-- Name: customer_group; Type: TABLE; Schema: public; Owner: vendure
--

CREATE TABLE public.customer_group (
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL,
    name character varying NOT NULL,
    id integer NOT NULL
);


ALTER TABLE public.customer_group OWNER TO vendure;

--
-- Name: customer_group_id_seq; Type: SEQUENCE; Schema: public; Owner: vendure
--

CREATE SEQUENCE public.customer_group_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.customer_group_id_seq OWNER TO vendure;

--
-- Name: customer_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vendure
--

ALTER SEQUENCE public.customer_group_id_seq OWNED BY public.customer_group.id;


--
-- Name: customer_groups_customer_group; Type: TABLE; Schema: public; Owner: vendure
--

CREATE TABLE public.customer_groups_customer_group (
    "customerId" integer NOT NULL,
    "customerGroupId" integer NOT NULL
);


ALTER TABLE public.customer_groups_customer_group OWNER TO vendure;

--
-- Name: customer_id_seq; Type: SEQUENCE; Schema: public; Owner: vendure
--

CREATE SEQUENCE public.customer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.customer_id_seq OWNER TO vendure;

--
-- Name: customer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vendure
--

ALTER SEQUENCE public.customer_id_seq OWNED BY public.customer.id;


--
-- Name: facet; Type: TABLE; Schema: public; Owner: vendure
--

CREATE TABLE public.facet (
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL,
    "isPrivate" boolean DEFAULT false NOT NULL,
    code character varying NOT NULL,
    id integer NOT NULL
);


ALTER TABLE public.facet OWNER TO vendure;

--
-- Name: facet_channels_channel; Type: TABLE; Schema: public; Owner: vendure
--

CREATE TABLE public.facet_channels_channel (
    "facetId" integer NOT NULL,
    "channelId" integer NOT NULL
);


ALTER TABLE public.facet_channels_channel OWNER TO vendure;

--
-- Name: facet_id_seq; Type: SEQUENCE; Schema: public; Owner: vendure
--

CREATE SEQUENCE public.facet_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.facet_id_seq OWNER TO vendure;

--
-- Name: facet_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vendure
--

ALTER SEQUENCE public.facet_id_seq OWNED BY public.facet.id;


--
-- Name: facet_translation; Type: TABLE; Schema: public; Owner: vendure
--

CREATE TABLE public.facet_translation (
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL,
    "languageCode" character varying NOT NULL,
    name character varying NOT NULL,
    id integer NOT NULL,
    "baseId" integer
);


ALTER TABLE public.facet_translation OWNER TO vendure;

--
-- Name: facet_translation_id_seq; Type: SEQUENCE; Schema: public; Owner: vendure
--

CREATE SEQUENCE public.facet_translation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.facet_translation_id_seq OWNER TO vendure;

--
-- Name: facet_translation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vendure
--

ALTER SEQUENCE public.facet_translation_id_seq OWNED BY public.facet_translation.id;


--
-- Name: facet_value; Type: TABLE; Schema: public; Owner: vendure
--

CREATE TABLE public.facet_value (
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL,
    code character varying NOT NULL,
    id integer NOT NULL,
    "facetId" integer NOT NULL
);


ALTER TABLE public.facet_value OWNER TO vendure;

--
-- Name: facet_value_channels_channel; Type: TABLE; Schema: public; Owner: vendure
--

CREATE TABLE public.facet_value_channels_channel (
    "facetValueId" integer NOT NULL,
    "channelId" integer NOT NULL
);


ALTER TABLE public.facet_value_channels_channel OWNER TO vendure;

--
-- Name: facet_value_id_seq; Type: SEQUENCE; Schema: public; Owner: vendure
--

CREATE SEQUENCE public.facet_value_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.facet_value_id_seq OWNER TO vendure;

--
-- Name: facet_value_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vendure
--

ALTER SEQUENCE public.facet_value_id_seq OWNED BY public.facet_value.id;


--
-- Name: facet_value_translation; Type: TABLE; Schema: public; Owner: vendure
--

CREATE TABLE public.facet_value_translation (
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL,
    "languageCode" character varying NOT NULL,
    name character varying NOT NULL,
    id integer NOT NULL,
    "baseId" integer
);


ALTER TABLE public.facet_value_translation OWNER TO vendure;

--
-- Name: facet_value_translation_id_seq; Type: SEQUENCE; Schema: public; Owner: vendure
--

CREATE SEQUENCE public.facet_value_translation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.facet_value_translation_id_seq OWNER TO vendure;

--
-- Name: facet_value_translation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vendure
--

ALTER SEQUENCE public.facet_value_translation_id_seq OWNED BY public.facet_value_translation.id;


--
-- Name: fulfillment; Type: TABLE; Schema: public; Owner: vendure
--

CREATE TABLE public.fulfillment (
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL,
    state character varying NOT NULL,
    "trackingCode" character varying DEFAULT ''::character varying NOT NULL,
    method character varying NOT NULL,
    "handlerCode" character varying NOT NULL,
    id integer NOT NULL
);


ALTER TABLE public.fulfillment OWNER TO vendure;

--
-- Name: fulfillment_id_seq; Type: SEQUENCE; Schema: public; Owner: vendure
--

CREATE SEQUENCE public.fulfillment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.fulfillment_id_seq OWNER TO vendure;

--
-- Name: fulfillment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vendure
--

ALTER SEQUENCE public.fulfillment_id_seq OWNED BY public.fulfillment.id;


--
-- Name: global_settings; Type: TABLE; Schema: public; Owner: vendure
--

CREATE TABLE public.global_settings (
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL,
    "availableLanguages" text NOT NULL,
    "trackInventory" boolean DEFAULT true NOT NULL,
    "outOfStockThreshold" integer DEFAULT 0 NOT NULL,
    id integer NOT NULL
);


ALTER TABLE public.global_settings OWNER TO vendure;

--
-- Name: global_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: vendure
--

CREATE SEQUENCE public.global_settings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.global_settings_id_seq OWNER TO vendure;

--
-- Name: global_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vendure
--

ALTER SEQUENCE public.global_settings_id_seq OWNED BY public.global_settings.id;


--
-- Name: history_entry; Type: TABLE; Schema: public; Owner: vendure
--

CREATE TABLE public.history_entry (
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL,
    type character varying NOT NULL,
    "isPublic" boolean NOT NULL,
    data text NOT NULL,
    id integer NOT NULL,
    discriminator character varying NOT NULL,
    "administratorId" integer,
    "customerId" integer,
    "orderId" integer
);


ALTER TABLE public.history_entry OWNER TO vendure;

--
-- Name: history_entry_id_seq; Type: SEQUENCE; Schema: public; Owner: vendure
--

CREATE SEQUENCE public.history_entry_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.history_entry_id_seq OWNER TO vendure;

--
-- Name: history_entry_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vendure
--

ALTER SEQUENCE public.history_entry_id_seq OWNED BY public.history_entry.id;


--
-- Name: job_record; Type: TABLE; Schema: public; Owner: vendure
--

CREATE TABLE public.job_record (
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL,
    "queueName" character varying NOT NULL,
    data text,
    state character varying NOT NULL,
    progress integer NOT NULL,
    result text,
    error character varying,
    "startedAt" timestamp(6) without time zone,
    "settledAt" timestamp(6) without time zone,
    "isSettled" boolean NOT NULL,
    retries integer NOT NULL,
    attempts integer NOT NULL,
    id integer NOT NULL
);


ALTER TABLE public.job_record OWNER TO vendure;

--
-- Name: job_record_buffer; Type: TABLE; Schema: public; Owner: vendure
--

CREATE TABLE public.job_record_buffer (
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL,
    "bufferId" character varying NOT NULL,
    job text NOT NULL,
    id integer NOT NULL
);


ALTER TABLE public.job_record_buffer OWNER TO vendure;

--
-- Name: job_record_buffer_id_seq; Type: SEQUENCE; Schema: public; Owner: vendure
--

CREATE SEQUENCE public.job_record_buffer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.job_record_buffer_id_seq OWNER TO vendure;

--
-- Name: job_record_buffer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vendure
--

ALTER SEQUENCE public.job_record_buffer_id_seq OWNED BY public.job_record_buffer.id;


--
-- Name: job_record_id_seq; Type: SEQUENCE; Schema: public; Owner: vendure
--

CREATE SEQUENCE public.job_record_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.job_record_id_seq OWNER TO vendure;

--
-- Name: job_record_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vendure
--

ALTER SEQUENCE public.job_record_id_seq OWNED BY public.job_record.id;


--
-- Name: migrations; Type: TABLE; Schema: public; Owner: vendure
--

CREATE TABLE public.migrations (
    id integer NOT NULL,
    "timestamp" bigint NOT NULL,
    name character varying NOT NULL
);


ALTER TABLE public.migrations OWNER TO vendure;

--
-- Name: migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: vendure
--

CREATE SEQUENCE public.migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.migrations_id_seq OWNER TO vendure;

--
-- Name: migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vendure
--

ALTER SEQUENCE public.migrations_id_seq OWNED BY public.migrations.id;


--
-- Name: order; Type: TABLE; Schema: public; Owner: vendure
--

CREATE TABLE public."order" (
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL,
    type character varying DEFAULT 'Regular'::character varying NOT NULL,
    code character varying NOT NULL,
    state character varying NOT NULL,
    active boolean DEFAULT true NOT NULL,
    "orderPlacedAt" timestamp without time zone,
    "couponCodes" text NOT NULL,
    "shippingAddress" text NOT NULL,
    "billingAddress" text NOT NULL,
    "currencyCode" character varying NOT NULL,
    id integer NOT NULL,
    "aggregateOrderId" integer,
    "customerId" integer,
    "taxZoneId" integer,
    "subTotal" integer NOT NULL,
    "subTotalWithTax" integer NOT NULL,
    shipping integer DEFAULT 0 NOT NULL,
    "shippingWithTax" integer DEFAULT 0 NOT NULL
);


ALTER TABLE public."order" OWNER TO vendure;

--
-- Name: order_channels_channel; Type: TABLE; Schema: public; Owner: vendure
--

CREATE TABLE public.order_channels_channel (
    "orderId" integer NOT NULL,
    "channelId" integer NOT NULL
);


ALTER TABLE public.order_channels_channel OWNER TO vendure;

--
-- Name: order_fulfillments_fulfillment; Type: TABLE; Schema: public; Owner: vendure
--

CREATE TABLE public.order_fulfillments_fulfillment (
    "orderId" integer NOT NULL,
    "fulfillmentId" integer NOT NULL
);


ALTER TABLE public.order_fulfillments_fulfillment OWNER TO vendure;

--
-- Name: order_id_seq; Type: SEQUENCE; Schema: public; Owner: vendure
--

CREATE SEQUENCE public.order_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.order_id_seq OWNER TO vendure;

--
-- Name: order_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vendure
--

ALTER SEQUENCE public.order_id_seq OWNED BY public."order".id;


--
-- Name: order_line; Type: TABLE; Schema: public; Owner: vendure
--

CREATE TABLE public.order_line (
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL,
    quantity integer NOT NULL,
    "orderPlacedQuantity" integer DEFAULT 0 NOT NULL,
    "listPriceIncludesTax" boolean NOT NULL,
    adjustments text NOT NULL,
    "taxLines" text NOT NULL,
    id integer NOT NULL,
    "sellerChannelId" integer,
    "shippingLineId" integer,
    "productVariantId" integer NOT NULL,
    "taxCategoryId" integer,
    "initialListPrice" integer,
    "listPrice" integer NOT NULL,
    "featuredAssetId" integer,
    "orderId" integer
);


ALTER TABLE public.order_line OWNER TO vendure;

--
-- Name: order_line_id_seq; Type: SEQUENCE; Schema: public; Owner: vendure
--

CREATE SEQUENCE public.order_line_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.order_line_id_seq OWNER TO vendure;

--
-- Name: order_line_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vendure
--

ALTER SEQUENCE public.order_line_id_seq OWNED BY public.order_line.id;


--
-- Name: order_line_reference; Type: TABLE; Schema: public; Owner: vendure
--

CREATE TABLE public.order_line_reference (
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL,
    quantity integer NOT NULL,
    id integer NOT NULL,
    "fulfillmentId" integer,
    "modificationId" integer,
    "orderLineId" integer NOT NULL,
    "refundId" integer,
    discriminator character varying NOT NULL
);


ALTER TABLE public.order_line_reference OWNER TO vendure;

--
-- Name: order_line_reference_id_seq; Type: SEQUENCE; Schema: public; Owner: vendure
--

CREATE SEQUENCE public.order_line_reference_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.order_line_reference_id_seq OWNER TO vendure;

--
-- Name: order_line_reference_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vendure
--

ALTER SEQUENCE public.order_line_reference_id_seq OWNED BY public.order_line_reference.id;


--
-- Name: order_modification; Type: TABLE; Schema: public; Owner: vendure
--

CREATE TABLE public.order_modification (
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL,
    note character varying NOT NULL,
    "shippingAddressChange" text,
    "billingAddressChange" text,
    id integer NOT NULL,
    "priceChange" integer NOT NULL,
    "orderId" integer,
    "paymentId" integer,
    "refundId" integer
);


ALTER TABLE public.order_modification OWNER TO vendure;

--
-- Name: order_modification_id_seq; Type: SEQUENCE; Schema: public; Owner: vendure
--

CREATE SEQUENCE public.order_modification_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.order_modification_id_seq OWNER TO vendure;

--
-- Name: order_modification_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vendure
--

ALTER SEQUENCE public.order_modification_id_seq OWNED BY public.order_modification.id;


--
-- Name: order_promotions_promotion; Type: TABLE; Schema: public; Owner: vendure
--

CREATE TABLE public.order_promotions_promotion (
    "orderId" integer NOT NULL,
    "promotionId" integer NOT NULL
);


ALTER TABLE public.order_promotions_promotion OWNER TO vendure;

--
-- Name: payment; Type: TABLE; Schema: public; Owner: vendure
--

CREATE TABLE public.payment (
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL,
    method character varying NOT NULL,
    state character varying NOT NULL,
    "errorMessage" character varying,
    "transactionId" character varying,
    metadata text NOT NULL,
    id integer NOT NULL,
    amount integer NOT NULL,
    "orderId" integer
);


ALTER TABLE public.payment OWNER TO vendure;

--
-- Name: payment_id_seq; Type: SEQUENCE; Schema: public; Owner: vendure
--

CREATE SEQUENCE public.payment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.payment_id_seq OWNER TO vendure;

--
-- Name: payment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vendure
--

ALTER SEQUENCE public.payment_id_seq OWNED BY public.payment.id;


--
-- Name: payment_method; Type: TABLE; Schema: public; Owner: vendure
--

CREATE TABLE public.payment_method (
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL,
    code character varying DEFAULT ''::character varying NOT NULL,
    enabled boolean NOT NULL,
    checker text,
    handler text NOT NULL,
    id integer NOT NULL
);


ALTER TABLE public.payment_method OWNER TO vendure;

--
-- Name: payment_method_channels_channel; Type: TABLE; Schema: public; Owner: vendure
--

CREATE TABLE public.payment_method_channels_channel (
    "paymentMethodId" integer NOT NULL,
    "channelId" integer NOT NULL
);


ALTER TABLE public.payment_method_channels_channel OWNER TO vendure;

--
-- Name: payment_method_id_seq; Type: SEQUENCE; Schema: public; Owner: vendure
--

CREATE SEQUENCE public.payment_method_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.payment_method_id_seq OWNER TO vendure;

--
-- Name: payment_method_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vendure
--

ALTER SEQUENCE public.payment_method_id_seq OWNED BY public.payment_method.id;


--
-- Name: payment_method_translation; Type: TABLE; Schema: public; Owner: vendure
--

CREATE TABLE public.payment_method_translation (
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL,
    "languageCode" character varying NOT NULL,
    name character varying NOT NULL,
    description text NOT NULL,
    id integer NOT NULL,
    "baseId" integer
);


ALTER TABLE public.payment_method_translation OWNER TO vendure;

--
-- Name: payment_method_translation_id_seq; Type: SEQUENCE; Schema: public; Owner: vendure
--

CREATE SEQUENCE public.payment_method_translation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.payment_method_translation_id_seq OWNER TO vendure;

--
-- Name: payment_method_translation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vendure
--

ALTER SEQUENCE public.payment_method_translation_id_seq OWNED BY public.payment_method_translation.id;


--
-- Name: product; Type: TABLE; Schema: public; Owner: vendure
--

CREATE TABLE public.product (
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL,
    "deletedAt" timestamp without time zone,
    enabled boolean DEFAULT true NOT NULL,
    id integer NOT NULL,
    "featuredAssetId" integer
);


ALTER TABLE public.product OWNER TO vendure;

--
-- Name: product_asset; Type: TABLE; Schema: public; Owner: vendure
--

CREATE TABLE public.product_asset (
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL,
    "assetId" integer NOT NULL,
    "position" integer NOT NULL,
    "productId" integer NOT NULL,
    id integer NOT NULL
);


ALTER TABLE public.product_asset OWNER TO vendure;

--
-- Name: product_asset_id_seq; Type: SEQUENCE; Schema: public; Owner: vendure
--

CREATE SEQUENCE public.product_asset_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.product_asset_id_seq OWNER TO vendure;

--
-- Name: product_asset_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vendure
--

ALTER SEQUENCE public.product_asset_id_seq OWNED BY public.product_asset.id;


--
-- Name: product_channels_channel; Type: TABLE; Schema: public; Owner: vendure
--

CREATE TABLE public.product_channels_channel (
    "productId" integer NOT NULL,
    "channelId" integer NOT NULL
);


ALTER TABLE public.product_channels_channel OWNER TO vendure;

--
-- Name: product_facet_values_facet_value; Type: TABLE; Schema: public; Owner: vendure
--

CREATE TABLE public.product_facet_values_facet_value (
    "productId" integer NOT NULL,
    "facetValueId" integer NOT NULL
);


ALTER TABLE public.product_facet_values_facet_value OWNER TO vendure;

--
-- Name: product_id_seq; Type: SEQUENCE; Schema: public; Owner: vendure
--

CREATE SEQUENCE public.product_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.product_id_seq OWNER TO vendure;

--
-- Name: product_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vendure
--

ALTER SEQUENCE public.product_id_seq OWNED BY public.product.id;


--
-- Name: product_option; Type: TABLE; Schema: public; Owner: vendure
--

CREATE TABLE public.product_option (
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL,
    "deletedAt" timestamp without time zone,
    code character varying NOT NULL,
    id integer NOT NULL,
    "groupId" integer NOT NULL
);


ALTER TABLE public.product_option OWNER TO vendure;

--
-- Name: product_option_group; Type: TABLE; Schema: public; Owner: vendure
--

CREATE TABLE public.product_option_group (
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL,
    "deletedAt" timestamp without time zone,
    code character varying NOT NULL,
    id integer NOT NULL,
    "productId" integer
);


ALTER TABLE public.product_option_group OWNER TO vendure;

--
-- Name: product_option_group_id_seq; Type: SEQUENCE; Schema: public; Owner: vendure
--

CREATE SEQUENCE public.product_option_group_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.product_option_group_id_seq OWNER TO vendure;

--
-- Name: product_option_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vendure
--

ALTER SEQUENCE public.product_option_group_id_seq OWNED BY public.product_option_group.id;


--
-- Name: product_option_group_translation; Type: TABLE; Schema: public; Owner: vendure
--

CREATE TABLE public.product_option_group_translation (
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL,
    "languageCode" character varying NOT NULL,
    name character varying NOT NULL,
    id integer NOT NULL,
    "baseId" integer
);


ALTER TABLE public.product_option_group_translation OWNER TO vendure;

--
-- Name: product_option_group_translation_id_seq; Type: SEQUENCE; Schema: public; Owner: vendure
--

CREATE SEQUENCE public.product_option_group_translation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.product_option_group_translation_id_seq OWNER TO vendure;

--
-- Name: product_option_group_translation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vendure
--

ALTER SEQUENCE public.product_option_group_translation_id_seq OWNED BY public.product_option_group_translation.id;


--
-- Name: product_option_id_seq; Type: SEQUENCE; Schema: public; Owner: vendure
--

CREATE SEQUENCE public.product_option_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.product_option_id_seq OWNER TO vendure;

--
-- Name: product_option_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vendure
--

ALTER SEQUENCE public.product_option_id_seq OWNED BY public.product_option.id;


--
-- Name: product_option_translation; Type: TABLE; Schema: public; Owner: vendure
--

CREATE TABLE public.product_option_translation (
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL,
    "languageCode" character varying NOT NULL,
    name character varying NOT NULL,
    id integer NOT NULL,
    "baseId" integer
);


ALTER TABLE public.product_option_translation OWNER TO vendure;

--
-- Name: product_option_translation_id_seq; Type: SEQUENCE; Schema: public; Owner: vendure
--

CREATE SEQUENCE public.product_option_translation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.product_option_translation_id_seq OWNER TO vendure;

--
-- Name: product_option_translation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vendure
--

ALTER SEQUENCE public.product_option_translation_id_seq OWNED BY public.product_option_translation.id;


--
-- Name: product_translation; Type: TABLE; Schema: public; Owner: vendure
--

CREATE TABLE public.product_translation (
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL,
    "languageCode" character varying NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    description text NOT NULL,
    id integer NOT NULL,
    "baseId" integer
);


ALTER TABLE public.product_translation OWNER TO vendure;

--
-- Name: product_translation_id_seq; Type: SEQUENCE; Schema: public; Owner: vendure
--

CREATE SEQUENCE public.product_translation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.product_translation_id_seq OWNER TO vendure;

--
-- Name: product_translation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vendure
--

ALTER SEQUENCE public.product_translation_id_seq OWNED BY public.product_translation.id;


--
-- Name: product_variant; Type: TABLE; Schema: public; Owner: vendure
--

CREATE TABLE public.product_variant (
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL,
    "deletedAt" timestamp without time zone,
    enabled boolean DEFAULT true NOT NULL,
    sku character varying NOT NULL,
    "outOfStockThreshold" integer DEFAULT 0 NOT NULL,
    "useGlobalOutOfStockThreshold" boolean DEFAULT true NOT NULL,
    "trackInventory" character varying DEFAULT 'INHERIT'::character varying NOT NULL,
    id integer NOT NULL,
    "featuredAssetId" integer,
    "taxCategoryId" integer,
    "productId" integer
);


ALTER TABLE public.product_variant OWNER TO vendure;

--
-- Name: product_variant_asset; Type: TABLE; Schema: public; Owner: vendure
--

CREATE TABLE public.product_variant_asset (
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL,
    "assetId" integer NOT NULL,
    "position" integer NOT NULL,
    "productVariantId" integer NOT NULL,
    id integer NOT NULL
);


ALTER TABLE public.product_variant_asset OWNER TO vendure;

--
-- Name: product_variant_asset_id_seq; Type: SEQUENCE; Schema: public; Owner: vendure
--

CREATE SEQUENCE public.product_variant_asset_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.product_variant_asset_id_seq OWNER TO vendure;

--
-- Name: product_variant_asset_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vendure
--

ALTER SEQUENCE public.product_variant_asset_id_seq OWNED BY public.product_variant_asset.id;


--
-- Name: product_variant_channels_channel; Type: TABLE; Schema: public; Owner: vendure
--

CREATE TABLE public.product_variant_channels_channel (
    "productVariantId" integer NOT NULL,
    "channelId" integer NOT NULL
);


ALTER TABLE public.product_variant_channels_channel OWNER TO vendure;

--
-- Name: product_variant_facet_values_facet_value; Type: TABLE; Schema: public; Owner: vendure
--

CREATE TABLE public.product_variant_facet_values_facet_value (
    "productVariantId" integer NOT NULL,
    "facetValueId" integer NOT NULL
);


ALTER TABLE public.product_variant_facet_values_facet_value OWNER TO vendure;

--
-- Name: product_variant_id_seq; Type: SEQUENCE; Schema: public; Owner: vendure
--

CREATE SEQUENCE public.product_variant_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.product_variant_id_seq OWNER TO vendure;

--
-- Name: product_variant_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vendure
--

ALTER SEQUENCE public.product_variant_id_seq OWNED BY public.product_variant.id;


--
-- Name: product_variant_options_product_option; Type: TABLE; Schema: public; Owner: vendure
--

CREATE TABLE public.product_variant_options_product_option (
    "productVariantId" integer NOT NULL,
    "productOptionId" integer NOT NULL
);


ALTER TABLE public.product_variant_options_product_option OWNER TO vendure;

--
-- Name: product_variant_price; Type: TABLE; Schema: public; Owner: vendure
--

CREATE TABLE public.product_variant_price (
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL,
    "currencyCode" character varying NOT NULL,
    id integer NOT NULL,
    "channelId" integer,
    price integer NOT NULL,
    "variantId" integer
);


ALTER TABLE public.product_variant_price OWNER TO vendure;

--
-- Name: product_variant_price_id_seq; Type: SEQUENCE; Schema: public; Owner: vendure
--

CREATE SEQUENCE public.product_variant_price_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.product_variant_price_id_seq OWNER TO vendure;

--
-- Name: product_variant_price_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vendure
--

ALTER SEQUENCE public.product_variant_price_id_seq OWNED BY public.product_variant_price.id;


--
-- Name: product_variant_translation; Type: TABLE; Schema: public; Owner: vendure
--

CREATE TABLE public.product_variant_translation (
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL,
    "languageCode" character varying NOT NULL,
    name character varying NOT NULL,
    id integer NOT NULL,
    "baseId" integer
);


ALTER TABLE public.product_variant_translation OWNER TO vendure;

--
-- Name: product_variant_translation_id_seq; Type: SEQUENCE; Schema: public; Owner: vendure
--

CREATE SEQUENCE public.product_variant_translation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.product_variant_translation_id_seq OWNER TO vendure;

--
-- Name: product_variant_translation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vendure
--

ALTER SEQUENCE public.product_variant_translation_id_seq OWNED BY public.product_variant_translation.id;


--
-- Name: promotion; Type: TABLE; Schema: public; Owner: vendure
--

CREATE TABLE public.promotion (
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL,
    "deletedAt" timestamp without time zone,
    "startsAt" timestamp without time zone,
    "endsAt" timestamp without time zone,
    "couponCode" character varying,
    "perCustomerUsageLimit" integer,
    "usageLimit" integer,
    enabled boolean NOT NULL,
    conditions text NOT NULL,
    actions text NOT NULL,
    "priorityScore" integer NOT NULL,
    id integer NOT NULL
);


ALTER TABLE public.promotion OWNER TO vendure;

--
-- Name: promotion_channels_channel; Type: TABLE; Schema: public; Owner: vendure
--

CREATE TABLE public.promotion_channels_channel (
    "promotionId" integer NOT NULL,
    "channelId" integer NOT NULL
);


ALTER TABLE public.promotion_channels_channel OWNER TO vendure;

--
-- Name: promotion_id_seq; Type: SEQUENCE; Schema: public; Owner: vendure
--

CREATE SEQUENCE public.promotion_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.promotion_id_seq OWNER TO vendure;

--
-- Name: promotion_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vendure
--

ALTER SEQUENCE public.promotion_id_seq OWNED BY public.promotion.id;


--
-- Name: promotion_translation; Type: TABLE; Schema: public; Owner: vendure
--

CREATE TABLE public.promotion_translation (
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL,
    "languageCode" character varying NOT NULL,
    name character varying NOT NULL,
    description text NOT NULL,
    id integer NOT NULL,
    "baseId" integer
);


ALTER TABLE public.promotion_translation OWNER TO vendure;

--
-- Name: promotion_translation_id_seq; Type: SEQUENCE; Schema: public; Owner: vendure
--

CREATE SEQUENCE public.promotion_translation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.promotion_translation_id_seq OWNER TO vendure;

--
-- Name: promotion_translation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vendure
--

ALTER SEQUENCE public.promotion_translation_id_seq OWNED BY public.promotion_translation.id;


--
-- Name: refund; Type: TABLE; Schema: public; Owner: vendure
--

CREATE TABLE public.refund (
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL,
    method character varying NOT NULL,
    reason character varying,
    state character varying NOT NULL,
    "transactionId" character varying,
    metadata text NOT NULL,
    id integer NOT NULL,
    "paymentId" integer NOT NULL,
    items integer NOT NULL,
    shipping integer NOT NULL,
    adjustment integer NOT NULL,
    total integer NOT NULL
);


ALTER TABLE public.refund OWNER TO vendure;

--
-- Name: refund_id_seq; Type: SEQUENCE; Schema: public; Owner: vendure
--

CREATE SEQUENCE public.refund_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.refund_id_seq OWNER TO vendure;

--
-- Name: refund_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vendure
--

ALTER SEQUENCE public.refund_id_seq OWNED BY public.refund.id;


--
-- Name: region; Type: TABLE; Schema: public; Owner: vendure
--

CREATE TABLE public.region (
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL,
    code character varying NOT NULL,
    type character varying NOT NULL,
    enabled boolean NOT NULL,
    id integer NOT NULL,
    "parentId" integer,
    discriminator character varying NOT NULL
);


ALTER TABLE public.region OWNER TO vendure;

--
-- Name: region_id_seq; Type: SEQUENCE; Schema: public; Owner: vendure
--

CREATE SEQUENCE public.region_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.region_id_seq OWNER TO vendure;

--
-- Name: region_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vendure
--

ALTER SEQUENCE public.region_id_seq OWNED BY public.region.id;


--
-- Name: region_translation; Type: TABLE; Schema: public; Owner: vendure
--

CREATE TABLE public.region_translation (
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL,
    "languageCode" character varying NOT NULL,
    name character varying NOT NULL,
    id integer NOT NULL,
    "baseId" integer
);


ALTER TABLE public.region_translation OWNER TO vendure;

--
-- Name: region_translation_id_seq; Type: SEQUENCE; Schema: public; Owner: vendure
--

CREATE SEQUENCE public.region_translation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.region_translation_id_seq OWNER TO vendure;

--
-- Name: region_translation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vendure
--

ALTER SEQUENCE public.region_translation_id_seq OWNED BY public.region_translation.id;


--
-- Name: role; Type: TABLE; Schema: public; Owner: vendure
--

CREATE TABLE public.role (
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL,
    code character varying NOT NULL,
    description character varying NOT NULL,
    permissions text NOT NULL,
    id integer NOT NULL
);


ALTER TABLE public.role OWNER TO vendure;

--
-- Name: role_channels_channel; Type: TABLE; Schema: public; Owner: vendure
--

CREATE TABLE public.role_channels_channel (
    "roleId" integer NOT NULL,
    "channelId" integer NOT NULL
);


ALTER TABLE public.role_channels_channel OWNER TO vendure;

--
-- Name: role_id_seq; Type: SEQUENCE; Schema: public; Owner: vendure
--

CREATE SEQUENCE public.role_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.role_id_seq OWNER TO vendure;

--
-- Name: role_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vendure
--

ALTER SEQUENCE public.role_id_seq OWNED BY public.role.id;


--
-- Name: scheduled_task_record; Type: TABLE; Schema: public; Owner: vendure
--

CREATE TABLE public.scheduled_task_record (
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL,
    "taskId" character varying NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    "lockedAt" timestamp(3) without time zone,
    "lastExecutedAt" timestamp(3) without time zone,
    "manuallyTriggeredAt" timestamp(3) without time zone,
    "lastResult" json,
    id integer NOT NULL
);


ALTER TABLE public.scheduled_task_record OWNER TO vendure;

--
-- Name: scheduled_task_record_id_seq; Type: SEQUENCE; Schema: public; Owner: vendure
--

CREATE SEQUENCE public.scheduled_task_record_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.scheduled_task_record_id_seq OWNER TO vendure;

--
-- Name: scheduled_task_record_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vendure
--

ALTER SEQUENCE public.scheduled_task_record_id_seq OWNED BY public.scheduled_task_record.id;


--
-- Name: search_index_item; Type: TABLE; Schema: public; Owner: vendure
--

CREATE TABLE public.search_index_item (
    "languageCode" character varying NOT NULL,
    enabled boolean NOT NULL,
    "productName" character varying NOT NULL,
    "productVariantName" character varying NOT NULL,
    description text NOT NULL,
    slug character varying NOT NULL,
    sku character varying NOT NULL,
    "facetIds" text NOT NULL,
    "facetValueIds" text NOT NULL,
    "collectionIds" text NOT NULL,
    "collectionSlugs" text NOT NULL,
    "channelIds" text NOT NULL,
    "productPreview" character varying NOT NULL,
    "productPreviewFocalPoint" text,
    "productVariantPreview" character varying NOT NULL,
    "productVariantPreviewFocalPoint" text,
    "inStock" boolean DEFAULT true NOT NULL,
    "productInStock" boolean DEFAULT true NOT NULL,
    "productVariantId" integer NOT NULL,
    "channelId" integer NOT NULL,
    "productId" integer NOT NULL,
    "productAssetId" integer,
    "productVariantAssetId" integer,
    price integer NOT NULL,
    "priceWithTax" integer NOT NULL
);


ALTER TABLE public.search_index_item OWNER TO vendure;

--
-- Name: seller; Type: TABLE; Schema: public; Owner: vendure
--

CREATE TABLE public.seller (
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL,
    "deletedAt" timestamp without time zone,
    name character varying NOT NULL,
    id integer NOT NULL
);


ALTER TABLE public.seller OWNER TO vendure;

--
-- Name: seller_id_seq; Type: SEQUENCE; Schema: public; Owner: vendure
--

CREATE SEQUENCE public.seller_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seller_id_seq OWNER TO vendure;

--
-- Name: seller_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vendure
--

ALTER SEQUENCE public.seller_id_seq OWNED BY public.seller.id;


--
-- Name: session; Type: TABLE; Schema: public; Owner: vendure
--

CREATE TABLE public.session (
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL,
    token character varying NOT NULL,
    expires timestamp without time zone NOT NULL,
    invalidated boolean NOT NULL,
    "authenticationStrategy" character varying,
    id integer NOT NULL,
    "activeOrderId" integer,
    "activeChannelId" integer,
    type character varying NOT NULL,
    "userId" integer
);


ALTER TABLE public.session OWNER TO vendure;

--
-- Name: session_id_seq; Type: SEQUENCE; Schema: public; Owner: vendure
--

CREATE SEQUENCE public.session_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.session_id_seq OWNER TO vendure;

--
-- Name: session_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vendure
--

ALTER SEQUENCE public.session_id_seq OWNED BY public.session.id;


--
-- Name: shipping_line; Type: TABLE; Schema: public; Owner: vendure
--

CREATE TABLE public.shipping_line (
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL,
    "listPriceIncludesTax" boolean NOT NULL,
    adjustments text NOT NULL,
    "taxLines" text NOT NULL,
    id integer NOT NULL,
    "shippingMethodId" integer NOT NULL,
    "listPrice" integer NOT NULL,
    "orderId" integer
);


ALTER TABLE public.shipping_line OWNER TO vendure;

--
-- Name: shipping_line_id_seq; Type: SEQUENCE; Schema: public; Owner: vendure
--

CREATE SEQUENCE public.shipping_line_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.shipping_line_id_seq OWNER TO vendure;

--
-- Name: shipping_line_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vendure
--

ALTER SEQUENCE public.shipping_line_id_seq OWNED BY public.shipping_line.id;


--
-- Name: shipping_method; Type: TABLE; Schema: public; Owner: vendure
--

CREATE TABLE public.shipping_method (
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL,
    "deletedAt" timestamp without time zone,
    code character varying NOT NULL,
    checker text NOT NULL,
    calculator text NOT NULL,
    "fulfillmentHandlerCode" character varying NOT NULL,
    id integer NOT NULL
);


ALTER TABLE public.shipping_method OWNER TO vendure;

--
-- Name: shipping_method_channels_channel; Type: TABLE; Schema: public; Owner: vendure
--

CREATE TABLE public.shipping_method_channels_channel (
    "shippingMethodId" integer NOT NULL,
    "channelId" integer NOT NULL
);


ALTER TABLE public.shipping_method_channels_channel OWNER TO vendure;

--
-- Name: shipping_method_id_seq; Type: SEQUENCE; Schema: public; Owner: vendure
--

CREATE SEQUENCE public.shipping_method_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.shipping_method_id_seq OWNER TO vendure;

--
-- Name: shipping_method_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vendure
--

ALTER SEQUENCE public.shipping_method_id_seq OWNED BY public.shipping_method.id;


--
-- Name: shipping_method_translation; Type: TABLE; Schema: public; Owner: vendure
--

CREATE TABLE public.shipping_method_translation (
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL,
    "languageCode" character varying NOT NULL,
    name character varying DEFAULT ''::character varying NOT NULL,
    description character varying DEFAULT ''::character varying NOT NULL,
    id integer NOT NULL,
    "baseId" integer
);


ALTER TABLE public.shipping_method_translation OWNER TO vendure;

--
-- Name: shipping_method_translation_id_seq; Type: SEQUENCE; Schema: public; Owner: vendure
--

CREATE SEQUENCE public.shipping_method_translation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.shipping_method_translation_id_seq OWNER TO vendure;

--
-- Name: shipping_method_translation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vendure
--

ALTER SEQUENCE public.shipping_method_translation_id_seq OWNED BY public.shipping_method_translation.id;


--
-- Name: stock_level; Type: TABLE; Schema: public; Owner: vendure
--

CREATE TABLE public.stock_level (
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL,
    "stockOnHand" integer NOT NULL,
    "stockAllocated" integer NOT NULL,
    id integer NOT NULL,
    "productVariantId" integer NOT NULL,
    "stockLocationId" integer NOT NULL
);


ALTER TABLE public.stock_level OWNER TO vendure;

--
-- Name: stock_level_id_seq; Type: SEQUENCE; Schema: public; Owner: vendure
--

CREATE SEQUENCE public.stock_level_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.stock_level_id_seq OWNER TO vendure;

--
-- Name: stock_level_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vendure
--

ALTER SEQUENCE public.stock_level_id_seq OWNED BY public.stock_level.id;


--
-- Name: stock_location; Type: TABLE; Schema: public; Owner: vendure
--

CREATE TABLE public.stock_location (
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL,
    name character varying NOT NULL,
    description character varying NOT NULL,
    id integer NOT NULL
);


ALTER TABLE public.stock_location OWNER TO vendure;

--
-- Name: stock_location_channels_channel; Type: TABLE; Schema: public; Owner: vendure
--

CREATE TABLE public.stock_location_channels_channel (
    "stockLocationId" integer NOT NULL,
    "channelId" integer NOT NULL
);


ALTER TABLE public.stock_location_channels_channel OWNER TO vendure;

--
-- Name: stock_location_id_seq; Type: SEQUENCE; Schema: public; Owner: vendure
--

CREATE SEQUENCE public.stock_location_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.stock_location_id_seq OWNER TO vendure;

--
-- Name: stock_location_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vendure
--

ALTER SEQUENCE public.stock_location_id_seq OWNED BY public.stock_location.id;


--
-- Name: stock_movement; Type: TABLE; Schema: public; Owner: vendure
--

CREATE TABLE public.stock_movement (
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL,
    type character varying NOT NULL,
    quantity integer NOT NULL,
    id integer NOT NULL,
    "stockLocationId" integer NOT NULL,
    discriminator character varying NOT NULL,
    "productVariantId" integer,
    "orderLineId" integer
);


ALTER TABLE public.stock_movement OWNER TO vendure;

--
-- Name: stock_movement_id_seq; Type: SEQUENCE; Schema: public; Owner: vendure
--

CREATE SEQUENCE public.stock_movement_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.stock_movement_id_seq OWNER TO vendure;

--
-- Name: stock_movement_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vendure
--

ALTER SEQUENCE public.stock_movement_id_seq OWNED BY public.stock_movement.id;


--
-- Name: surcharge; Type: TABLE; Schema: public; Owner: vendure
--

CREATE TABLE public.surcharge (
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL,
    description character varying NOT NULL,
    "listPriceIncludesTax" boolean NOT NULL,
    sku character varying NOT NULL,
    "taxLines" text NOT NULL,
    id integer NOT NULL,
    "listPrice" integer NOT NULL,
    "orderId" integer,
    "orderModificationId" integer
);


ALTER TABLE public.surcharge OWNER TO vendure;

--
-- Name: surcharge_id_seq; Type: SEQUENCE; Schema: public; Owner: vendure
--

CREATE SEQUENCE public.surcharge_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.surcharge_id_seq OWNER TO vendure;

--
-- Name: surcharge_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vendure
--

ALTER SEQUENCE public.surcharge_id_seq OWNED BY public.surcharge.id;


--
-- Name: tag; Type: TABLE; Schema: public; Owner: vendure
--

CREATE TABLE public.tag (
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL,
    value character varying NOT NULL,
    id integer NOT NULL
);


ALTER TABLE public.tag OWNER TO vendure;

--
-- Name: tag_id_seq; Type: SEQUENCE; Schema: public; Owner: vendure
--

CREATE SEQUENCE public.tag_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tag_id_seq OWNER TO vendure;

--
-- Name: tag_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vendure
--

ALTER SEQUENCE public.tag_id_seq OWNED BY public.tag.id;


--
-- Name: tax_category; Type: TABLE; Schema: public; Owner: vendure
--

CREATE TABLE public.tax_category (
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL,
    name character varying NOT NULL,
    "isDefault" boolean DEFAULT false NOT NULL,
    id integer NOT NULL
);


ALTER TABLE public.tax_category OWNER TO vendure;

--
-- Name: tax_category_id_seq; Type: SEQUENCE; Schema: public; Owner: vendure
--

CREATE SEQUENCE public.tax_category_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tax_category_id_seq OWNER TO vendure;

--
-- Name: tax_category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vendure
--

ALTER SEQUENCE public.tax_category_id_seq OWNED BY public.tax_category.id;


--
-- Name: tax_rate; Type: TABLE; Schema: public; Owner: vendure
--

CREATE TABLE public.tax_rate (
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL,
    name character varying NOT NULL,
    enabled boolean NOT NULL,
    value numeric(5,2) NOT NULL,
    id integer NOT NULL,
    "categoryId" integer,
    "zoneId" integer,
    "customerGroupId" integer
);


ALTER TABLE public.tax_rate OWNER TO vendure;

--
-- Name: tax_rate_id_seq; Type: SEQUENCE; Schema: public; Owner: vendure
--

CREATE SEQUENCE public.tax_rate_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tax_rate_id_seq OWNER TO vendure;

--
-- Name: tax_rate_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vendure
--

ALTER SEQUENCE public.tax_rate_id_seq OWNED BY public.tax_rate.id;


--
-- Name: user; Type: TABLE; Schema: public; Owner: vendure
--

CREATE TABLE public."user" (
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL,
    "deletedAt" timestamp without time zone,
    identifier character varying NOT NULL,
    verified boolean DEFAULT false NOT NULL,
    "lastLogin" timestamp without time zone,
    id integer NOT NULL
);


ALTER TABLE public."user" OWNER TO vendure;

--
-- Name: user_id_seq; Type: SEQUENCE; Schema: public; Owner: vendure
--

CREATE SEQUENCE public.user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_id_seq OWNER TO vendure;

--
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vendure
--

ALTER SEQUENCE public.user_id_seq OWNED BY public."user".id;


--
-- Name: user_roles_role; Type: TABLE; Schema: public; Owner: vendure
--

CREATE TABLE public.user_roles_role (
    "userId" integer NOT NULL,
    "roleId" integer NOT NULL
);


ALTER TABLE public.user_roles_role OWNER TO vendure;

--
-- Name: zone; Type: TABLE; Schema: public; Owner: vendure
--

CREATE TABLE public.zone (
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL,
    name character varying NOT NULL,
    id integer NOT NULL
);


ALTER TABLE public.zone OWNER TO vendure;

--
-- Name: zone_id_seq; Type: SEQUENCE; Schema: public; Owner: vendure
--

CREATE SEQUENCE public.zone_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.zone_id_seq OWNER TO vendure;

--
-- Name: zone_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vendure
--

ALTER SEQUENCE public.zone_id_seq OWNED BY public.zone.id;


--
-- Name: zone_members_region; Type: TABLE; Schema: public; Owner: vendure
--

CREATE TABLE public.zone_members_region (
    "zoneId" integer NOT NULL,
    "regionId" integer NOT NULL
);


ALTER TABLE public.zone_members_region OWNER TO vendure;

--
-- Name: address id; Type: DEFAULT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.address ALTER COLUMN id SET DEFAULT nextval('public.address_id_seq'::regclass);


--
-- Name: administrator id; Type: DEFAULT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.administrator ALTER COLUMN id SET DEFAULT nextval('public.administrator_id_seq'::regclass);


--
-- Name: asset id; Type: DEFAULT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.asset ALTER COLUMN id SET DEFAULT nextval('public.asset_id_seq'::regclass);


--
-- Name: authentication_method id; Type: DEFAULT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.authentication_method ALTER COLUMN id SET DEFAULT nextval('public.authentication_method_id_seq'::regclass);


--
-- Name: channel id; Type: DEFAULT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.channel ALTER COLUMN id SET DEFAULT nextval('public.channel_id_seq'::regclass);


--
-- Name: collection id; Type: DEFAULT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.collection ALTER COLUMN id SET DEFAULT nextval('public.collection_id_seq'::regclass);


--
-- Name: collection_asset id; Type: DEFAULT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.collection_asset ALTER COLUMN id SET DEFAULT nextval('public.collection_asset_id_seq'::regclass);


--
-- Name: collection_translation id; Type: DEFAULT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.collection_translation ALTER COLUMN id SET DEFAULT nextval('public.collection_translation_id_seq'::regclass);


--
-- Name: customer id; Type: DEFAULT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.customer ALTER COLUMN id SET DEFAULT nextval('public.customer_id_seq'::regclass);


--
-- Name: customer_group id; Type: DEFAULT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.customer_group ALTER COLUMN id SET DEFAULT nextval('public.customer_group_id_seq'::regclass);


--
-- Name: facet id; Type: DEFAULT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.facet ALTER COLUMN id SET DEFAULT nextval('public.facet_id_seq'::regclass);


--
-- Name: facet_translation id; Type: DEFAULT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.facet_translation ALTER COLUMN id SET DEFAULT nextval('public.facet_translation_id_seq'::regclass);


--
-- Name: facet_value id; Type: DEFAULT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.facet_value ALTER COLUMN id SET DEFAULT nextval('public.facet_value_id_seq'::regclass);


--
-- Name: facet_value_translation id; Type: DEFAULT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.facet_value_translation ALTER COLUMN id SET DEFAULT nextval('public.facet_value_translation_id_seq'::regclass);


--
-- Name: fulfillment id; Type: DEFAULT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.fulfillment ALTER COLUMN id SET DEFAULT nextval('public.fulfillment_id_seq'::regclass);


--
-- Name: global_settings id; Type: DEFAULT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.global_settings ALTER COLUMN id SET DEFAULT nextval('public.global_settings_id_seq'::regclass);


--
-- Name: history_entry id; Type: DEFAULT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.history_entry ALTER COLUMN id SET DEFAULT nextval('public.history_entry_id_seq'::regclass);


--
-- Name: job_record id; Type: DEFAULT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.job_record ALTER COLUMN id SET DEFAULT nextval('public.job_record_id_seq'::regclass);


--
-- Name: job_record_buffer id; Type: DEFAULT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.job_record_buffer ALTER COLUMN id SET DEFAULT nextval('public.job_record_buffer_id_seq'::regclass);


--
-- Name: migrations id; Type: DEFAULT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.migrations ALTER COLUMN id SET DEFAULT nextval('public.migrations_id_seq'::regclass);


--
-- Name: order id; Type: DEFAULT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public."order" ALTER COLUMN id SET DEFAULT nextval('public.order_id_seq'::regclass);


--
-- Name: order_line id; Type: DEFAULT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.order_line ALTER COLUMN id SET DEFAULT nextval('public.order_line_id_seq'::regclass);


--
-- Name: order_line_reference id; Type: DEFAULT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.order_line_reference ALTER COLUMN id SET DEFAULT nextval('public.order_line_reference_id_seq'::regclass);


--
-- Name: order_modification id; Type: DEFAULT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.order_modification ALTER COLUMN id SET DEFAULT nextval('public.order_modification_id_seq'::regclass);


--
-- Name: payment id; Type: DEFAULT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.payment ALTER COLUMN id SET DEFAULT nextval('public.payment_id_seq'::regclass);


--
-- Name: payment_method id; Type: DEFAULT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.payment_method ALTER COLUMN id SET DEFAULT nextval('public.payment_method_id_seq'::regclass);


--
-- Name: payment_method_translation id; Type: DEFAULT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.payment_method_translation ALTER COLUMN id SET DEFAULT nextval('public.payment_method_translation_id_seq'::regclass);


--
-- Name: product id; Type: DEFAULT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.product ALTER COLUMN id SET DEFAULT nextval('public.product_id_seq'::regclass);


--
-- Name: product_asset id; Type: DEFAULT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.product_asset ALTER COLUMN id SET DEFAULT nextval('public.product_asset_id_seq'::regclass);


--
-- Name: product_option id; Type: DEFAULT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.product_option ALTER COLUMN id SET DEFAULT nextval('public.product_option_id_seq'::regclass);


--
-- Name: product_option_group id; Type: DEFAULT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.product_option_group ALTER COLUMN id SET DEFAULT nextval('public.product_option_group_id_seq'::regclass);


--
-- Name: product_option_group_translation id; Type: DEFAULT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.product_option_group_translation ALTER COLUMN id SET DEFAULT nextval('public.product_option_group_translation_id_seq'::regclass);


--
-- Name: product_option_translation id; Type: DEFAULT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.product_option_translation ALTER COLUMN id SET DEFAULT nextval('public.product_option_translation_id_seq'::regclass);


--
-- Name: product_translation id; Type: DEFAULT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.product_translation ALTER COLUMN id SET DEFAULT nextval('public.product_translation_id_seq'::regclass);


--
-- Name: product_variant id; Type: DEFAULT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.product_variant ALTER COLUMN id SET DEFAULT nextval('public.product_variant_id_seq'::regclass);


--
-- Name: product_variant_asset id; Type: DEFAULT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.product_variant_asset ALTER COLUMN id SET DEFAULT nextval('public.product_variant_asset_id_seq'::regclass);


--
-- Name: product_variant_price id; Type: DEFAULT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.product_variant_price ALTER COLUMN id SET DEFAULT nextval('public.product_variant_price_id_seq'::regclass);


--
-- Name: product_variant_translation id; Type: DEFAULT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.product_variant_translation ALTER COLUMN id SET DEFAULT nextval('public.product_variant_translation_id_seq'::regclass);


--
-- Name: promotion id; Type: DEFAULT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.promotion ALTER COLUMN id SET DEFAULT nextval('public.promotion_id_seq'::regclass);


--
-- Name: promotion_translation id; Type: DEFAULT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.promotion_translation ALTER COLUMN id SET DEFAULT nextval('public.promotion_translation_id_seq'::regclass);


--
-- Name: refund id; Type: DEFAULT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.refund ALTER COLUMN id SET DEFAULT nextval('public.refund_id_seq'::regclass);


--
-- Name: region id; Type: DEFAULT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.region ALTER COLUMN id SET DEFAULT nextval('public.region_id_seq'::regclass);


--
-- Name: region_translation id; Type: DEFAULT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.region_translation ALTER COLUMN id SET DEFAULT nextval('public.region_translation_id_seq'::regclass);


--
-- Name: role id; Type: DEFAULT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.role ALTER COLUMN id SET DEFAULT nextval('public.role_id_seq'::regclass);


--
-- Name: scheduled_task_record id; Type: DEFAULT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.scheduled_task_record ALTER COLUMN id SET DEFAULT nextval('public.scheduled_task_record_id_seq'::regclass);


--
-- Name: seller id; Type: DEFAULT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.seller ALTER COLUMN id SET DEFAULT nextval('public.seller_id_seq'::regclass);


--
-- Name: session id; Type: DEFAULT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.session ALTER COLUMN id SET DEFAULT nextval('public.session_id_seq'::regclass);


--
-- Name: shipping_line id; Type: DEFAULT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.shipping_line ALTER COLUMN id SET DEFAULT nextval('public.shipping_line_id_seq'::regclass);


--
-- Name: shipping_method id; Type: DEFAULT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.shipping_method ALTER COLUMN id SET DEFAULT nextval('public.shipping_method_id_seq'::regclass);


--
-- Name: shipping_method_translation id; Type: DEFAULT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.shipping_method_translation ALTER COLUMN id SET DEFAULT nextval('public.shipping_method_translation_id_seq'::regclass);


--
-- Name: stock_level id; Type: DEFAULT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.stock_level ALTER COLUMN id SET DEFAULT nextval('public.stock_level_id_seq'::regclass);


--
-- Name: stock_location id; Type: DEFAULT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.stock_location ALTER COLUMN id SET DEFAULT nextval('public.stock_location_id_seq'::regclass);


--
-- Name: stock_movement id; Type: DEFAULT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.stock_movement ALTER COLUMN id SET DEFAULT nextval('public.stock_movement_id_seq'::regclass);


--
-- Name: surcharge id; Type: DEFAULT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.surcharge ALTER COLUMN id SET DEFAULT nextval('public.surcharge_id_seq'::regclass);


--
-- Name: tag id; Type: DEFAULT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.tag ALTER COLUMN id SET DEFAULT nextval('public.tag_id_seq'::regclass);


--
-- Name: tax_category id; Type: DEFAULT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.tax_category ALTER COLUMN id SET DEFAULT nextval('public.tax_category_id_seq'::regclass);


--
-- Name: tax_rate id; Type: DEFAULT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.tax_rate ALTER COLUMN id SET DEFAULT nextval('public.tax_rate_id_seq'::regclass);


--
-- Name: user id; Type: DEFAULT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public."user" ALTER COLUMN id SET DEFAULT nextval('public.user_id_seq'::regclass);


--
-- Name: zone id; Type: DEFAULT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.zone ALTER COLUMN id SET DEFAULT nextval('public.zone_id_seq'::regclass);


--
-- Data for Name: address; Type: TABLE DATA; Schema: public; Owner: vendure
--

COPY public.address ("createdAt", "updatedAt", "fullName", company, "streetLine1", "streetLine2", city, province, "postalCode", "phoneNumber", "defaultShippingAddress", "defaultBillingAddress", id, "customerId", "countryId") FROM stdin;
\.


--
-- Data for Name: administrator; Type: TABLE DATA; Schema: public; Owner: vendure
--

COPY public.administrator ("createdAt", "updatedAt", "deletedAt", "firstName", "lastName", "emailAddress", id, "userId") FROM stdin;
2025-06-21 07:06:32.135612	2025-06-21 07:06:32.135612	\N	Super	Admin	superadmin	1	1
\.


--
-- Data for Name: asset; Type: TABLE DATA; Schema: public; Owner: vendure
--

COPY public.asset ("createdAt", "updatedAt", name, type, "mimeType", width, height, "fileSize", source, preview, "focalPoint", id) FROM stdin;
2025-06-21 07:06:35.072178	2025-06-21 07:06:35.072178	derick-david-409858-unsplash.jpg	IMAGE	image/jpeg	1600	1200	44525	source\\b6\\derick-david-409858-unsplash.jpg	preview\\71\\derick-david-409858-unsplash__preview.jpg	\N	1
2025-06-21 07:06:35.331057	2025-06-21 07:06:35.331057	kelly-sikkema-685291-unsplash.jpg	IMAGE	image/jpeg	1600	1067	47714	source\\5a\\kelly-sikkema-685291-unsplash.jpg	preview\\b8\\kelly-sikkema-685291-unsplash__preview.jpg	\N	2
2025-06-21 07:06:35.439517	2025-06-21 07:06:35.439517	oscar-ivan-esquivel-arteaga-687447-unsplash.jpg	IMAGE	image/jpeg	1600	1071	76870	source\\0b\\oscar-ivan-esquivel-arteaga-687447-unsplash.jpg	preview\\a1\\oscar-ivan-esquivel-arteaga-687447-unsplash__preview.jpg	\N	3
2025-06-21 07:06:35.50948	2025-06-21 07:06:35.50948	daniel-korpai-1302051-unsplash.jpg	IMAGE	image/jpeg	1280	1600	201064	source\\28\\daniel-korpai-1302051-unsplash.jpg	preview\\d2\\daniel-korpai-1302051-unsplash__preview.jpg	\N	4
2025-06-21 07:06:35.575596	2025-06-21 07:06:35.575596	alexandru-acea-686569-unsplash.jpg	IMAGE	image/jpeg	1067	1600	71196	source\\e8\\alexandru-acea-686569-unsplash.jpg	preview\\9c\\alexandru-acea-686569-unsplash__preview.jpg	\N	5
2025-06-21 07:06:35.67861	2025-06-21 07:06:35.67861	liam-briese-1128307-unsplash.jpg	IMAGE	image/jpeg	1600	1067	120523	source\\2e\\liam-briese-1128307-unsplash.jpg	preview\\58\\liam-briese-1128307-unsplash__preview.jpg	\N	6
2025-06-21 07:06:35.820874	2025-06-21 07:06:35.820874	florian-olivo-1166419-unsplash.jpg	IMAGE	image/jpeg	1067	1600	73904	source\\63\\florian-olivo-1166419-unsplash.jpg	preview\\5a\\florian-olivo-1166419-unsplash__preview.jpg	\N	7
2025-06-21 07:06:35.9864	2025-06-21 07:06:35.9864	vincent-botta-736919-unsplash.jpg	IMAGE	image/jpeg	1600	1200	87075	source\\59\\vincent-botta-736919-unsplash.jpg	preview\\96\\vincent-botta-736919-unsplash__preview.jpg	\N	8
2025-06-21 07:06:36.168247	2025-06-21 07:06:36.168247	juan-gomez-674574-unsplash.jpg	IMAGE	image/jpeg	1600	1060	60470	source\\b8\\juan-gomez-674574-unsplash.jpg	preview\\09\\juan-gomez-674574-unsplash__preview.jpg	\N	9
2025-06-21 07:06:36.231662	2025-06-21 07:06:36.231662	thomas-q-1229169-unsplash.jpg	IMAGE	image/jpeg	1600	1600	94113	source\\86\\thomas-q-1229169-unsplash.jpg	preview\\7b\\thomas-q-1229169-unsplash__preview.jpg	\N	10
2025-06-21 07:06:36.281995	2025-06-21 07:06:36.281995	adam-birkett-239153-unsplash.jpg	IMAGE	image/jpeg	1067	1600	17676	source\\3c\\adam-birkett-239153-unsplash.jpg	preview\\64\\adam-birkett-239153-unsplash__preview.jpg	\N	11
2025-06-21 07:06:36.326476	2025-06-21 07:06:36.326476	eniko-kis-663725-unsplash.jpg	IMAGE	image/jpeg	1600	1067	42943	source\\1d\\eniko-kis-663725-unsplash.jpg	preview\\b5\\eniko-kis-663725-unsplash__preview.jpg	\N	12
2025-06-21 07:06:36.39517	2025-06-21 07:06:36.39517	brandi-redd-104140-unsplash.jpg	IMAGE	image/jpeg	1600	1110	91458	source\\21\\brandi-redd-104140-unsplash.jpg	preview\\9b\\brandi-redd-104140-unsplash__preview.jpg	\N	13
2025-06-21 07:06:36.461274	2025-06-21 07:06:36.461274	jonathan-talbert-697262-unsplash.jpg	IMAGE	image/jpeg	1067	1600	103011	source\\69\\jonathan-talbert-697262-unsplash.jpg	preview\\3c\\jonathan-talbert-697262-unsplash__preview.jpg	\N	14
2025-06-21 07:06:36.521091	2025-06-21 07:06:36.521091	zoltan-tasi-423051-unsplash.jpg	IMAGE	image/jpeg	1067	1600	49099	source\\92\\zoltan-tasi-423051-unsplash.jpg	preview\\21\\zoltan-tasi-423051-unsplash__preview.jpg	\N	15
2025-06-21 07:06:36.577604	2025-06-21 07:06:36.577604	jakob-owens-274337-unsplash.jpg	IMAGE	image/jpeg	1600	1067	213089	source\\cf\\jakob-owens-274337-unsplash.jpg	preview\\5b\\jakob-owens-274337-unsplash__preview.jpg	\N	16
2025-06-21 07:06:36.641514	2025-06-21 07:06:36.641514	patrick-brinksma-663044-unsplash.jpg	IMAGE	image/jpeg	1600	1067	190811	source\\0f\\patrick-brinksma-663044-unsplash.jpg	preview\\bc\\patrick-brinksma-663044-unsplash__preview.jpg	\N	17
2025-06-21 07:06:36.702354	2025-06-21 07:06:36.702354	chuttersnap-324234-unsplash.jpg	IMAGE	image/jpeg	1600	1068	118442	source\\df\\chuttersnap-324234-unsplash.jpg	preview\\95\\chuttersnap-324234-unsplash__preview.jpg	\N	18
2025-06-21 07:06:36.751253	2025-06-21 07:06:36.751253	robert-shunev-528016-unsplash.jpg	IMAGE	image/jpeg	1600	1067	36204	source\\9e\\robert-shunev-528016-unsplash.jpg	preview\\9d\\robert-shunev-528016-unsplash__preview.jpg	\N	19
2025-06-21 07:06:36.796151	2025-06-21 07:06:36.796151	alexander-andrews-260988-unsplash.jpg	IMAGE	image/jpeg	1050	1600	65460	source\\f8\\alexander-andrews-260988-unsplash.jpg	preview\\ef\\alexander-andrews-260988-unsplash__preview.jpg	\N	20
2025-06-21 07:06:36.860338	2025-06-21 07:06:36.860338	mikkel-bech-748940-unsplash.jpg	IMAGE	image/jpeg	1600	1130	62785	source\\29\\mikkel-bech-748940-unsplash.jpg	preview\\2f\\mikkel-bech-748940-unsplash__preview.jpg	\N	21
2025-06-21 07:06:36.938577	2025-06-21 07:06:36.938577	stoica-ionela-530966-unsplash.jpg	IMAGE	image/jpeg	1600	1600	50995	source\\b1\\stoica-ionela-530966-unsplash.jpg	preview\\34\\stoica-ionela-530966-unsplash__preview.jpg	\N	22
2025-06-21 07:06:37.000645	2025-06-21 07:06:37.000645	neonbrand-428982-unsplash.jpg	IMAGE	image/jpeg	1600	1332	169677	source\\3c\\neonbrand-428982-unsplash.jpg	preview\\4f\\neonbrand-428982-unsplash__preview.jpg	\N	23
2025-06-21 07:06:37.05833	2025-06-21 07:06:37.05833	michael-guite-571169-unsplash.jpg	IMAGE	image/jpeg	1600	1067	240247	source\\ab\\michael-guite-571169-unsplash.jpg	preview\\96\\michael-guite-571169-unsplash__preview.jpg	\N	24
2025-06-21 07:06:37.114396	2025-06-21 07:06:37.114396	max-tarkhov-737999-unsplash.jpg	IMAGE	image/jpeg	1600	1280	192508	source\\ed\\max-tarkhov-737999-unsplash.jpg	preview\\35\\max-tarkhov-737999-unsplash__preview.jpg	\N	25
2025-06-21 07:06:37.164041	2025-06-21 07:06:37.164041	nik-shuliahin-619349-unsplash.jpg	IMAGE	image/jpeg	1600	1020	130437	source\\87\\nik-shuliahin-619349-unsplash.jpg	preview\\d6\\nik-shuliahin-619349-unsplash__preview.jpg	\N	26
2025-06-21 07:06:37.224842	2025-06-21 07:06:37.224842	ben-hershey-574483-unsplash.jpg	IMAGE	image/jpeg	1600	1070	77118	source\\f3\\ben-hershey-574483-unsplash.jpg	preview\\30\\ben-hershey-574483-unsplash__preview.jpg	\N	27
2025-06-21 07:06:37.293548	2025-06-21 07:06:37.293548	tommy-bebo-600358-unsplash.jpg	IMAGE	image/jpeg	1067	1600	262335	source\\ac\\tommy-bebo-600358-unsplash.jpg	preview\\0f\\tommy-bebo-600358-unsplash__preview.jpg	\N	28
2025-06-21 07:06:37.344317	2025-06-21 07:06:37.344317	chuttersnap-584518-unsplash.jpg	IMAGE	image/jpeg	1600	1068	76330	source\\20\\chuttersnap-584518-unsplash.jpg	preview\\ed\\chuttersnap-584518-unsplash__preview.jpg	\N	29
2025-06-21 07:06:37.54149	2025-06-21 07:06:37.54149	imani-clovis-234736-unsplash.jpg	IMAGE	image/jpeg	1600	1600	99111	source\\de\\imani-clovis-234736-unsplash.jpg	preview\\0f\\imani-clovis-234736-unsplash__preview.jpg	\N	30
2025-06-21 07:06:37.700117	2025-06-21 07:06:37.700117	xavier-teo-469050-unsplash.jpg	IMAGE	image/jpeg	1200	1600	167599	source\\5c\\xavier-teo-469050-unsplash.jpg	preview\\3c\\xavier-teo-469050-unsplash__preview.jpg	\N	31
2025-06-21 07:06:37.84098	2025-06-21 07:06:37.84098	thomas-serer-420833-unsplash.jpg	IMAGE	image/jpeg	1600	1223	78999	source\\55\\thomas-serer-420833-unsplash.jpg	preview\\a2\\thomas-serer-420833-unsplash__preview.jpg	\N	32
2025-06-21 07:06:37.97792	2025-06-21 07:06:37.97792	nikolai-chernichenko-1299748-unsplash.jpg	IMAGE	image/jpeg	1600	1067	56282	source\\01\\nikolai-chernichenko-1299748-unsplash.jpg	preview\\00\\nikolai-chernichenko-1299748-unsplash__preview.jpg	\N	33
2025-06-21 07:06:38.119888	2025-06-21 07:06:38.119888	mitch-lensink-256007-unsplash.jpg	IMAGE	image/jpeg	1600	1067	154988	source\\2b\\mitch-lensink-256007-unsplash.jpg	preview\\aa\\mitch-lensink-256007-unsplash__preview.jpg	\N	34
2025-06-21 07:06:38.29324	2025-06-21 07:06:38.29324	charles-deluvio-695736-unsplash.jpg	IMAGE	image/jpeg	1600	1600	54419	source\\92\\charles-deluvio-695736-unsplash.jpg	preview\\78\\charles-deluvio-695736-unsplash__preview.jpg	\N	35
2025-06-21 07:06:38.38181	2025-06-21 07:06:38.38181	natalia-y-345738-unsplash.jpg	IMAGE	image/jpeg	900	1600	97819	source\\17\\natalia-y-345738-unsplash.jpg	preview\\14\\natalia-y-345738-unsplash__preview.jpg	\N	36
2025-06-21 07:06:38.448899	2025-06-21 07:06:38.448899	alex-rodriguez-santibanez-200278-unsplash.jpg	IMAGE	image/jpeg	1600	1067	176280	source\\ff\\alex-rodriguez-santibanez-200278-unsplash.jpg	preview\\5b\\alex-rodriguez-santibanez-200278-unsplash__preview.jpg	\N	37
2025-06-21 07:06:38.497761	2025-06-21 07:06:38.497761	silvia-agrasar-227575-unsplash.jpg	IMAGE	image/jpeg	1600	1063	119654	source\\d5\\silvia-agrasar-227575-unsplash.jpg	preview\\29\\silvia-agrasar-227575-unsplash__preview.jpg	\N	38
2025-06-21 07:06:38.850651	2025-06-21 07:06:38.850651	neslihan-gunaydin-3493-unsplash.jpg	IMAGE	image/jpeg	1600	1067	152486	source\\01\\neslihan-gunaydin-3493-unsplash.jpg	preview\\7d\\neslihan-gunaydin-3493-unsplash__preview.jpg	\N	44
2025-06-21 07:06:38.90228	2025-06-21 07:06:38.90228	florian-klauer-14840-unsplash.jpg	IMAGE	image/jpeg	800	1200	17149	source\\a9\\florian-klauer-14840-unsplash.jpg	preview\\ef\\florian-klauer-14840-unsplash__preview.jpg	\N	45
2025-06-21 07:06:38.959265	2025-06-21 07:06:38.959265	nathan-fertig-249917-unsplash.jpg	IMAGE	image/jpeg	1600	1067	113855	source\\68\\nathan-fertig-249917-unsplash.jpg	preview\\69\\nathan-fertig-249917-unsplash__preview.jpg	\N	46
2025-06-21 07:06:39.017876	2025-06-21 07:06:39.017876	paul-weaver-1120584-unsplash.jpg	IMAGE	image/jpeg	1600	1067	65612	source\\14\\paul-weaver-1120584-unsplash.jpg	preview\\3e\\paul-weaver-1120584-unsplash__preview.jpg	\N	47
2025-06-21 07:06:39.349908	2025-06-21 07:06:39.349908	benjamin-voros-310026-unsplash.jpg	IMAGE	image/jpeg	1200	1600	218391	source\\7a\\benjamin-voros-310026-unsplash.jpg	preview\\72\\benjamin-voros-310026-unsplash__preview.jpg	\N	53
2025-06-21 07:08:25.110222	2025-06-21 07:08:25.110222	caleb-george-536388-unsplash.jpg	IMAGE	image/jpeg	1200	1600	184968	source\\f0\\caleb-george-536388-unsplash.jpg	preview\\6d\\caleb-george-536388-unsplash__preview.jpg	\N	39
2025-06-21 07:06:39.137447	2025-06-21 07:06:39.137447	abel-y-costa-716024-unsplash.jpg	IMAGE	image/jpeg	1600	1067	103392	source\\46\\abel-y-costa-716024-unsplash.jpg	preview\\40\\abel-y-costa-716024-unsplash__preview.jpg	\N	49
2025-06-21 07:06:39.248085	2025-06-21 07:06:39.248085	andres-jasso-220776-unsplash.jpg	IMAGE	image/jpeg	1600	1104	100927	source\\f1\\andres-jasso-220776-unsplash.jpg	preview\\09\\andres-jasso-220776-unsplash__preview.jpg	\N	51
2025-06-21 07:08:25.164948	2025-06-21 07:08:25.164948	annie-spratt-78044-unsplash.jpg	IMAGE	image/jpeg	1115	1600	173536	source\\f1\\annie-spratt-78044-unsplash.jpg	preview\\81\\annie-spratt-78044-unsplash__preview.jpg	\N	40
2025-06-21 07:06:38.721011	2025-06-21 07:06:38.721011	mark-tegethoff-667351-unsplash.jpg	IMAGE	image/jpeg	1600	1200	79857	source\\e6\\mark-tegethoff-667351-unsplash.jpg	preview\\f3\\mark-tegethoff-667351-unsplash__preview.jpg	\N	42
2025-06-21 07:06:38.774114	2025-06-21 07:06:38.774114	vincent-liu-525429-unsplash.jpg	IMAGE	image/jpeg	1600	1067	77358	source\\10\\vincent-liu-525429-unsplash.jpg	preview\\44\\vincent-liu-525429-unsplash__preview.jpg	\N	43
2025-06-21 07:08:25.21521	2025-06-21 07:08:25.21521	zoltan-kovacs-642412-unsplash.jpg	IMAGE	image/jpeg	1067	1600	72752	source\\e3\\zoltan-kovacs-642412-unsplash.jpg	preview\\88\\zoltan-kovacs-642412-unsplash__preview.jpg	\N	41
2025-06-21 07:06:39.082315	2025-06-21 07:06:39.082315	pierre-chatel-innocenti-483198-unsplash.jpg	IMAGE	image/jpeg	1600	1067	32036	source\\39\\pierre-chatel-innocenti-483198-unsplash.jpg	preview\\5f\\pierre-chatel-innocenti-483198-unsplash__preview.jpg	\N	48
2025-06-21 07:06:39.398504	2025-06-21 07:06:39.398504	jean-philippe-delberghe-1400011-unsplash.jpg	IMAGE	image/jpeg	1067	1600	64529	source\\94\\jean-philippe-delberghe-1400011-unsplash.jpg	preview\\b1\\jean-philippe-delberghe-1400011-unsplash__preview.jpg	\N	54
2025-06-21 07:06:39.19961	2025-06-21 07:06:39.19961	kari-shea-398668-unsplash.jpg	IMAGE	image/jpeg	1048	1500	181352	source\\4f\\kari-shea-398668-unsplash.jpg	preview\\3b\\kari-shea-398668-unsplash__preview.jpg	\N	50
2025-06-21 07:06:39.292385	2025-06-21 07:06:39.292385	ruslan-bardash-351288-unsplash.jpg	IMAGE	image/jpeg	1067	1600	47113	source\\95\\ruslan-bardash-351288-unsplash.jpg	preview\\d0\\ruslan-bardash-351288-unsplash__preview.jpg	\N	52
\.


--
-- Data for Name: asset_channels_channel; Type: TABLE DATA; Schema: public; Owner: vendure
--

COPY public.asset_channels_channel ("assetId", "channelId") FROM stdin;
1	1
2	1
3	1
4	1
5	1
6	1
7	1
8	1
9	1
10	1
11	1
12	1
13	1
14	1
15	1
16	1
17	1
18	1
19	1
20	1
21	1
22	1
23	1
24	1
25	1
26	1
27	1
28	1
29	1
30	1
31	1
32	1
33	1
34	1
35	1
36	1
37	1
38	1
39	1
40	1
41	1
42	1
43	1
44	1
45	1
46	1
47	1
48	1
49	1
50	1
51	1
52	1
53	1
54	1
\.


--
-- Data for Name: asset_tags_tag; Type: TABLE DATA; Schema: public; Owner: vendure
--

COPY public.asset_tags_tag ("assetId", "tagId") FROM stdin;
\.


--
-- Data for Name: authentication_method; Type: TABLE DATA; Schema: public; Owner: vendure
--

COPY public.authentication_method ("createdAt", "updatedAt", identifier, "passwordHash", "verificationToken", "passwordResetToken", "identifierChangeToken", "pendingIdentifier", strategy, "externalIdentifier", metadata, id, type, "userId") FROM stdin;
2025-06-21 07:06:32.120844	2025-06-21 07:06:32.127574	superadmin	$2b$12$xcqjuaMSDaQmMMhvzJTpNO4w9x8Bhc8TVZcfpgkRdS1OkH9K1JjkW	\N	\N	\N	\N	\N	\N	\N	1	NativeAuthenticationMethod	1
\.


--
-- Data for Name: channel; Type: TABLE DATA; Schema: public; Owner: vendure
--

COPY public.channel ("createdAt", "updatedAt", code, token, description, "defaultLanguageCode", "availableLanguageCodes", "defaultCurrencyCode", "availableCurrencyCodes", "trackInventory", "outOfStockThreshold", "pricesIncludeTax", id, "sellerId", "defaultTaxZoneId", "defaultShippingZoneId") FROM stdin;
2025-06-21 07:06:31.827702	2025-06-21 07:06:34.979747	__default_channel__	5pler0mlhh5px9fh222h		en	en	USD	USD	t	0	f	1	1	2	2
\.


--
-- Data for Name: collection; Type: TABLE DATA; Schema: public; Owner: vendure
--

COPY public.collection ("createdAt", "updatedAt", "isRoot", "position", "isPrivate", filters, "inheritFilters", id, "parentId", "featuredAssetId") FROM stdin;
2025-06-21 07:06:39.544394	2025-06-21 07:06:39.544394	t	0	f	[]	t	1	\N	\N
2025-06-21 07:06:39.554783	2025-06-21 07:06:39.554783	f	1	f	[{"code":"facet-value-filter","args":[{"name":"facetValueIds","value":"[1]"},{"name":"containsAny","value":"false"}]}]	t	2	1	16
2025-06-21 07:06:39.582182	2025-06-21 07:06:39.582182	f	1	f	[{"code":"facet-value-filter","args":[{"name":"facetValueIds","value":"[2]"},{"name":"containsAny","value":"false"}]}]	t	3	2	5
2025-06-21 07:06:39.606597	2025-06-21 07:06:39.606597	f	2	f	[{"code":"facet-value-filter","args":[{"name":"facetValueIds","value":"[9]"},{"name":"containsAny","value":"false"}]}]	t	4	2	12
2025-06-21 07:06:39.635447	2025-06-21 07:06:39.635447	f	2	f	[{"code":"facet-value-filter","args":[{"name":"facetValueIds","value":"[30]"},{"name":"containsAny","value":"false"}]}]	t	5	1	47
2025-06-21 07:06:39.65876	2025-06-21 07:06:39.65876	f	1	f	[{"code":"facet-value-filter","args":[{"name":"facetValueIds","value":"[34]"},{"name":"containsAny","value":"false"}]}]	t	6	5	46
2025-06-21 07:06:39.684711	2025-06-21 07:06:39.684711	f	2	f	[{"code":"facet-value-filter","args":[{"name":"facetValueIds","value":"[31]"},{"name":"containsAny","value":"false"}]}]	t	7	5	37
2025-06-21 07:06:39.708257	2025-06-21 07:06:39.708257	f	3	f	[{"code":"facet-value-filter","args":[{"name":"facetValueIds","value":"[17]"},{"name":"containsAny","value":"false"}]}]	t	8	1	24
2025-06-21 07:06:39.737321	2025-06-21 07:06:39.737321	f	1	f	[{"code":"facet-value-filter","args":[{"name":"facetValueIds","value":"[18]"},{"name":"containsAny","value":"false"}]}]	t	9	8	23
2025-06-21 07:06:39.762019	2025-06-21 07:06:39.762019	f	2	f	[{"code":"facet-value-filter","args":[{"name":"facetValueIds","value":"[23]"},{"name":"containsAny","value":"false"}]}]	t	10	8	32
\.


--
-- Data for Name: collection_asset; Type: TABLE DATA; Schema: public; Owner: vendure
--

COPY public.collection_asset ("createdAt", "updatedAt", "assetId", "position", "collectionId", id) FROM stdin;
2025-06-21 07:06:39.56303	2025-06-21 07:06:39.56303	16	0	2	1
2025-06-21 07:06:39.589586	2025-06-21 07:06:39.589586	5	0	3	2
2025-06-21 07:06:39.618427	2025-06-21 07:06:39.618427	12	0	4	3
2025-06-21 07:06:39.64299	2025-06-21 07:06:39.64299	47	0	5	4
2025-06-21 07:06:39.667503	2025-06-21 07:06:39.667503	46	0	6	5
2025-06-21 07:06:39.692201	2025-06-21 07:06:39.692201	37	0	7	6
2025-06-21 07:06:39.718503	2025-06-21 07:06:39.718503	24	0	8	7
2025-06-21 07:06:39.74468	2025-06-21 07:06:39.74468	23	0	9	8
2025-06-21 07:06:39.770587	2025-06-21 07:06:39.770587	32	0	10	9
\.


--
-- Data for Name: collection_channels_channel; Type: TABLE DATA; Schema: public; Owner: vendure
--

COPY public.collection_channels_channel ("collectionId", "channelId") FROM stdin;
1	1
2	1
3	1
4	1
5	1
6	1
7	1
8	1
9	1
10	1
\.


--
-- Data for Name: collection_closure; Type: TABLE DATA; Schema: public; Owner: vendure
--

COPY public.collection_closure (id_ancestor, id_descendant) FROM stdin;
1	1
2	2
1	2
3	3
2	3
1	3
4	4
2	4
1	4
5	5
1	5
6	6
5	6
1	6
7	7
5	7
1	7
8	8
1	8
9	9
8	9
1	9
10	10
8	10
1	10
\.


--
-- Data for Name: collection_product_variants_product_variant; Type: TABLE DATA; Schema: public; Owner: vendure
--

COPY public.collection_product_variants_product_variant ("collectionId", "productVariantId") FROM stdin;
2	1
2	2
2	3
2	4
2	5
2	6
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
2	23
2	24
2	25
2	26
2	27
2	28
2	29
2	30
2	31
2	32
2	33
2	34
3	1
3	2
3	3
3	4
3	5
3	6
3	7
3	8
3	9
3	10
3	11
3	12
3	13
3	14
3	15
3	16
3	17
3	18
3	19
3	20
3	21
3	22
3	23
3	24
3	25
4	26
4	27
4	28
4	29
4	30
4	31
4	32
4	33
4	34
5	67
5	68
5	69
5	70
5	71
5	72
5	73
5	74
5	75
5	76
5	77
5	78
5	79
5	80
5	81
5	82
5	83
5	84
5	85
5	86
5	87
5	88
6	75
6	77
6	78
6	79
6	80
6	81
6	82
6	83
6	84
6	85
6	86
6	87
6	88
7	67
7	68
7	69
7	70
7	71
7	72
7	73
7	74
7	76
8	35
8	36
8	37
8	38
8	39
8	40
8	41
8	42
8	43
8	44
8	45
8	46
8	47
8	48
8	49
8	50
8	51
8	52
8	53
8	54
8	55
8	56
8	57
8	58
8	59
8	60
8	61
8	62
8	63
8	64
8	65
8	66
9	35
9	36
9	37
9	38
9	39
9	40
9	41
9	42
10	43
10	44
10	45
10	46
10	47
10	48
10	49
10	50
10	51
10	52
10	53
10	54
10	55
10	56
10	57
10	58
10	59
10	60
10	61
10	62
10	63
10	64
10	65
10	66
\.


--
-- Data for Name: collection_translation; Type: TABLE DATA; Schema: public; Owner: vendure
--

COPY public.collection_translation ("createdAt", "updatedAt", "languageCode", name, slug, description, id, "baseId") FROM stdin;
2025-06-21 07:06:39.539107	2025-06-21 07:06:39.544394	en	__root_collection__	__root_collection__	The root of the Collection tree.	2	1
2025-06-21 07:06:39.53333	2025-06-21 07:06:39.554783	en	Electronics	electronics		1	2
2025-06-21 07:06:39.576072	2025-06-21 07:06:39.582182	en	Computers	computers		3	3
2025-06-21 07:06:39.600635	2025-06-21 07:06:39.606597	en	Camera & Photo	camera-photo		4	4
2025-06-21 07:06:39.630647	2025-06-21 07:06:39.635447	en	Home & Garden	home-garden		5	5
2025-06-21 07:06:39.652695	2025-06-21 07:06:39.65876	en	Furniture	furniture		6	6
2025-06-21 07:06:39.678821	2025-06-21 07:06:39.684711	en	Plants	plants		7	7
2025-06-21 07:06:39.702826	2025-06-21 07:06:39.708257	en	Sports & Outdoor	sports-outdoor		8	8
2025-06-21 07:06:39.730053	2025-06-21 07:06:39.737321	en	Equipment	equipment		9	9
2025-06-21 07:06:39.756146	2025-06-21 07:06:39.762019	en	Footwear	footwear		10	10
\.


--
-- Data for Name: customer; Type: TABLE DATA; Schema: public; Owner: vendure
--

COPY public.customer ("createdAt", "updatedAt", "deletedAt", title, "firstName", "lastName", "phoneNumber", "emailAddress", id, "userId") FROM stdin;
\.


--
-- Data for Name: customer_channels_channel; Type: TABLE DATA; Schema: public; Owner: vendure
--

COPY public.customer_channels_channel ("customerId", "channelId") FROM stdin;
\.


--
-- Data for Name: customer_group; Type: TABLE DATA; Schema: public; Owner: vendure
--

COPY public.customer_group ("createdAt", "updatedAt", name, id) FROM stdin;
\.


--
-- Data for Name: customer_groups_customer_group; Type: TABLE DATA; Schema: public; Owner: vendure
--

COPY public.customer_groups_customer_group ("customerId", "customerGroupId") FROM stdin;
\.


--
-- Data for Name: facet; Type: TABLE DATA; Schema: public; Owner: vendure
--

COPY public.facet ("createdAt", "updatedAt", "isPrivate", code, id) FROM stdin;
2025-06-21 07:06:35.087682	2025-06-21 07:06:35.087682	f	category	1
2025-06-21 07:06:35.131978	2025-06-21 07:06:35.131978	f	brand	2
2025-06-21 07:06:37.37132	2025-06-21 07:06:37.37132	f	color	3
2025-06-21 07:06:38.321198	2025-06-21 07:06:38.321198	f	plant-type	4
\.


--
-- Data for Name: facet_channels_channel; Type: TABLE DATA; Schema: public; Owner: vendure
--

COPY public.facet_channels_channel ("facetId", "channelId") FROM stdin;
1	1
2	1
3	1
4	1
\.


--
-- Data for Name: facet_translation; Type: TABLE DATA; Schema: public; Owner: vendure
--

COPY public.facet_translation ("createdAt", "updatedAt", "languageCode", name, id, "baseId") FROM stdin;
2025-06-21 07:06:35.082908	2025-06-21 07:06:35.087682	en	category	1	1
2025-06-21 07:06:35.12771	2025-06-21 07:06:35.131978	en	brand	2	2
2025-06-21 07:06:37.367565	2025-06-21 07:06:37.37132	en	color	3	3
2025-06-21 07:06:38.317664	2025-06-21 07:06:38.321198	en	plant type	4	4
\.


--
-- Data for Name: facet_value; Type: TABLE DATA; Schema: public; Owner: vendure
--

COPY public.facet_value ("createdAt", "updatedAt", code, id, "facetId") FROM stdin;
2025-06-21 07:06:35.105225	2025-06-21 07:06:35.105225	electronics	1	1
2025-06-21 07:06:35.117435	2025-06-21 07:06:35.117435	computers	2	1
2025-06-21 07:06:35.142978	2025-06-21 07:06:35.142978	apple	3	2
2025-06-21 07:06:35.44742	2025-06-21 07:06:35.44742	logitech	4	2
2025-06-21 07:06:35.518091	2025-06-21 07:06:35.518091	samsung	5	2
2025-06-21 07:06:35.687063	2025-06-21 07:06:35.687063	corsair	6	2
2025-06-21 07:06:35.827967	2025-06-21 07:06:35.827967	admi	7	2
2025-06-21 07:06:35.993364	2025-06-21 07:06:35.993364	seagate	8	2
2025-06-21 07:06:36.332546	2025-06-21 07:06:36.332546	photo	9	1
2025-06-21 07:06:36.343496	2025-06-21 07:06:36.343496	polaroid	10	2
2025-06-21 07:06:36.403219	2025-06-21 07:06:36.403219	nikkon	11	2
2025-06-21 07:06:36.468256	2025-06-21 07:06:36.468256	agfa	12	2
2025-06-21 07:06:36.526911	2025-06-21 07:06:36.526911	manfrotto	13	2
2025-06-21 07:06:36.583235	2025-06-21 07:06:36.583235	kodak	14	2
2025-06-21 07:06:36.648266	2025-06-21 07:06:36.648266	sony	15	2
2025-06-21 07:06:36.802461	2025-06-21 07:06:36.802461	rolleiflex	16	2
2025-06-21 07:06:36.866142	2025-06-21 07:06:36.866142	sports-outdoor	17	1
2025-06-21 07:06:36.875668	2025-06-21 07:06:36.875668	equipment	18	1
2025-06-21 07:06:36.884944	2025-06-21 07:06:36.884944	pinarello	19	2
2025-06-21 07:06:36.945747	2025-06-21 07:06:36.945747	everlast	20	2
2025-06-21 07:06:37.171047	2025-06-21 07:06:37.171047	nike	21	2
2025-06-21 07:06:37.231695	2025-06-21 07:06:37.231695	wilson	22	2
2025-06-21 07:06:37.35046	2025-06-21 07:06:37.35046	footwear	23	1
2025-06-21 07:06:37.359673	2025-06-21 07:06:37.359673	adidas	24	2
2025-06-21 07:06:37.382512	2025-06-21 07:06:37.382512	blue	25	3
2025-06-21 07:06:37.392234	2025-06-21 07:06:37.392234	pink	26	3
2025-06-21 07:06:37.54872	2025-06-21 07:06:37.54872	black	27	3
2025-06-21 07:06:37.707075	2025-06-21 07:06:37.707075	white	28	3
2025-06-21 07:06:38.128645	2025-06-21 07:06:38.128645	converse	29	2
2025-06-21 07:06:38.299419	2025-06-21 07:06:38.299419	home-garden	30	1
2025-06-21 07:06:38.308431	2025-06-21 07:06:38.308431	plants	31	1
2025-06-21 07:06:38.332806	2025-06-21 07:06:38.332806	indoor	32	4
2025-06-21 07:06:38.387945	2025-06-21 07:06:38.387945	outdoor	33	4
2025-06-21 07:06:38.780502	2025-06-21 07:06:38.780502	furniture	34	1
2025-06-21 07:06:38.790508	2025-06-21 07:06:38.790508	gray	35	3
2025-06-21 07:06:39.025343	2025-06-21 07:06:39.025343	brown	36	3
2025-06-21 07:06:39.144425	2025-06-21 07:06:39.144425	wood	37	3
2025-06-21 07:06:39.438729	2025-06-21 07:06:39.438729	yellow	38	3
2025-06-21 07:06:39.471959	2025-06-21 07:06:39.471959	green	39	3
\.


--
-- Data for Name: facet_value_channels_channel; Type: TABLE DATA; Schema: public; Owner: vendure
--

COPY public.facet_value_channels_channel ("facetValueId", "channelId") FROM stdin;
1	1
2	1
3	1
4	1
5	1
6	1
7	1
8	1
9	1
10	1
11	1
12	1
13	1
14	1
15	1
16	1
17	1
18	1
19	1
20	1
21	1
22	1
23	1
24	1
25	1
26	1
27	1
28	1
29	1
30	1
31	1
32	1
33	1
34	1
35	1
36	1
37	1
38	1
39	1
\.


--
-- Data for Name: facet_value_translation; Type: TABLE DATA; Schema: public; Owner: vendure
--

COPY public.facet_value_translation ("createdAt", "updatedAt", "languageCode", name, id, "baseId") FROM stdin;
2025-06-21 07:06:35.100507	2025-06-21 07:06:35.105225	en	Electronics	1	1
2025-06-21 07:06:35.114563	2025-06-21 07:06:35.117435	en	Computers	2	2
2025-06-21 07:06:35.140418	2025-06-21 07:06:35.142978	en	Apple	3	3
2025-06-21 07:06:35.444411	2025-06-21 07:06:35.44742	en	Logitech	4	4
2025-06-21 07:06:35.514952	2025-06-21 07:06:35.518091	en	Samsung	5	5
2025-06-21 07:06:35.683936	2025-06-21 07:06:35.687063	en	Corsair	6	6
2025-06-21 07:06:35.824693	2025-06-21 07:06:35.827967	en	ADMI	7	7
2025-06-21 07:06:35.990846	2025-06-21 07:06:35.993364	en	Seagate	8	8
2025-06-21 07:06:36.330198	2025-06-21 07:06:36.332546	en	Photo	9	9
2025-06-21 07:06:36.340089	2025-06-21 07:06:36.343496	en	Polaroid	10	10
2025-06-21 07:06:36.399227	2025-06-21 07:06:36.403219	en	Nikkon	11	11
2025-06-21 07:06:36.465641	2025-06-21 07:06:36.468256	en	Agfa	12	12
2025-06-21 07:06:36.524733	2025-06-21 07:06:36.526911	en	Manfrotto	13	13
2025-06-21 07:06:36.581081	2025-06-21 07:06:36.583235	en	Kodak	14	14
2025-06-21 07:06:36.645607	2025-06-21 07:06:36.648266	en	Sony	15	15
2025-06-21 07:06:36.800239	2025-06-21 07:06:36.802461	en	Rolleiflex	16	16
2025-06-21 07:06:36.863949	2025-06-21 07:06:36.866142	en	Sports & Outdoor	17	17
2025-06-21 07:06:36.872986	2025-06-21 07:06:36.875668	en	Equipment	18	18
2025-06-21 07:06:36.882465	2025-06-21 07:06:36.884944	en	Pinarello	19	19
2025-06-21 07:06:36.943131	2025-06-21 07:06:36.945747	en	Everlast	20	20
2025-06-21 07:06:37.168333	2025-06-21 07:06:37.171047	en	Nike	21	21
2025-06-21 07:06:37.229353	2025-06-21 07:06:37.231695	en	Wilson	22	22
2025-06-21 07:06:37.348104	2025-06-21 07:06:37.35046	en	Footwear	23	23
2025-06-21 07:06:37.357165	2025-06-21 07:06:37.359673	en	Adidas	24	24
2025-06-21 07:06:37.380285	2025-06-21 07:06:37.382512	en	blue	25	25
2025-06-21 07:06:37.38962	2025-06-21 07:06:37.392234	en	pink	26	26
2025-06-21 07:06:37.546012	2025-06-21 07:06:37.54872	en	black	27	27
2025-06-21 07:06:37.704375	2025-06-21 07:06:37.707075	en	white	28	28
2025-06-21 07:06:38.125699	2025-06-21 07:06:38.128645	en	Converse	29	29
2025-06-21 07:06:38.296637	2025-06-21 07:06:38.299419	en	Home & Garden	30	30
2025-06-21 07:06:38.306377	2025-06-21 07:06:38.308431	en	Plants	31	31
2025-06-21 07:06:38.330389	2025-06-21 07:06:38.332806	en	Indoor	32	32
2025-06-21 07:06:38.385567	2025-06-21 07:06:38.387945	en	Outdoor	33	33
2025-06-21 07:06:38.778097	2025-06-21 07:06:38.780502	en	Furniture	34	34
2025-06-21 07:06:38.787694	2025-06-21 07:06:38.790508	en	gray	35	35
2025-06-21 07:06:39.022465	2025-06-21 07:06:39.025343	en	brown	36	36
2025-06-21 07:06:39.141433	2025-06-21 07:06:39.144425	en	wood	37	37
2025-06-21 07:06:39.436441	2025-06-21 07:06:39.438729	en	yellow	38	38
2025-06-21 07:06:39.468789	2025-06-21 07:06:39.471959	en	green	39	39
\.


--
-- Data for Name: fulfillment; Type: TABLE DATA; Schema: public; Owner: vendure
--

COPY public.fulfillment ("createdAt", "updatedAt", state, "trackingCode", method, "handlerCode", id) FROM stdin;
\.


--
-- Data for Name: global_settings; Type: TABLE DATA; Schema: public; Owner: vendure
--

COPY public.global_settings ("createdAt", "updatedAt", "availableLanguages", "trackInventory", "outOfStockThreshold", id) FROM stdin;
2025-06-21 07:06:31.804102	2025-06-21 07:06:31.804102	en	t	0	1
\.


--
-- Data for Name: history_entry; Type: TABLE DATA; Schema: public; Owner: vendure
--

COPY public.history_entry ("createdAt", "updatedAt", type, "isPublic", data, id, discriminator, "administratorId", "customerId", "orderId") FROM stdin;
\.


--
-- Data for Name: job_record; Type: TABLE DATA; Schema: public; Owner: vendure
--

COPY public.job_record ("createdAt", "updatedAt", "queueName", data, state, progress, result, error, "startedAt", "settledAt", "isSettled", retries, attempts, id) FROM stdin;
2025-06-21 07:06:35.26829	2025-06-21 07:06:35.626542	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[2]}	COMPLETED	100	true	\N	2025-06-21 12:38:22.13	2025-06-21 12:38:22.18	t	0	1	2
2025-06-21 07:06:35.241054	2025-06-21 07:06:35.436282	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[1]}	COMPLETED	100	true	\N	2025-06-21 12:38:21.917	2025-06-21 12:38:21.989	t	0	1	1
2025-06-21 07:06:35.556834	2025-06-21 07:06:36.863511	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[8]}	COMPLETED	100	true	\N	2025-06-21 12:38:23.368	2025-06-21 12:38:23.418	t	0	1	8
2025-06-21 07:06:35.776708	2025-06-21 07:06:37.684994	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[12]}	COMPLETED	100	true	\N	2025-06-21 12:38:24.193	2025-06-21 12:38:24.239	t	0	1	12
2025-06-21 07:06:35.926634	2025-06-21 07:06:38.30799	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[15]}	COMPLETED	100	true	\N	2025-06-21 12:38:24.815	2025-06-21 12:38:24.862	t	0	1	15
2025-06-21 07:06:35.96507	2025-06-21 07:06:38.723886	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[17]}	COMPLETED	100	true	\N	2025-06-21 12:38:25.23	2025-06-21 12:38:25.283	t	0	1	17
2025-06-21 07:06:36.147822	2025-06-21 07:06:39.759656	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[22]}	COMPLETED	100	true	\N	2025-06-21 12:38:26.269	2025-06-21 12:38:26.319	t	0	1	22
2025-06-21 07:06:36.917739	2025-06-21 07:07:06.740304	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[35]}	COMPLETED	100	true	\N	2025-06-21 12:38:53.222	2025-06-21 12:38:53.302	t	0	1	35
2025-06-21 07:06:35.387689	2025-06-21 07:06:36.247587	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[5]}	COMPLETED	100	true	\N	2025-06-21 12:38:22.747	2025-06-21 12:38:22.802	t	0	1	5
2025-06-21 07:06:35.290054	2025-06-21 07:06:35.836826	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[3]}	COMPLETED	100	true	\N	2025-06-21 12:38:22.336	2025-06-21 12:38:22.39	t	0	1	3
2025-06-21 07:06:36.127716	2025-06-21 07:06:39.559229	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[21]}	COMPLETED	100	true	\N	2025-06-21 12:38:26.061	2025-06-21 12:38:26.119	t	0	1	21
2025-06-21 07:06:36.556147	2025-06-21 07:06:41.268789	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[29]}	COMPLETED	100	true	\N	2025-06-21 12:38:27.78	2025-06-21 12:38:27.828	t	0	1	29
2025-06-21 07:06:35.311892	2025-06-21 07:06:36.037561	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[4]}	COMPLETED	100	true	\N	2025-06-21 12:38:22.542	2025-06-21 12:38:22.591	t	0	1	4
2025-06-21 07:06:35.485722	2025-06-21 07:06:36.654048	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[7]}	COMPLETED	100	true	\N	2025-06-21 12:38:23.161	2025-06-21 12:38:23.208	t	0	1	7
2025-06-21 07:06:36.733288	2025-06-21 07:07:06.107867	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[32]}	COMPLETED	100	true	\N	2025-06-21 12:38:52.561	2025-06-21 12:38:52.669	t	0	1	32
2025-06-21 07:06:37.144704	2025-06-21 07:07:07.590194	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[39]}	COMPLETED	100	true	\N	2025-06-21 12:38:54.098	2025-06-21 12:38:54.152	t	0	1	39
2025-06-21 07:06:35.415154	2025-06-21 07:06:36.444707	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[6]}	COMPLETED	100	true	\N	2025-06-21 12:38:22.954	2025-06-21 12:38:22.999	t	0	1	6
2025-06-21 07:06:35.632837	2025-06-21 07:06:37.070096	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[9]}	COMPLETED	100	true	\N	2025-06-21 12:38:23.574	2025-06-21 12:38:23.624	t	0	1	9
2025-06-21 07:06:37.785761	2025-06-21 07:07:10.408604	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[52]}	COMPLETED	100	true	\N	2025-06-21 12:38:56.922	2025-06-21 12:38:56.971	t	0	1	52
2025-06-21 07:06:37.903683	2025-06-21 07:07:11.062732	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[55]}	COMPLETED	100	true	\N	2025-06-21 12:38:57.573	2025-06-21 12:38:57.626	t	0	1	55
2025-06-21 07:06:36.976677	2025-06-21 07:07:06.952386	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[36]}	COMPLETED	100	true	\N	2025-06-21 12:38:53.442	2025-06-21 12:38:53.514	t	0	1	36
2025-06-21 07:06:36.615831	2025-06-21 07:06:41.486589	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[30]}	COMPLETED	100	true	\N	2025-06-21 12:38:28	2025-06-21 12:38:28.046	t	0	1	30
2025-06-21 07:06:39.115918	2025-06-21 07:07:16.079978	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[80]}	COMPLETED	100	true	\N	2025-06-21 12:39:02.566	2025-06-21 12:39:02.637	t	0	1	80
2025-06-21 07:06:39.522078	2025-06-21 07:07:17.834352	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[88]}	COMPLETED	100	true	\N	2025-06-21 12:39:04.312	2025-06-21 12:39:04.391	t	0	1	88
2025-06-21 07:06:37.480116	2025-06-21 07:08:55.249571	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[44]}	COMPLETED	100	true	\N	2025-06-21 12:38:55.186	2025-06-21 12:38:55.248	t	0	1	44
2025-06-21 07:06:37.518705	2025-06-21 07:07:09.119777	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[46]}	COMPLETED	100	true	\N	2025-06-21 12:38:55.62	2025-06-21 12:38:55.683	t	0	1	46
2025-06-21 07:06:37.765173	2025-06-21 07:07:10.195508	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[51]}	COMPLETED	100	true	\N	2025-06-21 12:38:56.705	2025-06-21 12:38:56.758	t	0	1	51
2025-06-21 07:06:38.054509	2025-06-21 07:07:12.157422	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[60]}	COMPLETED	100	true	\N	2025-06-21 12:38:58.661	2025-06-21 12:38:58.72	t	0	1	60
2025-06-21 07:06:35.657789	2025-06-21 07:06:37.27379	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[10]}	COMPLETED	100	true	\N	2025-06-21 12:38:23.782	2025-06-21 12:38:23.828	t	0	1	10
2025-06-21 07:06:35.756962	2025-06-21 07:06:37.478943	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[11]}	COMPLETED	100	true	\N	2025-06-21 12:38:23.987	2025-06-21 12:38:24.033	t	0	1	11
2025-06-21 07:06:37.960859	2025-06-21 07:07:11.716459	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[58]}	COMPLETED	100	true	\N	2025-06-21 12:38:58.224	2025-06-21 12:38:58.279	t	0	1	58
2025-06-21 07:06:38.53042	2025-06-21 07:07:14.329452	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[70]}	COMPLETED	100	true	\N	2025-06-21 12:39:00.836	2025-06-21 12:39:00.886	t	0	1	70
2025-06-21 07:06:35.800628	2025-06-21 07:06:37.891414	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[13]}	COMPLETED	100	true	\N	2025-06-21 12:38:24.402	2025-06-21 12:38:24.446	t	0	1	13
2025-06-21 07:06:36.088702	2025-06-21 07:06:39.13227	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[19]}	COMPLETED	100	true	\N	2025-06-21 12:38:25.644	2025-06-21 12:38:25.691	t	0	1	19
2025-06-21 07:06:38.077246	2025-06-21 07:07:12.373881	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[61]}	COMPLETED	100	true	\N	2025-06-21 12:38:58.877	2025-06-21 12:38:58.937	t	0	1	61
2025-06-21 07:06:39.498649	2025-06-21 07:07:17.606116	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[87]}	COMPLETED	100	true	\N	2025-06-21 12:39:04.09	2025-06-21 12:39:04.162	t	0	1	87
2025-06-21 07:06:35.906863	2025-06-21 07:06:38.116761	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[14]}	COMPLETED	100	true	\N	2025-06-21 12:38:24.608	2025-06-21 12:38:24.671	t	0	1	14
2025-06-21 07:06:35.946489	2025-06-21 07:06:38.518654	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[16]}	COMPLETED	100	true	\N	2025-06-21 12:38:25.022	2025-06-21 12:38:25.073	t	0	1	16
2025-06-21 07:06:38.095707	2025-06-21 07:07:12.606492	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[62]}	COMPLETED	100	true	\N	2025-06-21 12:38:59.096	2025-06-21 12:38:59.169	t	0	1	62
2025-06-21 07:06:38.365312	2025-06-21 07:09:00.249051	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[67]}	COMPLETED	100	true	\N	2025-06-21 12:39:00.183	2025-06-21 12:39:00.247	t	0	1	67
2025-06-21 07:06:38.230461	2025-06-21 07:07:13.03203	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[64]}	COMPLETED	100	true	\N	2025-06-21 12:38:59.531	2025-06-21 12:38:59.595	t	0	1	64
2025-06-21 07:06:36.069101	2025-06-21 07:06:38.927278	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[18]}	COMPLETED	100	true	\N	2025-06-21 12:38:25.437	2025-06-21 12:38:25.487	t	0	1	18
2025-06-21 07:06:38.27122	2025-06-21 07:07:13.463071	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[66]}	COMPLETED	100	true	\N	2025-06-21 12:38:59.963	2025-06-21 12:39:00.026	t	0	1	66
2025-06-21 07:06:38.82631	2025-06-21 07:07:14.985161	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[75]}	COMPLETED	100	true	\N	2025-06-21 12:39:01.486	2025-06-21 12:39:01.542	t	0	1	75
2025-06-21 07:06:39.592063	2025-06-21 07:06:39.842279	apply-collection-filters	{"ctx":{"languageCode":"en","channelToken":"5pler0mlhh5px9fh222h"},"collectionIds":[3]}	COMPLETED	100	{"processedCollections":1}	\N	2025-06-21 12:38:26.374	2025-06-21 12:38:26.402	t	0	1	90
2025-06-21 07:06:38.935025	2025-06-21 07:07:15.428839	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[77]}	COMPLETED	100	true	\N	2025-06-21 12:39:01.917	2025-06-21 12:39:01.986	t	0	1	77
2025-06-21 07:06:39.566714	2025-06-21 07:06:39.620608	apply-collection-filters	{"ctx":{"languageCode":"en","channelToken":"5pler0mlhh5px9fh222h"},"collectionIds":[2]}	COMPLETED	100	{"processedCollections":1}	\N	2025-06-21 12:38:26.16	2025-06-21 12:38:26.18	t	0	1	89
2025-06-21 07:06:39.671037	2025-06-21 07:06:40.487934	apply-collection-filters	{"ctx":{"languageCode":"en","channelToken":"5pler0mlhh5px9fh222h"},"collectionIds":[6]}	COMPLETED	100	{"processedCollections":1}	\N	2025-06-21 12:38:27.027	2025-06-21 12:38:27.047	t	0	1	93
2025-06-21 07:06:39.645392	2025-06-21 07:06:40.267816	apply-collection-filters	{"ctx":{"languageCode":"en","channelToken":"5pler0mlhh5px9fh222h"},"collectionIds":[5]}	COMPLETED	100	{"processedCollections":1}	\N	2025-06-21 12:38:26.809	2025-06-21 12:38:26.827	t	0	1	92
2025-06-21 07:06:39.622677	2025-06-21 07:06:40.049612	apply-collection-filters	{"ctx":{"languageCode":"en","channelToken":"5pler0mlhh5px9fh222h"},"collectionIds":[4]}	COMPLETED	100	{"processedCollections":1}	\N	2025-06-21 12:38:26.593	2025-06-21 12:38:26.609	t	0	1	91
2025-06-21 07:06:39.694577	2025-06-21 07:06:40.700195	apply-collection-filters	{"ctx":{"languageCode":"en","channelToken":"5pler0mlhh5px9fh222h"},"collectionIds":[7]}	COMPLETED	100	{"processedCollections":1}	\N	2025-06-21 12:38:27.241	2025-06-21 12:38:27.26	t	0	1	95
2025-06-21 07:06:39.773364	2025-06-21 07:06:41.33783	apply-collection-filters	{"ctx":{"languageCode":"en","channelToken":"5pler0mlhh5px9fh222h"},"collectionIds":[10]}	COMPLETED	100	{"processedCollections":1}	\N	2025-06-21 12:38:27.877	2025-06-21 12:38:27.897	t	0	1	98
2025-06-21 07:06:39.721616	2025-06-21 07:06:40.916515	apply-collection-filters	{"ctx":{"languageCode":"en","channelToken":"5pler0mlhh5px9fh222h"},"collectionIds":[8]}	COMPLETED	100	{"processedCollections":1}	\N	2025-06-21 12:38:27.455	2025-06-21 12:38:27.476	t	0	1	96
2025-06-21 07:06:39.747375	2025-06-21 07:06:41.128712	apply-collection-filters	{"ctx":{"languageCode":"en","channelToken":"5pler0mlhh5px9fh222h"},"collectionIds":[9]}	COMPLETED	100	{"processedCollections":1}	\N	2025-06-21 12:38:27.672	2025-06-21 12:38:27.688	t	0	1	97
2025-06-21 07:06:38.995008	2025-06-21 07:07:15.647373	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[78]}	COMPLETED	100	true	\N	2025-06-21 12:39:02.134	2025-06-21 12:39:02.204	t	0	1	78
2025-06-21 07:06:39.06438	2025-06-21 07:07:15.870999	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[79]}	COMPLETED	100	true	\N	2025-06-21 12:39:02.353	2025-06-21 12:39:02.428	t	0	1	79
2025-06-21 07:06:39.378974	2025-06-21 07:07:17.184292	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[85]}	COMPLETED	100	true	\N	2025-06-21 12:39:03.656	2025-06-21 12:39:03.741	t	0	1	85
2025-06-21 07:06:36.200622	2025-06-21 07:06:39.974759	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[23]}	COMPLETED	100	true	\N	2025-06-21 12:38:26.483	2025-06-21 12:38:26.534	t	0	1	23
2025-06-21 07:06:39.228301	2025-06-21 07:07:16.517876	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[82]}	COMPLETED	100	true	\N	2025-06-21 12:39:03.01	2025-06-21 12:39:03.075	t	0	1	82
2025-06-21 07:06:39.321408	2025-06-21 07:07:16.96998	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[84]}	COMPLETED	100	true	\N	2025-06-21 12:39:03.441	2025-06-21 12:39:03.527	t	0	1	84
2025-06-21 07:06:39.904802	2025-06-21 07:07:21.248494	update-search-index	{"type":"update-variants-by-id","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"ids":[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25]}	COMPLETED	100	{"success":true,"indexedItemCount":25,"timeTaken":421}	\N	2025-06-21 12:39:07.377	2025-06-21 12:39:07.805	t	0	1	100
2025-06-21 07:06:36.108238	2025-06-21 07:06:39.341727	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[20]}	COMPLETED	100	true	\N	2025-06-21 12:38:25.854	2025-06-21 12:38:25.901	t	0	1	20
2025-06-21 07:06:39.671414	2025-06-21 07:07:18.748405	update-search-index	{"type":"update-variants-by-id","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"ids":[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34]}	COMPLETED	100	{"success":true,"indexedItemCount":34,"timeTaken":769}	\N	2025-06-21 12:39:04.528	2025-06-21 12:39:05.304	t	0	1	94
2025-06-21 07:06:36.310809	2025-06-21 07:06:40.407985	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[25]}	COMPLETED	100	true	\N	2025-06-21 12:38:26.92	2025-06-21 12:38:26.967	t	0	1	25
2025-06-21 07:06:36.376242	2025-06-21 07:06:40.620592	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[26]}	COMPLETED	100	true	\N	2025-06-21 12:38:27.133	2025-06-21 12:38:27.18	t	0	1	26
2025-06-21 07:06:36.43985	2025-06-21 07:06:40.845339	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[27]}	COMPLETED	100	true	\N	2025-06-21 12:38:27.35	2025-06-21 12:38:27.405	t	0	1	27
2025-06-21 07:06:40.32592	2025-06-21 07:07:22.425245	update-search-index	{"type":"update-variants-by-id","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"ids":[67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88]}	COMPLETED	100	{"success":true,"indexedItemCount":22,"timeTaken":558}	\N	2025-06-21 12:39:08.417	2025-06-21 12:39:08.981	t	0	1	102
2025-06-21 07:06:36.683843	2025-06-21 07:06:41.70634	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[31]}	COMPLETED	100	true	\N	2025-06-21 12:38:28.219	2025-06-21 12:38:28.266	t	0	1	31
2025-06-21 07:06:41.18725	2025-06-21 07:07:24.159641	update-search-index	{"type":"update-variants-by-id","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"ids":[35,36,37,38,39,40,41,42]}	COMPLETED	100	{"success":true,"indexedItemCount":8,"timeTaken":216}	\N	2025-06-21 12:39:10.496	2025-06-21 12:39:10.719	t	0	1	106
2025-06-21 07:06:36.264358	2025-06-21 07:06:40.188986	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[24]}	COMPLETED	100	true	\N	2025-06-21 12:38:26.701	2025-06-21 12:38:26.748	t	0	1	24
2025-06-21 07:06:36.503102	2025-06-21 07:06:41.052576	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[28]}	COMPLETED	100	true	\N	2025-06-21 12:38:27.565	2025-06-21 12:38:27.612	t	0	1	28
2025-06-21 07:06:36.778552	2025-06-21 07:07:06.283654	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[33]}	COMPLETED	100	true	\N	2025-06-21 12:38:52.785	2025-06-21 12:38:52.845	t	0	1	33
2025-06-21 07:06:40.972999	2025-06-21 07:07:23.826569	update-search-index	{"type":"update-variants-by-id","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"ids":[35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66]}	COMPLETED	100	{"success":true,"indexedItemCount":32,"timeTaken":501}	\N	2025-06-21 12:39:09.878	2025-06-21 12:39:10.386	t	0	1	105
2025-06-21 07:06:40.757105	2025-06-21 07:07:23.146838	update-search-index	{"type":"update-variants-by-id","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"ids":[67,68,69,70,71,72,73,74,76]}	COMPLETED	100	{"success":true,"indexedItemCount":9,"timeTaken":241}	\N	2025-06-21 12:39:09.456	2025-06-21 12:39:09.703	t	0	1	104
2025-06-21 07:06:36.83552	2025-06-21 07:07:06.535701	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[34]}	COMPLETED	100	true	\N	2025-06-21 12:38:53.005	2025-06-21 12:38:53.097	t	0	1	34
2025-06-21 07:06:37.031468	2025-06-21 07:07:07.163282	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[37]}	COMPLETED	100	true	\N	2025-06-21 12:38:53.657	2025-06-21 12:38:53.725	t	0	1	37
2025-06-21 07:06:37.088789	2025-06-21 07:07:07.372596	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[38]}	COMPLETED	100	true	\N	2025-06-21 12:38:53.88	2025-06-21 12:38:53.934	t	0	1	38
2025-06-21 07:06:37.266304	2025-06-21 07:07:08.02638	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[41]}	COMPLETED	100	true	\N	2025-06-21 12:38:54.534	2025-06-21 12:38:54.588	t	0	1	41
2025-06-21 07:06:37.325227	2025-06-21 07:07:08.244586	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[42]}	COMPLETED	100	true	\N	2025-06-21 12:38:54.752	2025-06-21 12:38:54.806	t	0	1	42
2025-06-21 07:06:37.615727	2025-06-21 07:07:09.329214	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[47]}	COMPLETED	100	true	\N	2025-06-21 12:38:55.839	2025-06-21 12:38:55.892	t	0	1	47
2025-06-21 07:06:37.674805	2025-06-21 07:07:09.977493	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[50]}	COMPLETED	100	true	\N	2025-06-21 12:38:56.488	2025-06-21 12:38:56.54	t	0	1	50
2025-06-21 07:06:37.922441	2025-06-21 07:07:11.27507	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[56]}	COMPLETED	100	true	\N	2025-06-21 12:38:57.788	2025-06-21 12:38:57.838	t	0	1	56
2025-06-21 07:06:37.205165	2025-06-21 07:07:07.811937	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[40]}	COMPLETED	100	true	\N	2025-06-21 12:38:54.316	2025-06-21 12:38:54.374	t	0	1	40
2025-06-21 07:06:37.455268	2025-06-21 07:07:08.462954	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[43]}	COMPLETED	100	true	\N	2025-06-21 12:38:54.969	2025-06-21 12:38:55.025	t	0	1	43
2025-06-21 07:06:37.499314	2025-06-21 07:07:08.887951	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[45]}	COMPLETED	100	true	\N	2025-06-21 12:38:55.401	2025-06-21 12:38:55.451	t	0	1	45
2025-06-21 07:06:37.635851	2025-06-21 07:07:09.543715	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[48]}	COMPLETED	100	true	\N	2025-06-21 12:38:56.055	2025-06-21 12:38:56.107	t	0	1	48
2025-06-21 07:06:37.655641	2025-06-21 07:07:09.763073	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[49]}	COMPLETED	100	true	\N	2025-06-21 12:38:56.273	2025-06-21 12:38:56.326	t	0	1	49
2025-06-21 07:06:37.802576	2025-06-21 07:07:10.62396	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[53]}	COMPLETED	100	true	\N	2025-06-21 12:38:57.139	2025-06-21 12:38:57.187	t	0	1	53
2025-06-21 07:06:38.250475	2025-06-21 07:07:13.246902	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[65]}	COMPLETED	100	true	\N	2025-06-21 12:38:59.746	2025-06-21 12:38:59.809	t	0	1	65
2025-06-21 07:06:37.82256	2025-06-21 07:07:10.844511	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[54]}	COMPLETED	100	true	\N	2025-06-21 12:38:57.355	2025-06-21 12:38:57.407	t	0	1	54
2025-06-21 07:06:38.034546	2025-06-21 07:07:11.941621	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[59]}	COMPLETED	100	true	\N	2025-06-21 12:38:58.443	2025-06-21 12:38:58.504	t	0	1	59
2025-06-21 07:06:39.177839	2025-06-21 07:07:16.338124	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[81]}	COMPLETED	100	true	\N	2025-06-21 12:39:02.78	2025-06-21 12:39:02.894	t	0	1	81
2025-06-21 07:06:37.941298	2025-06-21 07:07:11.498143	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[57]}	COMPLETED	100	true	\N	2025-06-21 12:38:58.007	2025-06-21 12:38:58.061	t	0	1	57
2025-06-21 07:06:38.209038	2025-06-21 07:07:12.815106	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[63]}	COMPLETED	100	true	\N	2025-06-21 12:38:59.313	2025-06-21 12:38:59.378	t	0	1	63
2025-06-21 07:06:38.885157	2025-06-21 07:07:15.205479	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[76]}	COMPLETED	100	true	\N	2025-06-21 12:39:01.703	2025-06-21 12:39:01.762	t	0	1	76
2025-06-21 07:06:39.276075	2025-06-21 07:07:16.746545	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[83]}	COMPLETED	100	true	\N	2025-06-21 12:39:03.225	2025-06-21 12:39:03.303	t	0	1	83
2025-06-21 07:06:38.426423	2025-06-21 07:07:13.903459	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[68]}	COMPLETED	100	true	\N	2025-06-21 12:39:00.4	2025-06-21 12:39:00.46	t	0	1	68
2025-06-21 07:06:38.478672	2025-06-21 07:07:14.127744	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[69]}	COMPLETED	100	true	\N	2025-06-21 12:39:00.619	2025-06-21 12:39:00.684	t	0	1	69
2025-06-21 07:06:38.696126	2025-06-21 07:07:14.545299	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[73]}	COMPLETED	100	true	\N	2025-06-21 12:39:01.051	2025-06-21 12:39:01.102	t	0	1	73
2025-06-21 07:06:38.753323	2025-06-21 07:07:14.764217	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[74]}	COMPLETED	100	true	\N	2025-06-21 12:39:01.27	2025-06-21 12:39:01.321	t	0	1	74
2025-06-21 07:06:39.462993	2025-06-21 07:07:17.397508	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[86]}	COMPLETED	100	true	\N	2025-06-21 12:39:03.873	2025-06-21 12:39:03.954	t	0	1	86
2025-06-21 07:06:39.830035	2025-06-21 07:07:20.632491	update-search-index	{"type":"reindex","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_session":{"user":{"id":1,"identifier":"superadmin","verified":true,"channelPermissions":[]},"id":"__dummy_session_id__","token":"__dummy_session_token__","expires":"2026-06-21T13:08:26.087Z","cacheExpiry":31557600000},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false}}	COMPLETED	100	{"success":true,"indexedItemCount":88,"timeTaken":1830}	\N	2025-06-21 12:39:05.352	2025-06-21 12:39:07.189	t	0	1	99
2025-06-21 07:06:40.107439	2025-06-21 07:07:21.697917	update-search-index	{"type":"update-variants-by-id","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"ids":[26,27,28,29,30,31,32,33,34]}	COMPLETED	100	{"success":true,"indexedItemCount":9,"timeTaken":249}	\N	2025-06-21 12:39:08	2025-06-21 12:39:08.254	t	0	1	101
2025-06-21 07:06:40.541502	2025-06-21 07:07:22.837407	update-search-index	{"type":"update-variants-by-id","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"ids":[75,77,78,79,80,81,82,83,84,85,86,87,88]}	COMPLETED	100	{"success":true,"indexedItemCount":13,"timeTaken":352}	\N	2025-06-21 12:39:09.036	2025-06-21 12:39:09.394	t	0	1	103
2025-06-21 07:06:41.390259	2025-06-21 07:07:24.663489	update-search-index	{"type":"update-variants-by-id","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"ids":[43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66]}	COMPLETED	100	{"success":true,"indexedItemCount":24,"timeTaken":305}	\N	2025-06-21 12:39:10.912	2025-06-21 12:39:11.223	t	0	1	107
2025-06-21 07:08:25.142214	2025-06-21 07:07:24.827593	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[71]}	COMPLETED	100	true	\N	2025-06-21 12:39:11.325	2025-06-21 12:39:11.387	t	0	1	71
2025-06-21 07:08:25.195557	2025-06-21 07:07:25.04314	update-search-index	{"type":"update-variants","ctx":{"_apiType":"admin","_channel":{"token":"5pler0mlhh5px9fh222h","createdAt":"2025-06-21T01:36:31.827Z","updatedAt":"2025-06-21T01:36:34.979Z","code":"__default_channel__","description":"","defaultLanguageCode":"en","availableLanguageCodes":["en"],"defaultCurrencyCode":"USD","availableCurrencyCodes":["USD"],"trackInventory":true,"outOfStockThreshold":0,"pricesIncludeTax":false,"id":1,"sellerId":1,"defaultShippingZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2},"defaultTaxZone":{"createdAt":"2025-06-21T01:36:32.569Z","updatedAt":"2025-06-21T01:36:32.569Z","name":"Europe","id":2}},"_languageCode":"en","_currencyCode":"USD","_isAuthorized":true,"_authorizedAsOwnerOnly":false},"variantIds":[72]}	COMPLETED	100	true	\N	2025-06-21 12:39:11.543	2025-06-21 12:39:11.602	t	0	1	72
\.


--
-- Data for Name: job_record_buffer; Type: TABLE DATA; Schema: public; Owner: vendure
--

COPY public.job_record_buffer ("createdAt", "updatedAt", "bufferId", job, id) FROM stdin;
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: public; Owner: vendure
--

COPY public.migrations (id, "timestamp", name) FROM stdin;
\.


--
-- Data for Name: order; Type: TABLE DATA; Schema: public; Owner: vendure
--

COPY public."order" ("createdAt", "updatedAt", type, code, state, active, "orderPlacedAt", "couponCodes", "shippingAddress", "billingAddress", "currencyCode", id, "aggregateOrderId", "customerId", "taxZoneId", "subTotal", "subTotalWithTax", shipping, "shippingWithTax") FROM stdin;
\.


--
-- Data for Name: order_channels_channel; Type: TABLE DATA; Schema: public; Owner: vendure
--

COPY public.order_channels_channel ("orderId", "channelId") FROM stdin;
\.


--
-- Data for Name: order_fulfillments_fulfillment; Type: TABLE DATA; Schema: public; Owner: vendure
--

COPY public.order_fulfillments_fulfillment ("orderId", "fulfillmentId") FROM stdin;
\.


--
-- Data for Name: order_line; Type: TABLE DATA; Schema: public; Owner: vendure
--

COPY public.order_line ("createdAt", "updatedAt", quantity, "orderPlacedQuantity", "listPriceIncludesTax", adjustments, "taxLines", id, "sellerChannelId", "shippingLineId", "productVariantId", "taxCategoryId", "initialListPrice", "listPrice", "featuredAssetId", "orderId") FROM stdin;
\.


--
-- Data for Name: order_line_reference; Type: TABLE DATA; Schema: public; Owner: vendure
--

COPY public.order_line_reference ("createdAt", "updatedAt", quantity, id, "fulfillmentId", "modificationId", "orderLineId", "refundId", discriminator) FROM stdin;
\.


--
-- Data for Name: order_modification; Type: TABLE DATA; Schema: public; Owner: vendure
--

COPY public.order_modification ("createdAt", "updatedAt", note, "shippingAddressChange", "billingAddressChange", id, "priceChange", "orderId", "paymentId", "refundId") FROM stdin;
\.


--
-- Data for Name: order_promotions_promotion; Type: TABLE DATA; Schema: public; Owner: vendure
--

COPY public.order_promotions_promotion ("orderId", "promotionId") FROM stdin;
\.


--
-- Data for Name: payment; Type: TABLE DATA; Schema: public; Owner: vendure
--

COPY public.payment ("createdAt", "updatedAt", method, state, "errorMessage", "transactionId", metadata, id, amount, "orderId") FROM stdin;
\.


--
-- Data for Name: payment_method; Type: TABLE DATA; Schema: public; Owner: vendure
--

COPY public.payment_method ("createdAt", "updatedAt", code, enabled, checker, handler, id) FROM stdin;
2025-06-21 07:06:34.966382	2025-06-21 07:06:34.966382	standard-payment	t	\N	{"code":"dummy-payment-handler","args":[{"name":"automaticSettle","value":"false"}]}	1
\.


--
-- Data for Name: payment_method_channels_channel; Type: TABLE DATA; Schema: public; Owner: vendure
--

COPY public.payment_method_channels_channel ("paymentMethodId", "channelId") FROM stdin;
1	1
\.


--
-- Data for Name: payment_method_translation; Type: TABLE DATA; Schema: public; Owner: vendure
--

COPY public.payment_method_translation ("createdAt", "updatedAt", "languageCode", name, description, id, "baseId") FROM stdin;
2025-06-21 07:06:34.963009	2025-06-21 07:06:34.966382	en	Standard Payment		1	1
\.


--
-- Data for Name: product; Type: TABLE DATA; Schema: public; Owner: vendure
--

COPY public.product ("createdAt", "updatedAt", "deletedAt", enabled, id, "featuredAssetId") FROM stdin;
2025-06-21 07:06:35.15417	2025-06-21 07:06:35.15417	\N	t	1	1
2025-06-21 07:06:35.338323	2025-06-21 07:06:35.338323	\N	t	2	2
2025-06-21 07:06:35.459703	2025-06-21 07:06:35.459703	\N	t	3	3
2025-06-21 07:06:35.530476	2025-06-21 07:06:35.530476	\N	t	4	4
2025-06-21 07:06:35.58316	2025-06-21 07:06:35.58316	\N	t	5	5
2025-06-21 07:06:35.700203	2025-06-21 07:06:35.700203	\N	t	6	6
2025-06-21 07:06:35.840756	2025-06-21 07:06:35.840756	\N	t	7	7
2025-06-21 07:06:36.004224	2025-06-21 07:06:36.004224	\N	t	8	8
2025-06-21 07:06:36.175621	2025-06-21 07:06:36.175621	\N	t	9	9
2025-06-21 07:06:36.239261	2025-06-21 07:06:36.239261	\N	t	10	10
2025-06-21 07:06:36.288416	2025-06-21 07:06:36.288416	\N	t	11	11
2025-06-21 07:06:36.352575	2025-06-21 07:06:36.352575	\N	t	12	12
2025-06-21 07:06:36.414458	2025-06-21 07:06:36.414458	\N	t	13	13
2025-06-21 07:06:36.478247	2025-06-21 07:06:36.478247	\N	t	14	14
2025-06-21 07:06:36.535385	2025-06-21 07:06:36.535385	\N	t	15	15
2025-06-21 07:06:36.591982	2025-06-21 07:06:36.591982	\N	t	16	16
2025-06-21 07:06:36.65866	2025-06-21 07:06:36.65866	\N	t	17	17
2025-06-21 07:06:36.709549	2025-06-21 07:06:36.709549	\N	t	18	18
2025-06-21 07:06:36.757413	2025-06-21 07:06:36.757413	\N	t	19	19
2025-06-21 07:06:36.811917	2025-06-21 07:06:36.811917	\N	t	20	20
2025-06-21 07:06:36.893691	2025-06-21 07:06:36.893691	\N	t	21	21
2025-06-21 07:06:36.955001	2025-06-21 07:06:36.955001	\N	t	22	22
2025-06-21 07:06:37.008127	2025-06-21 07:06:37.008127	\N	t	23	23
2025-06-21 07:06:37.064751	2025-06-21 07:06:37.064751	\N	t	24	24
2025-06-21 07:06:37.121593	2025-06-21 07:06:37.121593	\N	t	25	25
2025-06-21 07:06:37.180934	2025-06-21 07:06:37.180934	\N	t	26	26
2025-06-21 07:06:37.24264	2025-06-21 07:06:37.24264	\N	t	27	27
2025-06-21 07:06:37.301082	2025-06-21 07:06:37.301082	\N	t	28	28
2025-06-21 07:06:37.401177	2025-06-21 07:06:37.401177	\N	t	29	29
2025-06-21 07:06:37.561262	2025-06-21 07:06:37.561262	\N	t	30	30
2025-06-21 07:06:37.716558	2025-06-21 07:06:37.716558	\N	t	31	31
2025-06-21 07:06:37.848728	2025-06-21 07:06:37.848728	\N	t	32	32
2025-06-21 07:06:37.983884	2025-06-21 07:06:37.983884	\N	t	33	33
2025-06-21 07:06:38.141424	2025-06-21 07:06:38.141424	\N	t	34	34
2025-06-21 07:06:38.342353	2025-06-21 07:06:38.342353	\N	t	35	35
2025-06-21 07:06:38.401273	2025-06-21 07:06:38.401273	\N	t	36	36
2025-06-21 07:06:38.455611	2025-06-21 07:06:38.455611	\N	t	37	37
2025-06-21 07:06:38.504201	2025-06-21 07:06:38.504201	\N	t	38	38
2025-06-21 07:08:25.117066	2025-06-21 07:08:25.117066	\N	t	39	39
2025-06-21 07:08:25.171893	2025-06-21 07:08:25.171893	\N	t	40	40
2025-06-21 07:08:25.225224	2025-06-21 07:08:25.225224	\N	t	41	41
2025-06-21 07:06:38.727515	2025-06-21 07:06:38.727515	\N	t	42	42
2025-06-21 07:06:38.800444	2025-06-21 07:06:38.800444	\N	t	43	43
2025-06-21 07:06:38.857432	2025-06-21 07:06:38.857432	\N	t	44	44
2025-06-21 07:06:38.909436	2025-06-21 07:06:38.909436	\N	t	45	45
2025-06-21 07:06:38.966483	2025-06-21 07:06:38.966483	\N	t	46	46
2025-06-21 07:06:39.037051	2025-06-21 07:06:39.037051	\N	t	47	47
2025-06-21 07:06:39.090481	2025-06-21 07:06:39.090481	\N	t	48	48
2025-06-21 07:06:39.154331	2025-06-21 07:06:39.154331	\N	t	49	49
2025-06-21 07:06:39.206299	2025-06-21 07:06:39.206299	\N	t	50	50
2025-06-21 07:06:39.25423	2025-06-21 07:06:39.25423	\N	t	51	51
2025-06-21 07:06:39.29952	2025-06-21 07:06:39.29952	\N	t	52	52
2025-06-21 07:06:39.356028	2025-06-21 07:06:39.356028	\N	t	53	53
2025-06-21 07:06:39.405183	2025-06-21 07:06:39.405183	\N	t	54	54
\.


--
-- Data for Name: product_asset; Type: TABLE DATA; Schema: public; Owner: vendure
--

COPY public.product_asset ("createdAt", "updatedAt", "assetId", "position", "productId", id) FROM stdin;
2025-06-21 07:06:35.162516	2025-06-21 07:06:35.162516	1	0	1	1
2025-06-21 07:06:35.344003	2025-06-21 07:06:35.344003	2	0	2	2
2025-06-21 07:06:35.465822	2025-06-21 07:06:35.465822	3	0	3	3
2025-06-21 07:06:35.537628	2025-06-21 07:06:35.537628	4	0	4	4
2025-06-21 07:06:35.588249	2025-06-21 07:06:35.588249	5	0	5	5
2025-06-21 07:06:35.707624	2025-06-21 07:06:35.707624	6	0	6	6
2025-06-21 07:06:35.84677	2025-06-21 07:06:35.84677	7	0	7	7
2025-06-21 07:06:36.00947	2025-06-21 07:06:36.00947	8	0	8	8
2025-06-21 07:06:36.180584	2025-06-21 07:06:36.180584	9	0	9	9
2025-06-21 07:06:36.244986	2025-06-21 07:06:36.244986	10	0	10	10
2025-06-21 07:06:36.293161	2025-06-21 07:06:36.293161	11	0	11	11
2025-06-21 07:06:36.357357	2025-06-21 07:06:36.357357	12	0	12	12
2025-06-21 07:06:36.419397	2025-06-21 07:06:36.419397	13	0	13	13
2025-06-21 07:06:36.483194	2025-06-21 07:06:36.483194	14	0	14	14
2025-06-21 07:06:36.539912	2025-06-21 07:06:36.539912	15	0	15	15
2025-06-21 07:06:36.596228	2025-06-21 07:06:36.596228	16	0	16	16
2025-06-21 07:06:36.663633	2025-06-21 07:06:36.663633	17	0	17	17
2025-06-21 07:06:36.714582	2025-06-21 07:06:36.714582	18	0	18	18
2025-06-21 07:06:36.761492	2025-06-21 07:06:36.761492	19	0	19	19
2025-06-21 07:06:36.817425	2025-06-21 07:06:36.817425	20	0	20	20
2025-06-21 07:06:36.898669	2025-06-21 07:06:36.898669	21	0	21	21
2025-06-21 07:06:36.960021	2025-06-21 07:06:36.960021	22	0	22	22
2025-06-21 07:06:37.012895	2025-06-21 07:06:37.012895	23	0	23	23
2025-06-21 07:06:37.070565	2025-06-21 07:06:37.070565	24	0	24	24
2025-06-21 07:06:37.126082	2025-06-21 07:06:37.126082	25	0	25	25
2025-06-21 07:06:37.185803	2025-06-21 07:06:37.185803	26	0	26	26
2025-06-21 07:06:37.247558	2025-06-21 07:06:37.247558	27	0	27	27
2025-06-21 07:06:37.306387	2025-06-21 07:06:37.306387	28	0	28	28
2025-06-21 07:06:37.406979	2025-06-21 07:06:37.406979	29	0	29	29
2025-06-21 07:06:37.566466	2025-06-21 07:06:37.566466	30	0	30	30
2025-06-21 07:06:37.720815	2025-06-21 07:06:37.720815	31	0	31	31
2025-06-21 07:06:37.853765	2025-06-21 07:06:37.853765	32	0	32	32
2025-06-21 07:06:37.989029	2025-06-21 07:06:37.989029	33	0	33	33
2025-06-21 07:06:38.148354	2025-06-21 07:06:38.148354	34	0	34	34
2025-06-21 07:06:38.347335	2025-06-21 07:06:38.347335	35	0	35	35
2025-06-21 07:06:38.407129	2025-06-21 07:06:38.407129	36	0	36	36
2025-06-21 07:06:38.460164	2025-06-21 07:06:38.460164	37	0	37	37
2025-06-21 07:06:38.509931	2025-06-21 07:06:38.509931	38	0	38	38
2025-06-21 07:08:25.121936	2025-06-21 07:08:25.121936	39	0	39	39
2025-06-21 07:08:25.177022	2025-06-21 07:08:25.177022	40	0	40	40
2025-06-21 07:06:38.672063	2025-06-21 07:06:38.672063	41	0	41	41
2025-06-21 07:06:38.732562	2025-06-21 07:06:38.732562	42	0	42	42
2025-06-21 07:06:38.805416	2025-06-21 07:06:38.805416	43	0	43	43
2025-06-21 07:06:38.863734	2025-06-21 07:06:38.863734	44	0	44	44
2025-06-21 07:06:38.915053	2025-06-21 07:06:38.915053	45	0	45	45
2025-06-21 07:06:38.972447	2025-06-21 07:06:38.972447	46	0	46	46
2025-06-21 07:06:39.042613	2025-06-21 07:06:39.042613	47	0	47	47
2025-06-21 07:06:39.097309	2025-06-21 07:06:39.097309	48	0	48	48
2025-06-21 07:06:39.159319	2025-06-21 07:06:39.159319	49	0	49	49
2025-06-21 07:06:39.210928	2025-06-21 07:06:39.210928	50	0	50	50
2025-06-21 07:06:39.258601	2025-06-21 07:06:39.258601	51	0	51	51
2025-06-21 07:06:39.305176	2025-06-21 07:06:39.305176	52	0	52	52
2025-06-21 07:06:39.360587	2025-06-21 07:06:39.360587	53	0	53	53
2025-06-21 07:06:39.410135	2025-06-21 07:06:39.410135	54	0	54	54
\.


--
-- Data for Name: product_channels_channel; Type: TABLE DATA; Schema: public; Owner: vendure
--

COPY public.product_channels_channel ("productId", "channelId") FROM stdin;
1	1
2	1
3	1
4	1
5	1
6	1
7	1
8	1
9	1
10	1
11	1
12	1
13	1
14	1
15	1
16	1
17	1
18	1
19	1
20	1
21	1
22	1
23	1
24	1
25	1
26	1
27	1
28	1
29	1
30	1
31	1
32	1
33	1
34	1
35	1
36	1
37	1
38	1
39	1
40	1
41	1
42	1
43	1
44	1
45	1
46	1
47	1
48	1
49	1
50	1
51	1
52	1
53	1
54	1
\.


--
-- Data for Name: product_facet_values_facet_value; Type: TABLE DATA; Schema: public; Owner: vendure
--

COPY public.product_facet_values_facet_value ("productId", "facetValueId") FROM stdin;
1	1
1	2
1	3
2	1
2	2
2	3
3	1
3	2
3	4
4	1
4	2
4	5
5	1
5	2
5	5
6	1
6	2
6	6
7	1
7	2
7	7
8	1
8	2
8	8
9	1
9	2
9	6
10	1
10	2
11	1
11	2
12	1
12	9
12	10
13	1
13	9
13	11
14	1
14	9
14	12
15	1
15	9
15	13
16	1
16	9
16	14
17	1
17	9
17	15
18	1
18	9
18	11
19	1
19	9
20	1
20	9
20	16
21	17
21	18
21	19
22	17
22	18
22	20
23	17
23	18
23	20
24	17
24	18
25	17
25	18
26	17
26	18
26	21
27	17
27	18
27	22
28	17
28	18
28	22
29	17
29	23
29	24
29	25
29	26
30	17
30	23
30	21
30	27
31	17
31	23
31	21
31	28
32	17
32	23
32	24
32	28
32	27
33	17
33	23
33	24
33	27
34	17
34	23
34	29
34	27
35	30
35	31
35	32
36	30
36	31
36	33
36	32
37	30
37	31
37	33
38	30
38	31
38	32
39	30
39	31
39	33
40	30
40	31
40	32
41	30
41	31
42	30
42	31
43	30
43	34
43	35
44	30
44	31
45	30
45	34
46	30
46	34
46	35
47	30
47	34
47	36
48	30
48	34
49	30
49	34
49	37
50	30
50	34
50	35
51	30
51	34
51	27
52	30
52	34
52	37
53	30
53	34
53	28
54	30
54	34
\.


--
-- Data for Name: product_option; Type: TABLE DATA; Schema: public; Owner: vendure
--

COPY public.product_option ("createdAt", "updatedAt", "deletedAt", code, id, "groupId") FROM stdin;
2025-06-21 07:06:35.178713	2025-06-21 07:06:35.178713	\N	13-inch	1	1
2025-06-21 07:06:35.186235	2025-06-21 07:06:35.186235	\N	15-inch	2	1
2025-06-21 07:06:35.200686	2025-06-21 07:06:35.200686	\N	8gb	3	2
2025-06-21 07:06:35.206335	2025-06-21 07:06:35.206335	\N	16gb	4	2
2025-06-21 07:06:35.354977	2025-06-21 07:06:35.354977	\N	32gb	5	3
2025-06-21 07:06:35.360935	2025-06-21 07:06:35.360935	\N	128gb	6	3
2025-06-21 07:06:35.600207	2025-06-21 07:06:35.600207	\N	24-inch	7	4
2025-06-21 07:06:35.608442	2025-06-21 07:06:35.608442	\N	27-inch	8	4
2025-06-21 07:06:35.722232	2025-06-21 07:06:35.722232	\N	4gb	9	5
2025-06-21 07:06:35.728999	2025-06-21 07:06:35.728999	\N	8gb	10	5
2025-06-21 07:06:35.734541	2025-06-21 07:06:35.734541	\N	16gb	11	5
2025-06-21 07:06:35.859098	2025-06-21 07:06:35.859098	\N	i7-8700	12	6
2025-06-21 07:06:35.865658	2025-06-21 07:06:35.865658	\N	r7-2700	13	6
2025-06-21 07:06:35.880048	2025-06-21 07:06:35.880048	\N	240gb-ssd	14	7
2025-06-21 07:06:35.885624	2025-06-21 07:06:35.885624	\N	120gb-ssd	15	7
2025-06-21 07:06:36.021166	2025-06-21 07:06:36.021166	\N	1tb	16	8
2025-06-21 07:06:36.027093	2025-06-21 07:06:36.027093	\N	2tb	17	8
2025-06-21 07:06:36.033916	2025-06-21 07:06:36.033916	\N	3tb	18	8
2025-06-21 07:06:36.040267	2025-06-21 07:06:36.040267	\N	4tb	19	8
2025-06-21 07:06:36.046253	2025-06-21 07:06:36.046253	\N	6tb	20	8
2025-06-21 07:06:37.417288	2025-06-21 07:06:37.417288	\N	size-40	21	9
2025-06-21 07:06:37.423094	2025-06-21 07:06:37.423094	\N	size-42	22	9
2025-06-21 07:06:37.428639	2025-06-21 07:06:37.428639	\N	size-44	23	9
2025-06-21 07:06:37.43487	2025-06-21 07:06:37.43487	\N	size-46	24	9
2025-06-21 07:06:37.577625	2025-06-21 07:06:37.577625	\N	size-40	25	10
2025-06-21 07:06:37.583977	2025-06-21 07:06:37.583977	\N	size-42	26	10
2025-06-21 07:06:37.589048	2025-06-21 07:06:37.589048	\N	size-44	27	10
2025-06-21 07:06:37.593734	2025-06-21 07:06:37.593734	\N	size-46	28	10
2025-06-21 07:06:37.730134	2025-06-21 07:06:37.730134	\N	size-40	29	11
2025-06-21 07:06:37.734919	2025-06-21 07:06:37.734919	\N	size-42	30	11
2025-06-21 07:06:37.740208	2025-06-21 07:06:37.740208	\N	size-44	31	11
2025-06-21 07:06:37.746077	2025-06-21 07:06:37.746077	\N	size-46	32	11
2025-06-21 07:06:37.864436	2025-06-21 07:06:37.864436	\N	size-40	33	12
2025-06-21 07:06:37.870884	2025-06-21 07:06:37.870884	\N	size-42	34	12
2025-06-21 07:06:37.877665	2025-06-21 07:06:37.877665	\N	size-44	35	12
2025-06-21 07:06:37.883431	2025-06-21 07:06:37.883431	\N	size-46	36	12
2025-06-21 07:06:37.998841	2025-06-21 07:06:37.998841	\N	size-40	37	13
2025-06-21 07:06:38.004099	2025-06-21 07:06:38.004099	\N	size-42	38	13
2025-06-21 07:06:38.009579	2025-06-21 07:06:38.009579	\N	size-44	39	13
2025-06-21 07:06:38.014645	2025-06-21 07:06:38.014645	\N	size-46	40	13
2025-06-21 07:06:38.160533	2025-06-21 07:06:38.160533	\N	size-40	41	14
2025-06-21 07:06:38.167088	2025-06-21 07:06:38.167088	\N	size-42	42	14
2025-06-21 07:06:38.17368	2025-06-21 07:06:38.17368	\N	size-44	43	14
2025-06-21 07:06:38.179575	2025-06-21 07:06:38.179575	\N	size-46	44	14
2025-06-21 07:06:39.420381	2025-06-21 07:06:39.420381	\N	mustard	45	15
2025-06-21 07:06:39.425861	2025-06-21 07:06:39.425861	\N	mint	46	15
2025-06-21 07:06:39.431287	2025-06-21 07:06:39.431287	\N	pearl	47	15
\.


--
-- Data for Name: product_option_group; Type: TABLE DATA; Schema: public; Owner: vendure
--

COPY public.product_option_group ("createdAt", "updatedAt", "deletedAt", code, id, "productId") FROM stdin;
2025-06-21 07:06:35.168949	2025-06-21 07:06:35.190734	\N	laptop-screen-size	1	1
2025-06-21 07:06:35.194998	2025-06-21 07:06:35.210177	\N	laptop-ram	2	1
2025-06-21 07:06:35.349374	2025-06-21 07:06:35.364607	\N	tablet-storage	3	2
2025-06-21 07:06:35.59349	2025-06-21 07:06:35.612114	\N	curvy-monitor-monitor-size	4	5
2025-06-21 07:06:35.714705	2025-06-21 07:06:35.738543	\N	high-performance-ram-size	5	6
2025-06-21 07:06:35.852603	2025-06-21 07:06:35.869676	\N	gaming-pc-cpu	6	7
2025-06-21 07:06:35.87403	2025-06-21 07:06:35.888871	\N	gaming-pc-hdd	7	7
2025-06-21 07:06:36.014602	2025-06-21 07:06:36.049644	\N	hard-drive-hdd	8	8
2025-06-21 07:06:37.411871	2025-06-21 07:06:37.438537	\N	ultraboost-running-shoe-size	9	29
2025-06-21 07:06:37.571685	2025-06-21 07:06:37.597148	\N	freerun-running-shoe-size	10	30
2025-06-21 07:06:37.725	2025-06-21 07:06:37.749073	\N	hi-top-basketball-shoe-size	11	31
2025-06-21 07:06:37.859011	2025-06-21 07:06:37.886591	\N	pureboost-running-shoe-size	12	32
2025-06-21 07:06:37.993677	2025-06-21 07:06:38.017822	\N	runx-running-shoe-size	13	33
2025-06-21 07:06:38.153822	2025-06-21 07:06:38.183264	\N	allstar-sneakers-size	14	34
2025-06-21 07:06:39.4147	2025-06-21 07:06:39.434982	\N	modern-cafe-chair-color	15	54
\.


--
-- Data for Name: product_option_group_translation; Type: TABLE DATA; Schema: public; Owner: vendure
--

COPY public.product_option_group_translation ("createdAt", "updatedAt", "languageCode", name, id, "baseId") FROM stdin;
2025-06-21 07:06:35.165792	2025-06-21 07:06:35.168949	en	screen size	1	1
2025-06-21 07:06:35.19251	2025-06-21 07:06:35.194998	en	RAM	2	2
2025-06-21 07:06:35.346717	2025-06-21 07:06:35.349374	en	storage	3	3
2025-06-21 07:06:35.591154	2025-06-21 07:06:35.59349	en	monitor size	4	4
2025-06-21 07:06:35.711412	2025-06-21 07:06:35.714705	en	size	5	5
2025-06-21 07:06:35.849749	2025-06-21 07:06:35.852603	en	cpu	6	6
2025-06-21 07:06:35.871421	2025-06-21 07:06:35.87403	en	HDD	7	7
2025-06-21 07:06:36.01171	2025-06-21 07:06:36.014602	en	HDD	8	8
2025-06-21 07:06:37.409516	2025-06-21 07:06:37.411871	en	size	9	9
2025-06-21 07:06:37.569168	2025-06-21 07:06:37.571685	en	size	10	10
2025-06-21 07:06:37.723046	2025-06-21 07:06:37.725	en	size	11	11
2025-06-21 07:06:37.857001	2025-06-21 07:06:37.859011	en	size	12	12
2025-06-21 07:06:37.991114	2025-06-21 07:06:37.993677	en	size	13	13
2025-06-21 07:06:38.151127	2025-06-21 07:06:38.153822	en	size	14	14
2025-06-21 07:06:39.412478	2025-06-21 07:06:39.4147	en	color	15	15
\.


--
-- Data for Name: product_option_translation; Type: TABLE DATA; Schema: public; Owner: vendure
--

COPY public.product_option_translation ("createdAt", "updatedAt", "languageCode", name, id, "baseId") FROM stdin;
2025-06-21 07:06:35.175176	2025-06-21 07:06:35.178713	en	13 inch	1	1
2025-06-21 07:06:35.183197	2025-06-21 07:06:35.186235	en	15 inch	2	2
2025-06-21 07:06:35.1985	2025-06-21 07:06:35.200686	en	8GB	3	3
2025-06-21 07:06:35.204022	2025-06-21 07:06:35.206335	en	16GB	4	4
2025-06-21 07:06:35.352627	2025-06-21 07:06:35.354977	en	32GB	5	5
2025-06-21 07:06:35.358597	2025-06-21 07:06:35.360935	en	128GB	6	6
2025-06-21 07:06:35.5979	2025-06-21 07:06:35.600207	en	24 inch	7	7
2025-06-21 07:06:35.605872	2025-06-21 07:06:35.608442	en	27 inch	8	8
2025-06-21 07:06:35.719233	2025-06-21 07:06:35.722232	en	4GB	9	9
2025-06-21 07:06:35.726175	2025-06-21 07:06:35.728999	en	8GB	10	10
2025-06-21 07:06:35.732352	2025-06-21 07:06:35.734541	en	16GB	11	11
2025-06-21 07:06:35.85641	2025-06-21 07:06:35.859098	en	i7-8700	12	12
2025-06-21 07:06:35.863244	2025-06-21 07:06:35.865658	en	R7-2700	13	13
2025-06-21 07:06:35.877764	2025-06-21 07:06:35.880048	en	240GB SSD	14	14
2025-06-21 07:06:35.88346	2025-06-21 07:06:35.885624	en	120GB SSD	15	15
2025-06-21 07:06:36.018699	2025-06-21 07:06:36.021166	en	1TB	16	16
2025-06-21 07:06:36.024224	2025-06-21 07:06:36.027093	en	2TB	17	17
2025-06-21 07:06:36.030778	2025-06-21 07:06:36.033916	en	3TB	18	18
2025-06-21 07:06:36.038116	2025-06-21 07:06:36.040267	en	4TB	19	19
2025-06-21 07:06:36.043969	2025-06-21 07:06:36.046253	en	6TB	20	20
2025-06-21 07:06:37.414907	2025-06-21 07:06:37.417288	en	Size 40	21	21
2025-06-21 07:06:37.420488	2025-06-21 07:06:37.423094	en	Size 42	22	22
2025-06-21 07:06:37.426185	2025-06-21 07:06:37.428639	en	Size 44	23	23
2025-06-21 07:06:37.432065	2025-06-21 07:06:37.43487	en	Size 46	24	24
2025-06-21 07:06:37.57489	2025-06-21 07:06:37.577625	en	Size 40	25	25
2025-06-21 07:06:37.581026	2025-06-21 07:06:37.583977	en	Size 42	26	26
2025-06-21 07:06:37.586898	2025-06-21 07:06:37.589048	en	Size 44	27	27
2025-06-21 07:06:37.591918	2025-06-21 07:06:37.593734	en	Size 46	28	28
2025-06-21 07:06:37.727793	2025-06-21 07:06:37.730134	en	Size 40	29	29
2025-06-21 07:06:37.73293	2025-06-21 07:06:37.734919	en	Size 42	30	30
2025-06-21 07:06:37.738245	2025-06-21 07:06:37.740208	en	Size 44	31	31
2025-06-21 07:06:37.743723	2025-06-21 07:06:37.746077	en	Size 46	32	32
2025-06-21 07:06:37.862106	2025-06-21 07:06:37.864436	en	Size 40	33	33
2025-06-21 07:06:37.867496	2025-06-21 07:06:37.870884	en	Size 42	34	34
2025-06-21 07:06:37.874729	2025-06-21 07:06:37.877665	en	Size 44	35	35
2025-06-21 07:06:37.880761	2025-06-21 07:06:37.883431	en	Size 46	36	36
2025-06-21 07:06:37.996554	2025-06-21 07:06:37.998841	en	Size 40	37	37
2025-06-21 07:06:38.001843	2025-06-21 07:06:38.004099	en	Size 42	38	38
2025-06-21 07:06:38.007341	2025-06-21 07:06:38.009579	en	Size 44	39	39
2025-06-21 07:06:38.012441	2025-06-21 07:06:38.014645	en	Size 46	40	40
2025-06-21 07:06:38.157724	2025-06-21 07:06:38.160533	en	Size 40	41	41
2025-06-21 07:06:38.164352	2025-06-21 07:06:38.167088	en	Size 42	42	42
2025-06-21 07:06:38.170802	2025-06-21 07:06:38.17368	en	Size 44	43	43
2025-06-21 07:06:38.177238	2025-06-21 07:06:38.179575	en	Size 46	44	44
2025-06-21 07:06:39.418277	2025-06-21 07:06:39.420381	en	mustard	45	45
2025-06-21 07:06:39.423337	2025-06-21 07:06:39.425861	en	mint	46	46
2025-06-21 07:06:39.428906	2025-06-21 07:06:39.431287	en	pearl	47	47
\.


--
-- Data for Name: product_translation; Type: TABLE DATA; Schema: public; Owner: vendure
--

COPY public.product_translation ("createdAt", "updatedAt", "languageCode", name, slug, description, id, "baseId") FROM stdin;
2025-06-21 07:06:35.149912	2025-06-21 07:06:35.15417	en	Laptop	laptop	Now equipped with seventh-generation Intel Core processors, Laptop is snappier than ever. From daily tasks like launching apps and opening files to more advanced computing, you can power through your day thanks to faster SSDs and Turbo Boost processing up to 3.6GHz.	1	1
2025-06-21 07:06:35.335731	2025-06-21 07:06:35.338323	en	Tablet	tablet	If the computer were invented today, what would it look like? It would be powerful enough for any task. So mobile you could take it everywhere. And so intuitive you could use it any way you wanted — with touch, a keyboard, or even a pencil. In other words, it wouldn’t really be a "computer." It would be Tablet.	2	2
2025-06-21 07:06:35.456687	2025-06-21 07:06:35.459703	en	Wireless Optical Mouse	cordless-mouse	The Logitech M185 Wireless Optical Mouse is a great device for any computer user, and as Logitech are the global market leaders for these devices, you are also guaranteed absolute reliability. A mouse to be reckoned with!	3	3
2025-06-21 07:06:35.527606	2025-06-21 07:06:35.530476	en	32-Inch Monitor	32-inch-monitor	The UJ59 with Ultra HD resolution has 4x the pixels of Full HD, delivering more screen space and amazingly life-like images. That means you can view documents and webpages with less scrolling, work more comfortably with multiple windows and toolbars, and enjoy photos, videos and games in stunning 4K quality. Note: beverage not included.	4	4
2025-06-21 07:06:35.579702	2025-06-21 07:06:35.58316	en	Curvy Monitor	curvy-monitor	Discover a truly immersive viewing experience with this monitor curved more deeply than any other. Wrapping around your field of vision the 1,800 R screencreates a wider field of view, enhances depth perception, and minimises peripheral distractions to draw you deeper in to your content.	5	5
2025-06-21 07:06:35.697083	2025-06-21 07:06:35.700203	en	High Performance RAM	high-performance-ram	Each RAM module is built with a pure aluminium heat spreader for faster heat dissipation and cooler operation. Enhanced to XMP 2.0 profiles for better overclocking; Compatibility: Intel 100 Series, Intel 200 Series, Intel 300 Series, Intel X299, AMD 300 Series, AMD 400 Series.	6	6
2025-06-21 07:06:35.83785	2025-06-21 07:06:35.840756	en	Gaming PC	gaming-pc	This pc is optimised for gaming, and is also VR ready. The Intel Core-i7 CPU and High Performance GPU give the computer the raw power it needs to function at a high level.	7	7
2025-06-21 07:06:36.001604	2025-06-21 07:06:36.004224	en	Hard Drive	hard-drive	Boost your PC storage with this internal hard drive, designed just for desktop and all-in-one PCs.	8	8
2025-06-21 07:06:36.172348	2025-06-21 07:06:36.175621	en	Clacky Keyboard	clacky-keyboard	Let all your colleagues know that you are typing on this exclusive, colorful klicky-klacky keyboard. Huge travel on each keypress ensures maximum klack on each and every keystroke.	9	9
2025-06-21 07:06:36.236062	2025-06-21 07:06:36.239261	en	Ethernet Cable	ethernet-cable	5m (metres) Cat.6 network cable (upwards/downwards compatible) | Patch cable | 2 RJ-45 plug | plug with bend protection mantle. High transmission speeds due to operating frequency with up to 250 MHz (in comparison to Cat.5/Cat.5e cable bandwidth of 100 MHz).	10	10
2025-06-21 07:06:36.286026	2025-06-21 07:06:36.288416	en	USB Cable	usb-cable	Solid conductors eliminate strand-interaction distortion and reduce jitter. As the surface is made of high-purity silver, the performance is very close to that of a solid silver cable, but priced much closer to solid copper cable.	11	11
2025-06-21 07:06:36.35015	2025-06-21 07:06:36.352575	en	Instant Camera	instant-camera	With its nostalgic design and simple point-and-shoot functionality, the Instant Camera is the perfect pick to get started with instant photography.	12	12
2025-06-21 07:06:36.411808	2025-06-21 07:06:36.414458	en	Camera Lens	camera-lens	This lens is a Di type lens using an optical system with improved multi-coating designed to function with digital SLR cameras as well as film cameras.	13	13
2025-06-21 07:06:36.475521	2025-06-21 07:06:36.478247	en	Vintage Folding Camera	vintage-folding-camera	This vintage folding camera is so antiquated that you cannot possibly hope to produce actual photographs with it. However, it makes a wonderful decorative piece for the home or office.	14	14
2025-06-21 07:06:36.533112	2025-06-21 07:06:36.535385	en	Tripod	tripod	Capture vivid, professional-style photographs with help from this lightweight tripod. The adjustable-height tripod makes it easy to achieve reliable stability and score just the right angle when going after that award-winning shot.	15	15
2025-06-21 07:06:36.589539	2025-06-21 07:06:36.591982	en	Instamatic Camera	instamatic-camera	This inexpensive point-and-shoot camera uses easy-to-load 126 film cartridges. A built-in flash unit ensure great results, no matter the lighting conditions.	16	16
2025-06-21 07:06:36.656115	2025-06-21 07:06:36.65866	en	Compact Digital Camera	compact-digital-camera	Unleash your creative potential with high-level performance and advanced features such as AI-powered Real-time Eye AF; new, high-precision Real-time Tracking; high-speed continuous shooting and 4K HDR movie-shooting. The camera's innovative AF quickly and reliably detects the position of the subject and then tracks the subject's motion, keeping it in sharp focus.	17	17
2025-06-21 07:06:36.70651	2025-06-21 07:06:36.709549	en	Nikkormat SLR Camera	nikkormat-slr-camera	The Nikkormat FS was brought to market by Nikon in 1965. The lens is a 50mm f1.4 Nikkor. Nice glass, smooth focus and a working diaphragm. A UV filter and a Nikon front lens cap are included with the lens.	18	18
2025-06-21 07:06:36.755155	2025-06-21 07:06:36.757413	en	Compact SLR Camera	compact-slr-camera	Retro styled, portable in size and built around a powerful 24-megapixel APS-C CMOS sensor, this digital camera is the ideal companion for creative everyday photography. Packed full of high spec features such as an advanced hybrid autofocus system able to keep pace with even the most active subjects, a speedy 6fps continuous-shooting mode, high-resolution electronic viewfinder and intuitive swivelling touchscreen, it brings professional image making into everyone’s grasp.	19	19
2025-06-21 07:06:36.80933	2025-06-21 07:06:36.811917	en	Twin Lens Camera	twin-lens-camera	What makes a Rolleiflex TLR so special? Many things. To start, TLR stands for twin lens reflex. “Twin” because there are two lenses. And reflex means that the photographer looks through the lens to view the reflected image of an object or scene on the focusing screen. 	20	20
2025-06-21 07:06:36.89143	2025-06-21 07:06:36.893691	en	Road Bike	road-bike	Featuring a full carbon chassis - complete with cyclocross-specific carbon fork - and a component setup geared for hard use on the race circuit, it's got the low weight, exceptional efficiency and brilliant handling you'll need to stay at the front of the pack.	21	21
2025-06-21 07:06:36.952287	2025-06-21 07:06:36.955001	en	Skipping Rope	skipping-rope	When you're working out you need a quality rope that doesn't tangle at every couple of jumps and with this skipping rope you won't have this problem. The fact that it looks like a pair of tasty frankfurters is merely a bonus.	22	22
2025-06-21 07:06:37.062544	2025-06-21 07:06:37.064751	en	Tent	tent	With tons of space inside (for max. 4 persons), full head height throughout the entire tent and an unusual and striking shape, this tent offers you everything you need.	24	24
2025-06-21 07:06:37.004953	2025-06-21 07:06:37.008127	en	Boxing Gloves	boxing-gloves	Training gloves designed for optimum training. Our gloves promote proper punching technique because they are conformed to the natural shape of your fist. Dense, innovative two-layer foam provides better shock absorbency and full padding on the front, back and wrist to promote proper punching technique.	23	23
2025-06-21 07:06:37.118933	2025-06-21 07:06:37.121593	en	Cruiser Skateboard	cruiser-skateboard	Based on the 1970s iconic shape, but made to a larger 69cm size, with updated, quality component, these skateboards are great for beginners to learn the foot spacing required, and are perfect for all-day cruising.	25	25
2025-06-21 07:06:37.178435	2025-06-21 07:06:37.180934	en	Football	football	This football features high-contrast graphics for high-visibility during play, while its machine-stitched tpu casing offers consistent performance.	26	26
2025-06-21 07:06:37.398729	2025-06-21 07:06:37.401177	en	Ultraboost Running Shoe	ultraboost-running-shoe	With its ultra-light, uber-responsive magic foam and a carbon fiber plate that feels like it’s propelling you forward, the Running Shoe is ready to push you to victories both large and small	29	29
2025-06-21 07:06:38.453196	2025-06-21 07:06:38.455611	en	Hanging Plant	hanging-plant	Can be found in tropical and sub-tropical America where it grows on the branches of trees, but also on telephone wires and electricity cables and poles that sometimes topple with the weight of these plants. This plant loves a moist and warm air.	37	37
2025-06-21 07:06:38.501576	2025-06-21 07:06:38.504201	en	Aloe Vera	aloe-vera	Decorative Aloe vera makes a lovely house plant. A really trendy plant, Aloe vera is just so easy to care for. Aloe vera sap has been renowned for its remarkable medicinal and cosmetic properties for many centuries and has been used to treat grazes, insect bites and sunburn - it really works.	38	38
2025-06-21 07:06:38.854574	2025-06-21 07:06:38.857432	en	Hand Trowel	hand-trowel	Hand trowel for garden cultivating hammer finish epoxy-coated head for improved resistance to rust, scratches, humidity and alkalines in the soil.	44	44
2025-06-21 07:06:38.906393	2025-06-21 07:06:38.909436	en	Balloon Chair	balloon-chair	A charming vintage white wooden chair featuring an extremely spherical pink balloon. The balloon may be detached and used for other purposes, for example as a party decoration.	45	45
2025-06-21 07:06:38.963473	2025-06-21 07:06:38.966483	en	Grey Fabric Sofa	grey-fabric-sofa	Seat cushions filled with high resilience foam and polyester fibre wadding give comfortable support for your body, and easily regain their shape when you get up. The cover is easy to keep clean as it is removable and can be machine washed.	46	46
2025-06-21 07:06:39.033643	2025-06-21 07:06:39.037051	en	Leather Sofa	leather-sofa	This premium, tan-brown bonded leather seat is part of the 'chill' sofa range. The lever activated recline feature makes it easy to adjust to any position. This smart, bustle back design with rounded tight padded arms has been designed with your comfort in mind. This well-padded chair has foam pocket sprung seat cushions and fibre-filled back cushions.	47	47
2025-06-21 07:06:39.353494	2025-06-21 07:06:39.356028	en	Bedside Table	bedside-table	Every table is unique, with varying grain pattern and natural colour shifts that are part of the charm of wood.	53	53
2025-06-21 07:06:37.239679	2025-06-21 07:06:37.24264	en	Tennis Ball	tennis-ball	Our dog loves these tennis balls and they last for some time before they eventually either get lost in some field or bush or the covering comes off due to it being used most of the day every day.	27	27
2025-06-21 07:08:25.114381	2025-06-21 07:08:25.117066	en	Fern Blechnum Gibbum	fern-blechnum-gibbum	Create a tropical feel in your home with this lush green tree fern, it has decorative leaves and will develop a short slender trunk in time.	39	39
2025-06-21 07:06:39.151612	2025-06-21 07:06:39.154331	en	Wooden Side Desk	wooden-side-desk	Drawer stops prevent the drawers from being pulled out too far. Built-in cable management for collecting cables and cords; out of sight but close at hand.	49	49
2025-06-21 07:06:39.25197	2025-06-21 07:06:39.25423	en	Black Eaves Chair	black-eaves-chair	Comfortable to sit on thanks to the bowl-shaped seat and rounded shape of the backrest. No tools are required to assemble the chair, you just click it together with a simple mechanism under the seat.	51	51
2025-06-21 07:06:37.298614	2025-06-21 07:06:37.301082	en	Basketball	basketball	The Wilson MVP ball is perfect for playing basketball, and improving your skill for hours on end. Designed for new players, it is created with a high-quality rubber suitable for courts, allowing you to get full use during your practices.	28	28
2025-06-21 07:06:37.845049	2025-06-21 07:06:37.848728	en	Pureboost Running Shoe	pureboost-running-shoe	Built to handle curbs, corners and uneven sidewalks, these natural running shoes have an expanded landing zone and a heel plate for added stability. A lightweight and stretchy knit upper supports your native stride.	32	32
2025-06-21 07:06:37.98163	2025-06-21 07:06:37.983884	en	RunX Running Shoe	runx-running-shoe	These running shoes are made with an airy, lightweight mesh upper. The durable rubber outsole grips the pavement for added stability. A cushioned midsole brings comfort to each step.	33	33
2025-06-21 07:06:39.203737	2025-06-21 07:06:39.206299	en	Comfy Padded Chair	comfy-padded-chair	You sit comfortably thanks to the shaped back. The chair frame is made of solid wood, which is a durable natural material.	50	50
2025-06-21 07:06:39.296362	2025-06-21 07:06:39.29952	en	Wooden Stool	wooden-stool	Solid wood is a hardwearing natural material, which can be sanded and surface treated as required.	52	52
2025-06-21 07:06:37.558078	2025-06-21 07:06:37.561262	en	Freerun Running Shoe	freerun-running-shoe	The Freerun Men's Running Shoe is built for record-breaking speed. The Flyknit upper delivers ultra-lightweight support that fits like a glove.	30	30
2025-06-21 07:06:37.714124	2025-06-21 07:06:37.716558	en	Hi-Top Basketball Shoe	hi-top-basketball-shoe	Boasting legendary performance since 2008, the Hyperdunkz Basketball Shoe needs no gimmicks to stand out. Air units deliver best-in-class cushioning, while a dynamic lacing system keeps your foot snug and secure, so you can focus on your game and nothing else.	31	31
2025-06-21 07:06:38.138224	2025-06-21 07:06:38.141424	en	Allstar Sneakers	allstar-sneakers	All Star is the most iconic sneaker in the world, recognised for its unmistakable silhouette, star-centred ankle patch and cultural authenticity. And like the best paradigms, it only gets better with time.	34	34
2025-06-21 07:06:38.339635	2025-06-21 07:06:38.342353	en	Spiky Cactus	spiky-cactus	A spiky yet elegant house cactus - perfect for the home or office. Origin and habitat: Probably native only to the Andes of Peru	35	35
2025-06-21 07:06:38.395733	2025-06-21 07:06:38.401273	en	Tulip Pot	tulip-pot	Bright crimson red species tulip with black centers, the poppy-like flowers will open up in full sun. Ideal for rock gardens, pots and border edging.	36	36
2025-06-21 07:08:25.169107	2025-06-21 07:08:25.171893	en	Assorted Indoor Succulents	assorted-succulents	These assorted succulents come in a variety of different shapes and colours - each with their own unique personality. Succulents grow best in plenty of light: a sunny windowsill would be the ideal spot for them to thrive!	40	40
2025-06-21 07:08:25.219697	2025-06-21 07:08:25.225224	en	Orchid	orchid	Gloriously elegant. It can go along with any interior as it is a neutral color and the most popular Phalaenopsis overall. 2 to 3 foot stems host large white flowers that can last for over 2 months.	41	41
2025-06-21 07:06:38.725354	2025-06-21 07:06:38.727515	en	Bonsai Tree	bonsai-tree	Excellent semi-evergreen bonsai. Indoors or out but needs some winter protection. All trees sent will leave the nursery in excellent condition and will be of equal quality or better than the photograph shown.	42	42
2025-06-21 07:06:38.797291	2025-06-21 07:06:38.800444	en	Guardian Lion Statue	guardian-lion-statue	Placing it at home or office can bring you fortune and prosperity, guard your house and ward off ill fortune.	43	43
2025-06-21 07:06:39.08741	2025-06-21 07:06:39.090481	en	Light Shade	light-shade	Modern tapered white polycotton pendant shade with a metallic silver chrome interior finish for maximum light reflection. Reversible gimble so it can be used as a ceiling shade or as a lamp shade.	48	48
2025-06-21 07:06:39.402569	2025-06-21 07:06:39.405183	en	Modern Cafe Chair	modern-cafe-chair	You sit comfortably thanks to the restful flexibility of the seat. Lightweight and easy to move around, yet stable enough even for the liveliest, young family members.	54	54
\.


--
-- Data for Name: product_variant; Type: TABLE DATA; Schema: public; Owner: vendure
--

COPY public.product_variant ("createdAt", "updatedAt", "deletedAt", enabled, sku, "outOfStockThreshold", "useGlobalOutOfStockThreshold", "trackInventory", id, "featuredAssetId", "taxCategoryId", "productId") FROM stdin;
2025-06-21 07:06:35.215291	2025-06-21 07:06:35.215291	\N	t	L2201308	0	t	INHERIT	1	\N	1	1
2025-06-21 07:06:35.248686	2025-06-21 07:06:35.248686	\N	t	L2201508	0	t	INHERIT	2	\N	1	1
2025-06-21 07:06:35.274681	2025-06-21 07:06:35.274681	\N	t	L2201316	0	t	INHERIT	3	\N	1	1
2025-06-21 07:06:35.296128	2025-06-21 07:06:35.296128	\N	t	L2201516	0	t	INHERIT	4	\N	1	1
2025-06-21 07:06:35.368895	2025-06-21 07:06:35.368895	\N	t	TBL200032	0	t	INHERIT	5	\N	1	2
2025-06-21 07:06:35.394177	2025-06-21 07:06:35.394177	\N	t	TBL200128	0	t	INHERIT	6	\N	1	2
2025-06-21 07:06:35.471714	2025-06-21 07:06:35.471714	\N	t	834444	0	t	INHERIT	7	\N	1	3
2025-06-21 07:06:35.543621	2025-06-21 07:06:35.543621	\N	t	LU32J590UQUXEN	0	t	INHERIT	8	\N	1	4
2025-06-21 07:06:35.616661	2025-06-21 07:06:35.616661	\N	t	C24F390	0	t	INHERIT	9	\N	1	5
2025-06-21 07:06:35.640167	2025-06-21 07:06:35.640167	\N	t	C27F390	0	t	INHERIT	10	\N	1	5
2025-06-21 07:06:35.742389	2025-06-21 07:06:35.742389	\N	t	CMK32GX4M2AC04	0	t	INHERIT	11	\N	1	6
2025-06-21 07:06:35.761823	2025-06-21 07:06:35.761823	\N	t	CMK32GX4M2AC08	0	t	INHERIT	12	\N	1	6
2025-06-21 07:06:35.782699	2025-06-21 07:06:35.782699	\N	t	CMK32GX4M2AC16	0	t	INHERIT	13	\N	1	6
2025-06-21 07:06:35.892503	2025-06-21 07:06:35.892503	\N	t	CGS480VR1063	0	t	INHERIT	14	\N	1	7
2025-06-21 07:06:35.912112	2025-06-21 07:06:35.912112	\N	t	CGS480VR1064	0	t	INHERIT	15	\N	1	7
2025-06-21 07:06:35.932163	2025-06-21 07:06:35.932163	\N	t	CGS480VR1065	0	t	INHERIT	16	\N	1	7
2025-06-21 07:06:35.951573	2025-06-21 07:06:35.951573	\N	t	CGS480VR1066	0	t	INHERIT	17	\N	1	7
2025-06-21 07:06:36.053468	2025-06-21 07:06:36.053468	\N	t	IHD455T1	0	t	INHERIT	18	\N	1	8
2025-06-21 07:06:36.074566	2025-06-21 07:06:36.074566	\N	t	IHD455T2	0	t	INHERIT	19	\N	1	8
2025-06-21 07:06:36.093735	2025-06-21 07:06:36.093735	\N	t	IHD455T3	0	t	INHERIT	20	\N	1	8
2025-06-21 07:06:36.113383	2025-06-21 07:06:36.113383	\N	t	IHD455T4	0	t	INHERIT	21	\N	1	8
2025-06-21 07:06:36.133104	2025-06-21 07:06:36.133104	\N	t	IHD455T6	0	t	INHERIT	22	\N	1	8
2025-06-21 07:06:36.186003	2025-06-21 07:06:36.186003	\N	t	A4TKLA45535	0	t	INHERIT	23	\N	1	9
2025-06-21 07:06:36.250722	2025-06-21 07:06:36.250722	\N	t	A23334x30	0	t	INHERIT	24	\N	1	10
2025-06-21 07:06:36.297883	2025-06-21 07:06:36.297883	\N	t	USBCIN01.5MI	0	t	INHERIT	25	\N	1	11
2025-06-21 07:06:36.362104	2025-06-21 07:06:36.362104	\N	t	IC22MWDD	0	t	INHERIT	26	\N	1	12
2025-06-21 07:06:36.425694	2025-06-21 07:06:36.425694	\N	t	B0012UUP02	0	t	INHERIT	27	\N	1	13
2025-06-21 07:06:36.488602	2025-06-21 07:06:36.488602	\N	t	B00AFC9099	0	t	INHERIT	28	\N	1	14
2025-06-21 07:06:36.544329	2025-06-21 07:06:36.544329	\N	t	B00XI87KV8	0	t	INHERIT	29	\N	1	15
2025-06-21 07:06:36.600722	2025-06-21 07:06:36.600722	\N	t	B07K1330LL	0	t	INHERIT	30	\N	1	16
2025-06-21 07:06:36.669499	2025-06-21 07:06:36.669499	\N	t	B07D990021	0	t	INHERIT	31	\N	1	17
2025-06-21 07:06:36.719509	2025-06-21 07:06:36.719509	\N	t	B07D33B334	0	t	INHERIT	32	\N	1	18
2025-06-21 07:06:36.76641	2025-06-21 07:06:36.76641	\N	t	B07D75V44S	0	t	INHERIT	33	\N	1	19
2025-06-21 07:06:36.822119	2025-06-21 07:06:36.822119	\N	t	B07D78JTLR	0	t	INHERIT	34	\N	1	20
2025-06-21 07:06:36.903668	2025-06-21 07:06:36.903668	\N	t	RB000844334	0	t	INHERIT	35	\N	1	21
2025-06-21 07:06:36.964111	2025-06-21 07:06:36.964111	\N	t	B07CNGXVXT	0	t	INHERIT	36	\N	1	22
2025-06-21 07:06:37.017555	2025-06-21 07:06:37.017555	\N	t	B000ZYLPPU	0	t	INHERIT	37	\N	1	23
2025-06-21 07:06:37.075495	2025-06-21 07:06:37.075495	\N	t	2000023510	0	t	INHERIT	38	\N	1	24
2025-06-21 07:06:37.13064	2025-06-21 07:06:37.13064	\N	t	799872520	0	t	INHERIT	39	\N	1	25
2025-06-21 07:06:37.191178	2025-06-21 07:06:37.191178	\N	t	SC3137-056	0	t	INHERIT	40	\N	1	26
2025-06-21 07:06:37.252503	2025-06-21 07:06:37.252503	\N	t	WRT11752P	0	t	INHERIT	41	\N	1	27
2025-06-21 07:06:37.311715	2025-06-21 07:06:37.311715	\N	t	WTB1418XB06	0	t	INHERIT	42	\N	1	28
2025-06-21 07:06:37.442498	2025-06-21 07:06:37.442498	\N	t	RS0040	0	t	INHERIT	43	\N	1	29
2025-06-21 07:06:37.460806	2025-06-21 07:06:37.460806	\N	t	RS0042	0	t	INHERIT	44	\N	1	29
2025-06-21 07:06:37.485446	2025-06-21 07:06:37.485446	\N	t	RS0044	0	t	INHERIT	45	\N	1	29
2025-06-21 07:06:37.504379	2025-06-21 07:06:37.504379	\N	t	RS0046	0	t	INHERIT	46	\N	1	29
2025-06-21 07:06:37.60084	2025-06-21 07:06:37.60084	\N	t	AR4561-40	0	t	INHERIT	47	\N	1	30
2025-06-21 07:06:37.621409	2025-06-21 07:06:37.621409	\N	t	AR4561-42	0	t	INHERIT	48	\N	1	30
2025-06-21 07:06:37.642644	2025-06-21 07:06:37.642644	\N	t	AR4561-44	0	t	INHERIT	49	\N	1	30
2025-06-21 07:06:37.660696	2025-06-21 07:06:37.660696	\N	t	AR4561-46	0	t	INHERIT	50	\N	1	30
2025-06-21 07:06:37.752597	2025-06-21 07:06:37.752597	\N	t	AO7893-40	0	t	INHERIT	51	\N	1	31
2025-06-21 07:06:37.771152	2025-06-21 07:06:37.771152	\N	t	AO7893-42	0	t	INHERIT	52	\N	1	31
2025-06-21 07:06:37.789846	2025-06-21 07:06:37.789846	\N	t	AO7893-44	0	t	INHERIT	53	\N	1	31
2025-06-21 07:06:37.808754	2025-06-21 07:06:37.808754	\N	t	AO7893-46	0	t	INHERIT	54	\N	1	31
2025-06-21 07:06:37.890441	2025-06-21 07:06:37.890441	\N	t	F3578640	0	t	INHERIT	55	\N	1	32
2025-06-21 07:06:37.908766	2025-06-21 07:06:37.908766	\N	t	F3578642	0	t	INHERIT	56	\N	1	32
2025-06-21 07:06:37.928069	2025-06-21 07:06:37.928069	\N	t	F3578644	0	t	INHERIT	57	\N	1	32
2025-06-21 07:06:37.946842	2025-06-21 07:06:37.946842	\N	t	F3578646	0	t	INHERIT	58	\N	1	32
2025-06-21 07:06:38.021481	2025-06-21 07:06:38.021481	\N	t	F3633340	0	t	INHERIT	59	\N	1	33
2025-06-21 07:06:38.039937	2025-06-21 07:06:38.039937	\N	t	F3633342	0	t	INHERIT	60	\N	1	33
2025-06-21 07:06:38.061127	2025-06-21 07:06:38.061127	\N	t	F3633344	0	t	INHERIT	61	\N	1	33
2025-06-21 07:06:38.082536	2025-06-21 07:06:38.082536	\N	t	F3633346	0	t	INHERIT	62	\N	1	33
2025-06-21 07:06:38.1892	2025-06-21 07:06:38.1892	\N	t	CAS23340	0	t	INHERIT	63	\N	1	34
2025-06-21 07:06:38.215598	2025-06-21 07:06:38.215598	\N	t	CAS23342	0	t	INHERIT	64	\N	1	34
2025-06-21 07:06:38.236172	2025-06-21 07:06:38.236172	\N	t	CAS23344	0	t	INHERIT	65	\N	1	34
2025-06-21 07:06:38.255672	2025-06-21 07:06:38.255672	\N	t	CAS23346	0	t	INHERIT	66	\N	1	34
2025-06-21 07:06:38.351761	2025-06-21 07:06:38.351761	\N	t	SC011001	0	t	INHERIT	67	\N	1	35
2025-06-21 07:06:38.412296	2025-06-21 07:06:38.412296	\N	t	A58477	0	t	INHERIT	68	\N	1	36
2025-06-21 07:06:38.46442	2025-06-21 07:06:38.46442	\N	t	A44223	0	t	INHERIT	69	\N	1	37
2025-06-21 07:06:38.517393	2025-06-21 07:06:38.517393	\N	t	A44352	0	t	INHERIT	70	\N	1	38
2025-06-21 07:08:25.127768	2025-06-21 07:08:25.127768	\N	t	A04851	0	t	INHERIT	71	\N	1	39
2025-06-21 07:08:25.182361	2025-06-21 07:08:25.182361	\N	t	A08593	0	t	INHERIT	72	\N	1	40
2025-06-21 07:06:38.678987	2025-06-21 07:06:38.678987	\N	t	ROR00221	0	t	INHERIT	73	\N	1	41
2025-06-21 07:06:38.73811	2025-06-21 07:06:38.73811	\N	t	B01MXFLUSV	0	t	INHERIT	74	\N	1	42
2025-06-21 07:06:38.810639	2025-06-21 07:06:38.810639	\N	t	GL34LLW11	0	t	INHERIT	75	\N	1	43
2025-06-21 07:06:38.869416	2025-06-21 07:06:38.869416	\N	t	4058NB/09	0	t	INHERIT	76	\N	1	44
2025-06-21 07:06:38.919756	2025-06-21 07:06:38.919756	\N	t	34-BC82444	0	t	INHERIT	77	\N	1	45
2025-06-21 07:06:38.978122	2025-06-21 07:06:38.978122	\N	t	CH00001-12	0	t	INHERIT	78	\N	1	46
2025-06-21 07:06:39.047924	2025-06-21 07:06:39.047924	\N	t	CH00001-02	0	t	INHERIT	79	\N	1	47
2025-06-21 07:06:39.102833	2025-06-21 07:06:39.102833	\N	t	B45809LSW	0	t	INHERIT	80	\N	1	48
2025-06-21 07:06:39.164342	2025-06-21 07:06:39.164342	\N	t	304.096.29	0	t	INHERIT	81	\N	1	49
2025-06-21 07:06:39.215159	2025-06-21 07:06:39.215159	\N	t	404.068.14	0	t	INHERIT	82	\N	1	50
2025-06-21 07:06:39.262863	2025-06-21 07:06:39.262863	\N	t	003.600.02	0	t	INHERIT	83	\N	1	51
2025-06-21 07:06:39.309442	2025-06-21 07:06:39.309442	\N	t	202.493.30	0	t	INHERIT	84	\N	1	52
2025-06-21 07:06:39.365472	2025-06-21 07:06:39.365472	\N	t	404.290.14	0	t	INHERIT	85	\N	1	53
2025-06-21 07:06:39.447278	2025-06-21 07:06:39.447278	\N	t	404.038.96	0	t	INHERIT	86	\N	1	54
2025-06-21 07:06:39.482914	2025-06-21 07:06:39.482914	\N	t	404.038.96	0	t	INHERIT	87	\N	1	54
2025-06-21 07:06:39.506073	2025-06-21 07:06:39.506073	\N	t	404.038.96	0	t	INHERIT	88	\N	1	54
\.


--
-- Data for Name: product_variant_asset; Type: TABLE DATA; Schema: public; Owner: vendure
--

COPY public.product_variant_asset ("createdAt", "updatedAt", "assetId", "position", "productVariantId", id) FROM stdin;
\.


--
-- Data for Name: product_variant_channels_channel; Type: TABLE DATA; Schema: public; Owner: vendure
--

COPY public.product_variant_channels_channel ("productVariantId", "channelId") FROM stdin;
1	1
2	1
3	1
4	1
5	1
6	1
7	1
8	1
9	1
10	1
11	1
12	1
13	1
14	1
15	1
16	1
17	1
18	1
19	1
20	1
21	1
22	1
23	1
24	1
25	1
26	1
27	1
28	1
29	1
30	1
31	1
32	1
33	1
34	1
35	1
36	1
37	1
38	1
39	1
40	1
41	1
42	1
43	1
44	1
45	1
46	1
47	1
48	1
49	1
50	1
51	1
52	1
53	1
54	1
55	1
56	1
57	1
58	1
59	1
60	1
61	1
62	1
63	1
64	1
65	1
66	1
67	1
68	1
69	1
70	1
71	1
72	1
73	1
74	1
75	1
76	1
77	1
78	1
79	1
80	1
81	1
82	1
83	1
84	1
85	1
86	1
87	1
88	1
\.


--
-- Data for Name: product_variant_facet_values_facet_value; Type: TABLE DATA; Schema: public; Owner: vendure
--

COPY public.product_variant_facet_values_facet_value ("productVariantId", "facetValueId") FROM stdin;
86	38
87	39
88	28
\.


--
-- Data for Name: product_variant_options_product_option; Type: TABLE DATA; Schema: public; Owner: vendure
--

COPY public.product_variant_options_product_option ("productVariantId", "productOptionId") FROM stdin;
1	1
1	3
2	2
2	3
3	1
3	4
4	2
4	4
5	5
6	6
9	7
10	8
11	9
12	10
13	11
14	12
14	14
15	13
15	14
16	12
16	15
17	13
17	15
18	16
19	17
20	18
21	19
22	20
43	21
44	22
45	23
46	24
47	25
48	26
49	27
50	28
51	29
52	30
53	31
54	32
55	33
56	34
57	35
58	36
59	37
60	38
61	39
62	40
63	41
64	42
65	43
66	44
86	45
87	46
88	47
\.


--
-- Data for Name: product_variant_price; Type: TABLE DATA; Schema: public; Owner: vendure
--

COPY public.product_variant_price ("createdAt", "updatedAt", "currencyCode", id, "channelId", price, "variantId") FROM stdin;
2025-06-21 07:06:35.241062	2025-06-21 07:06:35.241062	USD	1	1	129900	1
2025-06-21 07:06:35.268514	2025-06-21 07:06:35.268514	USD	2	1	139900	2
2025-06-21 07:06:35.290053	2025-06-21 07:06:35.290053	USD	3	1	219900	3
2025-06-21 07:06:35.311876	2025-06-21 07:06:35.311876	USD	4	1	229900	4
2025-06-21 07:06:35.387732	2025-06-21 07:06:35.387732	USD	5	1	32900	5
2025-06-21 07:06:35.415173	2025-06-21 07:06:35.415173	USD	6	1	44500	6
2025-06-21 07:06:35.485748	2025-06-21 07:06:35.485748	USD	7	1	1899	7
2025-06-21 07:06:35.556847	2025-06-21 07:06:35.556847	USD	8	1	31000	8
2025-06-21 07:06:35.632898	2025-06-21 07:06:35.632898	USD	9	1	14374	9
2025-06-21 07:06:35.657799	2025-06-21 07:06:35.657799	USD	10	1	16994	10
2025-06-21 07:06:35.756995	2025-06-21 07:06:35.756995	USD	11	1	13785	11
2025-06-21 07:06:35.776754	2025-06-21 07:06:35.776754	USD	12	1	14639	12
2025-06-21 07:06:35.800673	2025-06-21 07:06:35.800673	USD	13	1	28181	13
2025-06-21 07:06:35.906864	2025-06-21 07:06:35.906864	USD	14	1	108720	14
2025-06-21 07:06:35.926697	2025-06-21 07:06:35.926697	USD	15	1	109995	15
2025-06-21 07:06:35.946543	2025-06-21 07:06:35.946543	USD	16	1	93120	16
2025-06-21 07:06:35.965088	2025-06-21 07:06:35.965088	USD	17	1	94920	17
2025-06-21 07:06:36.069103	2025-06-21 07:06:36.069103	USD	18	1	3799	18
2025-06-21 07:06:36.088745	2025-06-21 07:06:36.088745	USD	19	1	5374	19
2025-06-21 07:06:36.108133	2025-06-21 07:06:36.108133	USD	20	1	7896	20
2025-06-21 07:06:36.127743	2025-06-21 07:06:36.127743	USD	21	1	9299	21
2025-06-21 07:06:36.147923	2025-06-21 07:06:36.147923	USD	22	1	13435	22
2025-06-21 07:06:36.200629	2025-06-21 07:06:36.200629	USD	23	1	7489	23
2025-06-21 07:06:36.264353	2025-06-21 07:06:36.264353	USD	24	1	597	24
2025-06-21 07:06:36.310845	2025-06-21 07:06:36.310845	USD	25	1	6900	25
2025-06-21 07:06:36.376258	2025-06-21 07:06:36.376258	USD	26	1	17499	26
2025-06-21 07:06:36.439971	2025-06-21 07:06:36.439971	USD	27	1	10400	27
2025-06-21 07:06:36.503118	2025-06-21 07:06:36.503118	USD	28	1	535000	28
2025-06-21 07:06:36.556113	2025-06-21 07:06:36.556113	USD	29	1	1498	29
2025-06-21 07:06:36.615867	2025-06-21 07:06:36.615867	USD	30	1	2000	30
2025-06-21 07:06:36.683798	2025-06-21 07:06:36.683798	USD	31	1	89999	31
2025-06-21 07:06:36.733277	2025-06-21 07:06:36.733277	USD	32	1	61500	32
2025-06-21 07:06:36.77864	2025-06-21 07:06:36.77864	USD	33	1	52100	33
2025-06-21 07:06:36.835566	2025-06-21 07:06:36.835566	USD	34	1	79900	34
2025-06-21 07:06:36.917752	2025-06-21 07:06:36.917752	USD	35	1	249900	35
2025-06-21 07:06:36.976677	2025-06-21 07:06:36.976677	USD	36	1	799	36
2025-06-21 07:06:37.031516	2025-06-21 07:06:37.031516	USD	37	1	3304	37
2025-06-21 07:06:37.088822	2025-06-21 07:06:37.088822	USD	38	1	21493	38
2025-06-21 07:06:37.14474	2025-06-21 07:06:37.14474	USD	39	1	2499	39
2025-06-21 07:06:37.205228	2025-06-21 07:06:37.205228	USD	40	1	5707	40
2025-06-21 07:06:37.266339	2025-06-21 07:06:37.266339	USD	41	1	1273	41
2025-06-21 07:06:37.32527	2025-06-21 07:06:37.32527	USD	42	1	3562	42
2025-06-21 07:06:37.455259	2025-06-21 07:06:37.455259	USD	43	1	9999	43
2025-06-21 07:06:37.480117	2025-06-21 07:06:37.480117	USD	44	1	9999	44
2025-06-21 07:06:37.499337	2025-06-21 07:06:37.499337	USD	45	1	9999	45
2025-06-21 07:06:37.51866	2025-06-21 07:06:37.51866	USD	46	1	9999	46
2025-06-21 07:06:37.615732	2025-06-21 07:06:37.615732	USD	47	1	16000	47
2025-06-21 07:06:37.635884	2025-06-21 07:06:37.635884	USD	48	1	16000	48
2025-06-21 07:06:37.655682	2025-06-21 07:06:37.655682	USD	49	1	16000	49
2025-06-21 07:06:37.674822	2025-06-21 07:06:37.674822	USD	50	1	16000	50
2025-06-21 07:06:37.765203	2025-06-21 07:06:37.765203	USD	51	1	14000	51
2025-06-21 07:06:37.785767	2025-06-21 07:06:37.785767	USD	52	1	14000	52
2025-06-21 07:06:37.802619	2025-06-21 07:06:37.802619	USD	53	1	14000	53
2025-06-21 07:06:37.822589	2025-06-21 07:06:37.822589	USD	54	1	14000	54
2025-06-21 07:06:37.903713	2025-06-21 07:06:37.903713	USD	55	1	9995	55
2025-06-21 07:06:37.922458	2025-06-21 07:06:37.922458	USD	56	1	9995	56
2025-06-21 07:06:37.941324	2025-06-21 07:06:37.941324	USD	57	1	9995	57
2025-06-21 07:06:37.960841	2025-06-21 07:06:37.960841	USD	58	1	9995	58
2025-06-21 07:06:38.034588	2025-06-21 07:06:38.034588	USD	59	1	4495	59
2025-06-21 07:06:38.054562	2025-06-21 07:06:38.054562	USD	60	1	4495	60
2025-06-21 07:06:38.077273	2025-06-21 07:06:38.077273	USD	61	1	4495	61
2025-06-21 07:06:38.095713	2025-06-21 07:06:38.095713	USD	62	1	4495	62
2025-06-21 07:06:38.209096	2025-06-21 07:06:38.209096	USD	63	1	6500	63
2025-06-21 07:06:38.230494	2025-06-21 07:06:38.230494	USD	64	1	6500	64
2025-06-21 07:06:38.250511	2025-06-21 07:06:38.250511	USD	65	1	6500	65
2025-06-21 07:06:38.271255	2025-06-21 07:06:38.271255	USD	66	1	6500	66
2025-06-21 07:06:38.365354	2025-06-21 07:06:38.365354	USD	67	1	1550	67
2025-06-21 07:06:38.42646	2025-06-21 07:06:38.42646	USD	68	1	675	68
2025-06-21 07:06:38.478702	2025-06-21 07:06:38.478702	USD	69	1	1995	69
2025-06-21 07:06:38.530449	2025-06-21 07:06:38.530449	USD	70	1	699	70
2025-06-21 07:08:25.142258	2025-06-21 07:08:25.142258	USD	71	1	895	71
2025-06-21 07:08:25.195587	2025-06-21 07:08:25.195587	USD	72	1	3250	72
2025-06-21 07:06:38.696174	2025-06-21 07:06:38.696174	USD	73	1	6500	73
2025-06-21 07:06:38.753384	2025-06-21 07:06:38.753384	USD	74	1	1999	74
2025-06-21 07:06:38.826176	2025-06-21 07:06:38.826176	USD	75	1	18853	75
2025-06-21 07:06:38.885105	2025-06-21 07:06:38.885105	USD	76	1	499	76
2025-06-21 07:06:38.935056	2025-06-21 07:06:38.935056	USD	77	1	6500	77
2025-06-21 07:06:38.995049	2025-06-21 07:06:38.995049	USD	78	1	29500	78
2025-06-21 07:06:39.06438	2025-06-21 07:06:39.06438	USD	79	1	124500	79
2025-06-21 07:06:39.116052	2025-06-21 07:06:39.116052	USD	80	1	2845	80
2025-06-21 07:06:39.177858	2025-06-21 07:06:39.177858	USD	81	1	12500	81
2025-06-21 07:06:39.228339	2025-06-21 07:06:39.228339	USD	82	1	13000	82
2025-06-21 07:06:39.276076	2025-06-21 07:06:39.276076	USD	83	1	7000	83
2025-06-21 07:06:39.321446	2025-06-21 07:06:39.321446	USD	84	1	1400	84
2025-06-21 07:06:39.379121	2025-06-21 07:06:39.379121	USD	85	1	13000	85
2025-06-21 07:06:39.463115	2025-06-21 07:06:39.463115	USD	86	1	10000	86
2025-06-21 07:06:39.498682	2025-06-21 07:06:39.498682	USD	87	1	10000	87
2025-06-21 07:06:39.522246	2025-06-21 07:06:39.522246	USD	88	1	10000	88
\.


--
-- Data for Name: product_variant_translation; Type: TABLE DATA; Schema: public; Owner: vendure
--

COPY public.product_variant_translation ("createdAt", "updatedAt", "languageCode", name, id, "baseId") FROM stdin;
2025-06-21 07:06:35.211986	2025-06-21 07:06:35.215291	en	Laptop 13 inch 8GB	1	1
2025-06-21 07:06:35.24578	2025-06-21 07:06:35.248686	en	Laptop 15 inch 8GB	2	2
2025-06-21 07:06:35.272346	2025-06-21 07:06:35.274681	en	Laptop 13 inch 16GB	3	3
2025-06-21 07:06:35.293672	2025-06-21 07:06:35.296128	en	Laptop 15 inch 16GB	4	4
2025-06-21 07:06:35.36636	2025-06-21 07:06:35.368895	en	Tablet 32GB	5	5
2025-06-21 07:06:35.391517	2025-06-21 07:06:35.394177	en	Tablet 128GB	6	6
2025-06-21 07:06:35.469015	2025-06-21 07:06:35.471714	en	Wireless Optical Mouse	7	7
2025-06-21 07:06:35.541152	2025-06-21 07:06:35.543621	en	32-Inch Monitor	8	8
2025-06-21 07:06:35.613839	2025-06-21 07:06:35.616661	en	Curvy Monitor 24 inch	9	9
2025-06-21 07:06:35.636537	2025-06-21 07:06:35.640167	en	Curvy Monitor 27 inch	10	10
2025-06-21 07:06:35.739876	2025-06-21 07:06:35.742389	en	High Performance RAM 4GB	11	11
2025-06-21 07:06:35.75947	2025-06-21 07:06:35.761823	en	High Performance RAM 8GB	12	12
2025-06-21 07:06:35.779937	2025-06-21 07:06:35.782699	en	High Performance RAM 16GB	13	13
2025-06-21 07:06:35.890258	2025-06-21 07:06:35.892503	en	Gaming PC i7-8700 240GB SSD	14	14
2025-06-21 07:06:35.909836	2025-06-21 07:06:35.912112	en	Gaming PC R7-2700 240GB SSD	15	15
2025-06-21 07:06:35.929723	2025-06-21 07:06:35.932163	en	Gaming PC i7-8700 120GB SSD	16	16
2025-06-21 07:06:35.949241	2025-06-21 07:06:35.951573	en	Gaming PC R7-2700 120GB SSD	17	17
2025-06-21 07:06:36.051173	2025-06-21 07:06:36.053468	en	Hard Drive 1TB	18	18
2025-06-21 07:06:36.072411	2025-06-21 07:06:36.074566	en	Hard Drive 2TB	19	19
2025-06-21 07:06:36.091729	2025-06-21 07:06:36.093735	en	Hard Drive 3TB	20	20
2025-06-21 07:06:36.110763	2025-06-21 07:06:36.113383	en	Hard Drive 4TB	21	21
2025-06-21 07:06:36.130761	2025-06-21 07:06:36.133104	en	Hard Drive 6TB	22	22
2025-06-21 07:06:36.183198	2025-06-21 07:06:36.186003	en	Clacky Keyboard	23	23
2025-06-21 07:06:36.248015	2025-06-21 07:06:36.250722	en	Ethernet Cable	24	24
2025-06-21 07:06:36.295549	2025-06-21 07:06:36.297883	en	USB Cable	25	25
2025-06-21 07:06:36.359614	2025-06-21 07:06:36.362104	en	Instant Camera	26	26
2025-06-21 07:06:36.421698	2025-06-21 07:06:36.425694	en	Camera Lens	27	27
2025-06-21 07:06:36.485763	2025-06-21 07:06:36.488602	en	Vintage Folding Camera	28	28
2025-06-21 07:06:36.542158	2025-06-21 07:06:36.544329	en	Tripod	29	29
2025-06-21 07:06:36.59862	2025-06-21 07:06:36.600722	en	Instamatic Camera	30	30
2025-06-21 07:06:36.666605	2025-06-21 07:06:36.669499	en	Compact Digital Camera	31	31
2025-06-21 07:06:36.717156	2025-06-21 07:06:36.719509	en	Nikkormat SLR Camera	32	32
2025-06-21 07:06:36.763971	2025-06-21 07:06:36.76641	en	Compact SLR Camera	33	33
2025-06-21 07:06:36.819769	2025-06-21 07:06:36.822119	en	Twin Lens Camera	34	34
2025-06-21 07:06:36.900864	2025-06-21 07:06:36.903668	en	Road Bike	35	35
2025-06-21 07:06:36.96213	2025-06-21 07:06:36.964111	en	Skipping Rope	36	36
2025-06-21 07:06:37.015277	2025-06-21 07:06:37.017555	en	Boxing Gloves	37	37
2025-06-21 07:06:37.07301	2025-06-21 07:06:37.075495	en	Tent	38	38
2025-06-21 07:06:37.128358	2025-06-21 07:06:37.13064	en	Cruiser Skateboard	39	39
2025-06-21 07:06:37.188661	2025-06-21 07:06:37.191178	en	Football	40	40
2025-06-21 07:06:37.250273	2025-06-21 07:06:37.252503	en	Tennis Ball	41	41
2025-06-21 07:06:37.309115	2025-06-21 07:06:37.311715	en	Basketball	42	42
2025-06-21 07:06:37.439743	2025-06-21 07:06:37.442498	en	Ultraboost Running Shoe Size 40	43	43
2025-06-21 07:06:37.458503	2025-06-21 07:06:37.460806	en	Ultraboost Running Shoe Size 42	44	44
2025-06-21 07:06:37.482907	2025-06-21 07:06:37.485446	en	Ultraboost Running Shoe Size 44	45	45
2025-06-21 07:06:37.502161	2025-06-21 07:06:37.504379	en	Ultraboost Running Shoe Size 46	46	46
2025-06-21 07:06:37.598775	2025-06-21 07:06:37.60084	en	Freerun Running Shoe Size 40	47	47
2025-06-21 07:06:37.619172	2025-06-21 07:06:37.621409	en	Freerun Running Shoe Size 42	48	48
2025-06-21 07:06:37.63912	2025-06-21 07:06:37.642644	en	Freerun Running Shoe Size 44	49	49
2025-06-21 07:06:37.658455	2025-06-21 07:06:37.660696	en	Freerun Running Shoe Size 46	50	50
2025-06-21 07:06:37.750481	2025-06-21 07:06:37.752597	en	Hi-Top Basketball Shoe Size 40	51	51
2025-06-21 07:06:37.768161	2025-06-21 07:06:37.771152	en	Hi-Top Basketball Shoe Size 42	52	52
2025-06-21 07:06:37.78794	2025-06-21 07:06:37.789846	en	Hi-Top Basketball Shoe Size 44	53	53
2025-06-21 07:06:37.806302	2025-06-21 07:06:37.808754	en	Hi-Top Basketball Shoe Size 46	54	54
2025-06-21 07:06:37.888211	2025-06-21 07:06:37.890441	en	Pureboost Running Shoe Size 40	55	55
2025-06-21 07:06:37.906544	2025-06-21 07:06:37.908766	en	Pureboost Running Shoe Size 42	56	56
2025-06-21 07:06:37.926136	2025-06-21 07:06:37.928069	en	Pureboost Running Shoe Size 44	57	57
2025-06-21 07:06:37.944452	2025-06-21 07:06:37.946842	en	Pureboost Running Shoe Size 46	58	58
2025-06-21 07:06:38.019105	2025-06-21 07:06:38.021481	en	RunX Running Shoe Size 40	59	59
2025-06-21 07:06:38.037694	2025-06-21 07:06:38.039937	en	RunX Running Shoe Size 42	60	60
2025-06-21 07:06:38.058265	2025-06-21 07:06:38.061127	en	RunX Running Shoe Size 44	61	61
2025-06-21 07:06:38.080242	2025-06-21 07:06:38.082536	en	RunX Running Shoe Size 46	62	62
2025-06-21 07:06:38.185238	2025-06-21 07:06:38.1892	en	Allstar Sneakers Size 40	63	63
2025-06-21 07:06:38.212377	2025-06-21 07:06:38.215598	en	Allstar Sneakers Size 42	64	64
2025-06-21 07:06:38.233489	2025-06-21 07:06:38.236172	en	Allstar Sneakers Size 44	65	65
2025-06-21 07:06:38.253433	2025-06-21 07:06:38.255672	en	Allstar Sneakers Size 46	66	66
2025-06-21 07:06:38.349689	2025-06-21 07:06:38.351761	en	Spiky Cactus	67	67
2025-06-21 07:06:38.409665	2025-06-21 07:06:38.412296	en	Tulip Pot	68	68
2025-06-21 07:06:38.462234	2025-06-21 07:06:38.46442	en	Hanging Plant	69	69
2025-06-21 07:06:38.512491	2025-06-21 07:06:38.517393	en	Aloe Vera	70	70
2025-06-21 07:08:25.125266	2025-06-21 07:08:25.127768	en	Fern Blechnum Gibbum	71	71
2025-06-21 07:08:25.179846	2025-06-21 07:08:25.182361	en	Assorted Indoor Succulents	72	72
2025-06-21 07:06:38.675444	2025-06-21 07:06:38.678987	en	Orchid	73	73
2025-06-21 07:06:38.735034	2025-06-21 07:06:38.73811	en	Bonsai Tree	74	74
2025-06-21 07:06:38.808314	2025-06-21 07:06:38.810639	en	Guardian Lion Statue	75	75
2025-06-21 07:06:38.866879	2025-06-21 07:06:38.869416	en	Hand Trowel	76	76
2025-06-21 07:06:38.917322	2025-06-21 07:06:38.919756	en	Balloon Chair	77	77
2025-06-21 07:06:38.975342	2025-06-21 07:06:38.978122	en	Grey Fabric Sofa	78	78
2025-06-21 07:06:39.045269	2025-06-21 07:06:39.047924	en	Leather Sofa	79	79
2025-06-21 07:06:39.100632	2025-06-21 07:06:39.102833	en	Light Shade	80	80
2025-06-21 07:06:39.161877	2025-06-21 07:06:39.164342	en	Wooden Side Desk	81	81
2025-06-21 07:06:39.213182	2025-06-21 07:06:39.215159	en	Comfy Padded Chair	82	82
2025-06-21 07:06:39.26075	2025-06-21 07:06:39.262863	en	Black Eaves Chair	83	83
2025-06-21 07:06:39.307471	2025-06-21 07:06:39.309442	en	Wooden Stool	84	84
2025-06-21 07:06:39.362786	2025-06-21 07:06:39.365472	en	Bedside Table	85	85
2025-06-21 07:06:39.444999	2025-06-21 07:06:39.447278	en	Modern Cafe Chair mustard	86	86
2025-06-21 07:06:39.480308	2025-06-21 07:06:39.482914	en	Modern Cafe Chair mint	87	87
2025-06-21 07:06:39.502274	2025-06-21 07:06:39.506073	en	Modern Cafe Chair pearl	88	88
\.


--
-- Data for Name: promotion; Type: TABLE DATA; Schema: public; Owner: vendure
--

COPY public.promotion ("createdAt", "updatedAt", "deletedAt", "startsAt", "endsAt", "couponCode", "perCustomerUsageLimit", "usageLimit", enabled, conditions, actions, "priorityScore", id) FROM stdin;
\.


--
-- Data for Name: promotion_channels_channel; Type: TABLE DATA; Schema: public; Owner: vendure
--

COPY public.promotion_channels_channel ("promotionId", "channelId") FROM stdin;
\.


--
-- Data for Name: promotion_translation; Type: TABLE DATA; Schema: public; Owner: vendure
--

COPY public.promotion_translation ("createdAt", "updatedAt", "languageCode", name, description, id, "baseId") FROM stdin;
\.


--
-- Data for Name: refund; Type: TABLE DATA; Schema: public; Owner: vendure
--

COPY public.refund ("createdAt", "updatedAt", method, reason, state, "transactionId", metadata, id, "paymentId", items, shipping, adjustment, total) FROM stdin;
\.


--
-- Data for Name: region; Type: TABLE DATA; Schema: public; Owner: vendure
--

COPY public.region ("createdAt", "updatedAt", code, type, enabled, id, "parentId", discriminator) FROM stdin;
2025-06-21 07:06:32.538123	2025-06-21 07:06:32.538123	AF	country	t	1	\N	Country
2025-06-21 07:06:32.562427	2025-06-21 07:06:32.562427	AX	country	t	2	\N	Country
2025-06-21 07:06:32.579799	2025-06-21 07:06:32.579799	AL	country	t	3	\N	Country
2025-06-21 07:06:32.58833	2025-06-21 07:06:32.58833	DZ	country	t	4	\N	Country
2025-06-21 07:06:32.605621	2025-06-21 07:06:32.605621	AS	country	t	5	\N	Country
2025-06-21 07:06:32.621599	2025-06-21 07:06:32.621599	AD	country	t	6	\N	Country
2025-06-21 07:06:32.630699	2025-06-21 07:06:32.630699	AO	country	t	7	\N	Country
2025-06-21 07:06:32.639478	2025-06-21 07:06:32.639478	AI	country	t	8	\N	Country
2025-06-21 07:06:32.655937	2025-06-21 07:06:32.655937	AG	country	t	9	\N	Country
2025-06-21 07:06:32.66472	2025-06-21 07:06:32.66472	AR	country	t	10	\N	Country
2025-06-21 07:06:32.673383	2025-06-21 07:06:32.673383	AM	country	t	11	\N	Country
2025-06-21 07:06:32.682293	2025-06-21 07:06:32.682293	AW	country	t	12	\N	Country
2025-06-21 07:06:32.691443	2025-06-21 07:06:32.691443	AU	country	t	13	\N	Country
2025-06-21 07:06:32.70078	2025-06-21 07:06:32.70078	AT	country	t	14	\N	Country
2025-06-21 07:06:32.709245	2025-06-21 07:06:32.709245	AZ	country	t	15	\N	Country
2025-06-21 07:06:32.717349	2025-06-21 07:06:32.717349	BS	country	t	16	\N	Country
2025-06-21 07:06:32.725421	2025-06-21 07:06:32.725421	BH	country	t	17	\N	Country
2025-06-21 07:06:32.735155	2025-06-21 07:06:32.735155	BD	country	t	18	\N	Country
2025-06-21 07:06:32.743578	2025-06-21 07:06:32.743578	BB	country	t	19	\N	Country
2025-06-21 07:06:32.751872	2025-06-21 07:06:32.751872	BY	country	t	20	\N	Country
2025-06-21 07:06:32.761504	2025-06-21 07:06:32.761504	BE	country	t	21	\N	Country
2025-06-21 07:06:32.771241	2025-06-21 07:06:32.771241	BZ	country	t	22	\N	Country
2025-06-21 07:06:32.779864	2025-06-21 07:06:32.779864	BJ	country	t	23	\N	Country
2025-06-21 07:06:32.788085	2025-06-21 07:06:32.788085	BM	country	t	24	\N	Country
2025-06-21 07:06:32.796258	2025-06-21 07:06:32.796258	BT	country	t	25	\N	Country
2025-06-21 07:06:32.80448	2025-06-21 07:06:32.80448	BO	country	t	26	\N	Country
2025-06-21 07:06:32.812594	2025-06-21 07:06:32.812594	BQ	country	t	27	\N	Country
2025-06-21 07:06:32.821979	2025-06-21 07:06:32.821979	BA	country	t	28	\N	Country
2025-06-21 07:06:32.830766	2025-06-21 07:06:32.830766	BW	country	t	29	\N	Country
2025-06-21 07:06:32.839204	2025-06-21 07:06:32.839204	BV	country	t	30	\N	Country
2025-06-21 07:06:32.847308	2025-06-21 07:06:32.847308	BR	country	t	31	\N	Country
2025-06-21 07:06:32.855158	2025-06-21 07:06:32.855158	IO	country	t	32	\N	Country
2025-06-21 07:06:32.864109	2025-06-21 07:06:32.864109	BN	country	t	33	\N	Country
2025-06-21 07:06:32.872899	2025-06-21 07:06:32.872899	BG	country	t	34	\N	Country
2025-06-21 07:06:32.881026	2025-06-21 07:06:32.881026	BF	country	t	35	\N	Country
2025-06-21 07:06:32.889411	2025-06-21 07:06:32.889411	BI	country	t	36	\N	Country
2025-06-21 07:06:32.898628	2025-06-21 07:06:32.898628	CV	country	t	37	\N	Country
2025-06-21 07:06:32.90709	2025-06-21 07:06:32.90709	KH	country	t	38	\N	Country
2025-06-21 07:06:32.915291	2025-06-21 07:06:32.915291	CM	country	t	39	\N	Country
2025-06-21 07:06:32.922929	2025-06-21 07:06:32.922929	CA	country	t	40	\N	Country
2025-06-21 07:06:32.932754	2025-06-21 07:06:32.932754	KY	country	t	41	\N	Country
2025-06-21 07:06:32.941562	2025-06-21 07:06:32.941562	CF	country	t	42	\N	Country
2025-06-21 07:06:32.949333	2025-06-21 07:06:32.949333	TD	country	t	43	\N	Country
2025-06-21 07:06:32.957552	2025-06-21 07:06:32.957552	CL	country	t	44	\N	Country
2025-06-21 07:06:32.967238	2025-06-21 07:06:32.967238	CN	country	t	45	\N	Country
2025-06-21 07:06:32.977097	2025-06-21 07:06:32.977097	CX	country	t	46	\N	Country
2025-06-21 07:06:32.98579	2025-06-21 07:06:32.98579	CC	country	t	47	\N	Country
2025-06-21 07:06:32.995505	2025-06-21 07:06:32.995505	CO	country	t	48	\N	Country
2025-06-21 07:06:33.004305	2025-06-21 07:06:33.004305	KM	country	t	49	\N	Country
2025-06-21 07:06:33.01255	2025-06-21 07:06:33.01255	CG	country	t	50	\N	Country
2025-06-21 07:06:33.02287	2025-06-21 07:06:33.02287	CD	country	t	51	\N	Country
2025-06-21 07:06:33.033509	2025-06-21 07:06:33.033509	CK	country	t	52	\N	Country
2025-06-21 07:06:33.043319	2025-06-21 07:06:33.043319	CR	country	t	53	\N	Country
2025-06-21 07:06:33.053608	2025-06-21 07:06:33.053608	CI	country	t	54	\N	Country
2025-06-21 07:06:33.063878	2025-06-21 07:06:33.063878	HR	country	t	55	\N	Country
2025-06-21 07:06:33.073249	2025-06-21 07:06:33.073249	CU	country	t	56	\N	Country
2025-06-21 07:06:33.081781	2025-06-21 07:06:33.081781	CW	country	t	57	\N	Country
2025-06-21 07:06:33.089717	2025-06-21 07:06:33.089717	CY	country	t	58	\N	Country
2025-06-21 07:06:33.098013	2025-06-21 07:06:33.098013	CZ	country	t	59	\N	Country
2025-06-21 07:06:33.107106	2025-06-21 07:06:33.107106	DK	country	t	60	\N	Country
2025-06-21 07:06:33.116745	2025-06-21 07:06:33.116745	DJ	country	t	61	\N	Country
2025-06-21 07:06:33.124981	2025-06-21 07:06:33.124981	DM	country	t	62	\N	Country
2025-06-21 07:06:33.134032	2025-06-21 07:06:33.134032	DO	country	t	63	\N	Country
2025-06-21 07:06:33.142223	2025-06-21 07:06:33.142223	EC	country	t	64	\N	Country
2025-06-21 07:06:33.150207	2025-06-21 07:06:33.150207	EG	country	t	65	\N	Country
2025-06-21 07:06:33.158466	2025-06-21 07:06:33.158466	SV	country	t	66	\N	Country
2025-06-21 07:06:33.167353	2025-06-21 07:06:33.167353	GQ	country	t	67	\N	Country
2025-06-21 07:06:33.176163	2025-06-21 07:06:33.176163	ER	country	t	68	\N	Country
2025-06-21 07:06:33.184824	2025-06-21 07:06:33.184824	EE	country	t	69	\N	Country
2025-06-21 07:06:33.193152	2025-06-21 07:06:33.193152	SZ	country	t	70	\N	Country
2025-06-21 07:06:33.201933	2025-06-21 07:06:33.201933	ET	country	t	71	\N	Country
2025-06-21 07:06:33.210751	2025-06-21 07:06:33.210751	FK	country	t	72	\N	Country
2025-06-21 07:06:33.218805	2025-06-21 07:06:33.218805	FO	country	t	73	\N	Country
2025-06-21 07:06:33.227162	2025-06-21 07:06:33.227162	FJ	country	t	74	\N	Country
2025-06-21 07:06:33.235608	2025-06-21 07:06:33.235608	FI	country	t	75	\N	Country
2025-06-21 07:06:33.245704	2025-06-21 07:06:33.245704	FR	country	t	76	\N	Country
2025-06-21 07:06:33.253593	2025-06-21 07:06:33.253593	GF	country	t	77	\N	Country
2025-06-21 07:06:33.261655	2025-06-21 07:06:33.261655	PF	country	t	78	\N	Country
2025-06-21 07:06:33.270038	2025-06-21 07:06:33.270038	TF	country	t	79	\N	Country
2025-06-21 07:06:33.277968	2025-06-21 07:06:33.277968	GA	country	t	80	\N	Country
2025-06-21 07:06:33.285741	2025-06-21 07:06:33.285741	GM	country	t	81	\N	Country
2025-06-21 07:06:33.293621	2025-06-21 07:06:33.293621	GE	country	t	82	\N	Country
2025-06-21 07:06:33.30226	2025-06-21 07:06:33.30226	DE	country	t	83	\N	Country
2025-06-21 07:06:33.309986	2025-06-21 07:06:33.309986	GH	country	t	84	\N	Country
2025-06-21 07:06:33.318211	2025-06-21 07:06:33.318211	GI	country	t	85	\N	Country
2025-06-21 07:06:33.326382	2025-06-21 07:06:33.326382	GR	country	t	86	\N	Country
2025-06-21 07:06:33.335081	2025-06-21 07:06:33.335081	GL	country	t	87	\N	Country
2025-06-21 07:06:33.342653	2025-06-21 07:06:33.342653	GD	country	t	88	\N	Country
2025-06-21 07:06:33.350575	2025-06-21 07:06:33.350575	GP	country	t	89	\N	Country
2025-06-21 07:06:33.358377	2025-06-21 07:06:33.358377	GU	country	t	90	\N	Country
2025-06-21 07:06:33.366023	2025-06-21 07:06:33.366023	GT	country	t	91	\N	Country
2025-06-21 07:06:33.373851	2025-06-21 07:06:33.373851	GG	country	t	92	\N	Country
2025-06-21 07:06:33.381335	2025-06-21 07:06:33.381335	GN	country	t	93	\N	Country
2025-06-21 07:06:33.388835	2025-06-21 07:06:33.388835	GW	country	t	94	\N	Country
2025-06-21 07:06:33.397056	2025-06-21 07:06:33.397056	GY	country	t	95	\N	Country
2025-06-21 07:06:33.405734	2025-06-21 07:06:33.405734	HT	country	t	96	\N	Country
2025-06-21 07:06:33.413581	2025-06-21 07:06:33.413581	HM	country	t	97	\N	Country
2025-06-21 07:06:33.420978	2025-06-21 07:06:33.420978	VA	country	t	98	\N	Country
2025-06-21 07:06:33.429345	2025-06-21 07:06:33.429345	HN	country	t	99	\N	Country
2025-06-21 07:06:33.437823	2025-06-21 07:06:33.437823	HK	country	t	100	\N	Country
2025-06-21 07:06:33.445774	2025-06-21 07:06:33.445774	HU	country	t	101	\N	Country
2025-06-21 07:06:33.453634	2025-06-21 07:06:33.453634	IS	country	t	102	\N	Country
2025-06-21 07:06:33.46163	2025-06-21 07:06:33.46163	IN	country	t	103	\N	Country
2025-06-21 07:06:33.469538	2025-06-21 07:06:33.469538	ID	country	t	104	\N	Country
2025-06-21 07:06:33.478281	2025-06-21 07:06:33.478281	IR	country	t	105	\N	Country
2025-06-21 07:06:33.485988	2025-06-21 07:06:33.485988	IQ	country	t	106	\N	Country
2025-06-21 07:06:33.494553	2025-06-21 07:06:33.494553	IE	country	t	107	\N	Country
2025-06-21 07:06:33.502397	2025-06-21 07:06:33.502397	IM	country	t	108	\N	Country
2025-06-21 07:06:33.509903	2025-06-21 07:06:33.509903	IL	country	t	109	\N	Country
2025-06-21 07:06:33.51802	2025-06-21 07:06:33.51802	IT	country	t	110	\N	Country
2025-06-21 07:08:20.092907	2025-06-21 07:08:20.092907	JM	country	t	111	\N	Country
2025-06-21 07:08:20.1007	2025-06-21 07:08:20.1007	JP	country	t	112	\N	Country
2025-06-21 07:08:20.110437	2025-06-21 07:08:20.110437	JE	country	t	113	\N	Country
2025-06-21 07:08:20.120128	2025-06-21 07:08:20.120128	JO	country	t	114	\N	Country
2025-06-21 07:08:20.128695	2025-06-21 07:08:20.128695	KZ	country	t	115	\N	Country
2025-06-21 07:08:20.137086	2025-06-21 07:08:20.137086	KE	country	t	116	\N	Country
2025-06-21 07:08:20.145202	2025-06-21 07:08:20.145202	KI	country	t	117	\N	Country
2025-06-21 07:08:20.153043	2025-06-21 07:08:20.153043	KP	country	t	118	\N	Country
2025-06-21 07:08:20.163045	2025-06-21 07:08:20.163045	KR	country	t	119	\N	Country
2025-06-21 07:08:20.171905	2025-06-21 07:08:20.171905	KW	country	t	120	\N	Country
2025-06-21 07:08:20.179703	2025-06-21 07:08:20.179703	KG	country	t	121	\N	Country
2025-06-21 07:08:20.188331	2025-06-21 07:08:20.188331	LA	country	t	122	\N	Country
2025-06-21 07:08:20.197137	2025-06-21 07:08:20.197137	LV	country	t	123	\N	Country
2025-06-21 07:08:20.205018	2025-06-21 07:08:20.205018	LB	country	t	124	\N	Country
2025-06-21 07:08:20.213467	2025-06-21 07:08:20.213467	LS	country	t	125	\N	Country
2025-06-21 07:06:33.664803	2025-06-21 07:06:33.664803	LR	country	t	126	\N	Country
2025-06-21 07:06:33.675566	2025-06-21 07:06:33.675566	LY	country	t	127	\N	Country
2025-06-21 07:06:33.684981	2025-06-21 07:06:33.684981	LI	country	t	128	\N	Country
2025-06-21 07:06:33.693211	2025-06-21 07:06:33.693211	LT	country	t	129	\N	Country
2025-06-21 07:06:33.701298	2025-06-21 07:06:33.701298	LU	country	t	130	\N	Country
2025-06-21 07:06:33.709771	2025-06-21 07:06:33.709771	MO	country	t	131	\N	Country
2025-06-21 07:06:33.716941	2025-06-21 07:06:33.716941	MK	country	t	132	\N	Country
2025-06-21 07:06:33.724385	2025-06-21 07:06:33.724385	MG	country	t	133	\N	Country
2025-06-21 07:06:33.732231	2025-06-21 07:06:33.732231	MW	country	t	134	\N	Country
2025-06-21 07:06:33.740683	2025-06-21 07:06:33.740683	MY	country	t	135	\N	Country
2025-06-21 07:06:33.748432	2025-06-21 07:06:33.748432	MV	country	t	136	\N	Country
2025-06-21 07:06:33.755561	2025-06-21 07:06:33.755561	ML	country	t	137	\N	Country
2025-06-21 07:06:33.763346	2025-06-21 07:06:33.763346	MT	country	t	138	\N	Country
2025-06-21 07:06:33.772609	2025-06-21 07:06:33.772609	MH	country	t	139	\N	Country
2025-06-21 07:06:33.781027	2025-06-21 07:06:33.781027	MQ	country	t	140	\N	Country
2025-06-21 07:06:33.788794	2025-06-21 07:06:33.788794	MR	country	t	141	\N	Country
2025-06-21 07:06:33.797004	2025-06-21 07:06:33.797004	MU	country	t	142	\N	Country
2025-06-21 07:08:20.363651	2025-06-21 07:08:20.363651	YT	country	t	143	\N	Country
2025-06-21 07:08:20.370915	2025-06-21 07:08:20.370915	MX	country	t	144	\N	Country
2025-06-21 07:08:20.378341	2025-06-21 07:08:20.378341	FM	country	t	145	\N	Country
2025-06-21 07:08:20.386683	2025-06-21 07:08:20.386683	MD	country	t	146	\N	Country
2025-06-21 07:08:20.394254	2025-06-21 07:08:20.394254	MC	country	t	147	\N	Country
2025-06-21 07:08:20.402516	2025-06-21 07:08:20.402516	MN	country	t	148	\N	Country
2025-06-21 07:08:20.409901	2025-06-21 07:08:20.409901	ME	country	t	149	\N	Country
2025-06-21 07:08:20.417432	2025-06-21 07:08:20.417432	MS	country	t	150	\N	Country
2025-06-21 07:08:20.424984	2025-06-21 07:08:20.424984	MA	country	t	151	\N	Country
2025-06-21 07:08:20.43308	2025-06-21 07:08:20.43308	MZ	country	t	152	\N	Country
2025-06-21 07:08:20.440894	2025-06-21 07:08:20.440894	MM	country	t	153	\N	Country
2025-06-21 07:08:20.449392	2025-06-21 07:08:20.449392	NA	country	t	154	\N	Country
2025-06-21 07:08:20.457149	2025-06-21 07:08:20.457149	NR	country	t	155	\N	Country
2025-06-21 07:08:20.46517	2025-06-21 07:08:20.46517	NP	country	t	156	\N	Country
2025-06-21 07:08:20.472236	2025-06-21 07:08:20.472236	NL	country	t	157	\N	Country
2025-06-21 07:08:20.479418	2025-06-21 07:08:20.479418	NC	country	t	158	\N	Country
2025-06-21 07:08:20.486895	2025-06-21 07:08:20.486895	NZ	country	t	159	\N	Country
2025-06-21 07:08:20.49535	2025-06-21 07:08:20.49535	NI	country	t	160	\N	Country
2025-06-21 07:06:33.948353	2025-06-21 07:06:33.948353	NE	country	t	161	\N	Country
2025-06-21 07:06:33.957147	2025-06-21 07:06:33.957147	NG	country	t	162	\N	Country
2025-06-21 07:06:33.965246	2025-06-21 07:06:33.965246	NU	country	t	163	\N	Country
2025-06-21 07:06:33.97378	2025-06-21 07:06:33.97378	NF	country	t	164	\N	Country
2025-06-21 07:06:33.982603	2025-06-21 07:06:33.982603	MP	country	t	165	\N	Country
2025-06-21 07:06:33.990407	2025-06-21 07:06:33.990407	NO	country	t	166	\N	Country
2025-06-21 07:06:33.998137	2025-06-21 07:06:33.998137	OM	country	t	167	\N	Country
2025-06-21 07:06:34.006754	2025-06-21 07:06:34.006754	PK	country	t	168	\N	Country
2025-06-21 07:06:34.014534	2025-06-21 07:06:34.014534	PW	country	t	169	\N	Country
2025-06-21 07:06:34.0217	2025-06-21 07:06:34.0217	PS	country	t	170	\N	Country
2025-06-21 07:06:34.029122	2025-06-21 07:06:34.029122	PA	country	t	171	\N	Country
2025-06-21 07:06:34.03656	2025-06-21 07:06:34.03656	PG	country	t	172	\N	Country
2025-06-21 07:06:34.04434	2025-06-21 07:06:34.04434	PY	country	t	173	\N	Country
2025-06-21 07:06:34.052118	2025-06-21 07:06:34.052118	PE	country	t	174	\N	Country
2025-06-21 07:06:34.059659	2025-06-21 07:06:34.059659	PH	country	t	175	\N	Country
2025-06-21 07:06:34.067236	2025-06-21 07:06:34.067236	PN	country	t	176	\N	Country
2025-06-21 07:06:34.075507	2025-06-21 07:06:34.075507	PL	country	t	177	\N	Country
2025-06-21 07:06:34.083078	2025-06-21 07:06:34.083078	PT	country	t	178	\N	Country
2025-06-21 07:06:34.091444	2025-06-21 07:06:34.091444	PR	country	t	179	\N	Country
2025-06-21 07:06:34.099169	2025-06-21 07:06:34.099169	QA	country	t	180	\N	Country
2025-06-21 07:06:34.107185	2025-06-21 07:06:34.107185	RE	country	t	181	\N	Country
2025-06-21 07:06:34.114993	2025-06-21 07:06:34.114993	RO	country	t	182	\N	Country
2025-06-21 07:06:34.123401	2025-06-21 07:06:34.123401	RU	country	t	183	\N	Country
2025-06-21 07:06:34.131234	2025-06-21 07:06:34.131234	RW	country	t	184	\N	Country
2025-06-21 07:06:34.139652	2025-06-21 07:06:34.139652	BL	country	t	185	\N	Country
2025-06-21 07:06:34.147382	2025-06-21 07:06:34.147382	SH	country	t	186	\N	Country
2025-06-21 07:06:34.155142	2025-06-21 07:06:34.155142	KN	country	t	187	\N	Country
2025-06-21 07:06:34.162541	2025-06-21 07:06:34.162541	LC	country	t	188	\N	Country
2025-06-21 07:06:34.170262	2025-06-21 07:06:34.170262	MF	country	t	189	\N	Country
2025-06-21 07:06:34.178785	2025-06-21 07:06:34.178785	PM	country	t	190	\N	Country
2025-06-21 07:06:34.186533	2025-06-21 07:06:34.186533	VC	country	t	191	\N	Country
2025-06-21 07:06:34.194631	2025-06-21 07:06:34.194631	WS	country	t	192	\N	Country
2025-06-21 07:06:34.202543	2025-06-21 07:06:34.202543	SM	country	t	193	\N	Country
2025-06-21 07:06:34.212112	2025-06-21 07:06:34.212112	ST	country	t	194	\N	Country
2025-06-21 07:06:34.223489	2025-06-21 07:06:34.223489	SA	country	t	195	\N	Country
2025-06-21 07:06:34.232764	2025-06-21 07:06:34.232764	SN	country	t	196	\N	Country
2025-06-21 07:06:34.242003	2025-06-21 07:06:34.242003	RS	country	t	197	\N	Country
2025-06-21 07:06:34.251997	2025-06-21 07:06:34.251997	SC	country	t	198	\N	Country
2025-06-21 07:06:34.260723	2025-06-21 07:06:34.260723	SL	country	t	199	\N	Country
2025-06-21 07:06:34.268489	2025-06-21 07:06:34.268489	SG	country	t	200	\N	Country
2025-06-21 07:06:34.276608	2025-06-21 07:06:34.276608	SX	country	t	201	\N	Country
2025-06-21 07:06:34.284016	2025-06-21 07:06:34.284016	SK	country	t	202	\N	Country
2025-06-21 07:06:34.291994	2025-06-21 07:06:34.291994	SI	country	t	203	\N	Country
2025-06-21 07:06:34.299873	2025-06-21 07:06:34.299873	SB	country	t	204	\N	Country
2025-06-21 07:06:34.308061	2025-06-21 07:06:34.308061	SO	country	t	205	\N	Country
2025-06-21 07:06:34.315613	2025-06-21 07:06:34.315613	ZA	country	t	206	\N	Country
2025-06-21 07:06:34.323082	2025-06-21 07:06:34.323082	GS	country	t	207	\N	Country
2025-06-21 07:06:34.330657	2025-06-21 07:06:34.330657	SS	country	t	208	\N	Country
2025-06-21 07:06:34.338356	2025-06-21 07:06:34.338356	ES	country	t	209	\N	Country
2025-06-21 07:06:34.346299	2025-06-21 07:06:34.346299	LK	country	t	210	\N	Country
2025-06-21 07:06:34.354873	2025-06-21 07:06:34.354873	SD	country	t	211	\N	Country
2025-06-21 07:06:34.362023	2025-06-21 07:06:34.362023	SR	country	t	212	\N	Country
2025-06-21 07:06:34.369632	2025-06-21 07:06:34.369632	SJ	country	t	213	\N	Country
2025-06-21 07:06:34.377856	2025-06-21 07:06:34.377856	SE	country	t	214	\N	Country
2025-06-21 07:06:34.385159	2025-06-21 07:06:34.385159	CH	country	t	215	\N	Country
2025-06-21 07:06:34.392571	2025-06-21 07:06:34.392571	SY	country	t	216	\N	Country
2025-06-21 07:06:34.400213	2025-06-21 07:06:34.400213	TW	country	t	217	\N	Country
2025-06-21 07:06:34.408228	2025-06-21 07:06:34.408228	TJ	country	t	218	\N	Country
2025-06-21 07:06:34.416279	2025-06-21 07:06:34.416279	TZ	country	t	219	\N	Country
2025-06-21 07:06:34.424009	2025-06-21 07:06:34.424009	TH	country	t	220	\N	Country
2025-06-21 07:06:34.432251	2025-06-21 07:06:34.432251	TL	country	t	221	\N	Country
2025-06-21 07:06:34.441291	2025-06-21 07:06:34.441291	TG	country	t	222	\N	Country
2025-06-21 07:06:34.449042	2025-06-21 07:06:34.449042	TK	country	t	223	\N	Country
2025-06-21 07:06:34.45669	2025-06-21 07:06:34.45669	TO	country	t	224	\N	Country
2025-06-21 07:06:34.46505	2025-06-21 07:06:34.46505	TT	country	t	225	\N	Country
2025-06-21 07:06:34.473571	2025-06-21 07:06:34.473571	TN	country	t	226	\N	Country
2025-06-21 07:06:34.481634	2025-06-21 07:06:34.481634	TR	country	t	227	\N	Country
2025-06-21 07:06:34.489735	2025-06-21 07:06:34.489735	TM	country	t	228	\N	Country
2025-06-21 07:06:34.498562	2025-06-21 07:06:34.498562	TC	country	t	229	\N	Country
2025-06-21 07:06:34.507071	2025-06-21 07:06:34.507071	TV	country	t	230	\N	Country
2025-06-21 07:06:34.515623	2025-06-21 07:06:34.515623	UG	country	t	231	\N	Country
2025-06-21 07:06:34.523123	2025-06-21 07:06:34.523123	UA	country	t	232	\N	Country
2025-06-21 07:06:34.53049	2025-06-21 07:06:34.53049	AE	country	t	233	\N	Country
2025-06-21 07:06:34.538697	2025-06-21 07:06:34.538697	GB	country	t	234	\N	Country
2025-06-21 07:06:34.546473	2025-06-21 07:06:34.546473	US	country	t	235	\N	Country
2025-06-21 07:06:34.553524	2025-06-21 07:06:34.553524	UM	country	t	236	\N	Country
2025-06-21 07:06:34.561094	2025-06-21 07:06:34.561094	UY	country	t	237	\N	Country
2025-06-21 07:06:34.569611	2025-06-21 07:06:34.569611	UZ	country	t	238	\N	Country
2025-06-21 07:06:34.578263	2025-06-21 07:06:34.578263	VU	country	t	239	\N	Country
2025-06-21 07:06:34.58615	2025-06-21 07:06:34.58615	VE	country	t	240	\N	Country
2025-06-21 07:06:34.593851	2025-06-21 07:06:34.593851	VN	country	t	241	\N	Country
2025-06-21 07:06:34.601307	2025-06-21 07:06:34.601307	VG	country	t	242	\N	Country
2025-06-21 07:06:34.609349	2025-06-21 07:06:34.609349	VI	country	t	243	\N	Country
2025-06-21 07:06:34.617064	2025-06-21 07:06:34.617064	WF	country	t	244	\N	Country
2025-06-21 07:06:34.62548	2025-06-21 07:06:34.62548	EH	country	t	245	\N	Country
2025-06-21 07:06:34.632883	2025-06-21 07:06:34.632883	YE	country	t	246	\N	Country
2025-06-21 07:06:34.640251	2025-06-21 07:06:34.640251	ZM	country	t	247	\N	Country
2025-06-21 07:06:34.648151	2025-06-21 07:06:34.648151	ZW	country	t	248	\N	Country
\.


--
-- Data for Name: region_translation; Type: TABLE DATA; Schema: public; Owner: vendure
--

COPY public.region_translation ("createdAt", "updatedAt", "languageCode", name, id, "baseId") FROM stdin;
2025-06-21 07:06:32.533637	2025-06-21 07:06:32.538123	en	Afghanistan	1	1
2025-06-21 07:06:32.558799	2025-06-21 07:06:32.562427	en	Åland Islands	2	2
2025-06-21 07:06:32.577117	2025-06-21 07:06:32.579799	en	Albania	3	3
2025-06-21 07:06:32.585782	2025-06-21 07:06:32.58833	en	Algeria	4	4
2025-06-21 07:06:32.602794	2025-06-21 07:06:32.605621	en	American Samoa	5	5
2025-06-21 07:06:32.61902	2025-06-21 07:06:32.621599	en	Andorra	6	6
2025-06-21 07:06:32.627646	2025-06-21 07:06:32.630699	en	Angola	7	7
2025-06-21 07:06:32.636786	2025-06-21 07:06:32.639478	en	Anguilla	8	8
2025-06-21 07:06:32.652298	2025-06-21 07:06:32.655937	en	Antigua and Barbuda	9	9
2025-06-21 07:06:32.661954	2025-06-21 07:06:32.66472	en	Argentina	10	10
2025-06-21 07:06:32.670624	2025-06-21 07:06:32.673383	en	Armenia	11	11
2025-06-21 07:06:32.679399	2025-06-21 07:06:32.682293	en	Aruba	12	12
2025-06-21 07:06:32.688329	2025-06-21 07:06:32.691443	en	Australia	13	13
2025-06-21 07:06:32.698095	2025-06-21 07:06:32.70078	en	Austria	14	14
2025-06-21 07:06:32.706562	2025-06-21 07:06:32.709245	en	Azerbaijan	15	15
2025-06-21 07:06:32.714762	2025-06-21 07:06:32.717349	en	Bahamas	16	16
2025-06-21 07:06:32.722492	2025-06-21 07:06:32.725421	en	Bahrain	17	17
2025-06-21 07:06:32.732273	2025-06-21 07:06:32.735155	en	Bangladesh	18	18
2025-06-21 07:06:32.741049	2025-06-21 07:06:32.743578	en	Barbados	19	19
2025-06-21 07:06:32.749298	2025-06-21 07:06:32.751872	en	Belarus	20	20
2025-06-21 07:06:32.758405	2025-06-21 07:06:32.761504	en	Belgium	21	21
2025-06-21 07:06:32.768437	2025-06-21 07:06:32.771241	en	Belize	22	22
2025-06-21 07:06:32.776826	2025-06-21 07:06:32.779864	en	Benin	23	23
2025-06-21 07:06:32.785513	2025-06-21 07:06:32.788085	en	Bermuda	24	24
2025-06-21 07:06:32.793531	2025-06-21 07:06:32.796258	en	Bhutan	25	25
2025-06-21 07:06:32.801909	2025-06-21 07:06:32.80448	en	Bolivia (Plurinational State of)	26	26
2025-06-21 07:06:32.809975	2025-06-21 07:06:32.812594	en	Bonaire, Sint Eustatius and Saba	27	27
2025-06-21 07:06:32.818554	2025-06-21 07:06:32.821979	en	Bosnia and Herzegovina	28	28
2025-06-21 07:06:32.827813	2025-06-21 07:06:32.830766	en	Botswana	29	29
2025-06-21 07:06:32.836809	2025-06-21 07:06:32.839204	en	Bouvet Island	30	30
2025-06-21 07:06:32.844704	2025-06-21 07:06:32.847308	en	Brazil	31	31
2025-06-21 07:06:32.852611	2025-06-21 07:06:32.855158	en	British Indian Ocean Territory	32	32
2025-06-21 07:06:32.861134	2025-06-21 07:06:32.864109	en	Brunei Darussalam	33	33
2025-06-21 07:06:32.870343	2025-06-21 07:06:32.872899	en	Bulgaria	34	34
2025-06-21 07:06:32.878615	2025-06-21 07:06:32.881026	en	Burkina Faso	35	35
2025-06-21 07:06:32.886711	2025-06-21 07:06:32.889411	en	Burundi	36	36
2025-06-21 07:06:32.895657	2025-06-21 07:06:32.898628	en	Cabo Verde	37	37
2025-06-21 07:06:32.904193	2025-06-21 07:06:32.90709	en	Cambodia	38	38
2025-06-21 07:06:32.912704	2025-06-21 07:06:32.915291	en	Cameroon	39	39
2025-06-21 07:06:32.920527	2025-06-21 07:06:32.922929	en	Canada	40	40
2025-06-21 07:06:32.929124	2025-06-21 07:06:32.932754	en	Cayman Islands	41	41
2025-06-21 07:06:32.938757	2025-06-21 07:06:32.941562	en	Central African Republic	42	42
2025-06-21 07:06:32.946965	2025-06-21 07:06:32.949333	en	Chad	43	43
2025-06-21 07:06:32.954865	2025-06-21 07:06:32.957552	en	Chile	44	44
2025-06-21 07:06:32.964164	2025-06-21 07:06:32.967238	en	China	45	45
2025-06-21 07:06:32.974036	2025-06-21 07:06:32.977097	en	Christmas Island	46	46
2025-06-21 07:06:32.98316	2025-06-21 07:06:32.98579	en	Cocos (Keeling) Islands	47	47
2025-06-21 07:06:32.992179	2025-06-21 07:06:32.995505	en	Colombia	48	48
2025-06-21 07:06:33.001652	2025-06-21 07:06:33.004305	en	Comoros	49	49
2025-06-21 07:06:33.00984	2025-06-21 07:06:33.01255	en	Congo	50	50
2025-06-21 07:06:33.018898	2025-06-21 07:06:33.02287	en	Congo (Democratic Republic of the)	51	51
2025-06-21 07:06:33.029754	2025-06-21 07:06:33.033509	en	Cook Islands	52	52
2025-06-21 07:06:33.04041	2025-06-21 07:06:33.043319	en	Costa Rica	53	53
2025-06-21 07:06:33.049607	2025-06-21 07:06:33.053608	en	Côte d'Ivoire	54	54
2025-06-21 07:06:33.060736	2025-06-21 07:06:33.063878	en	Croatia	55	55
2025-06-21 07:06:33.070174	2025-06-21 07:06:33.073249	en	Cuba	56	56
2025-06-21 07:06:33.079172	2025-06-21 07:06:33.081781	en	Curaçao	57	57
2025-06-21 07:06:33.087334	2025-06-21 07:06:33.089717	en	Cyprus	58	58
2025-06-21 07:06:33.095561	2025-06-21 07:06:33.098013	en	Czechia	59	59
2025-06-21 07:06:33.104111	2025-06-21 07:06:33.107106	en	Denmark	60	60
2025-06-21 07:06:33.113952	2025-06-21 07:06:33.116745	en	Djibouti	61	61
2025-06-21 07:06:33.122433	2025-06-21 07:06:33.124981	en	Dominica	62	62
2025-06-21 07:06:33.131128	2025-06-21 07:06:33.134032	en	Dominican Republic	63	63
2025-06-21 07:06:33.139577	2025-06-21 07:06:33.142223	en	Ecuador	64	64
2025-06-21 07:06:33.147643	2025-06-21 07:06:33.150207	en	Egypt	65	65
2025-06-21 07:06:33.155576	2025-06-21 07:06:33.158466	en	El Salvador	66	66
2025-06-21 07:06:33.164736	2025-06-21 07:06:33.167353	en	Equatorial Guinea	67	67
2025-06-21 07:06:33.173061	2025-06-21 07:06:33.176163	en	Eritrea	68	68
2025-06-21 07:06:33.182003	2025-06-21 07:06:33.184824	en	Estonia	69	69
2025-06-21 07:06:33.190463	2025-06-21 07:06:33.193152	en	Eswatini	70	70
2025-06-21 07:06:33.199281	2025-06-21 07:06:33.201933	en	Ethiopia	71	71
2025-06-21 07:06:33.207999	2025-06-21 07:06:33.210751	en	Falkland Islands (Malvinas)	72	72
2025-06-21 07:06:33.216301	2025-06-21 07:06:33.218805	en	Faroe Islands	73	73
2025-06-21 07:06:33.22425	2025-06-21 07:06:33.227162	en	Fiji	74	74
2025-06-21 07:06:33.2329	2025-06-21 07:06:33.235608	en	Finland	75	75
2025-06-21 07:06:33.243005	2025-06-21 07:06:33.245704	en	France	76	76
2025-06-21 07:06:33.251074	2025-06-21 07:06:33.253593	en	French Guiana	77	77
2025-06-21 07:06:33.259027	2025-06-21 07:06:33.261655	en	French Polynesia	78	78
2025-06-21 07:06:33.267518	2025-06-21 07:06:33.270038	en	French Southern Territories	79	79
2025-06-21 07:06:33.275494	2025-06-21 07:06:33.277968	en	Gabon	80	80
2025-06-21 07:06:33.283105	2025-06-21 07:06:33.285741	en	Gambia	81	81
2025-06-21 07:06:33.29096	2025-06-21 07:06:33.293621	en	Georgia	82	82
2025-06-21 07:06:33.299117	2025-06-21 07:06:33.30226	en	Germany	83	83
2025-06-21 07:06:33.307417	2025-06-21 07:06:33.309986	en	Ghana	84	84
2025-06-21 07:06:33.31565	2025-06-21 07:06:33.318211	en	Gibraltar	85	85
2025-06-21 07:06:33.323565	2025-06-21 07:06:33.326382	en	Greece	86	86
2025-06-21 07:06:33.332195	2025-06-21 07:06:33.335081	en	Greenland	87	87
2025-06-21 07:06:33.340057	2025-06-21 07:06:33.342653	en	Grenada	88	88
2025-06-21 07:06:33.348019	2025-06-21 07:06:33.350575	en	Guadeloupe	89	89
2025-06-21 07:06:33.355925	2025-06-21 07:06:33.358377	en	Guam	90	90
2025-06-21 07:06:33.363689	2025-06-21 07:06:33.366023	en	Guatemala	91	91
2025-06-21 07:06:33.371508	2025-06-21 07:06:33.373851	en	Guernsey	92	92
2025-06-21 07:06:33.37917	2025-06-21 07:06:33.381335	en	Guinea	93	93
2025-06-21 07:06:33.386786	2025-06-21 07:06:33.388835	en	Guinea-Bissau	94	94
2025-06-21 07:06:33.394415	2025-06-21 07:06:33.397056	en	Guyana	95	95
2025-06-21 07:06:33.40278	2025-06-21 07:06:33.405734	en	Haiti	96	96
2025-06-21 07:06:33.411264	2025-06-21 07:06:33.413581	en	Heard Island and McDonald Islands	97	97
2025-06-21 07:06:33.418554	2025-06-21 07:06:33.420978	en	Holy See	98	98
2025-06-21 07:06:33.426742	2025-06-21 07:06:33.429345	en	Honduras	99	99
2025-06-21 07:06:33.435416	2025-06-21 07:06:33.437823	en	Hong Kong	100	100
2025-06-21 07:06:33.443528	2025-06-21 07:06:33.445774	en	Hungary	101	101
2025-06-21 07:06:33.451167	2025-06-21 07:06:33.453634	en	Iceland	102	102
2025-06-21 07:06:33.458888	2025-06-21 07:06:33.46163	en	India	103	103
2025-06-21 07:06:33.466945	2025-06-21 07:06:33.469538	en	Indonesia	104	104
2025-06-21 07:06:33.475645	2025-06-21 07:06:33.478281	en	Iran (Islamic Republic of)	105	105
2025-06-21 07:06:33.483839	2025-06-21 07:06:33.485988	en	Iraq	106	106
2025-06-21 07:06:33.491873	2025-06-21 07:06:33.494553	en	Ireland	107	107
2025-06-21 07:06:33.499975	2025-06-21 07:06:33.502397	en	Isle of Man	108	108
2025-06-21 07:06:33.507516	2025-06-21 07:06:33.509903	en	Israel	109	109
2025-06-21 07:06:33.51517	2025-06-21 07:06:33.51802	en	Italy	110	110
2025-06-21 07:08:20.090535	2025-06-21 07:08:20.092907	en	Jamaica	111	111
2025-06-21 07:08:20.098214	2025-06-21 07:08:20.1007	en	Japan	112	112
2025-06-21 07:08:20.107221	2025-06-21 07:08:20.110437	en	Jersey	113	113
2025-06-21 07:08:20.116118	2025-06-21 07:08:20.120128	en	Jordan	114	114
2025-06-21 07:08:20.126121	2025-06-21 07:08:20.128695	en	Kazakhstan	115	115
2025-06-21 07:08:20.134695	2025-06-21 07:08:20.137086	en	Kenya	116	116
2025-06-21 07:08:20.142493	2025-06-21 07:08:20.145202	en	Kiribati	117	117
2025-06-21 07:08:20.150564	2025-06-21 07:08:20.153043	en	Korea (Democratic People's Republic of)	118	118
2025-06-21 07:08:20.159543	2025-06-21 07:08:20.163045	en	Korea (Republic of)	119	119
2025-06-21 07:08:20.169317	2025-06-21 07:08:20.171905	en	Kuwait	120	120
2025-06-21 07:08:20.177425	2025-06-21 07:08:20.179703	en	Kyrgyzstan	121	121
2025-06-21 07:08:20.185786	2025-06-21 07:08:20.188331	en	Lao People's Democratic Republic	122	122
2025-06-21 07:08:20.194657	2025-06-21 07:08:20.197137	en	Latvia	123	123
2025-06-21 07:08:20.202496	2025-06-21 07:08:20.205018	en	Lebanon	124	124
2025-06-21 07:08:20.210819	2025-06-21 07:08:20.213467	en	Lesotho	125	125
2025-06-21 07:06:33.661433	2025-06-21 07:06:33.664803	en	Liberia	126	126
2025-06-21 07:06:33.672632	2025-06-21 07:06:33.675566	en	Libya	127	127
2025-06-21 07:06:33.682412	2025-06-21 07:06:33.684981	en	Liechtenstein	128	128
2025-06-21 07:06:33.690399	2025-06-21 07:06:33.693211	en	Lithuania	129	129
2025-06-21 07:06:33.698685	2025-06-21 07:06:33.701298	en	Luxembourg	130	130
2025-06-21 07:06:33.707289	2025-06-21 07:06:33.709771	en	Macao	131	131
2025-06-21 07:06:33.714686	2025-06-21 07:06:33.716941	en	Macedonia (the former Yugoslav Republic of)	132	132
2025-06-21 07:06:33.721979	2025-06-21 07:06:33.724385	en	Madagascar	133	133
2025-06-21 07:06:33.729724	2025-06-21 07:06:33.732231	en	Malawi	134	134
2025-06-21 07:06:33.737931	2025-06-21 07:06:33.740683	en	Malaysia	135	135
2025-06-21 07:06:33.746286	2025-06-21 07:06:33.748432	en	Maldives	136	136
2025-06-21 07:06:33.753158	2025-06-21 07:06:33.755561	en	Mali	137	137
2025-06-21 07:06:33.760803	2025-06-21 07:06:33.763346	en	Malta	138	138
2025-06-21 07:06:33.769909	2025-06-21 07:06:33.772609	en	Marshall Islands	139	139
2025-06-21 07:06:33.778502	2025-06-21 07:06:33.781027	en	Martinique	140	140
2025-06-21 07:06:33.786283	2025-06-21 07:06:33.788794	en	Mauritania	141	141
2025-06-21 07:06:33.794215	2025-06-21 07:06:33.797004	en	Mauritius	142	142
2025-06-21 07:08:20.36115	2025-06-21 07:08:20.363651	en	Mayotte	143	143
2025-06-21 07:08:20.368692	2025-06-21 07:08:20.370915	en	Mexico	144	144
2025-06-21 07:08:20.376121	2025-06-21 07:08:20.378341	en	Micronesia (Federated States of)	145	145
2025-06-21 07:08:20.383394	2025-06-21 07:08:20.386683	en	Moldova (Republic of)	146	146
2025-06-21 07:08:20.391829	2025-06-21 07:08:20.394254	en	Monaco	147	147
2025-06-21 07:08:20.400119	2025-06-21 07:08:20.402516	en	Mongolia	148	148
2025-06-21 07:08:20.407568	2025-06-21 07:08:20.409901	en	Montenegro	149	149
2025-06-21 07:08:20.414939	2025-06-21 07:08:20.417432	en	Montserrat	150	150
2025-06-21 07:08:20.422228	2025-06-21 07:08:20.424984	en	Morocco	151	151
2025-06-21 07:08:20.430528	2025-06-21 07:08:20.43308	en	Mozambique	152	152
2025-06-21 07:08:20.438624	2025-06-21 07:08:20.440894	en	Myanmar	153	153
2025-06-21 07:08:20.446739	2025-06-21 07:08:20.449392	en	Namibia	154	154
2025-06-21 07:08:20.454507	2025-06-21 07:08:20.457149	en	Nauru	155	155
2025-06-21 07:08:20.462569	2025-06-21 07:08:20.46517	en	Nepal	156	156
2025-06-21 07:08:20.470024	2025-06-21 07:08:20.472236	en	Netherlands	157	157
2025-06-21 07:08:20.477106	2025-06-21 07:08:20.479418	en	New Caledonia	158	158
2025-06-21 07:08:20.484377	2025-06-21 07:08:20.486895	en	New Zealand	159	159
2025-06-21 07:08:20.493057	2025-06-21 07:08:20.49535	en	Nicaragua	160	160
2025-06-21 07:06:33.945947	2025-06-21 07:06:33.948353	en	Niger	161	161
2025-06-21 07:06:33.954523	2025-06-21 07:06:33.957147	en	Nigeria	162	162
2025-06-21 07:06:33.962617	2025-06-21 07:06:33.965246	en	Niue	163	163
2025-06-21 07:06:33.970514	2025-06-21 07:06:33.97378	en	Norfolk Island	164	164
2025-06-21 07:06:33.979956	2025-06-21 07:06:33.982603	en	Northern Mariana Islands	165	165
2025-06-21 07:06:33.988009	2025-06-21 07:06:33.990407	en	Norway	166	166
2025-06-21 07:06:33.995708	2025-06-21 07:06:33.998137	en	Oman	167	167
2025-06-21 07:06:34.003521	2025-06-21 07:06:34.006754	en	Pakistan	168	168
2025-06-21 07:06:34.012135	2025-06-21 07:06:34.014534	en	Palau	169	169
2025-06-21 07:06:34.019347	2025-06-21 07:06:34.0217	en	Palestine, State of	170	170
2025-06-21 07:06:34.026738	2025-06-21 07:06:34.029122	en	Panama	171	171
2025-06-21 07:06:34.034028	2025-06-21 07:06:34.03656	en	Papua New Guinea	172	172
2025-06-21 07:06:34.041914	2025-06-21 07:06:34.04434	en	Paraguay	173	173
2025-06-21 07:06:34.049727	2025-06-21 07:06:34.052118	en	Peru	174	174
2025-06-21 07:06:34.057513	2025-06-21 07:06:34.059659	en	Philippines	175	175
2025-06-21 07:06:34.064723	2025-06-21 07:06:34.067236	en	Pitcairn	176	176
2025-06-21 07:06:34.072841	2025-06-21 07:06:34.075507	en	Poland	177	177
2025-06-21 07:06:34.080694	2025-06-21 07:06:34.083078	en	Portugal	178	178
2025-06-21 07:06:34.089037	2025-06-21 07:06:34.091444	en	Puerto Rico	179	179
2025-06-21 07:06:34.09654	2025-06-21 07:06:34.099169	en	Qatar	180	180
2025-06-21 07:06:34.104549	2025-06-21 07:06:34.107185	en	Réunion	181	181
2025-06-21 07:06:34.112495	2025-06-21 07:06:34.114993	en	Romania	182	182
2025-06-21 07:06:34.120846	2025-06-21 07:06:34.123401	en	Russian Federation	183	183
2025-06-21 07:06:34.128668	2025-06-21 07:06:34.131234	en	Rwanda	184	184
2025-06-21 07:06:34.136687	2025-06-21 07:06:34.139652	en	Saint Barthélemy	185	185
2025-06-21 07:06:34.144967	2025-06-21 07:06:34.147382	en	Saint Helena, Ascension and Tristan da Cunha	186	186
2025-06-21 07:06:34.152851	2025-06-21 07:06:34.155142	en	Saint Kitts and Nevis	187	187
2025-06-21 07:06:34.160089	2025-06-21 07:06:34.162541	en	Saint Lucia	188	188
2025-06-21 07:06:34.16785	2025-06-21 07:06:34.170262	en	Saint Martin (French part)	189	189
2025-06-21 07:06:34.176206	2025-06-21 07:06:34.178785	en	Saint Pierre and Miquelon	190	190
2025-06-21 07:06:34.183981	2025-06-21 07:06:34.186533	en	Saint Vincent and the Grenadines	191	191
2025-06-21 07:06:34.191957	2025-06-21 07:06:34.194631	en	Samoa	192	192
2025-06-21 07:06:34.199981	2025-06-21 07:06:34.202543	en	San Marino	193	193
2025-06-21 07:06:34.209232	2025-06-21 07:06:34.212112	en	Sao Tome and Principe	194	194
2025-06-21 07:06:34.220225	2025-06-21 07:06:34.223489	en	Saudi Arabia	195	195
2025-06-21 07:06:34.230217	2025-06-21 07:06:34.232764	en	Senegal	196	196
2025-06-21 07:06:34.239048	2025-06-21 07:06:34.242003	en	Serbia	197	197
2025-06-21 07:06:34.248743	2025-06-21 07:06:34.251997	en	Seychelles	198	198
2025-06-21 07:06:34.2582	2025-06-21 07:06:34.260723	en	Sierra Leone	199	199
2025-06-21 07:06:34.266097	2025-06-21 07:06:34.268489	en	Singapore	200	200
2025-06-21 07:06:34.273947	2025-06-21 07:06:34.276608	en	Sint Maarten (Dutch part)	201	201
2025-06-21 07:06:34.281691	2025-06-21 07:06:34.284016	en	Slovakia	202	202
2025-06-21 07:06:34.289345	2025-06-21 07:06:34.291994	en	Slovenia	203	203
2025-06-21 07:06:34.297043	2025-06-21 07:06:34.299873	en	Solomon Islands	204	204
2025-06-21 07:06:34.305468	2025-06-21 07:06:34.308061	en	Somalia	205	205
2025-06-21 07:06:34.313277	2025-06-21 07:06:34.315613	en	South Africa	206	206
2025-06-21 07:06:34.320636	2025-06-21 07:06:34.323082	en	South Georgia and the South Sandwich Islands	207	207
2025-06-21 07:06:34.328508	2025-06-21 07:06:34.330657	en	South Sudan	208	208
2025-06-21 07:06:34.335771	2025-06-21 07:06:34.338356	en	Spain	209	209
2025-06-21 07:06:34.343754	2025-06-21 07:06:34.346299	en	Sri Lanka	210	210
2025-06-21 07:06:34.35223	2025-06-21 07:06:34.354873	en	Sudan	211	211
2025-06-21 07:06:34.359578	2025-06-21 07:06:34.362023	en	Suriname	212	212
2025-06-21 07:06:34.367131	2025-06-21 07:06:34.369632	en	Svalbard and Jan Mayen	213	213
2025-06-21 07:06:34.375481	2025-06-21 07:06:34.377856	en	Sweden	214	214
2025-06-21 07:06:34.382738	2025-06-21 07:06:34.385159	en	Switzerland	215	215
2025-06-21 07:06:34.390191	2025-06-21 07:06:34.392571	en	Syrian Arab Republic	216	216
2025-06-21 07:06:34.397807	2025-06-21 07:06:34.400213	en	Taiwan, Province of China	217	217
2025-06-21 07:06:34.405598	2025-06-21 07:06:34.408228	en	Tajikistan	218	218
2025-06-21 07:06:34.41366	2025-06-21 07:06:34.416279	en	Tanzania, United Republic of	219	219
2025-06-21 07:06:34.421173	2025-06-21 07:06:34.424009	en	Thailand	220	220
2025-06-21 07:06:34.429205	2025-06-21 07:06:34.432251	en	Timor-Leste	221	221
2025-06-21 07:06:34.438818	2025-06-21 07:06:34.441291	en	Togo	222	222
2025-06-21 07:06:34.446614	2025-06-21 07:06:34.449042	en	Tokelau	223	223
2025-06-21 07:06:34.454112	2025-06-21 07:06:34.45669	en	Tonga	224	224
2025-06-21 07:06:34.462162	2025-06-21 07:06:34.46505	en	Trinidad and Tobago	225	225
2025-06-21 07:06:34.470917	2025-06-21 07:06:34.473571	en	Tunisia	226	226
2025-06-21 07:06:34.478962	2025-06-21 07:06:34.481634	en	Turkey	227	227
2025-06-21 07:06:34.487039	2025-06-21 07:06:34.489735	en	Turkmenistan	228	228
2025-06-21 07:06:34.495875	2025-06-21 07:06:34.498562	en	Turks and Caicos Islands	229	229
2025-06-21 07:06:34.504121	2025-06-21 07:06:34.507071	en	Tuvalu	230	230
2025-06-21 07:06:34.512584	2025-06-21 07:06:34.515623	en	Uganda	231	231
2025-06-21 07:06:34.520682	2025-06-21 07:06:34.523123	en	Ukraine	232	232
2025-06-21 07:06:34.527936	2025-06-21 07:06:34.53049	en	United Arab Emirates	233	233
2025-06-21 07:06:34.53614	2025-06-21 07:06:34.538697	en	United Kingdom	234	234
2025-06-21 07:06:34.544185	2025-06-21 07:06:34.546473	en	United States of America	235	235
2025-06-21 07:06:34.551478	2025-06-21 07:06:34.553524	en	United States Minor Outlying Islands	236	236
2025-06-21 07:06:34.558769	2025-06-21 07:06:34.561094	en	Uruguay	237	237
2025-06-21 07:06:34.566473	2025-06-21 07:06:34.569611	en	Uzbekistan	238	238
2025-06-21 07:06:34.575605	2025-06-21 07:06:34.578263	en	Vanuatu	239	239
2025-06-21 07:06:34.58349	2025-06-21 07:06:34.58615	en	Venezuela (Bolivarian Republic of)	240	240
2025-06-21 07:06:34.591422	2025-06-21 07:06:34.593851	en	Viet Nam	241	241
2025-06-21 07:06:34.598985	2025-06-21 07:06:34.601307	en	Virgin Islands (British)	242	242
2025-06-21 07:06:34.606551	2025-06-21 07:06:34.609349	en	Virgin Islands (U.S.)	243	243
2025-06-21 07:06:34.614798	2025-06-21 07:06:34.617064	en	Wallis and Futuna	244	244
2025-06-21 07:06:34.622833	2025-06-21 07:06:34.62548	en	Western Sahara	245	245
2025-06-21 07:06:34.630668	2025-06-21 07:06:34.632883	en	Yemen	246	246
2025-06-21 07:06:34.637811	2025-06-21 07:06:34.640251	en	Zambia	247	247
2025-06-21 07:06:34.645643	2025-06-21 07:06:34.648151	en	Zimbabwe	248	248
\.


--
-- Data for Name: role; Type: TABLE DATA; Schema: public; Owner: vendure
--

COPY public.role ("createdAt", "updatedAt", code, description, permissions, id) FROM stdin;
2025-06-21 07:06:31.843067	2025-06-21 07:06:31.843067	__super_admin_role__	SuperAdmin	Authenticated,SuperAdmin,UpdateGlobalSettings,CreateCatalog,ReadCatalog,UpdateCatalog,DeleteCatalog,CreateSettings,ReadSettings,UpdateSettings,DeleteSettings,CreateAdministrator,ReadAdministrator,UpdateAdministrator,DeleteAdministrator,CreateAsset,ReadAsset,UpdateAsset,DeleteAsset,CreateChannel,ReadChannel,UpdateChannel,DeleteChannel,CreateCollection,ReadCollection,UpdateCollection,DeleteCollection,CreateCountry,ReadCountry,UpdateCountry,DeleteCountry,CreateCustomer,ReadCustomer,UpdateCustomer,DeleteCustomer,CreateCustomerGroup,ReadCustomerGroup,UpdateCustomerGroup,DeleteCustomerGroup,CreateFacet,ReadFacet,UpdateFacet,DeleteFacet,CreateOrder,ReadOrder,UpdateOrder,DeleteOrder,CreatePaymentMethod,ReadPaymentMethod,UpdatePaymentMethod,DeletePaymentMethod,CreateProduct,ReadProduct,UpdateProduct,DeleteProduct,CreatePromotion,ReadPromotion,UpdatePromotion,DeletePromotion,CreateShippingMethod,ReadShippingMethod,UpdateShippingMethod,DeleteShippingMethod,CreateTag,ReadTag,UpdateTag,DeleteTag,CreateTaxCategory,ReadTaxCategory,UpdateTaxCategory,DeleteTaxCategory,CreateTaxRate,ReadTaxRate,UpdateTaxRate,DeleteTaxRate,CreateSeller,ReadSeller,UpdateSeller,DeleteSeller,CreateStockLocation,ReadStockLocation,UpdateStockLocation,DeleteStockLocation,CreateSystem,ReadSystem,UpdateSystem,DeleteSystem,CreateZone,ReadZone,UpdateZone,DeleteZone	1
2025-06-21 07:06:31.850292	2025-06-21 07:06:31.850292	__customer_role__	Customer	Authenticated	2
2025-06-21 07:06:34.99477	2025-06-21 07:06:34.99477	administrator	Administrator	Authenticated,CreateCatalog,ReadCatalog,UpdateCatalog,DeleteCatalog,CreateSettings,ReadSettings,UpdateSettings,DeleteSettings,CreateCustomer,ReadCustomer,UpdateCustomer,DeleteCustomer,CreateCustomerGroup,ReadCustomerGroup,UpdateCustomerGroup,DeleteCustomerGroup,CreateOrder,ReadOrder,UpdateOrder,DeleteOrder,CreateSystem,ReadSystem,UpdateSystem,DeleteSystem	3
2025-06-21 07:06:34.998618	2025-06-21 07:06:34.998618	order-manager	Order manager	Authenticated,CreateOrder,ReadOrder,UpdateOrder,DeleteOrder,ReadCustomer,ReadPaymentMethod,ReadShippingMethod,ReadPromotion,ReadCountry,ReadZone	4
2025-06-21 07:06:35.002065	2025-06-21 07:06:35.002065	inventory-manager	Inventory manager	Authenticated,CreateCatalog,ReadCatalog,UpdateCatalog,DeleteCatalog,CreateTag,ReadTag,UpdateTag,DeleteTag,ReadCustomer	5
\.


--
-- Data for Name: role_channels_channel; Type: TABLE DATA; Schema: public; Owner: vendure
--

COPY public.role_channels_channel ("roleId", "channelId") FROM stdin;
1	1
2	1
3	1
4	1
5	1
\.


--
-- Data for Name: scheduled_task_record; Type: TABLE DATA; Schema: public; Owner: vendure
--

COPY public.scheduled_task_record ("createdAt", "updatedAt", "taskId", enabled, "lockedAt", "lastExecutedAt", "manuallyTriggeredAt", "lastResult", id) FROM stdin;
\.


--
-- Data for Name: search_index_item; Type: TABLE DATA; Schema: public; Owner: vendure
--

COPY public.search_index_item ("languageCode", enabled, "productName", "productVariantName", description, slug, sku, "facetIds", "facetValueIds", "collectionIds", "collectionSlugs", "channelIds", "productPreview", "productPreviewFocalPoint", "productVariantPreview", "productVariantPreviewFocalPoint", "inStock", "productInStock", "productVariantId", "channelId", "productId", "productAssetId", "productVariantAssetId", price, "priceWithTax") FROM stdin;
en	t	Laptop	Laptop 13 inch 8GB	Now equipped with seventh-generation Intel Core processors, Laptop is snappier than ever. From daily tasks like launching apps and opening files to more advanced computing, you can power through your day thanks to faster SSDs and Turbo Boost processing up to 3.6GHz.	laptop	L2201308	1,2	1,2,3	2,3	electronics,computers	1	preview\\71\\derick-david-409858-unsplash__preview.jpg	\N		\N	t	t	1	1	1	1	\N	129900	155880
en	t	Laptop	Laptop 15 inch 8GB	Now equipped with seventh-generation Intel Core processors, Laptop is snappier than ever. From daily tasks like launching apps and opening files to more advanced computing, you can power through your day thanks to faster SSDs and Turbo Boost processing up to 3.6GHz.	laptop	L2201508	1,2	1,2,3	2,3	electronics,computers	1	preview\\71\\derick-david-409858-unsplash__preview.jpg	\N		\N	t	t	2	1	1	1	\N	139900	167880
en	t	Laptop	Laptop 13 inch 16GB	Now equipped with seventh-generation Intel Core processors, Laptop is snappier than ever. From daily tasks like launching apps and opening files to more advanced computing, you can power through your day thanks to faster SSDs and Turbo Boost processing up to 3.6GHz.	laptop	L2201316	1,2	1,2,3	2,3	electronics,computers	1	preview\\71\\derick-david-409858-unsplash__preview.jpg	\N		\N	t	t	3	1	1	1	\N	219900	263880
en	t	Laptop	Laptop 15 inch 16GB	Now equipped with seventh-generation Intel Core processors, Laptop is snappier than ever. From daily tasks like launching apps and opening files to more advanced computing, you can power through your day thanks to faster SSDs and Turbo Boost processing up to 3.6GHz.	laptop	L2201516	1,2	1,2,3	2,3	electronics,computers	1	preview\\71\\derick-david-409858-unsplash__preview.jpg	\N		\N	t	t	4	1	1	1	\N	229900	275880
en	t	Football	Football	This football features high-contrast graphics for high-visibility during play, while its machine-stitched tpu casing offers consistent performance.	football	SC3137-056	1,2	17,18,21	8,9	sports-outdoor,equipment	1	preview\\d6\\nik-shuliahin-619349-unsplash__preview.jpg	\N		\N	t	t	40	1	26	26	\N	5707	6848
en	t	Tablet	Tablet 32GB	If the computer were invented today, what would it look like? It would be powerful enough for any task. So mobile you could take it everywhere. And so intuitive you could use it any way you wanted — with touch, a keyboard, or even a pencil. In other words, it wouldn’t really be a "computer." It would be Tablet.	tablet	TBL200032	1,2	1,2,3	2,3	electronics,computers	1	preview\\b8\\kelly-sikkema-685291-unsplash__preview.jpg	\N		\N	t	t	5	1	2	2	\N	32900	39480
en	t	Tablet	Tablet 128GB	If the computer were invented today, what would it look like? It would be powerful enough for any task. So mobile you could take it everywhere. And so intuitive you could use it any way you wanted — with touch, a keyboard, or even a pencil. In other words, it wouldn’t really be a "computer." It would be Tablet.	tablet	TBL200128	1,2	1,2,3	2,3	electronics,computers	1	preview\\b8\\kelly-sikkema-685291-unsplash__preview.jpg	\N		\N	t	t	6	1	2	2	\N	44500	53400
en	t	Wireless Optical Mouse	Wireless Optical Mouse	The Logitech M185 Wireless Optical Mouse is a great device for any computer user, and as Logitech are the global market leaders for these devices, you are also guaranteed absolute reliability. A mouse to be reckoned with!	cordless-mouse	834444	1,2	1,2,4	2,3	electronics,computers	1	preview\\a1\\oscar-ivan-esquivel-arteaga-687447-unsplash__preview.jpg	\N		\N	t	t	7	1	3	3	\N	1899	2279
en	t	32-Inch Monitor	32-Inch Monitor	The UJ59 with Ultra HD resolution has 4x the pixels of Full HD, delivering more screen space and amazingly life-like images. That means you can view documents and webpages with less scrolling, work more comfortably with multiple windows and toolbars, and enjoy photos, videos and games in stunning 4K quality. Note: beverage not included.	32-inch-monitor	LU32J590UQUXEN	1,2	1,2,5	2,3	electronics,computers	1	preview\\d2\\daniel-korpai-1302051-unsplash__preview.jpg	\N		\N	t	t	8	1	4	4	\N	31000	37200
en	t	Curvy Monitor	Curvy Monitor 24 inch	Discover a truly immersive viewing experience with this monitor curved more deeply than any other. Wrapping around your field of vision the 1,800 R screencreates a wider field of view, enhances depth perception, and minimises peripheral distractions to draw you deeper in to your content.	curvy-monitor	C24F390	1,2	1,2,5	2,3	electronics,computers	1	preview\\9c\\alexandru-acea-686569-unsplash__preview.jpg	\N		\N	t	t	9	1	5	5	\N	14374	17249
en	t	Curvy Monitor	Curvy Monitor 27 inch	Discover a truly immersive viewing experience with this monitor curved more deeply than any other. Wrapping around your field of vision the 1,800 R screencreates a wider field of view, enhances depth perception, and minimises peripheral distractions to draw you deeper in to your content.	curvy-monitor	C27F390	1,2	1,2,5	2,3	electronics,computers	1	preview\\9c\\alexandru-acea-686569-unsplash__preview.jpg	\N		\N	t	t	10	1	5	5	\N	16994	20393
en	t	High Performance RAM	High Performance RAM 4GB	Each RAM module is built with a pure aluminium heat spreader for faster heat dissipation and cooler operation. Enhanced to XMP 2.0 profiles for better overclocking; Compatibility: Intel 100 Series, Intel 200 Series, Intel 300 Series, Intel X299, AMD 300 Series, AMD 400 Series.	high-performance-ram	CMK32GX4M2AC04	1,2	1,2,6	2,3	electronics,computers	1	preview\\58\\liam-briese-1128307-unsplash__preview.jpg	\N		\N	t	t	11	1	6	6	\N	13785	16542
en	t	High Performance RAM	High Performance RAM 8GB	Each RAM module is built with a pure aluminium heat spreader for faster heat dissipation and cooler operation. Enhanced to XMP 2.0 profiles for better overclocking; Compatibility: Intel 100 Series, Intel 200 Series, Intel 300 Series, Intel X299, AMD 300 Series, AMD 400 Series.	high-performance-ram	CMK32GX4M2AC08	1,2	1,2,6	2,3	electronics,computers	1	preview\\58\\liam-briese-1128307-unsplash__preview.jpg	\N		\N	t	t	12	1	6	6	\N	14639	17567
en	t	High Performance RAM	High Performance RAM 16GB	Each RAM module is built with a pure aluminium heat spreader for faster heat dissipation and cooler operation. Enhanced to XMP 2.0 profiles for better overclocking; Compatibility: Intel 100 Series, Intel 200 Series, Intel 300 Series, Intel X299, AMD 300 Series, AMD 400 Series.	high-performance-ram	CMK32GX4M2AC16	1,2	1,2,6	2,3	electronics,computers	1	preview\\58\\liam-briese-1128307-unsplash__preview.jpg	\N		\N	t	t	13	1	6	6	\N	28181	33817
en	t	Gaming PC	Gaming PC i7-8700 240GB SSD	This pc is optimised for gaming, and is also VR ready. The Intel Core-i7 CPU and High Performance GPU give the computer the raw power it needs to function at a high level.	gaming-pc	CGS480VR1063	1,2	1,2,7	2,3	electronics,computers	1	preview\\5a\\florian-olivo-1166419-unsplash__preview.jpg	\N		\N	t	t	14	1	7	7	\N	108720	130464
en	t	Gaming PC	Gaming PC R7-2700 240GB SSD	This pc is optimised for gaming, and is also VR ready. The Intel Core-i7 CPU and High Performance GPU give the computer the raw power it needs to function at a high level.	gaming-pc	CGS480VR1064	1,2	1,2,7	2,3	electronics,computers	1	preview\\5a\\florian-olivo-1166419-unsplash__preview.jpg	\N		\N	t	t	15	1	7	7	\N	109995	131994
en	t	Gaming PC	Gaming PC i7-8700 120GB SSD	This pc is optimised for gaming, and is also VR ready. The Intel Core-i7 CPU and High Performance GPU give the computer the raw power it needs to function at a high level.	gaming-pc	CGS480VR1065	1,2	1,2,7	2,3	electronics,computers	1	preview\\5a\\florian-olivo-1166419-unsplash__preview.jpg	\N		\N	t	t	16	1	7	7	\N	93120	111744
en	t	Gaming PC	Gaming PC R7-2700 120GB SSD	This pc is optimised for gaming, and is also VR ready. The Intel Core-i7 CPU and High Performance GPU give the computer the raw power it needs to function at a high level.	gaming-pc	CGS480VR1066	1,2	1,2,7	2,3	electronics,computers	1	preview\\5a\\florian-olivo-1166419-unsplash__preview.jpg	\N		\N	t	t	17	1	7	7	\N	94920	113904
en	t	Hard Drive	Hard Drive 1TB	Boost your PC storage with this internal hard drive, designed just for desktop and all-in-one PCs.	hard-drive	IHD455T1	1,2	1,2,8	2,3	electronics,computers	1	preview\\96\\vincent-botta-736919-unsplash__preview.jpg	\N		\N	t	t	18	1	8	8	\N	3799	4559
en	t	Hard Drive	Hard Drive 2TB	Boost your PC storage with this internal hard drive, designed just for desktop and all-in-one PCs.	hard-drive	IHD455T2	1,2	1,2,8	2,3	electronics,computers	1	preview\\96\\vincent-botta-736919-unsplash__preview.jpg	\N		\N	t	t	19	1	8	8	\N	5374	6449
en	t	Hard Drive	Hard Drive 3TB	Boost your PC storage with this internal hard drive, designed just for desktop and all-in-one PCs.	hard-drive	IHD455T3	1,2	1,2,8	2,3	electronics,computers	1	preview\\96\\vincent-botta-736919-unsplash__preview.jpg	\N		\N	t	t	20	1	8	8	\N	7896	9475
en	t	Hard Drive	Hard Drive 4TB	Boost your PC storage with this internal hard drive, designed just for desktop and all-in-one PCs.	hard-drive	IHD455T4	1,2	1,2,8	2,3	electronics,computers	1	preview\\96\\vincent-botta-736919-unsplash__preview.jpg	\N		\N	t	t	21	1	8	8	\N	9299	11159
en	t	Hard Drive	Hard Drive 6TB	Boost your PC storage with this internal hard drive, designed just for desktop and all-in-one PCs.	hard-drive	IHD455T6	1,2	1,2,8	2,3	electronics,computers	1	preview\\96\\vincent-botta-736919-unsplash__preview.jpg	\N		\N	t	t	22	1	8	8	\N	13435	16122
en	t	Clacky Keyboard	Clacky Keyboard	Let all your colleagues know that you are typing on this exclusive, colorful klicky-klacky keyboard. Huge travel on each keypress ensures maximum klack on each and every keystroke.	clacky-keyboard	A4TKLA45535	1,2	1,2,6	2,3	electronics,computers	1	preview\\09\\juan-gomez-674574-unsplash__preview.jpg	\N		\N	t	t	23	1	9	9	\N	7489	8987
en	t	Ethernet Cable	Ethernet Cable	5m (metres) Cat.6 network cable (upwards/downwards compatible) | Patch cable | 2 RJ-45 plug | plug with bend protection mantle. High transmission speeds due to operating frequency with up to 250 MHz (in comparison to Cat.5/Cat.5e cable bandwidth of 100 MHz).	ethernet-cable	A23334x30	1	1,2	2,3	electronics,computers	1	preview\\7b\\thomas-q-1229169-unsplash__preview.jpg	\N		\N	t	t	24	1	10	10	\N	597	716
en	t	USB Cable	USB Cable	Solid conductors eliminate strand-interaction distortion and reduce jitter. As the surface is made of high-purity silver, the performance is very close to that of a solid silver cable, but priced much closer to solid copper cable.	usb-cable	USBCIN01.5MI	1	1,2	2,3	electronics,computers	1	preview\\64\\adam-birkett-239153-unsplash__preview.jpg	\N		\N	t	t	25	1	11	11	\N	6900	8280
en	t	Instant Camera	Instant Camera	With its nostalgic design and simple point-and-shoot functionality, the Instant Camera is the perfect pick to get started with instant photography.	instant-camera	IC22MWDD	1,2	1,9,10	2,4	electronics,camera-photo	1	preview\\b5\\eniko-kis-663725-unsplash__preview.jpg	\N		\N	t	t	26	1	12	12	\N	17499	20999
en	t	Camera Lens	Camera Lens	This lens is a Di type lens using an optical system with improved multi-coating designed to function with digital SLR cameras as well as film cameras.	camera-lens	B0012UUP02	1,2	1,9,11	2,4	electronics,camera-photo	1	preview\\9b\\brandi-redd-104140-unsplash__preview.jpg	\N		\N	t	t	27	1	13	13	\N	10400	12480
en	t	Vintage Folding Camera	Vintage Folding Camera	This vintage folding camera is so antiquated that you cannot possibly hope to produce actual photographs with it. However, it makes a wonderful decorative piece for the home or office.	vintage-folding-camera	B00AFC9099	1,2	1,9,12	2,4	electronics,camera-photo	1	preview\\3c\\jonathan-talbert-697262-unsplash__preview.jpg	\N		\N	t	t	28	1	14	14	\N	535000	642000
en	t	Tripod	Tripod	Capture vivid, professional-style photographs with help from this lightweight tripod. The adjustable-height tripod makes it easy to achieve reliable stability and score just the right angle when going after that award-winning shot.	tripod	B00XI87KV8	1,2	1,9,13	2,4	electronics,camera-photo	1	preview\\21\\zoltan-tasi-423051-unsplash__preview.jpg	\N		\N	t	t	29	1	15	15	\N	1498	1798
en	t	Instamatic Camera	Instamatic Camera	This inexpensive point-and-shoot camera uses easy-to-load 126 film cartridges. A built-in flash unit ensure great results, no matter the lighting conditions.	instamatic-camera	B07K1330LL	1,2	1,9,14	2,4	electronics,camera-photo	1	preview\\5b\\jakob-owens-274337-unsplash__preview.jpg	\N		\N	t	t	30	1	16	16	\N	2000	2400
en	t	Compact Digital Camera	Compact Digital Camera	Unleash your creative potential with high-level performance and advanced features such as AI-powered Real-time Eye AF; new, high-precision Real-time Tracking; high-speed continuous shooting and 4K HDR movie-shooting. The camera's innovative AF quickly and reliably detects the position of the subject and then tracks the subject's motion, keeping it in sharp focus.	compact-digital-camera	B07D990021	1,2	1,9,15	2,4	electronics,camera-photo	1	preview\\bc\\patrick-brinksma-663044-unsplash__preview.jpg	\N		\N	t	t	31	1	17	17	\N	89999	107999
en	t	Nikkormat SLR Camera	Nikkormat SLR Camera	The Nikkormat FS was brought to market by Nikon in 1965. The lens is a 50mm f1.4 Nikkor. Nice glass, smooth focus and a working diaphragm. A UV filter and a Nikon front lens cap are included with the lens.	nikkormat-slr-camera	B07D33B334	1,2	1,9,11	2,4	electronics,camera-photo	1	preview\\95\\chuttersnap-324234-unsplash__preview.jpg	\N		\N	t	t	32	1	18	18	\N	61500	73800
en	t	Compact SLR Camera	Compact SLR Camera	Retro styled, portable in size and built around a powerful 24-megapixel APS-C CMOS sensor, this digital camera is the ideal companion for creative everyday photography. Packed full of high spec features such as an advanced hybrid autofocus system able to keep pace with even the most active subjects, a speedy 6fps continuous-shooting mode, high-resolution electronic viewfinder and intuitive swivelling touchscreen, it brings professional image making into everyone’s grasp.	compact-slr-camera	B07D75V44S	1	1,9	2,4	electronics,camera-photo	1	preview\\9d\\robert-shunev-528016-unsplash__preview.jpg	\N		\N	t	t	33	1	19	19	\N	52100	62520
en	t	Twin Lens Camera	Twin Lens Camera	What makes a Rolleiflex TLR so special? Many things. To start, TLR stands for twin lens reflex. “Twin” because there are two lenses. And reflex means that the photographer looks through the lens to view the reflected image of an object or scene on the focusing screen. 	twin-lens-camera	B07D78JTLR	1,2	1,9,16	2,4	electronics,camera-photo	1	preview\\ef\\alexander-andrews-260988-unsplash__preview.jpg	\N		\N	t	t	34	1	20	20	\N	79900	95880
en	t	Road Bike	Road Bike	Featuring a full carbon chassis - complete with cyclocross-specific carbon fork - and a component setup geared for hard use on the race circuit, it's got the low weight, exceptional efficiency and brilliant handling you'll need to stay at the front of the pack.	road-bike	RB000844334	1,2	17,18,19	8,9	sports-outdoor,equipment	1	preview\\2f\\mikkel-bech-748940-unsplash__preview.jpg	\N		\N	t	t	35	1	21	21	\N	249900	299880
en	t	Skipping Rope	Skipping Rope	When you're working out you need a quality rope that doesn't tangle at every couple of jumps and with this skipping rope you won't have this problem. The fact that it looks like a pair of tasty frankfurters is merely a bonus.	skipping-rope	B07CNGXVXT	1,2	17,18,20	8,9	sports-outdoor,equipment	1	preview\\34\\stoica-ionela-530966-unsplash__preview.jpg	\N		\N	t	t	36	1	22	22	\N	799	959
en	t	Boxing Gloves	Boxing Gloves	Training gloves designed for optimum training. Our gloves promote proper punching technique because they are conformed to the natural shape of your fist. Dense, innovative two-layer foam provides better shock absorbency and full padding on the front, back and wrist to promote proper punching technique.	boxing-gloves	B000ZYLPPU	1,2	17,18,20	8,9	sports-outdoor,equipment	1	preview\\4f\\neonbrand-428982-unsplash__preview.jpg	\N		\N	t	t	37	1	23	23	\N	3304	3965
en	t	Tent	Tent	With tons of space inside (for max. 4 persons), full head height throughout the entire tent and an unusual and striking shape, this tent offers you everything you need.	tent	2000023510	1	17,18	8,9	sports-outdoor,equipment	1	preview\\96\\michael-guite-571169-unsplash__preview.jpg	\N		\N	t	t	38	1	24	24	\N	21493	25792
en	t	Cruiser Skateboard	Cruiser Skateboard	Based on the 1970s iconic shape, but made to a larger 69cm size, with updated, quality component, these skateboards are great for beginners to learn the foot spacing required, and are perfect for all-day cruising.	cruiser-skateboard	799872520	1	17,18	8,9	sports-outdoor,equipment	1	preview\\35\\max-tarkhov-737999-unsplash__preview.jpg	\N		\N	t	t	39	1	25	25	\N	2499	2999
en	t	Tennis Ball	Tennis Ball	Our dog loves these tennis balls and they last for some time before they eventually either get lost in some field or bush or the covering comes off due to it being used most of the day every day.	tennis-ball	WRT11752P	1,2	17,18,22	8,9	sports-outdoor,equipment	1	preview\\30\\ben-hershey-574483-unsplash__preview.jpg	\N		\N	t	t	41	1	27	27	\N	1273	1528
en	t	Basketball	Basketball	The Wilson MVP ball is perfect for playing basketball, and improving your skill for hours on end. Designed for new players, it is created with a high-quality rubber suitable for courts, allowing you to get full use during your practices.	basketball	WTB1418XB06	1,2	17,18,22	8,9	sports-outdoor,equipment	1	preview\\0f\\tommy-bebo-600358-unsplash__preview.jpg	\N		\N	t	t	42	1	28	28	\N	3562	4274
en	t	Ultraboost Running Shoe	Ultraboost Running Shoe Size 40	With its ultra-light, uber-responsive magic foam and a carbon fiber plate that feels like it’s propelling you forward, the Running Shoe is ready to push you to victories both large and small	ultraboost-running-shoe	RS0040	1,2,3	17,23,24,25,26	8,10	sports-outdoor,footwear	1	preview\\ed\\chuttersnap-584518-unsplash__preview.jpg	\N		\N	t	t	43	1	29	29	\N	9999	11999
en	t	Ultraboost Running Shoe	Ultraboost Running Shoe Size 42	With its ultra-light, uber-responsive magic foam and a carbon fiber plate that feels like it’s propelling you forward, the Running Shoe is ready to push you to victories both large and small	ultraboost-running-shoe	RS0042	1,2,3	17,23,24,25,26	8,10	sports-outdoor,footwear	1	preview\\ed\\chuttersnap-584518-unsplash__preview.jpg	\N		\N	t	t	44	1	29	29	\N	9999	11999
en	t	Ultraboost Running Shoe	Ultraboost Running Shoe Size 44	With its ultra-light, uber-responsive magic foam and a carbon fiber plate that feels like it’s propelling you forward, the Running Shoe is ready to push you to victories both large and small	ultraboost-running-shoe	RS0044	1,2,3	17,23,24,25,26	8,10	sports-outdoor,footwear	1	preview\\ed\\chuttersnap-584518-unsplash__preview.jpg	\N		\N	t	t	45	1	29	29	\N	9999	11999
en	t	Ultraboost Running Shoe	Ultraboost Running Shoe Size 46	With its ultra-light, uber-responsive magic foam and a carbon fiber plate that feels like it’s propelling you forward, the Running Shoe is ready to push you to victories both large and small	ultraboost-running-shoe	RS0046	1,2,3	17,23,24,25,26	8,10	sports-outdoor,footwear	1	preview\\ed\\chuttersnap-584518-unsplash__preview.jpg	\N		\N	t	t	46	1	29	29	\N	9999	11999
en	t	Freerun Running Shoe	Freerun Running Shoe Size 40	The Freerun Men's Running Shoe is built for record-breaking speed. The Flyknit upper delivers ultra-lightweight support that fits like a glove.	freerun-running-shoe	AR4561-40	1,2,3	17,21,23,27	8,10	sports-outdoor,footwear	1	preview\\0f\\imani-clovis-234736-unsplash__preview.jpg	\N		\N	t	t	47	1	30	30	\N	16000	19200
en	t	Freerun Running Shoe	Freerun Running Shoe Size 42	The Freerun Men's Running Shoe is built for record-breaking speed. The Flyknit upper delivers ultra-lightweight support that fits like a glove.	freerun-running-shoe	AR4561-42	1,2,3	17,21,23,27	8,10	sports-outdoor,footwear	1	preview\\0f\\imani-clovis-234736-unsplash__preview.jpg	\N		\N	t	t	48	1	30	30	\N	16000	19200
en	t	Freerun Running Shoe	Freerun Running Shoe Size 44	The Freerun Men's Running Shoe is built for record-breaking speed. The Flyknit upper delivers ultra-lightweight support that fits like a glove.	freerun-running-shoe	AR4561-44	1,2,3	17,21,23,27	8,10	sports-outdoor,footwear	1	preview\\0f\\imani-clovis-234736-unsplash__preview.jpg	\N		\N	t	t	49	1	30	30	\N	16000	19200
en	t	Freerun Running Shoe	Freerun Running Shoe Size 46	The Freerun Men's Running Shoe is built for record-breaking speed. The Flyknit upper delivers ultra-lightweight support that fits like a glove.	freerun-running-shoe	AR4561-46	1,2,3	17,21,23,27	8,10	sports-outdoor,footwear	1	preview\\0f\\imani-clovis-234736-unsplash__preview.jpg	\N		\N	t	t	50	1	30	30	\N	16000	19200
en	t	Hi-Top Basketball Shoe	Hi-Top Basketball Shoe Size 40	Boasting legendary performance since 2008, the Hyperdunkz Basketball Shoe needs no gimmicks to stand out. Air units deliver best-in-class cushioning, while a dynamic lacing system keeps your foot snug and secure, so you can focus on your game and nothing else.	hi-top-basketball-shoe	AO7893-40	1,2,3	17,21,23,28	8,10	sports-outdoor,footwear	1	preview\\3c\\xavier-teo-469050-unsplash__preview.jpg	\N		\N	t	t	51	1	31	31	\N	14000	16800
en	t	Hi-Top Basketball Shoe	Hi-Top Basketball Shoe Size 42	Boasting legendary performance since 2008, the Hyperdunkz Basketball Shoe needs no gimmicks to stand out. Air units deliver best-in-class cushioning, while a dynamic lacing system keeps your foot snug and secure, so you can focus on your game and nothing else.	hi-top-basketball-shoe	AO7893-42	1,2,3	17,21,23,28	8,10	sports-outdoor,footwear	1	preview\\3c\\xavier-teo-469050-unsplash__preview.jpg	\N		\N	t	t	52	1	31	31	\N	14000	16800
en	t	Hi-Top Basketball Shoe	Hi-Top Basketball Shoe Size 44	Boasting legendary performance since 2008, the Hyperdunkz Basketball Shoe needs no gimmicks to stand out. Air units deliver best-in-class cushioning, while a dynamic lacing system keeps your foot snug and secure, so you can focus on your game and nothing else.	hi-top-basketball-shoe	AO7893-44	1,2,3	17,21,23,28	8,10	sports-outdoor,footwear	1	preview\\3c\\xavier-teo-469050-unsplash__preview.jpg	\N		\N	t	t	53	1	31	31	\N	14000	16800
en	t	Hi-Top Basketball Shoe	Hi-Top Basketball Shoe Size 46	Boasting legendary performance since 2008, the Hyperdunkz Basketball Shoe needs no gimmicks to stand out. Air units deliver best-in-class cushioning, while a dynamic lacing system keeps your foot snug and secure, so you can focus on your game and nothing else.	hi-top-basketball-shoe	AO7893-46	1,2,3	17,21,23,28	8,10	sports-outdoor,footwear	1	preview\\3c\\xavier-teo-469050-unsplash__preview.jpg	\N		\N	t	t	54	1	31	31	\N	14000	16800
en	t	Pureboost Running Shoe	Pureboost Running Shoe Size 40	Built to handle curbs, corners and uneven sidewalks, these natural running shoes have an expanded landing zone and a heel plate for added stability. A lightweight and stretchy knit upper supports your native stride.	pureboost-running-shoe	F3578640	1,2,3	17,23,24,27,28	8,10	sports-outdoor,footwear	1	preview\\a2\\thomas-serer-420833-unsplash__preview.jpg	\N		\N	t	t	55	1	32	32	\N	9995	11994
en	t	Pureboost Running Shoe	Pureboost Running Shoe Size 42	Built to handle curbs, corners and uneven sidewalks, these natural running shoes have an expanded landing zone and a heel plate for added stability. A lightweight and stretchy knit upper supports your native stride.	pureboost-running-shoe	F3578642	1,2,3	17,23,24,27,28	8,10	sports-outdoor,footwear	1	preview\\a2\\thomas-serer-420833-unsplash__preview.jpg	\N		\N	t	t	56	1	32	32	\N	9995	11994
en	t	Pureboost Running Shoe	Pureboost Running Shoe Size 44	Built to handle curbs, corners and uneven sidewalks, these natural running shoes have an expanded landing zone and a heel plate for added stability. A lightweight and stretchy knit upper supports your native stride.	pureboost-running-shoe	F3578644	1,2,3	17,23,24,27,28	8,10	sports-outdoor,footwear	1	preview\\a2\\thomas-serer-420833-unsplash__preview.jpg	\N		\N	t	t	57	1	32	32	\N	9995	11994
en	t	Pureboost Running Shoe	Pureboost Running Shoe Size 46	Built to handle curbs, corners and uneven sidewalks, these natural running shoes have an expanded landing zone and a heel plate for added stability. A lightweight and stretchy knit upper supports your native stride.	pureboost-running-shoe	F3578646	1,2,3	17,23,24,27,28	8,10	sports-outdoor,footwear	1	preview\\a2\\thomas-serer-420833-unsplash__preview.jpg	\N		\N	t	t	58	1	32	32	\N	9995	11994
en	t	RunX Running Shoe	RunX Running Shoe Size 40	These running shoes are made with an airy, lightweight mesh upper. The durable rubber outsole grips the pavement for added stability. A cushioned midsole brings comfort to each step.	runx-running-shoe	F3633340	1,2,3	17,23,24,27	8,10	sports-outdoor,footwear	1	preview\\00\\nikolai-chernichenko-1299748-unsplash__preview.jpg	\N		\N	t	t	59	1	33	33	\N	4495	5394
en	t	RunX Running Shoe	RunX Running Shoe Size 42	These running shoes are made with an airy, lightweight mesh upper. The durable rubber outsole grips the pavement for added stability. A cushioned midsole brings comfort to each step.	runx-running-shoe	F3633342	1,2,3	17,23,24,27	8,10	sports-outdoor,footwear	1	preview\\00\\nikolai-chernichenko-1299748-unsplash__preview.jpg	\N		\N	t	t	60	1	33	33	\N	4495	5394
en	t	RunX Running Shoe	RunX Running Shoe Size 44	These running shoes are made with an airy, lightweight mesh upper. The durable rubber outsole grips the pavement for added stability. A cushioned midsole brings comfort to each step.	runx-running-shoe	F3633344	1,2,3	17,23,24,27	8,10	sports-outdoor,footwear	1	preview\\00\\nikolai-chernichenko-1299748-unsplash__preview.jpg	\N		\N	t	t	61	1	33	33	\N	4495	5394
en	t	RunX Running Shoe	RunX Running Shoe Size 46	These running shoes are made with an airy, lightweight mesh upper. The durable rubber outsole grips the pavement for added stability. A cushioned midsole brings comfort to each step.	runx-running-shoe	F3633346	1,2,3	17,23,24,27	8,10	sports-outdoor,footwear	1	preview\\00\\nikolai-chernichenko-1299748-unsplash__preview.jpg	\N		\N	t	t	62	1	33	33	\N	4495	5394
en	t	Allstar Sneakers	Allstar Sneakers Size 40	All Star is the most iconic sneaker in the world, recognised for its unmistakable silhouette, star-centred ankle patch and cultural authenticity. And like the best paradigms, it only gets better with time.	allstar-sneakers	CAS23340	1,3,2	17,23,27,29	8,10	sports-outdoor,footwear	1	preview\\aa\\mitch-lensink-256007-unsplash__preview.jpg	\N		\N	t	t	63	1	34	34	\N	6500	7800
en	t	Allstar Sneakers	Allstar Sneakers Size 42	All Star is the most iconic sneaker in the world, recognised for its unmistakable silhouette, star-centred ankle patch and cultural authenticity. And like the best paradigms, it only gets better with time.	allstar-sneakers	CAS23342	1,3,2	17,23,27,29	8,10	sports-outdoor,footwear	1	preview\\aa\\mitch-lensink-256007-unsplash__preview.jpg	\N		\N	t	t	64	1	34	34	\N	6500	7800
en	t	Allstar Sneakers	Allstar Sneakers Size 44	All Star is the most iconic sneaker in the world, recognised for its unmistakable silhouette, star-centred ankle patch and cultural authenticity. And like the best paradigms, it only gets better with time.	allstar-sneakers	CAS23344	1,3,2	17,23,27,29	8,10	sports-outdoor,footwear	1	preview\\aa\\mitch-lensink-256007-unsplash__preview.jpg	\N		\N	t	t	65	1	34	34	\N	6500	7800
en	t	Allstar Sneakers	Allstar Sneakers Size 46	All Star is the most iconic sneaker in the world, recognised for its unmistakable silhouette, star-centred ankle patch and cultural authenticity. And like the best paradigms, it only gets better with time.	allstar-sneakers	CAS23346	1,3,2	17,23,27,29	8,10	sports-outdoor,footwear	1	preview\\aa\\mitch-lensink-256007-unsplash__preview.jpg	\N		\N	t	t	66	1	34	34	\N	6500	7800
en	t	Spiky Cactus	Spiky Cactus	A spiky yet elegant house cactus - perfect for the home or office. Origin and habitat: Probably native only to the Andes of Peru	spiky-cactus	SC011001	1,4	30,31,32	5,7	home-garden,plants	1	preview\\78\\charles-deluvio-695736-unsplash__preview.jpg	\N		\N	t	t	67	1	35	35	\N	1550	1860
en	t	Tulip Pot	Tulip Pot	Bright crimson red species tulip with black centers, the poppy-like flowers will open up in full sun. Ideal for rock gardens, pots and border edging.	tulip-pot	A58477	1,4	30,31,32,33	5,7	home-garden,plants	1	preview\\14\\natalia-y-345738-unsplash__preview.jpg	\N		\N	t	t	68	1	36	36	\N	675	810
en	t	Hanging Plant	Hanging Plant	Can be found in tropical and sub-tropical America where it grows on the branches of trees, but also on telephone wires and electricity cables and poles that sometimes topple with the weight of these plants. This plant loves a moist and warm air.	hanging-plant	A44223	1,4	30,31,33	5,7	home-garden,plants	1	preview\\5b\\alex-rodriguez-santibanez-200278-unsplash__preview.jpg	\N		\N	t	t	69	1	37	37	\N	1995	2394
en	t	Aloe Vera	Aloe Vera	Decorative Aloe vera makes a lovely house plant. A really trendy plant, Aloe vera is just so easy to care for. Aloe vera sap has been renowned for its remarkable medicinal and cosmetic properties for many centuries and has been used to treat grazes, insect bites and sunburn - it really works.	aloe-vera	A44352	1,4	30,31,32	5,7	home-garden,plants	1	preview\\29\\silvia-agrasar-227575-unsplash__preview.jpg	\N		\N	t	t	70	1	38	38	\N	699	839
en	t	Fern Blechnum Gibbum	Fern Blechnum Gibbum	Create a tropical feel in your home with this lush green tree fern, it has decorative leaves and will develop a short slender trunk in time.	fern-blechnum-gibbum	A04851	1,4	30,31,33	5,7	home-garden,plants	1	preview\\6d\\caleb-george-536388-unsplash__preview.jpg	\N		\N	t	t	71	1	39	39	\N	895	1074
en	t	Assorted Indoor Succulents	Assorted Indoor Succulents	These assorted succulents come in a variety of different shapes and colours - each with their own unique personality. Succulents grow best in plenty of light: a sunny windowsill would be the ideal spot for them to thrive!	assorted-succulents	A08593	1,4	30,31,32	5,7	home-garden,plants	1	preview\\81\\annie-spratt-78044-unsplash__preview.jpg	\N		\N	t	t	72	1	40	40	\N	3250	3900
en	t	Orchid	Orchid	Gloriously elegant. It can go along with any interior as it is a neutral color and the most popular Phalaenopsis overall. 2 to 3 foot stems host large white flowers that can last for over 2 months.	orchid	ROR00221	1	30,31	5,7	home-garden,plants	1	preview\\88\\zoltan-kovacs-642412-unsplash__preview.jpg	\N		\N	t	t	73	1	41	41	\N	6500	7800
en	t	Bonsai Tree	Bonsai Tree	Excellent semi-evergreen bonsai. Indoors or out but needs some winter protection. All trees sent will leave the nursery in excellent condition and will be of equal quality or better than the photograph shown.	bonsai-tree	B01MXFLUSV	1	30,31	5,7	home-garden,plants	1	preview\\f3\\mark-tegethoff-667351-unsplash__preview.jpg	\N		\N	t	t	74	1	42	42	\N	1999	2399
en	t	Guardian Lion Statue	Guardian Lion Statue	Placing it at home or office can bring you fortune and prosperity, guard your house and ward off ill fortune.	guardian-lion-statue	GL34LLW11	1,3	30,34,35	5,6	home-garden,furniture	1	preview\\44\\vincent-liu-525429-unsplash__preview.jpg	\N		\N	t	t	75	1	43	43	\N	18853	22624
en	t	Hand Trowel	Hand Trowel	Hand trowel for garden cultivating hammer finish epoxy-coated head for improved resistance to rust, scratches, humidity and alkalines in the soil.	hand-trowel	4058NB/09	1	30,31	5,7	home-garden,plants	1	preview\\7d\\neslihan-gunaydin-3493-unsplash__preview.jpg	\N		\N	t	t	76	1	44	44	\N	499	599
en	t	Balloon Chair	Balloon Chair	A charming vintage white wooden chair featuring an extremely spherical pink balloon. The balloon may be detached and used for other purposes, for example as a party decoration.	balloon-chair	34-BC82444	1	30,34	5,6	home-garden,furniture	1	preview\\ef\\florian-klauer-14840-unsplash__preview.jpg	\N		\N	t	t	77	1	45	45	\N	6500	7800
en	t	Grey Fabric Sofa	Grey Fabric Sofa	Seat cushions filled with high resilience foam and polyester fibre wadding give comfortable support for your body, and easily regain their shape when you get up. The cover is easy to keep clean as it is removable and can be machine washed.	grey-fabric-sofa	CH00001-12	1,3	30,34,35	5,6	home-garden,furniture	1	preview\\69\\nathan-fertig-249917-unsplash__preview.jpg	\N		\N	t	t	78	1	46	46	\N	29500	35400
en	t	Leather Sofa	Leather Sofa	This premium, tan-brown bonded leather seat is part of the 'chill' sofa range. The lever activated recline feature makes it easy to adjust to any position. This smart, bustle back design with rounded tight padded arms has been designed with your comfort in mind. This well-padded chair has foam pocket sprung seat cushions and fibre-filled back cushions.	leather-sofa	CH00001-02	1,3	30,34,36	5,6	home-garden,furniture	1	preview\\3e\\paul-weaver-1120584-unsplash__preview.jpg	\N		\N	t	t	79	1	47	47	\N	124500	149400
en	t	Light Shade	Light Shade	Modern tapered white polycotton pendant shade with a metallic silver chrome interior finish for maximum light reflection. Reversible gimble so it can be used as a ceiling shade or as a lamp shade.	light-shade	B45809LSW	1	30,34	5,6	home-garden,furniture	1	preview\\5f\\pierre-chatel-innocenti-483198-unsplash__preview.jpg	\N		\N	t	t	80	1	48	48	\N	2845	3414
en	t	Wooden Side Desk	Wooden Side Desk	Drawer stops prevent the drawers from being pulled out too far. Built-in cable management for collecting cables and cords; out of sight but close at hand.	wooden-side-desk	304.096.29	1,3	30,34,37	5,6	home-garden,furniture	1	preview\\40\\abel-y-costa-716024-unsplash__preview.jpg	\N		\N	t	t	81	1	49	49	\N	12500	15000
en	t	Comfy Padded Chair	Comfy Padded Chair	You sit comfortably thanks to the shaped back. The chair frame is made of solid wood, which is a durable natural material.	comfy-padded-chair	404.068.14	1,3	30,34,35	5,6	home-garden,furniture	1	preview\\3b\\kari-shea-398668-unsplash__preview.jpg	\N		\N	t	t	82	1	50	50	\N	13000	15600
en	t	Black Eaves Chair	Black Eaves Chair	Comfortable to sit on thanks to the bowl-shaped seat and rounded shape of the backrest. No tools are required to assemble the chair, you just click it together with a simple mechanism under the seat.	black-eaves-chair	003.600.02	1,3	30,34,27	5,6	home-garden,furniture	1	preview\\09\\andres-jasso-220776-unsplash__preview.jpg	\N		\N	t	t	83	1	51	51	\N	7000	8400
en	t	Wooden Stool	Wooden Stool	Solid wood is a hardwearing natural material, which can be sanded and surface treated as required.	wooden-stool	202.493.30	1,3	30,34,37	5,6	home-garden,furniture	1	preview\\d0\\ruslan-bardash-351288-unsplash__preview.jpg	\N		\N	t	t	84	1	52	52	\N	1400	1680
en	t	Bedside Table	Bedside Table	Every table is unique, with varying grain pattern and natural colour shifts that are part of the charm of wood.	bedside-table	404.290.14	1,3	30,34,28	5,6	home-garden,furniture	1	preview\\72\\benjamin-voros-310026-unsplash__preview.jpg	\N		\N	t	t	85	1	53	53	\N	13000	15600
en	t	Modern Cafe Chair	Modern Cafe Chair mustard	You sit comfortably thanks to the restful flexibility of the seat. Lightweight and easy to move around, yet stable enough even for the liveliest, young family members.	modern-cafe-chair	404.038.96	3,1	38,30,34	5,6	home-garden,furniture	1	preview\\b1\\jean-philippe-delberghe-1400011-unsplash__preview.jpg	\N		\N	t	t	86	1	54	54	\N	10000	12000
en	t	Modern Cafe Chair	Modern Cafe Chair mint	You sit comfortably thanks to the restful flexibility of the seat. Lightweight and easy to move around, yet stable enough even for the liveliest, young family members.	modern-cafe-chair	404.038.96	3,1	39,30,34	5,6	home-garden,furniture	1	preview\\b1\\jean-philippe-delberghe-1400011-unsplash__preview.jpg	\N		\N	t	t	87	1	54	54	\N	10000	12000
en	t	Modern Cafe Chair	Modern Cafe Chair pearl	You sit comfortably thanks to the restful flexibility of the seat. Lightweight and easy to move around, yet stable enough even for the liveliest, young family members.	modern-cafe-chair	404.038.96	3,1	28,30,34	5,6	home-garden,furniture	1	preview\\b1\\jean-philippe-delberghe-1400011-unsplash__preview.jpg	\N		\N	t	t	88	1	54	54	\N	10000	12000
\.


--
-- Data for Name: seller; Type: TABLE DATA; Schema: public; Owner: vendure
--

COPY public.seller ("createdAt", "updatedAt", "deletedAt", name, id) FROM stdin;
2025-06-21 07:06:31.814186	2025-06-21 07:06:31.814186	\N	Default Seller	1
\.


--
-- Data for Name: session; Type: TABLE DATA; Schema: public; Owner: vendure
--

COPY public.session ("createdAt", "updatedAt", token, expires, invalidated, "authenticationStrategy", id, "activeOrderId", "activeChannelId", type, "userId") FROM stdin;
\.


--
-- Data for Name: shipping_line; Type: TABLE DATA; Schema: public; Owner: vendure
--

COPY public.shipping_line ("createdAt", "updatedAt", "listPriceIncludesTax", adjustments, "taxLines", id, "shippingMethodId", "listPrice", "orderId") FROM stdin;
\.


--
-- Data for Name: shipping_method; Type: TABLE DATA; Schema: public; Owner: vendure
--

COPY public.shipping_method ("createdAt", "updatedAt", "deletedAt", code, checker, calculator, "fulfillmentHandlerCode", id) FROM stdin;
2025-06-21 07:06:34.932099	2025-06-21 07:06:34.932099	\N	standard-shipping	{"code":"default-shipping-eligibility-checker","args":[{"name":"orderMinimum","value":"0"}]}	{"code":"default-shipping-calculator","args":[{"name":"rate","value":"500"},{"name":"includesTax","value":"auto"},{"name":"taxRate","value":"0"}]}	manual-fulfillment	1
2025-06-21 07:06:34.951674	2025-06-21 07:06:34.951674	\N	express-shipping	{"code":"default-shipping-eligibility-checker","args":[{"name":"orderMinimum","value":"0"}]}	{"code":"default-shipping-calculator","args":[{"name":"rate","value":"1000"},{"name":"includesTax","value":"auto"},{"name":"taxRate","value":"0"}]}	manual-fulfillment	2
\.


--
-- Data for Name: shipping_method_channels_channel; Type: TABLE DATA; Schema: public; Owner: vendure
--

COPY public.shipping_method_channels_channel ("shippingMethodId", "channelId") FROM stdin;
1	1
2	1
\.


--
-- Data for Name: shipping_method_translation; Type: TABLE DATA; Schema: public; Owner: vendure
--

COPY public.shipping_method_translation ("createdAt", "updatedAt", "languageCode", name, description, id, "baseId") FROM stdin;
2025-06-21 07:06:34.928571	2025-06-21 07:06:34.932099	en	Standard Shipping		1	1
2025-06-21 07:06:34.949064	2025-06-21 07:06:34.951674	en	Express Shipping		2	2
\.


--
-- Data for Name: stock_level; Type: TABLE DATA; Schema: public; Owner: vendure
--

COPY public.stock_level ("createdAt", "updatedAt", "stockOnHand", "stockAllocated", id, "productVariantId", "stockLocationId") FROM stdin;
2025-06-21 07:06:35.227974	2025-06-21 07:06:35.238328	100	0	1	1	1
2025-06-21 07:06:35.259486	2025-06-21 07:06:35.266705	100	0	2	2	1
2025-06-21 07:06:35.281619	2025-06-21 07:06:35.288412	100	0	3	3	1
2025-06-21 07:06:35.302771	2025-06-21 07:06:35.309999	100	0	4	4	1
2025-06-21 07:06:35.37947	2025-06-21 07:06:35.386058	100	0	5	5	1
2025-06-21 07:06:35.405574	2025-06-21 07:06:35.41349	100	0	6	6	1
2025-06-21 07:06:35.477786	2025-06-21 07:06:35.484047	100	0	7	7	1
2025-06-21 07:06:35.549284	2025-06-21 07:06:35.555202	100	0	8	8	1
2025-06-21 07:06:35.624424	2025-06-21 07:06:35.631076	100	0	9	9	1
2025-06-21 07:06:35.649125	2025-06-21 07:06:35.656267	100	0	10	10	1
2025-06-21 07:06:35.748982	2025-06-21 07:06:35.755082	100	0	11	11	1
2025-06-21 07:06:35.768842	2025-06-21 07:06:35.775227	100	0	12	12	1
2025-06-21 07:06:35.790676	2025-06-21 07:06:35.798894	100	0	13	13	1
2025-06-21 07:06:35.899182	2025-06-21 07:06:35.905265	100	0	14	14	1
2025-06-21 07:06:35.918959	2025-06-21 07:06:35.925215	100	0	15	15	1
2025-06-21 07:06:35.938668	2025-06-21 07:06:35.944886	100	0	16	16	1
2025-06-21 07:06:35.957238	2025-06-21 07:06:35.963367	100	0	17	17	1
2025-06-21 07:06:36.060074	2025-06-21 07:06:36.067223	100	0	18	18	1
2025-06-21 07:06:36.08095	2025-06-21 07:06:36.08721	100	0	19	19	1
2025-06-21 07:06:36.099848	2025-06-21 07:06:36.106397	100	0	20	20	1
2025-06-21 07:06:36.120009	2025-06-21 07:06:36.126122	100	0	21	21	1
2025-06-21 07:06:36.14007	2025-06-21 07:06:36.146172	100	0	22	22	1
2025-06-21 07:06:36.192607	2025-06-21 07:06:36.1992	100	0	23	23	1
2025-06-21 07:06:36.256354	2025-06-21 07:06:36.262364	100	0	24	24	1
2025-06-21 07:06:36.30327	2025-06-21 07:06:36.309409	100	0	25	25	1
2025-06-21 07:06:36.367797	2025-06-21 07:06:36.374333	100	0	26	26	1
2025-06-21 07:06:36.43141	2025-06-21 07:06:36.438337	100	0	27	27	1
2025-06-21 07:06:36.494774	2025-06-21 07:06:36.501381	100	0	28	28	1
2025-06-21 07:06:36.549522	2025-06-21 07:06:36.55467	100	0	29	29	1
2025-06-21 07:06:36.608074	2025-06-21 07:06:36.614159	100	0	30	30	1
2025-06-21 07:06:36.67532	2025-06-21 07:06:36.682042	100	0	31	31	1
2025-06-21 07:06:36.725202	2025-06-21 07:06:36.731667	100	0	32	32	1
2025-06-21 07:06:36.771603	2025-06-21 07:06:36.776996	100	0	33	33	1
2025-06-21 07:06:36.827578	2025-06-21 07:06:36.833912	100	0	34	34	1
2025-06-21 07:06:36.910078	2025-06-21 07:06:36.916054	100	0	35	35	1
2025-06-21 07:06:36.969023	2025-06-21 07:06:36.974999	100	0	36	36	1
2025-06-21 07:06:37.023536	2025-06-21 07:06:37.029971	100	0	37	37	1
2025-06-21 07:06:37.081606	2025-06-21 07:06:37.087408	100	0	38	38	1
2025-06-21 07:06:37.136294	2025-06-21 07:06:37.142994	100	0	39	39	1
2025-06-21 07:06:37.197202	2025-06-21 07:06:37.203703	100	0	40	40	1
2025-06-21 07:06:37.258419	2025-06-21 07:06:37.264504	100	0	41	41	1
2025-06-21 07:06:37.317112	2025-06-21 07:06:37.323516	100	0	42	42	1
2025-06-21 07:06:37.448462	2025-06-21 07:06:37.453682	100	0	43	43	1
2025-06-21 07:06:37.471849	2025-06-21 07:06:37.478486	100	0	44	44	1
2025-06-21 07:06:37.492325	2025-06-21 07:06:37.497908	100	0	45	45	1
2025-06-21 07:06:37.510894	2025-06-21 07:06:37.517002	100	0	46	46	1
2025-06-21 07:06:37.608282	2025-06-21 07:06:37.614225	100	0	47	47	1
2025-06-21 07:06:37.628265	2025-06-21 07:06:37.634247	100	0	48	48	1
2025-06-21 07:06:37.648695	2025-06-21 07:06:37.65407	100	0	49	49	1
2025-06-21 07:06:37.666372	2025-06-21 07:06:37.672561	100	0	50	50	1
2025-06-21 07:06:37.758155	2025-06-21 07:06:37.76362	100	0	51	51	1
2025-06-21 07:06:37.778002	2025-06-21 07:06:37.784194	100	0	52	52	1
2025-06-21 07:06:37.795726	2025-06-21 07:06:37.801217	100	0	53	53	1
2025-06-21 07:06:37.815291	2025-06-21 07:06:37.82108	100	0	54	54	1
2025-06-21 07:06:37.896039	2025-06-21 07:06:37.901856	100	0	55	55	1
2025-06-21 07:06:37.915013	2025-06-21 07:06:37.920737	100	0	56	56	1
2025-06-21 07:06:37.933908	2025-06-21 07:06:37.939971	100	0	57	57	1
2025-06-21 07:06:37.953165	2025-06-21 07:06:37.959283	100	0	58	58	1
2025-06-21 07:06:38.02723	2025-06-21 07:06:38.032762	100	0	59	59	1
2025-06-21 07:06:38.047062	2025-06-21 07:06:38.052775	100	0	60	60	1
2025-06-21 07:06:38.069378	2025-06-21 07:06:38.075818	100	0	61	61	1
2025-06-21 07:06:38.088876	2025-06-21 07:06:38.094196	100	0	62	62	1
2025-06-21 07:06:38.199756	2025-06-21 07:06:38.207362	100	0	63	63	1
2025-06-21 07:06:38.22228	2025-06-21 07:06:38.228993	100	0	64	64	1
2025-06-21 07:06:38.243084	2025-06-21 07:06:38.248962	100	0	65	65	1
2025-06-21 07:06:38.262492	2025-06-21 07:06:38.269493	100	0	66	66	1
2025-06-21 07:06:38.357769	2025-06-21 07:06:38.363798	100	0	67	67	1
2025-06-21 07:06:38.418617	2025-06-21 07:06:38.424847	100	0	68	68	1
2025-06-21 07:06:38.471036	2025-06-21 07:06:38.477257	100	0	69	69	1
2025-06-21 07:06:38.523165	2025-06-21 07:06:38.529104	100	0	70	70	1
2025-06-21 07:08:25.134252	2025-06-21 07:08:25.140668	100	0	71	71	1
2025-06-21 07:08:25.18752	2025-06-21 07:08:25.193711	100	0	72	72	1
2025-06-21 07:06:38.685978	2025-06-21 07:06:38.694207	100	0	73	73	1
2025-06-21 07:06:38.744818	2025-06-21 07:06:38.751355	100	0	74	74	1
2025-06-21 07:06:38.816606	2025-06-21 07:06:38.824512	100	0	75	75	1
2025-06-21 07:06:38.876316	2025-06-21 07:06:38.883625	100	0	76	76	1
2025-06-21 07:06:38.926447	2025-06-21 07:06:38.9329	100	0	77	77	1
2025-06-21 07:06:38.984778	2025-06-21 07:06:38.99272	100	0	78	78	1
2025-06-21 07:06:39.054545	2025-06-21 07:06:39.062141	100	0	79	79	1
2025-06-21 07:06:39.107904	2025-06-21 07:06:39.114262	100	0	80	80	1
2025-06-21 07:06:39.170366	2025-06-21 07:06:39.176224	100	0	81	81	1
2025-06-21 07:06:39.220912	2025-06-21 07:06:39.226925	100	0	82	82	1
2025-06-21 07:06:39.268745	2025-06-21 07:06:39.274607	100	0	83	83	1
2025-06-21 07:06:39.314314	2025-06-21 07:06:39.319648	100	0	84	84	1
2025-06-21 07:06:39.371334	2025-06-21 07:06:39.37746	100	0	85	85	1
2025-06-21 07:06:39.454332	2025-06-21 07:06:39.460792	100	0	86	86	1
2025-06-21 07:06:39.489941	2025-06-21 07:06:39.496214	100	0	87	87	1
2025-06-21 07:06:39.514108	2025-06-21 07:06:39.520315	100	0	88	88	1
\.


--
-- Data for Name: stock_location; Type: TABLE DATA; Schema: public; Owner: vendure
--

COPY public.stock_location ("createdAt", "updatedAt", name, description, id) FROM stdin;
2025-06-21 07:06:32.160052	2025-06-21 07:06:32.160052	Default Stock Location	The default stock location	1
\.


--
-- Data for Name: stock_location_channels_channel; Type: TABLE DATA; Schema: public; Owner: vendure
--

COPY public.stock_location_channels_channel ("stockLocationId", "channelId") FROM stdin;
1	1
\.


--
-- Data for Name: stock_movement; Type: TABLE DATA; Schema: public; Owner: vendure
--

COPY public.stock_movement ("createdAt", "updatedAt", type, quantity, id, "stockLocationId", discriminator, "productVariantId", "orderLineId") FROM stdin;
2025-06-21 07:06:35.232384	2025-06-21 07:06:35.232384	ADJUSTMENT	100	1	1	StockAdjustment	1	\N
2025-06-21 07:06:35.262299	2025-06-21 07:06:35.262299	ADJUSTMENT	100	2	1	StockAdjustment	2	\N
2025-06-21 07:06:35.284437	2025-06-21 07:06:35.284437	ADJUSTMENT	100	3	1	StockAdjustment	3	\N
2025-06-21 07:06:35.306154	2025-06-21 07:06:35.306154	ADJUSTMENT	100	4	1	StockAdjustment	4	\N
2025-06-21 07:06:35.38223	2025-06-21 07:06:35.38223	ADJUSTMENT	100	5	1	StockAdjustment	5	\N
2025-06-21 07:06:35.409191	2025-06-21 07:06:35.409191	ADJUSTMENT	100	6	1	StockAdjustment	6	\N
2025-06-21 07:06:35.480323	2025-06-21 07:06:35.480323	ADJUSTMENT	100	7	1	StockAdjustment	7	\N
2025-06-21 07:06:35.551767	2025-06-21 07:06:35.551767	ADJUSTMENT	100	8	1	StockAdjustment	8	\N
2025-06-21 07:06:35.627666	2025-06-21 07:06:35.627666	ADJUSTMENT	100	9	1	StockAdjustment	9	\N
2025-06-21 07:06:35.651924	2025-06-21 07:06:35.651924	ADJUSTMENT	100	10	1	StockAdjustment	10	\N
2025-06-21 07:06:35.751764	2025-06-21 07:06:35.751764	ADJUSTMENT	100	11	1	StockAdjustment	11	\N
2025-06-21 07:06:35.771685	2025-06-21 07:06:35.771685	ADJUSTMENT	100	12	1	StockAdjustment	12	\N
2025-06-21 07:06:35.793569	2025-06-21 07:06:35.793569	ADJUSTMENT	100	13	1	StockAdjustment	13	\N
2025-06-21 07:06:35.901389	2025-06-21 07:06:35.901389	ADJUSTMENT	100	14	1	StockAdjustment	14	\N
2025-06-21 07:06:35.921572	2025-06-21 07:06:35.921572	ADJUSTMENT	100	15	1	StockAdjustment	15	\N
2025-06-21 07:06:35.941213	2025-06-21 07:06:35.941213	ADJUSTMENT	100	16	1	StockAdjustment	16	\N
2025-06-21 07:06:35.959987	2025-06-21 07:06:35.959987	ADJUSTMENT	100	17	1	StockAdjustment	17	\N
2025-06-21 07:06:36.063723	2025-06-21 07:06:36.063723	ADJUSTMENT	100	18	1	StockAdjustment	18	\N
2025-06-21 07:06:36.083579	2025-06-21 07:06:36.083579	ADJUSTMENT	100	19	1	StockAdjustment	19	\N
2025-06-21 07:06:36.102231	2025-06-21 07:06:36.102231	ADJUSTMENT	100	20	1	StockAdjustment	20	\N
2025-06-21 07:06:36.122641	2025-06-21 07:06:36.122641	ADJUSTMENT	100	21	1	StockAdjustment	21	\N
2025-06-21 07:06:36.142685	2025-06-21 07:06:36.142685	ADJUSTMENT	100	22	1	StockAdjustment	22	\N
2025-06-21 07:06:36.195489	2025-06-21 07:06:36.195489	ADJUSTMENT	100	23	1	StockAdjustment	23	\N
2025-06-21 07:06:36.259074	2025-06-21 07:06:36.259074	ADJUSTMENT	100	24	1	StockAdjustment	24	\N
2025-06-21 07:06:36.305721	2025-06-21 07:06:36.305721	ADJUSTMENT	100	25	1	StockAdjustment	25	\N
2025-06-21 07:06:36.370749	2025-06-21 07:06:36.370749	ADJUSTMENT	100	26	1	StockAdjustment	26	\N
2025-06-21 07:06:36.434329	2025-06-21 07:06:36.434329	ADJUSTMENT	100	27	1	StockAdjustment	27	\N
2025-06-21 07:06:36.497374	2025-06-21 07:06:36.497374	ADJUSTMENT	100	28	1	StockAdjustment	28	\N
2025-06-21 07:06:36.551715	2025-06-21 07:06:36.551715	ADJUSTMENT	100	29	1	StockAdjustment	29	\N
2025-06-21 07:06:36.610777	2025-06-21 07:06:36.610777	ADJUSTMENT	100	30	1	StockAdjustment	30	\N
2025-06-21 07:06:36.678145	2025-06-21 07:06:36.678145	ADJUSTMENT	100	31	1	StockAdjustment	31	\N
2025-06-21 07:06:36.727901	2025-06-21 07:06:36.727901	ADJUSTMENT	100	32	1	StockAdjustment	32	\N
2025-06-21 07:06:36.77385	2025-06-21 07:06:36.77385	ADJUSTMENT	100	33	1	StockAdjustment	33	\N
2025-06-21 07:06:36.830112	2025-06-21 07:06:36.830112	ADJUSTMENT	100	34	1	StockAdjustment	34	\N
2025-06-21 07:06:36.912529	2025-06-21 07:06:36.912529	ADJUSTMENT	100	35	1	StockAdjustment	35	\N
2025-06-21 07:06:36.971419	2025-06-21 07:06:36.971419	ADJUSTMENT	100	36	1	StockAdjustment	36	\N
2025-06-21 07:06:37.025937	2025-06-21 07:06:37.025937	ADJUSTMENT	100	37	1	StockAdjustment	37	\N
2025-06-21 07:06:37.084102	2025-06-21 07:06:37.084102	ADJUSTMENT	100	38	1	StockAdjustment	38	\N
2025-06-21 07:06:37.139483	2025-06-21 07:06:37.139483	ADJUSTMENT	100	39	1	StockAdjustment	39	\N
2025-06-21 07:06:37.19989	2025-06-21 07:06:37.19989	ADJUSTMENT	100	40	1	StockAdjustment	40	\N
2025-06-21 07:06:37.260967	2025-06-21 07:06:37.260967	ADJUSTMENT	100	41	1	StockAdjustment	41	\N
2025-06-21 07:06:37.319954	2025-06-21 07:06:37.319954	ADJUSTMENT	100	42	1	StockAdjustment	42	\N
2025-06-21 07:06:37.450617	2025-06-21 07:06:37.450617	ADJUSTMENT	100	43	1	StockAdjustment	43	\N
2025-06-21 07:06:37.474893	2025-06-21 07:06:37.474893	ADJUSTMENT	100	44	1	StockAdjustment	44	\N
2025-06-21 07:06:37.494786	2025-06-21 07:06:37.494786	ADJUSTMENT	100	45	1	StockAdjustment	45	\N
2025-06-21 07:06:37.51364	2025-06-21 07:06:37.51364	ADJUSTMENT	100	46	1	StockAdjustment	46	\N
2025-06-21 07:06:37.610835	2025-06-21 07:06:37.610835	ADJUSTMENT	100	47	1	StockAdjustment	47	\N
2025-06-21 07:06:37.630715	2025-06-21 07:06:37.630715	ADJUSTMENT	100	48	1	StockAdjustment	48	\N
2025-06-21 07:06:37.650917	2025-06-21 07:06:37.650917	ADJUSTMENT	100	49	1	StockAdjustment	49	\N
2025-06-21 07:06:37.669037	2025-06-21 07:06:37.669037	ADJUSTMENT	100	50	1	StockAdjustment	50	\N
2025-06-21 07:06:37.76027	2025-06-21 07:06:37.76027	ADJUSTMENT	100	51	1	StockAdjustment	51	\N
2025-06-21 07:06:37.780512	2025-06-21 07:06:37.780512	ADJUSTMENT	100	52	1	StockAdjustment	52	\N
2025-06-21 07:06:37.797813	2025-06-21 07:06:37.797813	ADJUSTMENT	100	53	1	StockAdjustment	53	\N
2025-06-21 07:06:37.817609	2025-06-21 07:06:37.817609	ADJUSTMENT	100	54	1	StockAdjustment	54	\N
2025-06-21 07:06:37.898537	2025-06-21 07:06:37.898537	ADJUSTMENT	100	55	1	StockAdjustment	55	\N
2025-06-21 07:06:37.917428	2025-06-21 07:06:37.917428	ADJUSTMENT	100	56	1	StockAdjustment	56	\N
2025-06-21 07:06:37.936371	2025-06-21 07:06:37.936371	ADJUSTMENT	100	57	1	StockAdjustment	57	\N
2025-06-21 07:06:37.955564	2025-06-21 07:06:37.955564	ADJUSTMENT	100	58	1	StockAdjustment	58	\N
2025-06-21 07:06:38.029535	2025-06-21 07:06:38.029535	ADJUSTMENT	100	59	1	StockAdjustment	59	\N
2025-06-21 07:06:38.049503	2025-06-21 07:06:38.049503	ADJUSTMENT	100	60	1	StockAdjustment	60	\N
2025-06-21 07:06:38.072105	2025-06-21 07:06:38.072105	ADJUSTMENT	100	61	1	StockAdjustment	61	\N
2025-06-21 07:06:38.091478	2025-06-21 07:06:38.091478	ADJUSTMENT	100	62	1	StockAdjustment	62	\N
2025-06-21 07:06:38.202653	2025-06-21 07:06:38.202653	ADJUSTMENT	100	63	1	StockAdjustment	63	\N
2025-06-21 07:06:38.224867	2025-06-21 07:06:38.224867	ADJUSTMENT	100	64	1	StockAdjustment	64	\N
2025-06-21 07:06:38.24543	2025-06-21 07:06:38.24543	ADJUSTMENT	100	65	1	StockAdjustment	65	\N
2025-06-21 07:06:38.265499	2025-06-21 07:06:38.265499	ADJUSTMENT	100	66	1	StockAdjustment	66	\N
2025-06-21 07:06:38.360322	2025-06-21 07:06:38.360322	ADJUSTMENT	100	67	1	StockAdjustment	67	\N
2025-06-21 07:06:38.421176	2025-06-21 07:06:38.421176	ADJUSTMENT	100	68	1	StockAdjustment	68	\N
2025-06-21 07:06:38.473946	2025-06-21 07:06:38.473946	ADJUSTMENT	100	69	1	StockAdjustment	69	\N
2025-06-21 07:06:38.5254	2025-06-21 07:06:38.5254	ADJUSTMENT	100	70	1	StockAdjustment	70	\N
2025-06-21 07:08:25.136612	2025-06-21 07:08:25.136612	ADJUSTMENT	100	71	1	StockAdjustment	71	\N
2025-06-21 07:08:25.189808	2025-06-21 07:08:25.189808	ADJUSTMENT	100	72	1	StockAdjustment	72	\N
2025-06-21 07:06:38.689501	2025-06-21 07:06:38.689501	ADJUSTMENT	100	73	1	StockAdjustment	73	\N
2025-06-21 07:06:38.747627	2025-06-21 07:06:38.747627	ADJUSTMENT	100	74	1	StockAdjustment	74	\N
2025-06-21 07:06:38.820477	2025-06-21 07:06:38.820477	ADJUSTMENT	100	75	1	StockAdjustment	75	\N
2025-06-21 07:06:38.879047	2025-06-21 07:06:38.879047	ADJUSTMENT	100	76	1	StockAdjustment	76	\N
2025-06-21 07:06:38.929027	2025-06-21 07:06:38.929027	ADJUSTMENT	100	77	1	StockAdjustment	77	\N
2025-06-21 07:06:38.987904	2025-06-21 07:06:38.987904	ADJUSTMENT	100	78	1	StockAdjustment	78	\N
2025-06-21 07:06:39.057773	2025-06-21 07:06:39.057773	ADJUSTMENT	100	79	1	StockAdjustment	79	\N
2025-06-21 07:06:39.110393	2025-06-21 07:06:39.110393	ADJUSTMENT	100	80	1	StockAdjustment	80	\N
2025-06-21 07:06:39.173002	2025-06-21 07:06:39.173002	ADJUSTMENT	100	81	1	StockAdjustment	81	\N
2025-06-21 07:06:39.223354	2025-06-21 07:06:39.223354	ADJUSTMENT	100	82	1	StockAdjustment	82	\N
2025-06-21 07:06:39.316516	2025-06-21 07:06:39.316516	ADJUSTMENT	100	84	1	StockAdjustment	84	\N
2025-06-21 07:06:39.271093	2025-06-21 07:06:39.271093	ADJUSTMENT	100	83	1	StockAdjustment	83	\N
2025-06-21 07:06:39.492315	2025-06-21 07:06:39.492315	ADJUSTMENT	100	87	1	StockAdjustment	87	\N
2025-06-21 07:06:39.373706	2025-06-21 07:06:39.373706	ADJUSTMENT	100	85	1	StockAdjustment	85	\N
2025-06-21 07:06:39.456708	2025-06-21 07:06:39.456708	ADJUSTMENT	100	86	1	StockAdjustment	86	\N
2025-06-21 07:06:39.516875	2025-06-21 07:06:39.516875	ADJUSTMENT	100	88	1	StockAdjustment	88	\N
\.


--
-- Data for Name: surcharge; Type: TABLE DATA; Schema: public; Owner: vendure
--

COPY public.surcharge ("createdAt", "updatedAt", description, "listPriceIncludesTax", sku, "taxLines", id, "listPrice", "orderId", "orderModificationId") FROM stdin;
\.


--
-- Data for Name: tag; Type: TABLE DATA; Schema: public; Owner: vendure
--

COPY public.tag ("createdAt", "updatedAt", value, id) FROM stdin;
\.


--
-- Data for Name: tax_category; Type: TABLE DATA; Schema: public; Owner: vendure
--

COPY public.tax_category ("createdAt", "updatedAt", name, "isDefault", id) FROM stdin;
2025-06-21 07:06:34.776582	2025-06-21 07:06:34.776582	Standard Tax	f	1
2025-06-21 07:06:34.833775	2025-06-21 07:06:34.833775	Reduced Tax	f	2
2025-06-21 07:06:34.881201	2025-06-21 07:06:34.881201	Zero Tax	f	3
\.


--
-- Data for Name: tax_rate; Type: TABLE DATA; Schema: public; Owner: vendure
--

COPY public.tax_rate ("createdAt", "updatedAt", name, enabled, value, id, "categoryId", "zoneId", "customerGroupId") FROM stdin;
2025-06-21 07:06:34.789453	2025-06-21 07:06:34.789453	Standard Tax Asia	t	20.00	1	1	1	\N
2025-06-21 07:06:34.802479	2025-06-21 07:06:34.802479	Standard Tax Europe	t	20.00	2	1	2	\N
2025-06-21 07:06:34.811699	2025-06-21 07:06:34.811699	Standard Tax Africa	t	20.00	3	1	3	\N
2025-06-21 07:06:34.819465	2025-06-21 07:06:34.819465	Standard Tax Oceania	t	20.00	4	1	4	\N
2025-06-21 07:06:34.827553	2025-06-21 07:06:34.827553	Standard Tax Americas	t	20.00	5	1	5	\N
2025-06-21 07:06:34.838549	2025-06-21 07:06:34.838549	Reduced Tax Asia	t	10.00	6	2	1	\N
2025-06-21 07:06:34.847498	2025-06-21 07:06:34.847498	Reduced Tax Europe	t	10.00	7	2	2	\N
2025-06-21 07:06:34.85623	2025-06-21 07:06:34.85623	Reduced Tax Africa	t	10.00	8	2	3	\N
2025-06-21 07:06:34.864327	2025-06-21 07:06:34.864327	Reduced Tax Oceania	t	10.00	9	2	4	\N
2025-06-21 07:06:34.873394	2025-06-21 07:06:34.873394	Reduced Tax Americas	t	10.00	10	2	5	\N
2025-06-21 07:06:34.886626	2025-06-21 07:06:34.886626	Zero Tax Asia	t	0.00	11	3	1	\N
2025-06-21 07:06:34.894882	2025-06-21 07:06:34.894882	Zero Tax Europe	t	0.00	12	3	2	\N
2025-06-21 07:06:34.90331	2025-06-21 07:06:34.90331	Zero Tax Africa	t	0.00	13	3	3	\N
2025-06-21 07:06:34.912622	2025-06-21 07:06:34.912622	Zero Tax Oceania	t	0.00	14	3	4	\N
2025-06-21 07:06:34.921639	2025-06-21 07:06:34.921639	Zero Tax Americas	t	0.00	15	3	5	\N
\.


--
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: vendure
--

COPY public."user" ("createdAt", "updatedAt", "deletedAt", identifier, verified, "lastLogin", id) FROM stdin;
2025-06-21 07:06:32.127574	2025-06-21 07:06:32.127574	\N	superadmin	t	\N	1
\.


--
-- Data for Name: user_roles_role; Type: TABLE DATA; Schema: public; Owner: vendure
--

COPY public.user_roles_role ("userId", "roleId") FROM stdin;
1	1
\.


--
-- Data for Name: zone; Type: TABLE DATA; Schema: public; Owner: vendure
--

COPY public.zone ("createdAt", "updatedAt", name, id) FROM stdin;
2025-06-21 07:06:32.547702	2025-06-21 07:06:32.547702	Asia	1
2025-06-21 07:06:32.569266	2025-06-21 07:06:32.569266	Europe	2
2025-06-21 07:06:32.595025	2025-06-21 07:06:32.595025	Africa	3
2025-06-21 07:06:32.61173	2025-06-21 07:06:32.61173	Oceania	4
2025-06-21 07:06:32.645438	2025-06-21 07:06:32.645438	Americas	5
\.


--
-- Data for Name: zone_members_region; Type: TABLE DATA; Schema: public; Owner: vendure
--

COPY public.zone_members_region ("zoneId", "regionId") FROM stdin;
1	1
1	11
1	15
1	17
1	18
1	25
1	33
1	38
1	45
1	58
1	82
1	100
1	103
1	104
1	105
1	106
1	109
1	112
1	114
1	115
1	118
1	119
1	120
1	121
1	122
1	124
1	131
1	135
1	136
1	148
1	153
1	156
1	167
1	168
1	170
1	175
1	180
1	195
1	200
1	210
1	216
1	217
1	218
1	220
1	221
1	227
1	228
1	233
1	238
1	241
1	246
2	2
2	3
2	6
2	14
2	20
2	21
2	28
2	34
2	55
2	59
2	60
2	69
2	73
2	75
2	76
2	83
2	85
2	86
2	92
2	98
2	101
2	102
2	107
2	108
2	110
2	113
2	123
2	128
2	129
2	130
2	132
2	138
2	146
2	147
2	149
2	157
2	166
2	177
2	178
2	182
2	183
2	193
2	197
2	202
2	203
2	209
2	213
2	214
2	215
2	232
2	234
3	4
3	7
3	23
3	29
3	32
3	35
3	36
3	37
3	39
3	42
3	43
3	49
3	50
3	51
3	54
3	61
3	65
3	67
3	68
3	70
3	71
3	79
3	80
3	81
3	84
3	93
3	94
3	116
3	125
3	126
3	127
3	133
3	134
3	137
3	141
3	142
3	143
3	151
3	152
3	154
3	161
3	162
3	181
3	184
3	186
3	194
3	196
3	198
3	199
3	205
3	206
3	208
3	211
3	219
3	222
3	226
3	231
3	245
3	247
3	248
4	5
4	13
4	46
4	47
4	52
4	74
4	78
4	90
4	97
4	117
4	139
4	145
4	155
4	158
4	159
4	163
4	164
4	165
4	169
4	172
4	176
4	192
4	204
4	223
4	224
4	230
4	236
4	239
4	244
5	8
5	9
5	10
5	12
5	16
5	19
5	22
5	24
5	26
5	27
5	30
5	31
5	40
5	41
5	44
5	48
5	53
5	56
5	57
5	62
5	63
5	64
5	66
5	72
5	77
5	87
5	88
5	89
5	91
5	95
5	96
5	99
5	111
5	140
5	144
5	150
5	160
5	171
5	173
5	174
5	179
5	185
5	187
5	188
5	189
5	190
5	191
5	201
5	207
5	212
5	225
5	229
5	235
5	237
5	240
5	242
5	243
\.


--
-- Name: address_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vendure
--

SELECT pg_catalog.setval('public.address_id_seq', 1, false);


--
-- Name: administrator_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vendure
--

SELECT pg_catalog.setval('public.administrator_id_seq', 1, true);


--
-- Name: asset_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vendure
--

SELECT pg_catalog.setval('public.asset_id_seq', 54, true);


--
-- Name: authentication_method_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vendure
--

SELECT pg_catalog.setval('public.authentication_method_id_seq', 1, true);


--
-- Name: channel_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vendure
--

SELECT pg_catalog.setval('public.channel_id_seq', 1, true);


--
-- Name: collection_asset_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vendure
--

SELECT pg_catalog.setval('public.collection_asset_id_seq', 9, true);


--
-- Name: collection_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vendure
--

SELECT pg_catalog.setval('public.collection_id_seq', 10, true);


--
-- Name: collection_translation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vendure
--

SELECT pg_catalog.setval('public.collection_translation_id_seq', 10, true);


--
-- Name: customer_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vendure
--

SELECT pg_catalog.setval('public.customer_group_id_seq', 1, false);


--
-- Name: customer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vendure
--

SELECT pg_catalog.setval('public.customer_id_seq', 1, false);


--
-- Name: facet_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vendure
--

SELECT pg_catalog.setval('public.facet_id_seq', 4, true);


--
-- Name: facet_translation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vendure
--

SELECT pg_catalog.setval('public.facet_translation_id_seq', 4, true);


--
-- Name: facet_value_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vendure
--

SELECT pg_catalog.setval('public.facet_value_id_seq', 39, true);


--
-- Name: facet_value_translation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vendure
--

SELECT pg_catalog.setval('public.facet_value_translation_id_seq', 39, true);


--
-- Name: fulfillment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vendure
--

SELECT pg_catalog.setval('public.fulfillment_id_seq', 1, false);


--
-- Name: global_settings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vendure
--

SELECT pg_catalog.setval('public.global_settings_id_seq', 1, true);


--
-- Name: history_entry_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vendure
--

SELECT pg_catalog.setval('public.history_entry_id_seq', 1, false);


--
-- Name: job_record_buffer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vendure
--

SELECT pg_catalog.setval('public.job_record_buffer_id_seq', 1, false);


--
-- Name: job_record_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vendure
--

SELECT pg_catalog.setval('public.job_record_id_seq', 107, true);


--
-- Name: migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vendure
--

SELECT pg_catalog.setval('public.migrations_id_seq', 1, false);


--
-- Name: order_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vendure
--

SELECT pg_catalog.setval('public.order_id_seq', 1, false);


--
-- Name: order_line_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vendure
--

SELECT pg_catalog.setval('public.order_line_id_seq', 1, false);


--
-- Name: order_line_reference_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vendure
--

SELECT pg_catalog.setval('public.order_line_reference_id_seq', 1, false);


--
-- Name: order_modification_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vendure
--

SELECT pg_catalog.setval('public.order_modification_id_seq', 1, false);


--
-- Name: payment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vendure
--

SELECT pg_catalog.setval('public.payment_id_seq', 1, false);


--
-- Name: payment_method_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vendure
--

SELECT pg_catalog.setval('public.payment_method_id_seq', 1, true);


--
-- Name: payment_method_translation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vendure
--

SELECT pg_catalog.setval('public.payment_method_translation_id_seq', 1, true);


--
-- Name: product_asset_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vendure
--

SELECT pg_catalog.setval('public.product_asset_id_seq', 54, true);


--
-- Name: product_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vendure
--

SELECT pg_catalog.setval('public.product_id_seq', 54, true);


--
-- Name: product_option_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vendure
--

SELECT pg_catalog.setval('public.product_option_group_id_seq', 15, true);


--
-- Name: product_option_group_translation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vendure
--

SELECT pg_catalog.setval('public.product_option_group_translation_id_seq', 15, true);


--
-- Name: product_option_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vendure
--

SELECT pg_catalog.setval('public.product_option_id_seq', 47, true);


--
-- Name: product_option_translation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vendure
--

SELECT pg_catalog.setval('public.product_option_translation_id_seq', 47, true);


--
-- Name: product_translation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vendure
--

SELECT pg_catalog.setval('public.product_translation_id_seq', 54, true);


--
-- Name: product_variant_asset_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vendure
--

SELECT pg_catalog.setval('public.product_variant_asset_id_seq', 1, false);


--
-- Name: product_variant_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vendure
--

SELECT pg_catalog.setval('public.product_variant_id_seq', 88, true);


--
-- Name: product_variant_price_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vendure
--

SELECT pg_catalog.setval('public.product_variant_price_id_seq', 88, true);


--
-- Name: product_variant_translation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vendure
--

SELECT pg_catalog.setval('public.product_variant_translation_id_seq', 88, true);


--
-- Name: promotion_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vendure
--

SELECT pg_catalog.setval('public.promotion_id_seq', 1, false);


--
-- Name: promotion_translation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vendure
--

SELECT pg_catalog.setval('public.promotion_translation_id_seq', 1, false);


--
-- Name: refund_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vendure
--

SELECT pg_catalog.setval('public.refund_id_seq', 1, false);


--
-- Name: region_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vendure
--

SELECT pg_catalog.setval('public.region_id_seq', 248, true);


--
-- Name: region_translation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vendure
--

SELECT pg_catalog.setval('public.region_translation_id_seq', 248, true);


--
-- Name: role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vendure
--

SELECT pg_catalog.setval('public.role_id_seq', 5, true);


--
-- Name: scheduled_task_record_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vendure
--

SELECT pg_catalog.setval('public.scheduled_task_record_id_seq', 1, false);


--
-- Name: seller_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vendure
--

SELECT pg_catalog.setval('public.seller_id_seq', 1, true);


--
-- Name: session_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vendure
--

SELECT pg_catalog.setval('public.session_id_seq', 1, false);


--
-- Name: shipping_line_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vendure
--

SELECT pg_catalog.setval('public.shipping_line_id_seq', 1, false);


--
-- Name: shipping_method_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vendure
--

SELECT pg_catalog.setval('public.shipping_method_id_seq', 2, true);


--
-- Name: shipping_method_translation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vendure
--

SELECT pg_catalog.setval('public.shipping_method_translation_id_seq', 2, true);


--
-- Name: stock_level_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vendure
--

SELECT pg_catalog.setval('public.stock_level_id_seq', 88, true);


--
-- Name: stock_location_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vendure
--

SELECT pg_catalog.setval('public.stock_location_id_seq', 1, true);


--
-- Name: stock_movement_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vendure
--

SELECT pg_catalog.setval('public.stock_movement_id_seq', 88, true);


--
-- Name: surcharge_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vendure
--

SELECT pg_catalog.setval('public.surcharge_id_seq', 1, false);


--
-- Name: tag_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vendure
--

SELECT pg_catalog.setval('public.tag_id_seq', 1, false);


--
-- Name: tax_category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vendure
--

SELECT pg_catalog.setval('public.tax_category_id_seq', 3, true);


--
-- Name: tax_rate_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vendure
--

SELECT pg_catalog.setval('public.tax_rate_id_seq', 15, true);


--
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vendure
--

SELECT pg_catalog.setval('public.user_id_seq', 1, true);


--
-- Name: zone_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vendure
--

SELECT pg_catalog.setval('public.zone_id_seq', 5, true);


--
-- Name: order_promotions_promotion PK_001dfe7435f3946fbc2d66a4e92; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.order_promotions_promotion
    ADD CONSTRAINT "PK_001dfe7435f3946fbc2d66a4e92" PRIMARY KEY ("orderId", "promotionId");


--
-- Name: order_line PK_01a7c973d9f30479647e44f9892; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.order_line
    ADD CONSTRAINT "PK_01a7c973d9f30479647e44f9892" PRIMARY KEY (id);


--
-- Name: promotion_translation PK_0b4fd34d2fc7abc06189494a178; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.promotion_translation
    ADD CONSTRAINT "PK_0b4fd34d2fc7abc06189494a178" PRIMARY KEY (id);


--
-- Name: collection_channels_channel PK_0e292d80228c9b4a114d2b09476; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.collection_channels_channel
    ADD CONSTRAINT "PK_0e292d80228c9b4a114d2b09476" PRIMARY KEY ("collectionId", "channelId");


--
-- Name: customer_groups_customer_group PK_0f902789cba691ce7ebbc9fcaa6; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.customer_groups_customer_group
    ADD CONSTRAINT "PK_0f902789cba691ce7ebbc9fcaa6" PRIMARY KEY ("customerId", "customerGroupId");


--
-- Name: order PK_1031171c13130102495201e3e20; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT "PK_1031171c13130102495201e3e20" PRIMARY KEY (id);


--
-- Name: asset PK_1209d107fe21482beaea51b745e; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.asset
    ADD CONSTRAINT "PK_1209d107fe21482beaea51b745e" PRIMARY KEY (id);


--
-- Name: product_variant_channels_channel PK_1a10ca648c3d73c0f2b455ae191; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.product_variant_channels_channel
    ADD CONSTRAINT "PK_1a10ca648c3d73c0f2b455ae191" PRIMARY KEY ("productVariantId", "channelId");


--
-- Name: product_variant PK_1ab69c9935c61f7c70791ae0a9f; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.product_variant
    ADD CONSTRAINT "PK_1ab69c9935c61f7c70791ae0a9f" PRIMARY KEY (id);


--
-- Name: order_line_reference PK_21891d07accb8fa87e11165bca2; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.order_line_reference
    ADD CONSTRAINT "PK_21891d07accb8fa87e11165bca2" PRIMARY KEY (id);


--
-- Name: tax_rate PK_23b71b53f650c0b39e99ccef4fd; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.tax_rate
    ADD CONSTRAINT "PK_23b71b53f650c0b39e99ccef4fd" PRIMARY KEY (id);


--
-- Name: tax_category PK_2432988f825c336d5584a96cded; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.tax_category
    ADD CONSTRAINT "PK_2432988f825c336d5584a96cded" PRIMARY KEY (id);


--
-- Name: customer_channels_channel PK_27e2fa538c020889d32a0a784e8; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.customer_channels_channel
    ADD CONSTRAINT "PK_27e2fa538c020889d32a0a784e8" PRIMARY KEY ("customerId", "channelId");


--
-- Name: seller PK_36445a9c6e794945a4a4a8d3c9d; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.seller
    ADD CONSTRAINT "PK_36445a9c6e794945a4a4a8d3c9d" PRIMARY KEY (id);


--
-- Name: order_channels_channel PK_39853134b20afe9dfb25de18292; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.order_channels_channel
    ADD CONSTRAINT "PK_39853134b20afe9dfb25de18292" PRIMARY KEY ("orderId", "channelId");


--
-- Name: region_translation PK_3e0c9619cafbe579eeecfd88abc; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.region_translation
    ADD CONSTRAINT "PK_3e0c9619cafbe579eeecfd88abc" PRIMARY KEY (id);


--
-- Name: order_fulfillments_fulfillment PK_414600087d71aee1583bc517590; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.order_fulfillments_fulfillment
    ADD CONSTRAINT "PK_414600087d71aee1583bc517590" PRIMARY KEY ("orderId", "fulfillmentId");


--
-- Name: product_option_group_translation PK_44ab19f118175288dff147c4a00; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.product_option_group_translation
    ADD CONSTRAINT "PK_44ab19f118175288dff147c4a00" PRIMARY KEY (id);


--
-- Name: promotion_channels_channel PK_4b34f9b7bf95a8d3dc7f7f6dd23; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.promotion_channels_channel
    ADD CONSTRAINT "PK_4b34f9b7bf95a8d3dc7f7f6dd23" PRIMARY KEY ("promotionId", "channelId");


--
-- Name: product_variant_translation PK_4b7f882e2b669800bed7ed065f0; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.product_variant_translation
    ADD CONSTRAINT "PK_4b7f882e2b669800bed7ed065f0" PRIMARY KEY (id);


--
-- Name: product_option PK_4cf3c467e9bc764bdd32c4cd938; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.product_option
    ADD CONSTRAINT "PK_4cf3c467e9bc764bdd32c4cd938" PRIMARY KEY (id);


--
-- Name: fulfillment PK_50c102da132afffae660585981f; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.fulfillment
    ADD CONSTRAINT "PK_50c102da132afffae660585981f" PRIMARY KEY (id);


--
-- Name: collection_product_variants_product_variant PK_50c5ed0504ded53967be811f633; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.collection_product_variants_product_variant
    ADD CONSTRAINT "PK_50c5ed0504ded53967be811f633" PRIMARY KEY ("collectionId", "productVariantId");


--
-- Name: channel PK_590f33ee6ee7d76437acf362e39; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.channel
    ADD CONSTRAINT "PK_590f33ee6ee7d76437acf362e39" PRIMARY KEY (id);


--
-- Name: region PK_5f48ffc3af96bc486f5f3f3a6da; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.region
    ADD CONSTRAINT "PK_5f48ffc3af96bc486f5f3f3a6da" PRIMARY KEY (id);


--
-- Name: product_translation PK_62d00fbc92e7a495701d6fee9d5; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.product_translation
    ADD CONSTRAINT "PK_62d00fbc92e7a495701d6fee9d5" PRIMARY KEY (id);


--
-- Name: search_index_item PK_6470dd173311562c89e5f80b30e; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.search_index_item
    ADD CONSTRAINT "PK_6470dd173311562c89e5f80b30e" PRIMARY KEY ("languageCode", "productVariantId", "channelId");


--
-- Name: facet_value_channels_channel PK_653fb72a256f100f52c573e419f; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.facet_value_channels_channel
    ADD CONSTRAINT "PK_653fb72a256f100f52c573e419f" PRIMARY KEY ("facetValueId", "channelId");


--
-- Name: product_option_translation PK_69c79a84baabcad3c7328576ac0; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.product_option_translation
    ADD CONSTRAINT "PK_69c79a84baabcad3c7328576ac0" PRIMARY KEY (id);


--
-- Name: role_channels_channel PK_6fb9277e9f11bb8a63445c36242; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.role_channels_channel
    ADD CONSTRAINT "PK_6fb9277e9f11bb8a63445c36242" PRIMARY KEY ("roleId", "channelId");


--
-- Name: product_channels_channel PK_722acbcc06403e693b518d2c345; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.product_channels_channel
    ADD CONSTRAINT "PK_722acbcc06403e693b518d2c345" PRIMARY KEY ("productId", "channelId");


--
-- Name: payment_method PK_7744c2b2dd932c9cf42f2b9bc3a; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.payment_method
    ADD CONSTRAINT "PK_7744c2b2dd932c9cf42f2b9bc3a" PRIMARY KEY (id);


--
-- Name: job_record PK_88ce3ea0c9dca8b571450b457a7; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.job_record
    ADD CONSTRAINT "PK_88ce3ea0c9dca8b571450b457a7" PRIMARY KEY (id);


--
-- Name: customer_group PK_88e7da3ff7262d9e0a35aa3664e; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.customer_group
    ADD CONSTRAINT "PK_88e7da3ff7262d9e0a35aa3664e" PRIMARY KEY (id);


--
-- Name: stock_level PK_88ff7d9dfb57dc9d435e365eb69; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.stock_level
    ADD CONSTRAINT "PK_88ff7d9dfb57dc9d435e365eb69" PRIMARY KEY (id);


--
-- Name: shipping_line PK_890522bfc44a4b6eb7cb1e52609; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.shipping_line
    ADD CONSTRAINT "PK_890522bfc44a4b6eb7cb1e52609" PRIMARY KEY (id);


--
-- Name: migrations PK_8c82d7f526340ab734260ea46be; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.migrations
    ADD CONSTRAINT "PK_8c82d7f526340ab734260ea46be" PRIMARY KEY (id);


--
-- Name: tag PK_8e4052373c579afc1471f526760; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.tag
    ADD CONSTRAINT "PK_8e4052373c579afc1471f526760" PRIMARY KEY (id);


--
-- Name: job_record_buffer PK_9a1cfa02511065b32053efceeff; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.job_record_buffer
    ADD CONSTRAINT "PK_9a1cfa02511065b32053efceeff" PRIMARY KEY (id);


--
-- Name: collection_closure PK_9dda38e2273a7744b8f655782a5; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.collection_closure
    ADD CONSTRAINT "PK_9dda38e2273a7744b8f655782a5" PRIMARY KEY (id_ancestor, id_descendant);


--
-- Name: stock_movement PK_9fe1232f916686ae8cf00294749; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.stock_movement
    ADD CONSTRAINT "PK_9fe1232f916686ae8cf00294749" PRIMARY KEY (id);


--
-- Name: facet_value_translation PK_a09fdeb788deff7a9ed827a6160; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.facet_value_translation
    ADD CONSTRAINT "PK_a09fdeb788deff7a9ed827a6160" PRIMARY KEY (id);


--
-- Name: facet PK_a0ebfe3c68076820c6886aa9ff3; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.facet
    ADD CONSTRAINT "PK_a0ebfe3c68076820c6886aa9ff3" PRIMARY KEY (id);


--
-- Name: product_variant_facet_values_facet_value PK_a28474836b2feeffcef98c806e1; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.product_variant_facet_values_facet_value
    ADD CONSTRAINT "PK_a28474836b2feeffcef98c806e1" PRIMARY KEY ("productVariantId", "facetValueId");


--
-- Name: collection_asset PK_a2adab6fd086adfb7858f1f110c; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.collection_asset
    ADD CONSTRAINT "PK_a2adab6fd086adfb7858f1f110c" PRIMARY KEY (id);


--
-- Name: surcharge PK_a62b89257bcc802b5d77346f432; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.surcharge
    ADD CONSTRAINT "PK_a62b89257bcc802b5d77346f432" PRIMARY KEY (id);


--
-- Name: facet_translation PK_a6902cc1dcbb5e52a980f0189ad; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.facet_translation
    ADD CONSTRAINT "PK_a6902cc1dcbb5e52a980f0189ad" PRIMARY KEY (id);


--
-- Name: customer PK_a7a13f4cacb744524e44dfdad32; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.customer
    ADD CONSTRAINT "PK_a7a13f4cacb744524e44dfdad32" PRIMARY KEY (id);


--
-- Name: collection PK_ad3f485bbc99d875491f44d7c85; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.collection
    ADD CONSTRAINT "PK_ad3f485bbc99d875491f44d7c85" PRIMARY KEY (id);


--
-- Name: stock_location PK_adf770067d0df1421f525fa25cc; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.stock_location
    ADD CONSTRAINT "PK_adf770067d0df1421f525fa25cc" PRIMARY KEY (id);


--
-- Name: payment_method_translation PK_ae5ae0af71ae8d15da9eb75768b; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.payment_method_translation
    ADD CONSTRAINT "PK_ae5ae0af71ae8d15da9eb75768b" PRIMARY KEY (id);


--
-- Name: role PK_b36bcfe02fc8de3c57a8b2391c2; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.role
    ADD CONSTRAINT "PK_b36bcfe02fc8de3c57a8b2391c2" PRIMARY KEY (id);


--
-- Name: user_roles_role PK_b47cd6c84ee205ac5a713718292; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.user_roles_role
    ADD CONSTRAINT "PK_b47cd6c84ee205ac5a713718292" PRIMARY KEY ("userId", "roleId");


--
-- Name: history_entry PK_b65bd95b0d2929668589d57b97a; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.history_entry
    ADD CONSTRAINT "PK_b65bd95b0d2929668589d57b97a" PRIMARY KEY (id);


--
-- Name: shipping_method_translation PK_b862a1fac1c6e1fd201eadadbcb; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.shipping_method_translation
    ADD CONSTRAINT "PK_b862a1fac1c6e1fd201eadadbcb" PRIMARY KEY (id);


--
-- Name: shipping_method PK_b9b0adfad3c6b99229c1e7d4865; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.shipping_method
    ADD CONSTRAINT "PK_b9b0adfad3c6b99229c1e7d4865" PRIMARY KEY (id);


--
-- Name: product_variant_price PK_ba659ff2940702124e799c5c854; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.product_variant_price
    ADD CONSTRAINT "PK_ba659ff2940702124e799c5c854" PRIMARY KEY (id);


--
-- Name: collection_translation PK_bb49cfcde50401eb5f463a84dac; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.collection_translation
    ADD CONSTRAINT "PK_bb49cfcde50401eb5f463a84dac" PRIMARY KEY (id);


--
-- Name: zone PK_bd3989e5a3c3fb5ed546dfaf832; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.zone
    ADD CONSTRAINT "PK_bd3989e5a3c3fb5ed546dfaf832" PRIMARY KEY (id);


--
-- Name: product PK_bebc9158e480b949565b4dc7a82; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT "PK_bebc9158e480b949565b4dc7a82" PRIMARY KEY (id);


--
-- Name: asset_tags_tag PK_c4113b84381e953901fa5553654; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.asset_tags_tag
    ADD CONSTRAINT "PK_c4113b84381e953901fa5553654" PRIMARY KEY ("assetId", "tagId");


--
-- Name: product_asset PK_c56a83efd14ec4175532e1867fc; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.product_asset
    ADD CONSTRAINT "PK_c56a83efd14ec4175532e1867fc" PRIMARY KEY (id);


--
-- Name: product_variant_options_product_option PK_c57de5cb6bb74504180604a00c0; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.product_variant_options_product_option
    ADD CONSTRAINT "PK_c57de5cb6bb74504180604a00c0" PRIMARY KEY ("productVariantId", "productOptionId");


--
-- Name: payment_method_channels_channel PK_c83e4a201c0402ce5cdb170a9a2; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.payment_method_channels_channel
    ADD CONSTRAINT "PK_c83e4a201c0402ce5cdb170a9a2" PRIMARY KEY ("paymentMethodId", "channelId");


--
-- Name: shipping_method_channels_channel PK_c92b2b226a6ee87888d8dcd8bd6; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.shipping_method_channels_channel
    ADD CONSTRAINT "PK_c92b2b226a6ee87888d8dcd8bd6" PRIMARY KEY ("shippingMethodId", "channelId");


--
-- Name: user PK_cace4a159ff9f2512dd42373760; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT "PK_cace4a159ff9f2512dd42373760" PRIMARY KEY (id);


--
-- Name: product_variant_asset PK_cb1e33ae13779da176f8b03a5d3; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.product_variant_asset
    ADD CONSTRAINT "PK_cb1e33ae13779da176f8b03a5d3" PRIMARY KEY (id);


--
-- Name: order_modification PK_cccf2e1612694eeb1e5b6760ffa; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.order_modification
    ADD CONSTRAINT "PK_cccf2e1612694eeb1e5b6760ffa" PRIMARY KEY (id);


--
-- Name: facet_value PK_d231e8eecc7e1a6059e1da7d325; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.facet_value
    ADD CONSTRAINT "PK_d231e8eecc7e1a6059e1da7d325" PRIMARY KEY (id);


--
-- Name: product_facet_values_facet_value PK_d57f06b38805181019d75662aa6; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.product_facet_values_facet_value
    ADD CONSTRAINT "PK_d57f06b38805181019d75662aa6" PRIMARY KEY ("productId", "facetValueId");


--
-- Name: product_option_group PK_d76e92fdbbb5a2e6752ffd4a2c1; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.product_option_group
    ADD CONSTRAINT "PK_d76e92fdbbb5a2e6752ffd4a2c1" PRIMARY KEY (id);


--
-- Name: address PK_d92de1f82754668b5f5f5dd4fd5; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.address
    ADD CONSTRAINT "PK_d92de1f82754668b5f5f5dd4fd5" PRIMARY KEY (id);


--
-- Name: asset_channels_channel PK_d943908a39e32952e8425d2f1ba; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.asset_channels_channel
    ADD CONSTRAINT "PK_d943908a39e32952e8425d2f1ba" PRIMARY KEY ("assetId", "channelId");


--
-- Name: facet_channels_channel PK_df0579886093b2f830c159adfde; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.facet_channels_channel
    ADD CONSTRAINT "PK_df0579886093b2f830c159adfde" PRIMARY KEY ("facetId", "channelId");


--
-- Name: authentication_method PK_e204686018c3c60f6164e385081; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.authentication_method
    ADD CONSTRAINT "PK_e204686018c3c60f6164e385081" PRIMARY KEY (id);


--
-- Name: stock_location_channels_channel PK_e6f8b2d61ff58c51505c38da8a0; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.stock_location_channels_channel
    ADD CONSTRAINT "PK_e6f8b2d61ff58c51505c38da8a0" PRIMARY KEY ("stockLocationId", "channelId");


--
-- Name: administrator PK_ee58e71b3b4008b20ddc7b3092b; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.administrator
    ADD CONSTRAINT "PK_ee58e71b3b4008b20ddc7b3092b" PRIMARY KEY (id);


--
-- Name: scheduled_task_record PK_efd4b61a3b227f3eba94de32e4c; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.scheduled_task_record
    ADD CONSTRAINT "PK_efd4b61a3b227f3eba94de32e4c" PRIMARY KEY (id);


--
-- Name: refund PK_f1cefa2e60d99b206c46c1116e5; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.refund
    ADD CONSTRAINT "PK_f1cefa2e60d99b206c46c1116e5" PRIMARY KEY (id);


--
-- Name: session PK_f55da76ac1c3ac420f444d2ff11; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.session
    ADD CONSTRAINT "PK_f55da76ac1c3ac420f444d2ff11" PRIMARY KEY (id);


--
-- Name: promotion PK_fab3630e0789a2002f1cadb7d38; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.promotion
    ADD CONSTRAINT "PK_fab3630e0789a2002f1cadb7d38" PRIMARY KEY (id);


--
-- Name: zone_members_region PK_fc4eaa2236c4d4f61db0ae3826f; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.zone_members_region
    ADD CONSTRAINT "PK_fc4eaa2236c4d4f61db0ae3826f" PRIMARY KEY ("zoneId", "regionId");


--
-- Name: payment PK_fcaec7df5adf9cac408c686b2ab; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT "PK_fcaec7df5adf9cac408c686b2ab" PRIMARY KEY (id);


--
-- Name: global_settings PK_fec5e2c0bf238e30b25d4a82976; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.global_settings
    ADD CONSTRAINT "PK_fec5e2c0bf238e30b25d4a82976" PRIMARY KEY (id);


--
-- Name: administrator REL_1966e18ce6a39a82b19204704d; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.administrator
    ADD CONSTRAINT "REL_1966e18ce6a39a82b19204704d" UNIQUE ("userId");


--
-- Name: customer REL_3f62b42ed23958b120c235f74d; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.customer
    ADD CONSTRAINT "REL_3f62b42ed23958b120c235f74d" UNIQUE ("userId");


--
-- Name: order_modification REL_ad2991fa2933ed8b7f86a71633; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.order_modification
    ADD CONSTRAINT "REL_ad2991fa2933ed8b7f86a71633" UNIQUE ("paymentId");


--
-- Name: order_modification REL_cb66b63b6e97613013795eadbd; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.order_modification
    ADD CONSTRAINT "REL_cb66b63b6e97613013795eadbd" UNIQUE ("refundId");


--
-- Name: channel UQ_06127ac6c6d913f4320759971db; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.channel
    ADD CONSTRAINT "UQ_06127ac6c6d913f4320759971db" UNIQUE (code);


--
-- Name: facet UQ_0c9a5d053fdf4ebb5f0490b40fd; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.facet
    ADD CONSTRAINT "UQ_0c9a5d053fdf4ebb5f0490b40fd" UNIQUE (code);


--
-- Name: administrator UQ_154f5c538b1576ccc277b1ed631; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.administrator
    ADD CONSTRAINT "UQ_154f5c538b1576ccc277b1ed631" UNIQUE ("emailAddress");


--
-- Name: scheduled_task_record UQ_661876d97056cad9fd37eaa8774; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.scheduled_task_record
    ADD CONSTRAINT "UQ_661876d97056cad9fd37eaa8774" UNIQUE ("taskId");


--
-- Name: channel UQ_842699fce4f3470a7d06d89de88; Type: CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.channel
    ADD CONSTRAINT "UQ_842699fce4f3470a7d06d89de88" UNIQUE (token);


--
-- Name: IDX_00cbe87bc0d4e36758d61bd31d; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_00cbe87bc0d4e36758d61bd31d" ON public.authentication_method USING btree ("userId");


--
-- Name: IDX_06b02fb482b188823e419d37bd; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_06b02fb482b188823e419d37bd" ON public.order_line_reference USING btree ("fulfillmentId");


--
-- Name: IDX_06e7d73673ee630e8ec50d0b29; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_06e7d73673ee630e8ec50d0b29" ON public.product_facet_values_facet_value USING btree ("facetValueId");


--
-- Name: IDX_0d1294f5c22a56da7845ebab72; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_0d1294f5c22a56da7845ebab72" ON public.product_asset USING btree ("productId");


--
-- Name: IDX_0d641b761ed1dce4ef3cd33d55; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_0d641b761ed1dce4ef3cd33d55" ON public.product_variant_facet_values_facet_value USING btree ("facetValueId");


--
-- Name: IDX_0d8e5c204480204a60e151e485; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_0d8e5c204480204a60e151e485" ON public.order_channels_channel USING btree ("orderId");


--
-- Name: IDX_0e6f516053cf982b537836e21c; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_0e6f516053cf982b537836e21c" ON public.product_variant USING btree ("featuredAssetId");


--
-- Name: IDX_0eaaf0f4b6c69afde1e88ffb52; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_0eaaf0f4b6c69afde1e88ffb52" ON public.promotion_channels_channel USING btree ("channelId");


--
-- Name: IDX_10b5a2e3dee0e30b1e26c32f5c; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_10b5a2e3dee0e30b1e26c32f5c" ON public.product_variant_asset USING btree ("assetId");


--
-- Name: IDX_124456e637cca7a415897dce65; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_124456e637cca7a415897dce65" ON public."order" USING btree ("customerId");


--
-- Name: IDX_154eb685f9b629033bd266df7f; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_154eb685f9b629033bd266df7f" ON public.surcharge USING btree ("orderId");


--
-- Name: IDX_16ca9151a5153f1169da5b7b7e; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_16ca9151a5153f1169da5b7b7e" ON public.asset_channels_channel USING btree ("channelId");


--
-- Name: IDX_1afd722b943c81310705fc3e61; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_1afd722b943c81310705fc3e61" ON public.region_translation USING btree ("baseId");


--
-- Name: IDX_1c6932a756108788a361e7d440; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_1c6932a756108788a361e7d440" ON public.refund USING btree ("paymentId");


--
-- Name: IDX_1cc009e9ab2263a35544064561; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_1cc009e9ab2263a35544064561" ON public.promotion_translation USING btree ("baseId");


--
-- Name: IDX_1df5bc14a47ef24d2e681f4559; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_1df5bc14a47ef24d2e681f4559" ON public.order_modification USING btree ("orderId");


--
-- Name: IDX_1ed9e48dfbf74b5fcbb35d3d68; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_1ed9e48dfbf74b5fcbb35d3d68" ON public.collection_asset USING btree ("collectionId");


--
-- Name: IDX_22b818af8722746fb9f206068c; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_22b818af8722746fb9f206068c" ON public.order_line_reference USING btree ("modificationId");


--
-- Name: IDX_232f8e85d7633bd6ddfad42169; Type: INDEX; Schema: public; Owner: vendure
--

CREATE UNIQUE INDEX "IDX_232f8e85d7633bd6ddfad42169" ON public.session USING btree (token);


--
-- Name: IDX_239cfca2a55b98b90b6bef2e44; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_239cfca2a55b98b90b6bef2e44" ON public.order_line USING btree ("orderId");


--
-- Name: IDX_26d12be3b5fec6c4adb1d79284; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_26d12be3b5fec6c4adb1d79284" ON public.product_channels_channel USING btree ("productId");


--
-- Name: IDX_2a8ea404d05bf682516184db7d; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_2a8ea404d05bf682516184db7d" ON public.facet_channels_channel USING btree ("channelId");


--
-- Name: IDX_2c26b988769c0e3b0120bdef31; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_2c26b988769c0e3b0120bdef31" ON public.order_promotions_promotion USING btree ("promotionId");


--
-- Name: IDX_30019aa65b17fe9ee962893199; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_30019aa65b17fe9ee962893199" ON public.order_line_reference USING btree ("refundId");


--
-- Name: IDX_39513fd02a573c848d23bee587; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_39513fd02a573c848d23bee587" ON public.stock_location_channels_channel USING btree ("stockLocationId");


--
-- Name: IDX_3a05127e67435b4d2332ded7c9; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_3a05127e67435b4d2332ded7c9" ON public.history_entry USING btree ("orderId");


--
-- Name: IDX_3d2f174ef04fb312fdebd0ddc5; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_3d2f174ef04fb312fdebd0ddc5" ON public.session USING btree ("userId");


--
-- Name: IDX_3d6e45823b65de808a66cb1423; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_3d6e45823b65de808a66cb1423" ON public.facet_value_translation USING btree ("baseId");


--
-- Name: IDX_420f4d6fb75d38b9dca79bc43b; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_420f4d6fb75d38b9dca79bc43b" ON public.product_variant_translation USING btree ("baseId");


--
-- Name: IDX_433f45158e4e2b2a2f344714b2; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_433f45158e4e2b2a2f344714b2" ON public.zone_members_region USING btree ("zoneId");


--
-- Name: IDX_43ac602f839847fdb91101f30e; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_43ac602f839847fdb91101f30e" ON public.history_entry USING btree ("customerId");


--
-- Name: IDX_457784c710f8ac9396010441f6; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_457784c710f8ac9396010441f6" ON public.collection_closure USING btree (id_descendant);


--
-- Name: IDX_49a8632be8cef48b076446b8b9; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_49a8632be8cef48b076446b8b9" ON public.order_line_reference USING btree (discriminator);


--
-- Name: IDX_4add5a5796e1582dec2877b289; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_4add5a5796e1582dec2877b289" ON public.order_fulfillments_fulfillment USING btree ("fulfillmentId");


--
-- Name: IDX_4be2f7adf862634f5f803d246b; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_4be2f7adf862634f5f803d246b" ON public.user_roles_role USING btree ("roleId");


--
-- Name: IDX_51da53b26522dc0525762d2de8; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_51da53b26522dc0525762d2de8" ON public.collection_asset USING btree ("assetId");


--
-- Name: IDX_526f0131260eec308a3bd2b61b; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_526f0131260eec308a3bd2b61b" ON public.product_variant_options_product_option USING btree ("productVariantId");


--
-- Name: IDX_5888ac17b317b93378494a1062; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_5888ac17b317b93378494a1062" ON public.product_asset USING btree ("assetId");


--
-- Name: IDX_5bcb569635ce5407eb3f264487; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_5bcb569635ce5407eb3f264487" ON public.payment_method_channels_channel USING btree ("paymentMethodId");


--
-- Name: IDX_5f9286e6c25594c6b88c108db7; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_5f9286e6c25594c6b88c108db7" ON public.user_roles_role USING btree ("userId");


--
-- Name: IDX_66187f782a3e71b9e0f5b50b68; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_66187f782a3e71b9e0f5b50b68" ON public.payment_method_translation USING btree ("baseId");


--
-- Name: IDX_67be0e40122ab30a62a9817efe; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_67be0e40122ab30a62a9817efe" ON public.order_promotions_promotion USING btree ("orderId");


--
-- Name: IDX_6901d8715f5ebadd764466f7bd; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_6901d8715f5ebadd764466f7bd" ON public.order_line USING btree ("sellerChannelId");


--
-- Name: IDX_69567bc225b6bbbd732d6c5455; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_69567bc225b6bbbd732d6c5455" ON public.product_variant_facet_values_facet_value USING btree ("productVariantId");


--
-- Name: IDX_6a0558e650d75ae639ff38e413; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_6a0558e650d75ae639ff38e413" ON public.product_facet_values_facet_value USING btree ("productId");


--
-- Name: IDX_6d9e2c39ab12391aaa374bcdaa; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_6d9e2c39ab12391aaa374bcdaa" ON public.promotion_channels_channel USING btree ("promotionId");


--
-- Name: IDX_6e420052844edf3a5506d863ce; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_6e420052844edf3a5506d863ce" ON public.product_variant USING btree ("productId");


--
-- Name: IDX_6faa7b72422d9c4679e2f186ad; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_6faa7b72422d9c4679e2f186ad" ON public.collection_product_variants_product_variant USING btree ("collectionId");


--
-- Name: IDX_6fb55742e13e8082954d0436dc; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_6fb55742e13e8082954d0436dc" ON public.search_index_item USING btree ("productName");


--
-- Name: IDX_7216ab24077cf5cbece7857dbb; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_7216ab24077cf5cbece7857dbb" ON public.collection_channels_channel USING btree ("channelId");


--
-- Name: IDX_7256fef1bb42f1b38156b7449f; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_7256fef1bb42f1b38156b7449f" ON public.collection USING btree ("featuredAssetId");


--
-- Name: IDX_729b3eea7ce540930dbb706949; Type: INDEX; Schema: public; Owner: vendure
--

CREATE UNIQUE INDEX "IDX_729b3eea7ce540930dbb706949" ON public."order" USING btree (code);


--
-- Name: IDX_73a78d7df09541ac5eba620d18; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_73a78d7df09541ac5eba620d18" ON public."order" USING btree ("aggregateOrderId");


--
-- Name: IDX_77be94ce9ec650446617946227; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_77be94ce9ec650446617946227" ON public.order_line USING btree ("taxCategoryId");


--
-- Name: IDX_7a75399a4f4ffa48ee02e98c05; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_7a75399a4f4ffa48ee02e98c05" ON public.session USING btree ("activeOrderId");


--
-- Name: IDX_7d57857922dfc7303604697dbe; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_7d57857922dfc7303604697dbe" ON public.order_line_reference USING btree ("orderLineId");


--
-- Name: IDX_7dbc75cb4e8b002620c4dbfdac; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_7dbc75cb4e8b002620c4dbfdac" ON public.product_translation USING btree ("baseId");


--
-- Name: IDX_7ee3306d7638aa85ca90d67219; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_7ee3306d7638aa85ca90d67219" ON public.tax_rate USING btree ("categoryId");


--
-- Name: IDX_7fc20486b8cfd33dc84c96e168; Type: INDEX; Schema: public; Owner: vendure
--

CREATE UNIQUE INDEX "IDX_7fc20486b8cfd33dc84c96e168" ON public.stock_level USING btree ("productVariantId", "stockLocationId");


--
-- Name: IDX_85ec26c71067ebc84adcd98d1a; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_85ec26c71067ebc84adcd98d1a" ON public.shipping_method_translation USING btree ("baseId");


--
-- Name: IDX_85feea3f0e5e82133605f78db0; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_85feea3f0e5e82133605f78db0" ON public.customer_groups_customer_group USING btree ("customerGroupId");


--
-- Name: IDX_8b5ab52fc8887c1a769b9276ca; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_8b5ab52fc8887c1a769b9276ca" ON public.tax_rate USING btree ("customerGroupId");


--
-- Name: IDX_91a19e6613534949a4ce6e76ff; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_91a19e6613534949a4ce6e76ff" ON public.product USING btree ("featuredAssetId");


--
-- Name: IDX_92f8c334ef06275f9586fd0183; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_92f8c334ef06275f9586fd0183" ON public.history_entry USING btree ("administratorId");


--
-- Name: IDX_93751abc1451972c02e033b766; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_93751abc1451972c02e033b766" ON public.product_option_group_translation USING btree ("baseId");


--
-- Name: IDX_984c48572468c69661a0b7b049; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_984c48572468c69661a0b7b049" ON public.stock_level USING btree ("stockLocationId");


--
-- Name: IDX_9872fc7de2f4e532fd3230d191; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_9872fc7de2f4e532fd3230d191" ON public.tax_rate USING btree ("zoneId");


--
-- Name: IDX_9950eae3180f39c71978748bd0; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_9950eae3180f39c71978748bd0" ON public.stock_level USING btree ("productVariantId");


--
-- Name: IDX_9a5a6a556f75c4ac7bfdd03410; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_9a5a6a556f75c4ac7bfdd03410" ON public.search_index_item USING btree (description);


--
-- Name: IDX_9e412b00d4c6cee1a4b3d92071; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_9e412b00d4c6cee1a4b3d92071" ON public.asset_tags_tag USING btree ("assetId");


--
-- Name: IDX_9f065453910ea77d4be8e92618; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_9f065453910ea77d4be8e92618" ON public.order_line USING btree ("featuredAssetId");


--
-- Name: IDX_9f9da7d94b0278ea0f7831e1fc; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_9f9da7d94b0278ea0f7831e1fc" ON public.collection_translation USING btree (slug);


--
-- Name: IDX_a23445b2c942d8dfcae15b8de2; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_a23445b2c942d8dfcae15b8de2" ON public.authentication_method USING btree (type);


--
-- Name: IDX_a2fe7172eeae9f1cca86f8f573; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_a2fe7172eeae9f1cca86f8f573" ON public.stock_movement USING btree ("stockLocationId");


--
-- Name: IDX_a49c5271c39cc8174a0535c808; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_a49c5271c39cc8174a0535c808" ON public.surcharge USING btree ("orderModificationId");


--
-- Name: IDX_a51dfbd87c330c075c39832b6e; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_a51dfbd87c330c075c39832b6e" ON public.product_channels_channel USING btree ("channelId");


--
-- Name: IDX_a6debf9198e2fbfa006aa10d71; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_a6debf9198e2fbfa006aa10d71" ON public.product_option USING btree ("groupId");


--
-- Name: IDX_a6e91739227bf4d442f23c52c7; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_a6e91739227bf4d442f23c52c7" ON public.product_option_group USING btree ("productId");


--
-- Name: IDX_a79a443c1f7841f3851767faa6; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_a79a443c1f7841f3851767faa6" ON public.product_option_translation USING btree ("baseId");


--
-- Name: IDX_a842c9fe8cd4c8ff31402d172d; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_a842c9fe8cd4c8ff31402d172d" ON public.customer_channels_channel USING btree ("customerId");


--
-- Name: IDX_ad690c1b05596d7f52e52ffeed; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_ad690c1b05596d7f52e52ffeed" ON public.facet_value_channels_channel USING btree ("facetValueId");


--
-- Name: IDX_af2116c7e176b6b88dceceeb74; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_af2116c7e176b6b88dceceeb74" ON public.channel USING btree ("sellerId");


--
-- Name: IDX_afe9f917a1c82b9e9e69f7c612; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_afe9f917a1c82b9e9e69f7c612" ON public.channel USING btree ("defaultTaxZoneId");


--
-- Name: IDX_b45b65256486a15a104e17d495; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_b45b65256486a15a104e17d495" ON public.zone_members_region USING btree ("regionId");


--
-- Name: IDX_b823a3c8bf3b78d3ed68736485; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_b823a3c8bf3b78d3ed68736485" ON public.customer_groups_customer_group USING btree ("customerId");


--
-- Name: IDX_beeb2b3cd800e589f2213ae99d; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_beeb2b3cd800e589f2213ae99d" ON public.product_variant_channels_channel USING btree ("productVariantId");


--
-- Name: IDX_bfd2a03e9988eda6a9d1176011; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_bfd2a03e9988eda6a9d1176011" ON public.role_channels_channel USING btree ("roleId");


--
-- Name: IDX_c00e36f667d35031087b382e61; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_c00e36f667d35031087b382e61" ON public.payment_method_channels_channel USING btree ("channelId");


--
-- Name: IDX_c309f8cd152bbeaea08491e0c6; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_c309f8cd152bbeaea08491e0c6" ON public.collection_closure USING btree (id_ancestor);


--
-- Name: IDX_c9ca2f58d4517460435cbd8b4c; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_c9ca2f58d4517460435cbd8b4c" ON public.channel USING btree ("defaultShippingZoneId");


--
-- Name: IDX_c9f34a440d490d1b66f6829b86; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_c9f34a440d490d1b66f6829b86" ON public.shipping_line USING btree ("orderId");


--
-- Name: IDX_ca796020c6d097e251e5d6d2b0; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_ca796020c6d097e251e5d6d2b0" ON public.facet_channels_channel USING btree ("facetId");


--
-- Name: IDX_cbcd22193eda94668e84d33f18; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_cbcd22193eda94668e84d33f18" ON public.order_line USING btree ("productVariantId");


--
-- Name: IDX_cdbf33ffb5d451916125152008; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_cdbf33ffb5d451916125152008" ON public.collection_channels_channel USING btree ("collectionId");


--
-- Name: IDX_d09d285fe1645cd2f0db811e29; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_d09d285fe1645cd2f0db811e29" ON public.payment USING btree ("orderId");


--
-- Name: IDX_d0d16db872499e83b15999f8c7; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_d0d16db872499e83b15999f8c7" ON public.order_channels_channel USING btree ("channelId");


--
-- Name: IDX_d101dc2265a7341be3d94968c5; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_d101dc2265a7341be3d94968c5" ON public.facet_value USING btree ("facetId");


--
-- Name: IDX_d194bff171b62357688a5d0f55; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_d194bff171b62357688a5d0f55" ON public.product_variant_channels_channel USING btree ("channelId");


--
-- Name: IDX_d2c8d5fca981cc820131f81aa8; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_d2c8d5fca981cc820131f81aa8" ON public.stock_movement USING btree ("orderLineId");


--
-- Name: IDX_d87215343c3a3a67e6a0b7f3ea; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_d87215343c3a3a67e6a0b7f3ea" ON public.address USING btree ("countryId");


--
-- Name: IDX_d8791f444a8bf23fe4c1bc020c; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_d8791f444a8bf23fe4c1bc020c" ON public.search_index_item USING btree ("productVariantName");


--
-- Name: IDX_dc34d382b493ade1f70e834c4d; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_dc34d382b493ade1f70e834c4d" ON public.address USING btree ("customerId");


--
-- Name: IDX_dc4e7435f9f5e9e6436bebd33b; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_dc4e7435f9f5e9e6436bebd33b" ON public.asset_channels_channel USING btree ("assetId");


--
-- Name: IDX_dc9ac68b47da7b62249886affb; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_dc9ac68b47da7b62249886affb" ON public.order_line USING btree ("shippingLineId");


--
-- Name: IDX_dc9f69207a8867f83b0fd257e3; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_dc9f69207a8867f83b0fd257e3" ON public.customer_channels_channel USING btree ("channelId");


--
-- Name: IDX_e09dfee62b158307404202b43a; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_e09dfee62b158307404202b43a" ON public.role_channels_channel USING btree ("channelId");


--
-- Name: IDX_e1d54c0b9db3e2eb17faaf5919; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_e1d54c0b9db3e2eb17faaf5919" ON public.facet_value_channels_channel USING btree ("channelId");


--
-- Name: IDX_e2e7642e1e88167c1dfc827fdf; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_e2e7642e1e88167c1dfc827fdf" ON public.shipping_line USING btree ("shippingMethodId");


--
-- Name: IDX_e329f9036210d75caa1d8f2154; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_e329f9036210d75caa1d8f2154" ON public.collection_translation USING btree ("baseId");


--
-- Name: IDX_e38dca0d82fd64c7cf8aac8b8e; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_e38dca0d82fd64c7cf8aac8b8e" ON public.product_variant USING btree ("taxCategoryId");


--
-- Name: IDX_e6126cd268aea6e9b31d89af9a; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_e6126cd268aea6e9b31d89af9a" ON public.product_variant_price USING btree ("variantId");


--
-- Name: IDX_e65ba3882557cab4febb54809b; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_e65ba3882557cab4febb54809b" ON public.stock_movement USING btree ("productVariantId");


--
-- Name: IDX_e96a71affe63c97f7fa2f076da; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_e96a71affe63c97f7fa2f076da" ON public.product_variant_options_product_option USING btree ("productOptionId");


--
-- Name: IDX_eaea53f44bf9e97790d38a3d68; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_eaea53f44bf9e97790d38a3d68" ON public.facet_translation USING btree ("baseId");


--
-- Name: IDX_eb87ef1e234444728138302263; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_eb87ef1e234444728138302263" ON public.session USING btree ("activeChannelId");


--
-- Name: IDX_ed0c8098ce6809925a437f42ae; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_ed0c8098ce6809925a437f42ae" ON public.region USING btree ("parentId");


--
-- Name: IDX_f0a17b94aa5a162f0d422920eb; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_f0a17b94aa5a162f0d422920eb" ON public.shipping_method_channels_channel USING btree ("shippingMethodId");


--
-- Name: IDX_f2b98dfb56685147bed509acc3; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_f2b98dfb56685147bed509acc3" ON public.shipping_method_channels_channel USING btree ("channelId");


--
-- Name: IDX_f4a2ec16ba86d277b6faa0b67b; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_f4a2ec16ba86d277b6faa0b67b" ON public.product_translation USING btree (slug);


--
-- Name: IDX_f80d84d525af2ffe974e7e8ca2; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_f80d84d525af2ffe974e7e8ca2" ON public.order_fulfillments_fulfillment USING btree ("orderId");


--
-- Name: IDX_fa21412afac15a2304f3eb35fe; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_fa21412afac15a2304f3eb35fe" ON public.product_variant_asset USING btree ("productVariantId");


--
-- Name: IDX_fb05887e2867365f236d7dd95e; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_fb05887e2867365f236d7dd95e" ON public.collection_product_variants_product_variant USING btree ("productVariantId");


--
-- Name: IDX_fb5e800171ffbe9823f2cc727f; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_fb5e800171ffbe9823f2cc727f" ON public.asset_tags_tag USING btree ("tagId");


--
-- Name: IDX_ff8150fe54e56a900d5712671a; Type: INDEX; Schema: public; Owner: vendure
--

CREATE INDEX "IDX_ff8150fe54e56a900d5712671a" ON public.stock_location_channels_channel USING btree ("channelId");


--
-- Name: authentication_method FK_00cbe87bc0d4e36758d61bd31d6; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.authentication_method
    ADD CONSTRAINT "FK_00cbe87bc0d4e36758d61bd31d6" FOREIGN KEY ("userId") REFERENCES public."user"(id);


--
-- Name: order_line_reference FK_06b02fb482b188823e419d37bd4; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.order_line_reference
    ADD CONSTRAINT "FK_06b02fb482b188823e419d37bd4" FOREIGN KEY ("fulfillmentId") REFERENCES public.fulfillment(id);


--
-- Name: product_facet_values_facet_value FK_06e7d73673ee630e8ec50d0b29f; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.product_facet_values_facet_value
    ADD CONSTRAINT "FK_06e7d73673ee630e8ec50d0b29f" FOREIGN KEY ("facetValueId") REFERENCES public.facet_value(id) ON DELETE CASCADE;


--
-- Name: product_asset FK_0d1294f5c22a56da7845ebab72c; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.product_asset
    ADD CONSTRAINT "FK_0d1294f5c22a56da7845ebab72c" FOREIGN KEY ("productId") REFERENCES public.product(id) ON DELETE CASCADE;


--
-- Name: product_variant_facet_values_facet_value FK_0d641b761ed1dce4ef3cd33d559; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.product_variant_facet_values_facet_value
    ADD CONSTRAINT "FK_0d641b761ed1dce4ef3cd33d559" FOREIGN KEY ("facetValueId") REFERENCES public.facet_value(id);


--
-- Name: order_channels_channel FK_0d8e5c204480204a60e151e4853; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.order_channels_channel
    ADD CONSTRAINT "FK_0d8e5c204480204a60e151e4853" FOREIGN KEY ("orderId") REFERENCES public."order"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product_variant FK_0e6f516053cf982b537836e21cf; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.product_variant
    ADD CONSTRAINT "FK_0e6f516053cf982b537836e21cf" FOREIGN KEY ("featuredAssetId") REFERENCES public.asset(id) ON DELETE SET NULL;


--
-- Name: promotion_channels_channel FK_0eaaf0f4b6c69afde1e88ffb52d; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.promotion_channels_channel
    ADD CONSTRAINT "FK_0eaaf0f4b6c69afde1e88ffb52d" FOREIGN KEY ("channelId") REFERENCES public.channel(id) ON DELETE CASCADE;


--
-- Name: product_variant_asset FK_10b5a2e3dee0e30b1e26c32f5c7; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.product_variant_asset
    ADD CONSTRAINT "FK_10b5a2e3dee0e30b1e26c32f5c7" FOREIGN KEY ("assetId") REFERENCES public.asset(id) ON DELETE CASCADE;


--
-- Name: order FK_124456e637cca7a415897dce659; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT "FK_124456e637cca7a415897dce659" FOREIGN KEY ("customerId") REFERENCES public.customer(id);


--
-- Name: surcharge FK_154eb685f9b629033bd266df7fa; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.surcharge
    ADD CONSTRAINT "FK_154eb685f9b629033bd266df7fa" FOREIGN KEY ("orderId") REFERENCES public."order"(id) ON DELETE CASCADE;


--
-- Name: asset_channels_channel FK_16ca9151a5153f1169da5b7b7e3; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.asset_channels_channel
    ADD CONSTRAINT "FK_16ca9151a5153f1169da5b7b7e3" FOREIGN KEY ("channelId") REFERENCES public.channel(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: administrator FK_1966e18ce6a39a82b19204704d7; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.administrator
    ADD CONSTRAINT "FK_1966e18ce6a39a82b19204704d7" FOREIGN KEY ("userId") REFERENCES public."user"(id);


--
-- Name: region_translation FK_1afd722b943c81310705fc3e612; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.region_translation
    ADD CONSTRAINT "FK_1afd722b943c81310705fc3e612" FOREIGN KEY ("baseId") REFERENCES public.region(id) ON DELETE CASCADE;


--
-- Name: refund FK_1c6932a756108788a361e7d4404; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.refund
    ADD CONSTRAINT "FK_1c6932a756108788a361e7d4404" FOREIGN KEY ("paymentId") REFERENCES public.payment(id);


--
-- Name: promotion_translation FK_1cc009e9ab2263a35544064561b; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.promotion_translation
    ADD CONSTRAINT "FK_1cc009e9ab2263a35544064561b" FOREIGN KEY ("baseId") REFERENCES public.promotion(id) ON DELETE CASCADE;


--
-- Name: order_modification FK_1df5bc14a47ef24d2e681f45598; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.order_modification
    ADD CONSTRAINT "FK_1df5bc14a47ef24d2e681f45598" FOREIGN KEY ("orderId") REFERENCES public."order"(id) ON DELETE CASCADE;


--
-- Name: collection_asset FK_1ed9e48dfbf74b5fcbb35d3d686; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.collection_asset
    ADD CONSTRAINT "FK_1ed9e48dfbf74b5fcbb35d3d686" FOREIGN KEY ("collectionId") REFERENCES public.collection(id) ON DELETE CASCADE;


--
-- Name: order_line_reference FK_22b818af8722746fb9f206068c2; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.order_line_reference
    ADD CONSTRAINT "FK_22b818af8722746fb9f206068c2" FOREIGN KEY ("modificationId") REFERENCES public.order_modification(id);


--
-- Name: order_line FK_239cfca2a55b98b90b6bef2e44f; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.order_line
    ADD CONSTRAINT "FK_239cfca2a55b98b90b6bef2e44f" FOREIGN KEY ("orderId") REFERENCES public."order"(id) ON DELETE CASCADE;


--
-- Name: product_channels_channel FK_26d12be3b5fec6c4adb1d792844; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.product_channels_channel
    ADD CONSTRAINT "FK_26d12be3b5fec6c4adb1d792844" FOREIGN KEY ("productId") REFERENCES public.product(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: facet_channels_channel FK_2a8ea404d05bf682516184db7d3; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.facet_channels_channel
    ADD CONSTRAINT "FK_2a8ea404d05bf682516184db7d3" FOREIGN KEY ("channelId") REFERENCES public.channel(id) ON DELETE CASCADE;


--
-- Name: order_promotions_promotion FK_2c26b988769c0e3b0120bdef31b; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.order_promotions_promotion
    ADD CONSTRAINT "FK_2c26b988769c0e3b0120bdef31b" FOREIGN KEY ("promotionId") REFERENCES public.promotion(id);


--
-- Name: order_line_reference FK_30019aa65b17fe9ee9628931991; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.order_line_reference
    ADD CONSTRAINT "FK_30019aa65b17fe9ee9628931991" FOREIGN KEY ("refundId") REFERENCES public.refund(id);


--
-- Name: stock_location_channels_channel FK_39513fd02a573c848d23bee587d; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.stock_location_channels_channel
    ADD CONSTRAINT "FK_39513fd02a573c848d23bee587d" FOREIGN KEY ("stockLocationId") REFERENCES public.stock_location(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: history_entry FK_3a05127e67435b4d2332ded7c9e; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.history_entry
    ADD CONSTRAINT "FK_3a05127e67435b4d2332ded7c9e" FOREIGN KEY ("orderId") REFERENCES public."order"(id) ON DELETE CASCADE;


--
-- Name: session FK_3d2f174ef04fb312fdebd0ddc53; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.session
    ADD CONSTRAINT "FK_3d2f174ef04fb312fdebd0ddc53" FOREIGN KEY ("userId") REFERENCES public."user"(id);


--
-- Name: facet_value_translation FK_3d6e45823b65de808a66cb1423b; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.facet_value_translation
    ADD CONSTRAINT "FK_3d6e45823b65de808a66cb1423b" FOREIGN KEY ("baseId") REFERENCES public.facet_value(id) ON DELETE CASCADE;


--
-- Name: customer FK_3f62b42ed23958b120c235f74df; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.customer
    ADD CONSTRAINT "FK_3f62b42ed23958b120c235f74df" FOREIGN KEY ("userId") REFERENCES public."user"(id);


--
-- Name: product_variant_translation FK_420f4d6fb75d38b9dca79bc43b4; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.product_variant_translation
    ADD CONSTRAINT "FK_420f4d6fb75d38b9dca79bc43b4" FOREIGN KEY ("baseId") REFERENCES public.product_variant(id) ON DELETE CASCADE;


--
-- Name: collection FK_4257b61275144db89fa0f5dc059; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.collection
    ADD CONSTRAINT "FK_4257b61275144db89fa0f5dc059" FOREIGN KEY ("parentId") REFERENCES public.collection(id);


--
-- Name: zone_members_region FK_433f45158e4e2b2a2f344714b22; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.zone_members_region
    ADD CONSTRAINT "FK_433f45158e4e2b2a2f344714b22" FOREIGN KEY ("zoneId") REFERENCES public.zone(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: history_entry FK_43ac602f839847fdb91101f30ec; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.history_entry
    ADD CONSTRAINT "FK_43ac602f839847fdb91101f30ec" FOREIGN KEY ("customerId") REFERENCES public.customer(id) ON DELETE CASCADE;


--
-- Name: collection_closure FK_457784c710f8ac9396010441f6c; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.collection_closure
    ADD CONSTRAINT "FK_457784c710f8ac9396010441f6c" FOREIGN KEY (id_descendant) REFERENCES public.collection(id) ON DELETE CASCADE;


--
-- Name: order_fulfillments_fulfillment FK_4add5a5796e1582dec2877b2898; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.order_fulfillments_fulfillment
    ADD CONSTRAINT "FK_4add5a5796e1582dec2877b2898" FOREIGN KEY ("fulfillmentId") REFERENCES public.fulfillment(id);


--
-- Name: user_roles_role FK_4be2f7adf862634f5f803d246b8; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.user_roles_role
    ADD CONSTRAINT "FK_4be2f7adf862634f5f803d246b8" FOREIGN KEY ("roleId") REFERENCES public.role(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: collection_asset FK_51da53b26522dc0525762d2de8e; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.collection_asset
    ADD CONSTRAINT "FK_51da53b26522dc0525762d2de8e" FOREIGN KEY ("assetId") REFERENCES public.asset(id) ON DELETE CASCADE;


--
-- Name: product_variant_options_product_option FK_526f0131260eec308a3bd2b61b6; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.product_variant_options_product_option
    ADD CONSTRAINT "FK_526f0131260eec308a3bd2b61b6" FOREIGN KEY ("productVariantId") REFERENCES public.product_variant(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product_asset FK_5888ac17b317b93378494a10620; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.product_asset
    ADD CONSTRAINT "FK_5888ac17b317b93378494a10620" FOREIGN KEY ("assetId") REFERENCES public.asset(id) ON DELETE CASCADE;


--
-- Name: payment_method_channels_channel FK_5bcb569635ce5407eb3f264487d; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.payment_method_channels_channel
    ADD CONSTRAINT "FK_5bcb569635ce5407eb3f264487d" FOREIGN KEY ("paymentMethodId") REFERENCES public.payment_method(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: user_roles_role FK_5f9286e6c25594c6b88c108db77; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.user_roles_role
    ADD CONSTRAINT "FK_5f9286e6c25594c6b88c108db77" FOREIGN KEY ("userId") REFERENCES public."user"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: payment_method_translation FK_66187f782a3e71b9e0f5b50b68b; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.payment_method_translation
    ADD CONSTRAINT "FK_66187f782a3e71b9e0f5b50b68b" FOREIGN KEY ("baseId") REFERENCES public.payment_method(id) ON DELETE CASCADE;


--
-- Name: order_promotions_promotion FK_67be0e40122ab30a62a9817efe0; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.order_promotions_promotion
    ADD CONSTRAINT "FK_67be0e40122ab30a62a9817efe0" FOREIGN KEY ("orderId") REFERENCES public."order"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_line FK_6901d8715f5ebadd764466f7bde; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.order_line
    ADD CONSTRAINT "FK_6901d8715f5ebadd764466f7bde" FOREIGN KEY ("sellerChannelId") REFERENCES public.channel(id) ON DELETE SET NULL;


--
-- Name: product_variant_facet_values_facet_value FK_69567bc225b6bbbd732d6c5455b; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.product_variant_facet_values_facet_value
    ADD CONSTRAINT "FK_69567bc225b6bbbd732d6c5455b" FOREIGN KEY ("productVariantId") REFERENCES public.product_variant(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product_facet_values_facet_value FK_6a0558e650d75ae639ff38e413a; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.product_facet_values_facet_value
    ADD CONSTRAINT "FK_6a0558e650d75ae639ff38e413a" FOREIGN KEY ("productId") REFERENCES public.product(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: promotion_channels_channel FK_6d9e2c39ab12391aaa374bcdaa4; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.promotion_channels_channel
    ADD CONSTRAINT "FK_6d9e2c39ab12391aaa374bcdaa4" FOREIGN KEY ("promotionId") REFERENCES public.promotion(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product_variant FK_6e420052844edf3a5506d863ce6; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.product_variant
    ADD CONSTRAINT "FK_6e420052844edf3a5506d863ce6" FOREIGN KEY ("productId") REFERENCES public.product(id);


--
-- Name: collection_product_variants_product_variant FK_6faa7b72422d9c4679e2f186ad1; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.collection_product_variants_product_variant
    ADD CONSTRAINT "FK_6faa7b72422d9c4679e2f186ad1" FOREIGN KEY ("collectionId") REFERENCES public.collection(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: collection_channels_channel FK_7216ab24077cf5cbece7857dbbd; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.collection_channels_channel
    ADD CONSTRAINT "FK_7216ab24077cf5cbece7857dbbd" FOREIGN KEY ("channelId") REFERENCES public.channel(id) ON DELETE CASCADE;


--
-- Name: collection FK_7256fef1bb42f1b38156b7449f5; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.collection
    ADD CONSTRAINT "FK_7256fef1bb42f1b38156b7449f5" FOREIGN KEY ("featuredAssetId") REFERENCES public.asset(id) ON DELETE SET NULL;


--
-- Name: order FK_73a78d7df09541ac5eba620d181; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT "FK_73a78d7df09541ac5eba620d181" FOREIGN KEY ("aggregateOrderId") REFERENCES public."order"(id);


--
-- Name: order_line FK_77be94ce9ec6504466179462275; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.order_line
    ADD CONSTRAINT "FK_77be94ce9ec6504466179462275" FOREIGN KEY ("taxCategoryId") REFERENCES public.tax_category(id);


--
-- Name: session FK_7a75399a4f4ffa48ee02e98c059; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.session
    ADD CONSTRAINT "FK_7a75399a4f4ffa48ee02e98c059" FOREIGN KEY ("activeOrderId") REFERENCES public."order"(id);


--
-- Name: order_line_reference FK_7d57857922dfc7303604697dbe9; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.order_line_reference
    ADD CONSTRAINT "FK_7d57857922dfc7303604697dbe9" FOREIGN KEY ("orderLineId") REFERENCES public.order_line(id) ON DELETE CASCADE;


--
-- Name: product_translation FK_7dbc75cb4e8b002620c4dbfdac5; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.product_translation
    ADD CONSTRAINT "FK_7dbc75cb4e8b002620c4dbfdac5" FOREIGN KEY ("baseId") REFERENCES public.product(id);


--
-- Name: tax_rate FK_7ee3306d7638aa85ca90d672198; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.tax_rate
    ADD CONSTRAINT "FK_7ee3306d7638aa85ca90d672198" FOREIGN KEY ("categoryId") REFERENCES public.tax_category(id);


--
-- Name: shipping_method_translation FK_85ec26c71067ebc84adcd98d1a5; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.shipping_method_translation
    ADD CONSTRAINT "FK_85ec26c71067ebc84adcd98d1a5" FOREIGN KEY ("baseId") REFERENCES public.shipping_method(id) ON DELETE CASCADE;


--
-- Name: customer_groups_customer_group FK_85feea3f0e5e82133605f78db02; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.customer_groups_customer_group
    ADD CONSTRAINT "FK_85feea3f0e5e82133605f78db02" FOREIGN KEY ("customerGroupId") REFERENCES public.customer_group(id);


--
-- Name: tax_rate FK_8b5ab52fc8887c1a769b9276caf; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.tax_rate
    ADD CONSTRAINT "FK_8b5ab52fc8887c1a769b9276caf" FOREIGN KEY ("customerGroupId") REFERENCES public.customer_group(id);


--
-- Name: product FK_91a19e6613534949a4ce6e76ff8; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT "FK_91a19e6613534949a4ce6e76ff8" FOREIGN KEY ("featuredAssetId") REFERENCES public.asset(id) ON DELETE SET NULL;


--
-- Name: history_entry FK_92f8c334ef06275f9586fd01832; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.history_entry
    ADD CONSTRAINT "FK_92f8c334ef06275f9586fd01832" FOREIGN KEY ("administratorId") REFERENCES public.administrator(id);


--
-- Name: product_option_group_translation FK_93751abc1451972c02e033b766c; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.product_option_group_translation
    ADD CONSTRAINT "FK_93751abc1451972c02e033b766c" FOREIGN KEY ("baseId") REFERENCES public.product_option_group(id) ON DELETE CASCADE;


--
-- Name: stock_level FK_984c48572468c69661a0b7b0494; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.stock_level
    ADD CONSTRAINT "FK_984c48572468c69661a0b7b0494" FOREIGN KEY ("stockLocationId") REFERENCES public.stock_location(id) ON DELETE CASCADE;


--
-- Name: tax_rate FK_9872fc7de2f4e532fd3230d1915; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.tax_rate
    ADD CONSTRAINT "FK_9872fc7de2f4e532fd3230d1915" FOREIGN KEY ("zoneId") REFERENCES public.zone(id);


--
-- Name: stock_level FK_9950eae3180f39c71978748bd08; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.stock_level
    ADD CONSTRAINT "FK_9950eae3180f39c71978748bd08" FOREIGN KEY ("productVariantId") REFERENCES public.product_variant(id) ON DELETE CASCADE;


--
-- Name: asset_tags_tag FK_9e412b00d4c6cee1a4b3d920716; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.asset_tags_tag
    ADD CONSTRAINT "FK_9e412b00d4c6cee1a4b3d920716" FOREIGN KEY ("assetId") REFERENCES public.asset(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_line FK_9f065453910ea77d4be8e92618f; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.order_line
    ADD CONSTRAINT "FK_9f065453910ea77d4be8e92618f" FOREIGN KEY ("featuredAssetId") REFERENCES public.asset(id) ON DELETE SET NULL;


--
-- Name: stock_movement FK_a2fe7172eeae9f1cca86f8f573a; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.stock_movement
    ADD CONSTRAINT "FK_a2fe7172eeae9f1cca86f8f573a" FOREIGN KEY ("stockLocationId") REFERENCES public.stock_location(id) ON DELETE CASCADE;


--
-- Name: surcharge FK_a49c5271c39cc8174a0535c8088; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.surcharge
    ADD CONSTRAINT "FK_a49c5271c39cc8174a0535c8088" FOREIGN KEY ("orderModificationId") REFERENCES public.order_modification(id);


--
-- Name: product_channels_channel FK_a51dfbd87c330c075c39832b6e7; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.product_channels_channel
    ADD CONSTRAINT "FK_a51dfbd87c330c075c39832b6e7" FOREIGN KEY ("channelId") REFERENCES public.channel(id) ON DELETE CASCADE;


--
-- Name: product_option FK_a6debf9198e2fbfa006aa10d710; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.product_option
    ADD CONSTRAINT "FK_a6debf9198e2fbfa006aa10d710" FOREIGN KEY ("groupId") REFERENCES public.product_option_group(id);


--
-- Name: product_option_group FK_a6e91739227bf4d442f23c52c75; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.product_option_group
    ADD CONSTRAINT "FK_a6e91739227bf4d442f23c52c75" FOREIGN KEY ("productId") REFERENCES public.product(id);


--
-- Name: product_option_translation FK_a79a443c1f7841f3851767faa6d; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.product_option_translation
    ADD CONSTRAINT "FK_a79a443c1f7841f3851767faa6d" FOREIGN KEY ("baseId") REFERENCES public.product_option(id) ON DELETE CASCADE;


--
-- Name: customer_channels_channel FK_a842c9fe8cd4c8ff31402d172d7; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.customer_channels_channel
    ADD CONSTRAINT "FK_a842c9fe8cd4c8ff31402d172d7" FOREIGN KEY ("customerId") REFERENCES public.customer(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_modification FK_ad2991fa2933ed8b7f86a716338; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.order_modification
    ADD CONSTRAINT "FK_ad2991fa2933ed8b7f86a716338" FOREIGN KEY ("paymentId") REFERENCES public.payment(id);


--
-- Name: facet_value_channels_channel FK_ad690c1b05596d7f52e52ffeedd; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.facet_value_channels_channel
    ADD CONSTRAINT "FK_ad690c1b05596d7f52e52ffeedd" FOREIGN KEY ("facetValueId") REFERENCES public.facet_value(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: channel FK_af2116c7e176b6b88dceceeb74b; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.channel
    ADD CONSTRAINT "FK_af2116c7e176b6b88dceceeb74b" FOREIGN KEY ("sellerId") REFERENCES public.seller(id);


--
-- Name: channel FK_afe9f917a1c82b9e9e69f7c6129; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.channel
    ADD CONSTRAINT "FK_afe9f917a1c82b9e9e69f7c6129" FOREIGN KEY ("defaultTaxZoneId") REFERENCES public.zone(id);


--
-- Name: zone_members_region FK_b45b65256486a15a104e17d495c; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.zone_members_region
    ADD CONSTRAINT "FK_b45b65256486a15a104e17d495c" FOREIGN KEY ("regionId") REFERENCES public.region(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: customer_groups_customer_group FK_b823a3c8bf3b78d3ed68736485c; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.customer_groups_customer_group
    ADD CONSTRAINT "FK_b823a3c8bf3b78d3ed68736485c" FOREIGN KEY ("customerId") REFERENCES public.customer(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product_variant_channels_channel FK_beeb2b3cd800e589f2213ae99d6; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.product_variant_channels_channel
    ADD CONSTRAINT "FK_beeb2b3cd800e589f2213ae99d6" FOREIGN KEY ("productVariantId") REFERENCES public.product_variant(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: role_channels_channel FK_bfd2a03e9988eda6a9d11760119; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.role_channels_channel
    ADD CONSTRAINT "FK_bfd2a03e9988eda6a9d11760119" FOREIGN KEY ("roleId") REFERENCES public.role(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: payment_method_channels_channel FK_c00e36f667d35031087b382e61b; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.payment_method_channels_channel
    ADD CONSTRAINT "FK_c00e36f667d35031087b382e61b" FOREIGN KEY ("channelId") REFERENCES public.channel(id) ON DELETE CASCADE;


--
-- Name: collection_closure FK_c309f8cd152bbeaea08491e0c66; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.collection_closure
    ADD CONSTRAINT "FK_c309f8cd152bbeaea08491e0c66" FOREIGN KEY (id_ancestor) REFERENCES public.collection(id) ON DELETE CASCADE;


--
-- Name: channel FK_c9ca2f58d4517460435cbd8b4c9; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.channel
    ADD CONSTRAINT "FK_c9ca2f58d4517460435cbd8b4c9" FOREIGN KEY ("defaultShippingZoneId") REFERENCES public.zone(id);


--
-- Name: shipping_line FK_c9f34a440d490d1b66f6829b86c; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.shipping_line
    ADD CONSTRAINT "FK_c9f34a440d490d1b66f6829b86c" FOREIGN KEY ("orderId") REFERENCES public."order"(id) ON DELETE CASCADE;


--
-- Name: facet_channels_channel FK_ca796020c6d097e251e5d6d2b02; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.facet_channels_channel
    ADD CONSTRAINT "FK_ca796020c6d097e251e5d6d2b02" FOREIGN KEY ("facetId") REFERENCES public.facet(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_modification FK_cb66b63b6e97613013795eadbd5; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.order_modification
    ADD CONSTRAINT "FK_cb66b63b6e97613013795eadbd5" FOREIGN KEY ("refundId") REFERENCES public.refund(id);


--
-- Name: order_line FK_cbcd22193eda94668e84d33f185; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.order_line
    ADD CONSTRAINT "FK_cbcd22193eda94668e84d33f185" FOREIGN KEY ("productVariantId") REFERENCES public.product_variant(id) ON DELETE CASCADE;


--
-- Name: collection_channels_channel FK_cdbf33ffb5d4519161251520083; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.collection_channels_channel
    ADD CONSTRAINT "FK_cdbf33ffb5d4519161251520083" FOREIGN KEY ("collectionId") REFERENCES public.collection(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: payment FK_d09d285fe1645cd2f0db811e293; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT "FK_d09d285fe1645cd2f0db811e293" FOREIGN KEY ("orderId") REFERENCES public."order"(id);


--
-- Name: order_channels_channel FK_d0d16db872499e83b15999f8c7a; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.order_channels_channel
    ADD CONSTRAINT "FK_d0d16db872499e83b15999f8c7a" FOREIGN KEY ("channelId") REFERENCES public.channel(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: facet_value FK_d101dc2265a7341be3d94968c5b; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.facet_value
    ADD CONSTRAINT "FK_d101dc2265a7341be3d94968c5b" FOREIGN KEY ("facetId") REFERENCES public.facet(id) ON DELETE CASCADE;


--
-- Name: product_variant_channels_channel FK_d194bff171b62357688a5d0f559; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.product_variant_channels_channel
    ADD CONSTRAINT "FK_d194bff171b62357688a5d0f559" FOREIGN KEY ("channelId") REFERENCES public.channel(id) ON DELETE CASCADE;


--
-- Name: stock_movement FK_d2c8d5fca981cc820131f81aa83; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.stock_movement
    ADD CONSTRAINT "FK_d2c8d5fca981cc820131f81aa83" FOREIGN KEY ("orderLineId") REFERENCES public.order_line(id);


--
-- Name: address FK_d87215343c3a3a67e6a0b7f3ea9; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.address
    ADD CONSTRAINT "FK_d87215343c3a3a67e6a0b7f3ea9" FOREIGN KEY ("countryId") REFERENCES public.region(id);


--
-- Name: address FK_dc34d382b493ade1f70e834c4d3; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.address
    ADD CONSTRAINT "FK_dc34d382b493ade1f70e834c4d3" FOREIGN KEY ("customerId") REFERENCES public.customer(id);


--
-- Name: asset_channels_channel FK_dc4e7435f9f5e9e6436bebd33bb; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.asset_channels_channel
    ADD CONSTRAINT "FK_dc4e7435f9f5e9e6436bebd33bb" FOREIGN KEY ("assetId") REFERENCES public.asset(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_line FK_dc9ac68b47da7b62249886affba; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.order_line
    ADD CONSTRAINT "FK_dc9ac68b47da7b62249886affba" FOREIGN KEY ("shippingLineId") REFERENCES public.shipping_line(id) ON DELETE SET NULL;


--
-- Name: customer_channels_channel FK_dc9f69207a8867f83b0fd257e30; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.customer_channels_channel
    ADD CONSTRAINT "FK_dc9f69207a8867f83b0fd257e30" FOREIGN KEY ("channelId") REFERENCES public.channel(id) ON DELETE CASCADE;


--
-- Name: role_channels_channel FK_e09dfee62b158307404202b43a5; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.role_channels_channel
    ADD CONSTRAINT "FK_e09dfee62b158307404202b43a5" FOREIGN KEY ("channelId") REFERENCES public.channel(id) ON DELETE CASCADE;


--
-- Name: facet_value_channels_channel FK_e1d54c0b9db3e2eb17faaf5919c; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.facet_value_channels_channel
    ADD CONSTRAINT "FK_e1d54c0b9db3e2eb17faaf5919c" FOREIGN KEY ("channelId") REFERENCES public.channel(id) ON DELETE CASCADE;


--
-- Name: shipping_line FK_e2e7642e1e88167c1dfc827fdf3; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.shipping_line
    ADD CONSTRAINT "FK_e2e7642e1e88167c1dfc827fdf3" FOREIGN KEY ("shippingMethodId") REFERENCES public.shipping_method(id);


--
-- Name: collection_translation FK_e329f9036210d75caa1d8f2154a; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.collection_translation
    ADD CONSTRAINT "FK_e329f9036210d75caa1d8f2154a" FOREIGN KEY ("baseId") REFERENCES public.collection(id) ON DELETE CASCADE;


--
-- Name: product_variant FK_e38dca0d82fd64c7cf8aac8b8ef; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.product_variant
    ADD CONSTRAINT "FK_e38dca0d82fd64c7cf8aac8b8ef" FOREIGN KEY ("taxCategoryId") REFERENCES public.tax_category(id);


--
-- Name: product_variant_price FK_e6126cd268aea6e9b31d89af9ab; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.product_variant_price
    ADD CONSTRAINT "FK_e6126cd268aea6e9b31d89af9ab" FOREIGN KEY ("variantId") REFERENCES public.product_variant(id) ON DELETE CASCADE;


--
-- Name: stock_movement FK_e65ba3882557cab4febb54809bb; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.stock_movement
    ADD CONSTRAINT "FK_e65ba3882557cab4febb54809bb" FOREIGN KEY ("productVariantId") REFERENCES public.product_variant(id);


--
-- Name: product_variant_options_product_option FK_e96a71affe63c97f7fa2f076dac; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.product_variant_options_product_option
    ADD CONSTRAINT "FK_e96a71affe63c97f7fa2f076dac" FOREIGN KEY ("productOptionId") REFERENCES public.product_option(id);


--
-- Name: facet_translation FK_eaea53f44bf9e97790d38a3d68f; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.facet_translation
    ADD CONSTRAINT "FK_eaea53f44bf9e97790d38a3d68f" FOREIGN KEY ("baseId") REFERENCES public.facet(id) ON DELETE CASCADE;


--
-- Name: session FK_eb87ef1e234444728138302263b; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.session
    ADD CONSTRAINT "FK_eb87ef1e234444728138302263b" FOREIGN KEY ("activeChannelId") REFERENCES public.channel(id);


--
-- Name: region FK_ed0c8098ce6809925a437f42aec; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.region
    ADD CONSTRAINT "FK_ed0c8098ce6809925a437f42aec" FOREIGN KEY ("parentId") REFERENCES public.region(id) ON DELETE SET NULL;


--
-- Name: shipping_method_channels_channel FK_f0a17b94aa5a162f0d422920eb2; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.shipping_method_channels_channel
    ADD CONSTRAINT "FK_f0a17b94aa5a162f0d422920eb2" FOREIGN KEY ("shippingMethodId") REFERENCES public.shipping_method(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: shipping_method_channels_channel FK_f2b98dfb56685147bed509acc3d; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.shipping_method_channels_channel
    ADD CONSTRAINT "FK_f2b98dfb56685147bed509acc3d" FOREIGN KEY ("channelId") REFERENCES public.channel(id) ON DELETE CASCADE;


--
-- Name: order_fulfillments_fulfillment FK_f80d84d525af2ffe974e7e8ca29; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.order_fulfillments_fulfillment
    ADD CONSTRAINT "FK_f80d84d525af2ffe974e7e8ca29" FOREIGN KEY ("orderId") REFERENCES public."order"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product_variant_asset FK_fa21412afac15a2304f3eb35feb; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.product_variant_asset
    ADD CONSTRAINT "FK_fa21412afac15a2304f3eb35feb" FOREIGN KEY ("productVariantId") REFERENCES public.product_variant(id) ON DELETE CASCADE;


--
-- Name: collection_product_variants_product_variant FK_fb05887e2867365f236d7dd95ee; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.collection_product_variants_product_variant
    ADD CONSTRAINT "FK_fb05887e2867365f236d7dd95ee" FOREIGN KEY ("productVariantId") REFERENCES public.product_variant(id);


--
-- Name: asset_tags_tag FK_fb5e800171ffbe9823f2cc727fd; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.asset_tags_tag
    ADD CONSTRAINT "FK_fb5e800171ffbe9823f2cc727fd" FOREIGN KEY ("tagId") REFERENCES public.tag(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: stock_location_channels_channel FK_ff8150fe54e56a900d5712671a0; Type: FK CONSTRAINT; Schema: public; Owner: vendure
--

ALTER TABLE ONLY public.stock_location_channels_channel
    ADD CONSTRAINT "FK_ff8150fe54e56a900d5712671a0" FOREIGN KEY ("channelId") REFERENCES public.channel(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

