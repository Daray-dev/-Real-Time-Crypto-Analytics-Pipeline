-- Creation of database --
CREATE DATABASE CryptoDW


CREATE TABLE coin_watch (
id INT IDENTITY(1,1) PRIMARY KEY,
coin_name VARCHAR(50),
usd DECIMAL(18, 8),
usd_24h_vol DECIMAL(18, 8),
usd_24h_change DECIMAL(18, 8),
fetched_at DATETIME2 DEFAULT GETDATE()

);


