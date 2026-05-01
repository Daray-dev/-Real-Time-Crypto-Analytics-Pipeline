# -Real-Time-Crypto-Analytics-Pipeline
A production-style data engineering project that ingests, processes, and analyzes real-time cryptocurrency market data to generate actionable insights, anomaly detection, and market intelligence.






<img width="1440" height="1640" alt="image" src="https://github.com/user-attachments/assets/139012e1-6890-4597-a1cf-52bfe782e668" />







====================================================================================================================================================================================================
PHASE 1


Check if Python is installed — open CMD and type python --version. If nothing comes back, download Python 3.11+ from python.org
Open SQL Server Management Studio (SSMS) and create a new database — call it something like CryptoDB
Install two Python libraries you'll need:


<img width="1098" height="233" alt="image" src="https://github.com/user-attachments/assets/f13f0935-259e-45d5-8473-b134cde6cdee" />



==========================================================================================================================================================================================================


 Test the connection in Python
Create a new file called test_connection.py and paste this — filling in your own server name and database:

<img width="558" height="234" alt="image" src="https://github.com/user-attachments/assets/a2d2a3dc-1fa5-4b51-976d-ccede0bfa10d" />

==========================================================================================================================================================================================================

PHASE 2 


It's now time to fetch our data using API's that are essential to our pipeline.

<img width="499" height="322" alt="image" src="https://github.com/user-attachments/assets/b5b15943-115c-4083-82ce-e66eb8fe4789" />



=====================================================================================================================================================

PHASE 3

We have recieved the output - now it;s time to start structuring your DDL

<img width="432" height="212" alt="image" src="https://github.com/user-attachments/assets/4c62d186-e6f4-4d7b-8499-68c3717644b9" />




<img width="671" height="301" alt="image" src="https://github.com/user-attachments/assets/55261874-52d4-4373-8fa6-21b6d6a63a1b" />















========================================================================================================================================

PHASE 6

This pipeline is fully automated using Windows Task Scheduler.

Configuration:
- Trigger: Daily at 10:39 AM
- Repeat: Every 5 minutes indefinitely

Execution:
Program:
python.exe

Arguments:
C:\CryptoProject\fetch_data.py

Working Directory:
C:\CryptoProject\

