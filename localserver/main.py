import sqlite3
import os
import math
from collections import Counter
from fastapi import FastAPI
from fastapi.responses import HTMLResponse
from pydantic import BaseModel
from typing import List

app = FastAPI()

# --- CONFIG ---
DB_PATH = 'localserver/track.db'
if not os.path.exists('localserver'):
    os.makedirs('localserver')

class Ping(BaseModel):
    id: int  
    x: float
    z: float

def init_db():
    conn = sqlite3.connect(DB_PATH)
    c = conn.cursor()
    c.execute("PRAGMA journal_mode=WAL;") 
    c.execute('''CREATE TABLE IF NOT EXISTS pings (
                 row_id INTEGER PRIMARY KEY AUTOINCREMENT,
                 device_id TEXT, x REAL, z REAL,
                 timestamp DATETIME DEFAULT CURRENT_TIMESTAMP)''')
    conn.commit()
    conn.close()

init_db()

# --- HELPER: INTERPOLATION ---
def get_points_on_line(x0, y0, x1, y1):
    points = []
    dx = abs(x1 - x0)
    dy = abs(y1 - y0)
    x, y = x0, y0
    sx = -1 if x0 > x1 else 1
    sy = -1 if y0 > y1 else 1
    if dx > dy:
        err = dx / 2.0
        while x != x1:
            points.append((x, y))
            err -= dy
            if err < 0:
                y += sy
                err += dx
            x += sx
    else:
        err = dy / 2.0
        while y != y1:
            points.append((x, y))
            err -= dx
            if err < 0:
                x += sx
                err += dy
            y += sy
    points.append((x, y))
    return points

# --- API: TURTLE INPUT ---
@app.post("/api/batch")
def log_batch(pings: List[Ping]):
    with sqlite3.connect(DB_PATH) as conn:
        c = conn.cursor()
        data = [(p.id, p.x, p.z) for p in pings]
        c.executemany("INSERT INTO pings (device_id, x, z) VALUES (?, ?, ?)", data)
        conn.commit()
    return {"status": "success"}

# --- API: BROWSER DATA FETCH ---
@app.get("/api/map-data")
def get_map_data():
    with sqlite3.connect(DB_PATH) as conn:
        c = conn.cursor()
        c.execute("SELECT x, z FROM pings ORDER BY row_id ASC")
        data = c.fetchall()

    if not data:
        return {"blocks": [], "current": None}

    # 1. Interpolate Path
    all_blocks = []
    for i in range(len(data) - 1):
        x1, z1 = int(math.floor(data[i][0])), int(math.floor(data[i][1]))
        x2, z2 = int(math.floor(data[i+1][0])), int(math.floor(data[i+1][1]))
        
        # Skip teleports
        if abs(x1 - x2) > 50 or abs(z1 - z2) > 50:
            all_blocks.append((x1, z1))
            continue
            
        all_blocks.extend(get_points_on_line(x1, z1, x2, z2))

    # Add last point
    last_x = int(math.floor(data[-1][0]))
    last_z = int(math.floor(data[-1][1]))
    all_blocks.append((last_x, last_z))

    # 2. Count Frequency
    counts = Counter(all_blocks)
    
    # 3. Format for JSON: [[x, z, count], ...]
    # This is very lightweight to send
    result_grid = [[k[0], k[1], v] for k, v in counts.items()]
    
    return {
        "blocks": result_grid,
        "current": [last_x, last_z]
    }

# --- FRONTEND: THE WEB RENDERER ---
@app.get("/live", response_class=HTMLResponse)
def serve_renderer():
    # We serve the HTML/JS directly from Python so you don't need extra files
    return """
<!DOCTYPE html>
<html>
<head>
    <title>Turtle Tracker</title>
    <style>
        body { margin: 0; background: #050505; overflow: hidden; font-family: monospace; color: white; }
        canvas { display: block; }
        #ui { position: absolute; top: 10px; left: 10px; background: rgba(0,0,0,0.7); padding: 10px; border: 1px solid #444; pointer-events: none; }
    </style>
</head>
<body>
    <div id="ui">
        <div>STATUS: <span id="status" style="color: lime">Connecting...</span></div>
        <div>COORDS: <span id="coords">0, 0</span></div>
        <div>ZOOM: <span id="zoomLvl">1.0</span>x</div>
    </div>
    <canvas id="mapCanvas"></canvas>

    <script>
        const canvas = document.getElementById('mapCanvas');
        const ctx = canvas.getContext('2d');
        const uiCoords = document.getElementById('coords');
        const uiZoom = document.getElementById('zoomLvl');
        const uiStatus = document.getElementById('status');

        // STATE
        let camera = { x: 0, y: 0, zoom: 10 }; // x,y is center of screen
        let isDragging = false;
        let lastMouse = { x: 0, y: 0 };
        let mapData = [];
        let currentPos = null;
        let maxCount = 1;

        // RESIZE
        function resize() {
            canvas.width = window.innerWidth;
            canvas.height = window.innerHeight;
            draw();
        }
        window.addEventListener('resize', resize);
        
        // --- INPUT HANDLING (PAN/ZOOM) ---
        canvas.addEventListener('mousedown', e => { isDragging = true; lastMouse = { x: e.clientX, y: e.clientY }; });
        canvas.addEventListener('mouseup', () => isDragging = false);
        canvas.addEventListener('mousemove', e => {
            // Update UI Coords
            const worldX = Math.floor((e.clientX - canvas.width/2) / camera.zoom + camera.x);
            const worldZ = Math.floor((e.clientY - canvas.height/2) / camera.zoom + camera.y);
            uiCoords.innerText = `${worldX}, ${worldZ}`;

            if (isDragging) {
                const dx = e.clientX - lastMouse.x;
                const dy = e.clientY - lastMouse.y;
                camera.x -= dx / camera.zoom;
                camera.y -= dy / camera.zoom;
                lastMouse = { x: e.clientX, y: e.clientY };
                draw();
            }
        });
        
        canvas.addEventListener('wheel', e => {
            const zoomSpeed = 0.1;
            if (e.deltaY < 0) camera.zoom *= (1 + zoomSpeed);
            else camera.zoom /= (1 + zoomSpeed);
            uiZoom.innerText = camera.zoom.toFixed(1);
            draw();
        });

        // --- COLOR MAP (INFERNO-ISH) ---
        function getColor(val) {
            // Logarithmic scaling logic
            let norm = Math.log(val) / Math.log(maxCount || 1); 
            if (val === 1) norm = 0; 
            if (norm > 1) norm = 1;

            // Simple Heatmap Gradient: Purple -> Red -> Yellow -> White
            if (norm < 0.33) {
                // Purple (50, 0, 100) to Red (255, 0, 0)
                let r = 50 + (205 * (norm / 0.33));
                let b = 100 - (100 * (norm / 0.33));
                return `rgb(${r}, 0, ${b})`;
            } else if (norm < 0.66) {
                // Red to Yellow (255, 255, 0)
                let g = 255 * ((norm - 0.33) / 0.33);
                return `rgb(255, ${g}, 0)`;
            } else {
                // Yellow to White
                let w = 255 * ((norm - 0.66) / 0.34);
                return `rgb(255, 255, ${w})`;
            }
        }

        // --- RENDER LOOP ---
        function draw() {
            // Clear Screen
            ctx.fillStyle = '#050505';
            ctx.fillRect(0, 0, canvas.width, canvas.height);

            const cx = canvas.width / 2;
            const cy = canvas.height / 2;

            // 1. Draw Grid (Optional, triggers if zoomed in)
            if (camera.zoom > 15) {
                ctx.beginPath();
                ctx.strokeStyle = '#222';
                ctx.lineWidth = 1;
                
                // Calculate visible range to optimize
                const startX = Math.floor(camera.x - cx / camera.zoom);
                const endX = Math.ceil(camera.x + cx / camera.zoom);
                const startY = Math.floor(camera.y - cy / camera.zoom);
                const endY = Math.ceil(camera.y + cy / camera.zoom);

                for (let x = startX; x <= endX; x++) {
                    let screenX = (x - camera.x) * camera.zoom + cx;
                    ctx.moveTo(screenX, 0); ctx.lineTo(screenX, canvas.height);
                }
                for (let y = startY; y <= endY; y++) {
                    let screenY = (y - camera.y) * camera.zoom + cy;
                    ctx.moveTo(0, screenY); ctx.lineTo(canvas.width, screenY);
                }
                ctx.stroke();
            }

            // 2. Draw Heatmap Blocks
            // Optimization: Only draw blocks inside the screen? 
            // For < 100k blocks, drawing all is usually fine on modern GPU.
            mapData.forEach(block => {
                const [x, z, count] = block;
                const screenX = (x - camera.x) * camera.zoom + cx;
                const screenZ = (z - camera.y) * camera.zoom + cy;
                
                // Culling: Don't draw if off screen
                if (screenX < -camera.zoom || screenX > canvas.width || screenZ < -camera.zoom || screenZ > canvas.height) return;

                ctx.fillStyle = getColor(count);
                // Draw rectangle slightly larger to prevent "cracks" between blocks
                ctx.fillRect(screenX, screenZ, camera.zoom + 0.5, camera.zoom + 0.5);
            });

            // 3. Draw Current Location (Green Box)
            if (currentPos) {
                const screenX = (currentPos[0] - camera.x) * camera.zoom + cx;
                const screenZ = (currentPos[1] - camera.y) * camera.zoom + cy;
                
                ctx.fillStyle = '#00ff00';
                ctx.fillRect(screenX, screenZ, camera.zoom, camera.zoom);
                
                // Glow effect
                ctx.strokeStyle = 'white';
                ctx.lineWidth = 2;
                ctx.strokeRect(screenX, screenZ, camera.zoom, camera.zoom);
            }
        }

        // --- DATA FETCHING ---
        async function fetchData() {
            try {
                const res = await fetch('/api/map-data');
                const json = await res.json();
                
                mapData = json.blocks;
                currentPos = json.current;

                // Recalculate Max for color scaling
                maxCount = 0;
                mapData.forEach(b => { if(b[2] > maxCount) maxCount = b[2]; });

                // If first load, center camera on player
                if (mapData.length > 0 && camera.x === 0 && camera.y === 0 && currentPos) {
                    camera.x = currentPos[0];
                    camera.y = currentPos[1];
                }
                
                uiStatus.innerText = "Connected";
                uiStatus.style.color = "lime";
                draw();
            } catch (err) {
                console.error(err);
                uiStatus.innerText = "Disconnected";
                uiStatus.style.color = "red";
            }
        }

        // Start
        resize();
        fetchData();
        setInterval(fetchData, 2000); // Refresh data every 2s

    </script>
</body>
</html>
    """