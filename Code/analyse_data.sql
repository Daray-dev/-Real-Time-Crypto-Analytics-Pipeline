SELECT 
coin_name,
COUNT(*) total_rows
FROM coin_watch
GROUP BY coin_name
-- Most recent numbers --
SELECT TOP 2 fetched_at,
coin_name,
usd
FROM coin_watch
ORDER BY fetched_at DESC

-- What were the highest and lowest today --
SELECT
coin_name,
MAX(usd) highest_price,
MIN(usd) lowest_price,
Max(usd) - MIN(usd) price_range
FROM coin_watch
WHERE CAST(fetched_at AS DATE) = CAST(GETDATE() AS date)
GROUP BY coin_name

-- How much price move last hour --
SELECT
coin_name,
MIN(usd) AS price_1hr_ago,
MAX(usd) AS price_now,
MAX(usd) - MIN(usd) AS movement
FROM coin_watch
WHERE CAST(fetched_at AS DATE) = CAST(GETDATE() AS DATE)
GROUP BY coin_name

-- Average price per hour --
SELECT
coin_name,
DATEPART(HOUR, fetched_at) AS hour,
AVG(usd) price,
COUNT(*) AS readings
FROM coin_watch
WHERE CAST(fetched_at AS DATE) = CAST(GETDATE() AS DATE)
GROUP BY coin_name, DATEPART(HOUR, fetched_at)
ORDER BY coin_name, HOUR