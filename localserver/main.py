import sqlite3
import os
from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI()

# 1. SETUP: Create folder if missing
if not os.path.exists('localserver'):
    os.makedirs('localserver')

# 2. MODEL: "id" matches what Lua sends
class Ping(BaseModel):
    id: str  
    x: int
    z: int

def init_db():
    conn = sqlite3.connect('localserver/track.db')
    cursor = conn.cursor()
    # 3. DATABASE: Renamed the text column to 'device_id' to avoid conflict
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS pings (
            row_id INTEGER PRIMARY KEY AUTOINCREMENT,
            device_id TEXT,
            x INTEGER,
            z INTEGER,
            timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
        )
    ''')
    conn.commit()
    conn.close()

init_db()

@app.post("/api/ping")
def logPing(ping: Ping):
    conn = sqlite3.connect('localserver/track.db')
    cursor = conn.cursor()
    # 4. INSERT: Map the incoming 'id' to 'device_id'
    cursor.execute('''
        INSERT INTO pings (device_id, x, z)
        VALUES (?, ?, ?)
    ''', (ping.id, ping.x, ping.z))
    conn.commit()
    conn.close()
    return {"status": "success"}