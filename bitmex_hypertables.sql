-- This is a Postgres database using TimeScale DB optimisations for timeseries data
-- Please refer to my github "Selenium-webscraping-/blob/master/bitmex_data.py" for downloading the csv files from Bitmex"

DROP TABLE IF EXISTS "digitalAssets";
CREATE TABLE "digitalAssets" (
    id SERIAL PRIMARY KEY,
    symbol TEXT NOT NULL
);

DROP TABLE IF EXISTS "bitmexLOB";
CREATE TABLE "bitmexLOB" (
    tstamp TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    symbol_id TEXT NOT NULL,
    bidSize INTEGER NOT NULL,
    bidPrice NUMERIC,
    askPrice NUMERIC,
    askSize INTEGER NOT NULL,
    PRIMARY KEY (tstamp, symbol_id),
    CONSTRAINT fk_dLOB FOREIGN KEY (symbol_id) REFERENCES digitalAssets(id)
);

DROP TABLE IF EXISTS "bitmexTrades";
CREATE TABLE "bitmexTrades" (
    tstamp TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    symbol_id TEXT NOT NULL,
    side TEXT NOT NULL,
    size INTEGER NOT NULL,
    price NUMERIC,
    tDirection TEXT NOT NULL,
    gross INTEGER NOT NULL,
    hNotional NUMERIC,
    fNotional NUMERIC
    PRIMARY KEY (tstamp, symbol_id),
    CONSTRAINT fk_dTrade FOREIGN KEY (symbol_id) REFERENCES digitalAssets(id)
);

-- Builds binary trees on the symbol to speed up searches. 
-- Not too useful here as the symbol is a primary key and indexed already (showcasing an optimisation)
CREATE INDEX ON bitmexLOB (symbol_id, tstamp DESC);
CREATE INDEX ON bitmexTrades (symbol_id, tstamp DESC);

-- TimeScaleDB conversion 
SELECT create_hypertable('bitmexLOB', 'tstamp');
SELECT create_hypertable('bitmexTrades', 'tstamp');

