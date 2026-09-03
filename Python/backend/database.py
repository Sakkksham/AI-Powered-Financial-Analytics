import os

import mysql.connector
import pandas as pd
from dotenv import load_dotenv


load_dotenv()


def get_connection():
    return mysql.connector.connect(
        host=os.getenv("MYSQL_HOST", "localhost"),
        user=os.getenv("MYSQL_USER", "root"),
        password=os.getenv("MYSQL_PASSWORD"),
        database=os.getenv("MYSQL_DATABASE", "financial_analytics")
    )


def run_query(sql):
    conn = get_connection()

    try:
        return pd.read_sql(sql, conn)
    finally:
        conn.close()