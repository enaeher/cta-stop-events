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
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: route; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE route (
    id text NOT NULL,
    name text NOT NULL
);


--
-- Name: stop; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE stop (
    id integer NOT NULL,
    name text NOT NULL,
    latitude numeric,
    longitude numeric
);


--
-- Name: stop_event; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE stop_event (
    stop_time timestamp without time zone NOT NULL,
    direction text NOT NULL,
    stop_id bigint NOT NULL,
    bus_id bigint NOT NULL,
    route_id text NOT NULL
);


--
-- Name: stop_route_direction; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE stop_route_direction (
    stop integer NOT NULL,
    route text NOT NULL,
    direction text NOT NULL
);


--
-- Name: bus_route_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY route
    ADD CONSTRAINT bus_route_pkey PRIMARY KEY (id);


--
-- Name: bus_stop_event_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY stop_event
    ADD CONSTRAINT bus_stop_event_pkey PRIMARY KEY (stop_time, stop_id, route_id, direction);


--
-- Name: stop_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY stop
    ADD CONSTRAINT stop_pkey PRIMARY KEY (id);


--
-- Name: stop_route_direction_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY stop_route_direction
    ADD CONSTRAINT stop_route_direction_pkey PRIMARY KEY (stop, route, direction);


--
-- Name: route_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX route_id ON route USING btree (id);


--
-- Name: stop_route_direction_route_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY stop_route_direction
    ADD CONSTRAINT stop_route_direction_route_fkey FOREIGN KEY (route) REFERENCES route(id);


--
-- Name: stop_route_direction_stop_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY stop_route_direction
    ADD CONSTRAINT stop_route_direction_stop_fkey FOREIGN KEY (stop) REFERENCES stop(id);


--
-- PostgreSQL database dump complete
--

