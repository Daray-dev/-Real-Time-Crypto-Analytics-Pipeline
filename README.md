Real-Time Crypto Analytics Pipeline

A production-style streaming data pipeline that ingests live cryptocurrency market data via public APIs, processes it in real time, applies anomaly detection logic, and loads it into SQL Server for time-series analytics and reporting.
Built entirely in Python and T-SQL. No third-party orchestration frameworks — just clean, readable engineering fundamentals.

Architecture
┌─────────────────────┐
│  CoinGecko API      │  ← Free public market data (price, volume, market cap)
└────────┬────────────┘
         │
         ▼
┌─────────────────────┐
│  Python Ingestion   │  ← Polling loop with retry logic + rate limit handling
│  Layer              │
└────────┬────────────┘
         │
         ▼
┌─────────────────────┐
│  Real-Time          │  ← Parses JSON response, validates fields, timestamps data
│  Processing         │
└────────┬────────────┘
         │
         ▼
┌─────────────────────┐
│  Anomaly Detection  │  ← Rolling z-score flags irregular price movements
│  Engine             │    Writes alerts to separate SQL table
└────────┬────────────┘
         │
         ▼
┌─────────────────────┐
│  SQL Server         │  ← DDL schema optimized for time-series queries
│  (CryptoDB)         │    Composite index on (symbol, captured_at)
└────────┬────────────┘
         │
         ▼
┌─────────────────────┐
│  Analytics Layer    │  ← Time-series queries, market signal reporting
└─────────────────────┘

Tech Stack
LayerTechnologyLanguagePython 3.11+DatabaseMicrosoft SQL ServerQuery LanguageT-SQLAPI SourceCoinGecko (free tier)DB DriverpyodbcHTTP ClientrequestsAnomaly DetectionRolling z-score (custom Python)

Features

Live API ingestion — polls real-time price, volume, and market cap across multiple crypto assets
Fault-tolerant — handles timeouts, HTTP errors, and rate limits gracefully without crashing the pipeline
DDL schema design — structured SQL Server tables with composite indexes for fast time-series querying
Anomaly detection — flags irregular price movements using a rolling statistical window
Alert table — separate SQL table captures flagged events for downstream analysis
End-to-end Python — API → processing → SQL load all in a single clean pipeline


Project Structure
Real-Time-Crypto-Analytics-Pipeline/
│
├── Code/
│   ├── connection_test.py       # Verify SQL Server connectivity before running
│   ├── api_fetch.py             # CoinGecko API ingestion with error handling
│   ├── ddl_schema.sql           # CREATE TABLE statements and index definitions
│   ├── pipeline.py              # Main pipeline orchestration loop
│   └── anomaly_detection.py     # Rolling z-score logic and alert writing
│
└── README.md

Getting Started
Prerequisites

Python 3.11+
Microsoft SQL Server (local or remote instance)
SQL Server Management Studio (SSMS) — optional but recommended

1. Clone the repository
bashgit clone https://https://github.com/Daray-dev/Real-Time-Crypto-Pipeline.git
cd Real-Time-Crypto-Analytics-Pipeline
2. Install dependencies
bashpip install requests pyodbc
3. Set up the database
Open SSMS and create a new database:
sqlCREATE DATABASE CryptoDB;
Then run the DDL script to create your tables:
sql-- Run Code/ddl_schema.sql in SSMS against CryptoDB
4. Test your connection
Edit connection_test.py with your server name and database, then run:
bashpython Code/connection_test.py
Expected output: Connection successful.
5. Run the pipeline
bashpython Code/pipeline.py
The pipeline will begin polling the API, processing data, and loading records into SQL Server in real time.

Schema Design
sql-- Core price table
CREATE TABLE crypto_prices (
    id          INT IDENTITY PRIMARY KEY,
    symbol      VARCHAR(20)    NOT NULL,
    price_usd   DECIMAL(18,8)  NOT NULL,
    volume_24h  DECIMAL(24,2),
    market_cap  DECIMAL(24,2),
    captured_at DATETIME2      NOT NULL DEFAULT GETUTCDATE(),
    INDEX ix_symbol_time (symbol, captured_at DESC)
);

-- Anomaly alerts table
CREATE TABLE price_alerts (
    id           INT IDENTITY PRIMARY KEY,
    symbol       VARCHAR(20)   NOT NULL,
    price_usd    DECIMAL(18,8) NOT NULL,
    z_score      FLOAT         NOT NULL,
    alert_type   VARCHAR(50),
    triggered_at DATETIME2     NOT NULL DEFAULT GETUTCDATE()
);
The composite index on (symbol, captured_at DESC) ensures fast filtering by asset across any time window — critical for time-series performance at scale.

Anomaly Detection Logic
Price anomalies are detected using a rolling z-score approach:

Calculate the rolling mean and standard deviation of price over a configurable window
Compute the z-score for each incoming price point
Flag any point where |z_score| > threshold (default: 2.5)
Write flagged records to the price_alerts table with the computed z-score

This approach detects sudden spikes and drops relative to recent price behavior — more adaptive than static threshold alerts.

Key Engineering Decisions
Why polling instead of websocket streaming?
Polling via REST is simpler to implement, easier to debug, and sufficient for minute-level granularity. A websocket upgrade is a natural next step for sub-second latency requirements.
Why SQL Server over a cloud data warehouse?
This project prioritizes demonstrating core data engineering fundamentals — schema design, indexing strategy, ETL logic — without cloud infrastructure dependencies. The architecture maps directly to cloud equivalents (Azure SQL, Snowflake, BigQuery).
Why a composite index on (symbol, captured_at)?
Most analytical queries filter by asset over a time range. Without this index, those queries require a full table scan. With it, they're O(log n) lookups.

What I Learned Building This

Error handling and retry logic are the most important parts of any production pipeline
Schema decisions compound — a well-indexed table at design time saves weeks of refactoring later
Anomaly detection window size requires empirical tuning — too small creates noise, too large misses real signals
Shipping a working project teaches more than any tutorial


What's Next

 Add requirements.txt for reproducible installs
 Environment variable support for DB credentials (.env + python-dotenv)
 Configurable polling interval and anomaly threshold via config.yaml
 Docker support for portable local deployment
 Power BI dashboard connected to the SQL Server analytics layer


Author
Ray Molden — Data Analyst transitioning to Data Engineering
LinkedIn · GitHub · Newsletter

License
MIT License — use freely, attribution appreciated.
