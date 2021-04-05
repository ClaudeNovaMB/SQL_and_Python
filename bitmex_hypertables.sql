-- This is a Postgres database using TimeScale DB optimisations for timeseries data
-- Please refer to my github "Selenium-webscraping-/blob/master/bitmex_data.py" for downloading the csv files from Bitmex"

DROP TABLE IF EXISTS digital_assets;
CREATE TABLE digital_assets (
    id SERIAL PRIMARY KEY,
    symbol TEXT NOT NULL
);

DROP TABLE IF EXISTS bitmex_lob;
CREATE TABLE bitmex_lob (
    timestamp TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    symbol_id INTEGER NOT NULL,
    bid_size INTEGER NOT NULL,
    bid_price NUMERIC,
    ask_price NUMERIC,
    ask_size INTEGER NOT NULL,
    PRIMARY KEY (timestamp, symbol_id),
    CONSTRAINT fk_dlob FOREIGN KEY (symbol_id) REFERENCES digital_assets (id)
);

DROP TABLE IF EXISTS bitmex_trades;
CREATE TABLE bitmex_trades (
    timestamp TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    symbol_id INTEGER NOT NULL,
    side TEXT NOT NULL,
    size INTEGER NOT NULL,
    price NUMERIC,
    tick_direction TEXT NOT NULL,
    gross INTEGER NOT NULL,
    home_notional NUMERIC,
    foreign_notional NUMERIC,
    PRIMARY KEY (tstamp, symbol_id),
    CONSTRAINT fk_dtrade FOREIGN KEY (symbol_id) REFERENCES digital_assets (id)
);

-- Builds binary trees on the symbol to speed up searches. 
-- Not too useful here as the symbol_id is a primary key and indexed already (showcasing an optimisation)
CREATE INDEX ON bitmex_lob (symbol_id, timestamp DESC);
CREATE INDEX ON bitmex_trades (symbol_id, timestamp DESC);

-- TimeScaleDB conversion 
SELECT create_hypertable('bitmex_lob', 'timestamp');
SELECT create_hypertable('bitmex_trades', 'timestamp');

