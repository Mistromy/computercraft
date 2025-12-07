import sqlite3
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation
import numpy as np
import os

# --- CONFIGURATION ---
DB_PATH = 'localserver/track.db'
REFRESH_RATE = 2000 # Update every 2000ms (2 seconds)
BIN_COUNT = 500     # The resolution of your heatmap (500x500 cells)

plt.style.use('dark_background') # For that cool "Randar" look

def fetch_data():
    if not os.path.exists(DB_PATH):
        print("Database not found. Is main.py running?")
        return []
    
    conn = sqlite3.connect(DB_PATH)
    c = conn.cursor()
    # Grab all X and Z coordinates
    c.execute("SELECT x, z FROM pings")
    data = c.fetchall()
    conn.close()
    return data

def update(frame):
    data = fetch_data()
    
    if not data:
        return
    
    xs = [row[0] for row in data]
    zs = [row[1] for row in data]
    
    plt.cla() # Clear the previous frame

    # hist2d automatically counts the frequency (dwell time) and bins the large coordinates
    counts, xedges, yedges, image = plt.hist2d(
        xs, zs, 
        bins=BIN_COUNT, 
        cmap='inferno', 
        cmin=1
    )
    
    plt.title(f"Movement Tracking | Total Pings: {len(data)}")
    plt.xlabel("X Coordinate")
    plt.ylabel("Z Coordinate")
    
    # Add a colorbar if it doesn't exist
    if not plt.gcf().axes[0].images:
        plt.colorbar(image, label='Seconds Spent at Location')

# Set up the plot window
fig = plt.figure(figsize=(10, 8))

# Run the animation
ani = FuncAnimation(fig, update, interval=REFRESH_RATE, blit=False)
plt.show()