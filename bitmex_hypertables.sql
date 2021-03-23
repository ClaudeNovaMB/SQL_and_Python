--This is a Postgres database using TimeScale DB optimisations for timeseries data

CREATE TABLE BitmexLOB(
    id SERIAL PRIMARY KEY,
    tstamp TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    symbol TEXT NOT NULL,
    bidSize INTEGER NOT NULL,
    BidPrice numeric ()

)