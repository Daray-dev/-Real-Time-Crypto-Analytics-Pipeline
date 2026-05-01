import requests
import pyodbc

# --- connect SQL Server --
conn = pyodbc.connect( "DRIVER={ODBC Driver 17 for SQL Server};"
    "SERVER=localhost\\SQLEXPRESS;"
    "DATABASE=CryptoDW;"
    "Trusted_Connection=yes;"
    )
cursor = conn.cursor()

# --- fetch from CoinGecko --
url = "https://api.coingecko.com/api/v3/simple/price"
params = {
    "ids": "bitcoin,ethereum",
    "vs_currencies": "usd",
    "include_24hr_vol": "true",
    "include_24hr_change": "true"
}

response = requests.get(url, params=params)
data = response.json()
print("fetched:", data)

# --- Loop through each coin and insert --
for coin_name, values in data.items():
    cursor.execute("""
        INSERT INTO coin_watch (coin_name, usd, usd_24h_vol, usd_24h_change, fetch_at)
        VALUES (?, ?, ?, ?, GETDATE())
    """,
        coin_name,
        values["usd"],
        values["usd_24h_vol"],
        values["usd_24h_change"]
        
        )

conn.commit()
print("Data inserted successfully!")

cursor.close()
conn.close ()
