import sqlite3
import os
import io
import matplotlib
matplotlib.use('Agg') 
import matplotlib.pyplot as plt
from fastapi import FastAPI
from fastapi.responses import Response, HTMLResponse
from pydantic import BaseModel

app = FastAPI()

# 1. CONFIG
DB_PATH = 'localserver/track.db'
if not os.path.exists('localserver'):
    os.makedirs('localserver')

class Ping(BaseModel):
    id: int  
    x: int
    z: int

# 2. DB SETUP (With Locking Fix)
def init_db():
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()
    
    # --- FIX: Enable Write-Ahead Logging (WAL) ---
    # This prevents the database from locking when reading and writing simultaneously
    cursor.execute("PRAGMA journal_mode=WAL;")
    
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

# --- ENDPOINT 1: API ---
@app.post("/api/ping")
def logPing(ping: Ping):
    # Use a context manager (with) to ensure the connection always closes, even if errors happen
    with sqlite3.connect(DB_PATH) as conn:
        cursor = conn.cursor()
        cursor.execute("INSERT INTO pings (device_id, x, z) VALUES (?, ?, ?)", 
                       (ping.id, ping.x, ping.z))
        conn.commit()
    return {"status": "success"}

# --- ENDPOINT 2: Smart Map Generator ---
@app.get("/map")
def get_map_image():
    # Fetch Data
    with sqlite3.connect(DB_PATH) as conn:
        c = conn.cursor()
        c.execute("SELECT x, z FROM pings")
        data = c.fetchall()

    if not data:
        return Response(content="No data yet.", media_type="text/plain")

    xs = [row[0] for row in data]
    zs = [row[1] for row in data]

    # Plot Setup
    plt.figure(figsize=(10, 8))
    plt.style.use('dark_background')
    
    # --- VISUAL FIX: Smart Switch ---
    # If we have less than 100 pings, use BIG DOTS (Scatter). 
    # If we have more, use the HEATMAP.
    if len(data) < 100:
        plt.scatter(xs, zs, color='#ff00ff', s=100, alpha=0.6) # s=100 makes dots huge
        plt.title(f"Live Tracking (Scatter Mode): {len(data)} pings")
    else:
        plt.hist2d(xs, zs, bins=100, cmap='inferno', cmin=1) # Reduced bins to 100 for better visibility
        plt.title(f"Live Tracking (Heatmap Mode): {len(data)} pings")
        plt.colorbar(label='Dwell Time')

    plt.xlabel("X")
    plt.ylabel("Z")
    plt.axis('equal') 
    plt.grid(True, alpha=0.3) # Add a faint grid to help see movement

    # Save to buffer
    buf = io.BytesIO()
    plt.savefig(buf, format='png')
    buf.seek(0)
    plt.close()

    return Response(content=buf.getvalue(), media_type="image/png")

# --- ENDPOINT 3: Dashboard ---
@app.get("/live", response_class=HTMLResponse)
def live_dashboard():
    html_content = """
    <html>
        <head>
            <title>Turtle Tracker</title>
            <meta http-equiv="refresh" content="2"> <style>
                body { background-color: #111; color: white; font-family: monospace; text-align: center; }
                img { border: 2px solid #555; margin-top: 20px; max-width: 90%; height: auto; }
            </style>
        </head>
        <body>
            <h1>SYSTEM TRACKING</h1>
            <img id="mapImage" src="/map" />
            <script>
                setInterval(function() {
                    var img = document.getElementById('mapImage');
                    img.src = '/map?t=' + new Date().getTime();
                }, 2000);
            </script>
        </body>
    </html>
    """
    return html_content