-- This is a Postgres database using TimeScale DB optimisations for timeseries data
-- Please refer to my github "Selenium-webscraping-/blob/master/bitmex_data.py" for downloading the csv files from Bitmex"

DROP TABLE IF EXISTS digital_assets;
CREATE TABLE digital_assets (
    id SERIAL PRIMARY KEY,
    symbol TEXT NOT NULL
);

DROP TABLE IF EXISTS bitmex_lob;
CREATE TABLE bitmex_lob (
    tstamp TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    symbol_id INTEGER NOT NULL,
    bidSize INTEGER NOT NULL,
    bidPrice NUMERIC,
    askPrice NUMERIC,
    askSize INTEGER NOT NULL,
    PRIMARY KEY (tstamp, symbol_id),
    CONSTRAINT fk_dLOB FOREIGN KEY (symbol_id) REFERENCES digital_assets (id)
);

DROP TABLE IF EXISTS bitmex_trades;
CREATE TABLE bitmex_trades (
    tstamp TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    symbol_id INTEGER NOT NULL,
    side TEXT NOT NULL,
    size INTEGER NOT NULL,
    price NUMERIC,
    tDirection TEXT NOT NULL,
    gross INTEGER NOT NULL,
    hNotional NUMERIC,
    fNotional NUMERIC,
    PRIMARY KEY (tstamp, symbol_id),
    CONSTRAINT fk_dTrade FOREIGN KEY (symbol_id) REFERENCES digital_assets (id)
);

-- Builds binary trees on the symbol to speed up searches. 
-- Not too useful here as the symbol_id is a primary key and indexed already (showcasing an optimisation)
CREATE INDEX ON bitmex_lob (symbol_id, tstamp DESC);
CREATE INDEX ON bitmex_trades (symbol_id, tstamp DESC);

-- TimeScaleDB conversion 
SELECT create_hypertable(bitmex_lob, 'tstamp');
SELECT create_hypertable(bitmex_trades, 'tstamp');

