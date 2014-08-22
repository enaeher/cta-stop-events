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


--
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry, geography, and raster spatial types and functions';


SET search_path = public, pg_catalog;

--
-- Name: generate_stop_intervals(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION generate_stop_intervals() RETURNS void
    LANGUAGE sql
    AS $$
  WITH preliminary_intervals (interval_start, interval_end, stop_route_direction) AS
  (SELECT lag(stop_time) OVER w interval_start, stop_time interval_end, stop_route_direction
    FROM stop_event se
    WHERE NOT EXISTS
      (SELECT true
        FROM stop_interval si
        WHERE si.interval_end = se.stop_time
        AND si.stop_route_direction = se.stop_route_direction)
    WINDOW w AS (PARTITION BY stop_route_direction ORDER BY stop_time))
  INSERT INTO stop_interval (interval_start, interval_end, stop_route_direction)
  SELECT interval_start, interval_end, stop_route_direction FROM preliminary_intervals WHERE interval_start IS NOT NULL;
$$;


--
-- Name: update_stop_location(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION update_stop_location() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  BEGIN
    -- Populate stop_location with PostGIS POINT based on the provided latitude and longitude
    NEW.stop_location := ('SRID=4326;POINT(' || NEW.longitude || ' ' || NEW.latitude || ')')::geometry;
    RETURN NEW;
  END;
$$;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: event_log; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE event_log (
    id bigint NOT NULL,
    event_time timestamp without time zone,
    event_type text,
    description text
);


--
-- Name: log_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE log_id_seq OWNED BY event_log.id;


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
    longitude numeric,
    stop_location geometry(Point,4326)
);


--
-- Name: stop_event; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE stop_event (
    stop_time timestamp without time zone NOT NULL,
    bus integer NOT NULL,
    stop_route_direction integer NOT NULL
);


--
-- Name: stop_interval; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE stop_interval (
    interval_start timestamp without time zone,
    interval_end timestamp without time zone,
    stop_route_direction integer
);


--
-- Name: stop_route_direction; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE stop_route_direction (
    stop integer NOT NULL,
    route text NOT NULL,
    direction text NOT NULL,
    id integer NOT NULL
);


--
-- Name: stop_route_direction_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE stop_route_direction_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: stop_route_direction_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE stop_route_direction_id_seq OWNED BY stop_route_direction.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY event_log ALTER COLUMN id SET DEFAULT nextval('log_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY stop_route_direction ALTER COLUMN id SET DEFAULT nextval('stop_route_direction_id_seq'::regclass);


--
-- Name: bus_route_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY route
    ADD CONSTRAINT bus_route_pkey PRIMARY KEY (id);


--
-- Name: stop_event_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY stop_event
    ADD CONSTRAINT stop_event_pkey PRIMARY KEY (stop_route_direction, stop_time);


--
-- Name: stop_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY stop
    ADD CONSTRAINT stop_pkey PRIMARY KEY (id);


--
-- Name: stop_route_direction_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY stop_route_direction
    ADD CONSTRAINT stop_route_direction_pkey PRIMARY KEY (id);


--
-- Name: stop_route_direction_stop_route_direction_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY stop_route_direction
    ADD CONSTRAINT stop_route_direction_stop_route_direction_key UNIQUE (stop, route, direction);


--
-- Name: route_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX route_id ON route USING btree (id);


--
-- Name: stop_event_stop_route_direction_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX stop_event_stop_route_direction_idx ON stop_event USING btree (stop_route_direction);


--
-- Name: stop_event_stop_time_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX stop_event_stop_time_idx ON stop_event USING btree (stop_time);


--
-- Name: stop_route_direction_direction_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX stop_route_direction_direction_idx ON stop_route_direction USING btree (direction);


--
-- Name: stop_route_direction_route_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX stop_route_direction_route_idx ON stop_route_direction USING btree (route);


--
-- Name: stop_route_direction_stop_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX stop_route_direction_stop_idx ON stop_route_direction USING btree (stop);


--
-- Name: update_stop_location; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_stop_location BEFORE INSERT OR UPDATE ON stop FOR EACH ROW EXECUTE PROCEDURE update_stop_location();


--
-- Name: stop_event_stop_route_direction_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY stop_event
    ADD CONSTRAINT stop_event_stop_route_direction_fkey FOREIGN KEY (stop_route_direction) REFERENCES stop_route_direction(id);


--
-- Name: stop_interval_stop_route_direction_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY stop_interval
    ADD CONSTRAINT stop_interval_stop_route_direction_fkey FOREIGN KEY (stop_route_direction) REFERENCES stop_route_direction(id);


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

