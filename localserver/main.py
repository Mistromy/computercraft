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

# --- API: BATCH LOGGING ---
@app.post("/api/batch")
def log_batch(pings: List[Ping]):
    with sqlite3.connect(DB_PATH) as conn:
        c = conn.cursor()
        data = [(p.id, p.x, p.z) for p in pings]
        c.executemany("INSERT INTO pings (device_id, x, z) VALUES (?, ?, ?)", data)
        conn.commit()
    return {"status": "success"}

# --- API: MAP DATA ---
@app.get("/api/map-data")
def get_map_data():
    with sqlite3.connect(DB_PATH) as conn:
        c = conn.cursor()
        c.execute("SELECT x, z FROM pings ORDER BY row_id ASC")
        data = c.fetchall()

    if not data:
        return {"blocks": [], "current": None}

    # Interpolate
    all_blocks = []
    for i in range(len(data) - 1):
        x1, z1 = int(math.floor(data[i][0])), int(math.floor(data[i][1]))
        x2, z2 = int(math.floor(data[i+1][0])), int(math.floor(data[i+1][1]))
        
        if abs(x1 - x2) > 50 or abs(z1 - z2) > 50:
            all_blocks.append((x1, z1))
            continue
            
        all_blocks.extend(get_points_on_line(x1, z1, x2, z2))

    if data:
        last_x = int(math.floor(data[-1][0]))
        last_z = int(math.floor(data[-1][1]))
        all_blocks.append((last_x, last_z))
    else:
        last_x, last_z = 0, 0

    counts = Counter(all_blocks)
    result_grid = [[k[0], k[1], v] for k, v in counts.items()]
    
    return {
        "blocks": result_grid,
        "current": [last_x, last_z]
    }

# --- FRONTEND: ADVANCED UI RENDERER ---
@app.get("/live", response_class=HTMLResponse)
def serve_renderer():
    return """
<!DOCTYPE html>
<html>
<head>
    <title>Turtle Command</title>
    <style>
        body { margin: 0; background: #0b0b0b; overflow: hidden; font-family: 'Segoe UI', monospace; color: white; }
        canvas { display: block; }
        
        /* UI Panel */
        #ui { 
            position: absolute; top: 10px; left: 10px; 
            background: rgba(20, 20, 20, 0.9); 
            padding: 15px; 
            border: 1px solid #444; 
            border-radius: 8px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.5);
            min-width: 200px;
        }
        
        .stat-row { display: flex; justify-content: space-between; margin-bottom: 5px; font-size: 14px; }
        .stat-val { font-weight: bold; color: #00ffcc; }
        
        /* Buttons */
        .btn-group { display: flex; gap: 10px; margin-top: 15px; }
        button {
            background: #333; color: white; border: 1px solid #555;
            padding: 8px 12px; cursor: pointer; border-radius: 4px;
            font-size: 12px; flex: 1; transition: 0.2s;
        }
        button:hover { background: #555; border-color: #777; }
        button:active { background: #00ffcc; color: black; }

        /* Status Indicator */
        #status { font-weight: bold; }
    </style>
</head>
<body>
    <div id="ui">
        <div style="border-bottom: 1px solid #444; padding-bottom: 5px; margin-bottom: 10px; font-weight:bold;">SYSTEM TRACKER</div>
        
        <div class="stat-row"><span>STATUS:</span> <span id="status" style="color: lime">Connecting...</span></div>
        <div class="stat-row"><span>MOUSE:</span> <span id="coords" class="stat-val">0, 0</span></div>
        <div class="stat-row"><span>ZOOM:</span> <span id="zoomLvl" class="stat-val">10.0x</span></div>
        <div class="stat-row"><span>POINTS:</span> <span id="pointCount" class="stat-val">0</span></div>

        <div class="btn-group">
            <button onclick="centerOnPlayer()">FIND PLAYER</button>
            <button onclick="fitMap()">FIT ALL</button>
        </div>
    </div>
    
    <canvas id="mapCanvas"></canvas>

    <script>
        const canvas = document.getElementById('mapCanvas');
        const ctx = canvas.getContext('2d');
        const uiCoords = document.getElementById('coords');
        const uiZoom = document.getElementById('zoomLvl');
        const uiStatus = document.getElementById('status');
        const uiPoints = document.getElementById('pointCount');

        // STATE
        let camera = { x: 0, y: 0, zoom: 15 }; 
        let isDragging = false;
        let lastMouse = { x: 0, y: 0 };
        let mapData = [];
        let currentPos = null;
        let maxCount = 1;
        let isFirstLoad = true;

        // --- RESIZE ---
        function resize() {
            canvas.width = window.innerWidth;
            canvas.height = window.innerHeight;
            draw();
        }
        window.addEventListener('resize', resize);
        
        // --- CONTROLS ---
        canvas.addEventListener('mousedown', e => { isDragging = true; lastMouse = { x: e.clientX, y: e.clientY }; });
        canvas.addEventListener('mouseup', () => isDragging = false);
        canvas.addEventListener('mousemove', e => {
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

        // --- BUTTON ACTIONS ---
        function centerOnPlayer() {
            if (currentPos) {
                // Animate or Snap? Let's Snap for now.
                camera.x = currentPos[0];
                camera.y = currentPos[1];
                camera.zoom = 20; // Zoom in when finding player
                draw();
            }
        }

        function fitMap() {
            if (mapData.length === 0) return;
            
            // Find bounds
            let minX = Infinity, maxX = -Infinity, minZ = Infinity, maxZ = -Infinity;
            mapData.forEach(b => {
                if (b[0] < minX) minX = b[0];
                if (b[0] > maxX) maxX = b[0];
                if (b[1] < minZ) minZ = b[1];
                if (b[1] > maxZ) maxZ = b[1];
            });

            const width = maxX - minX;
            const height = maxZ - minZ;
            const centerX = minX + width / 2;
            const centerZ = minZ + height / 2;

            // Calculate zoom to fit (with 50px padding)
            const zoomX = (canvas.width - 100) / width;
            const zoomY = (canvas.height - 100) / height;
            
            camera.x = centerX;
            camera.y = centerZ;
            camera.zoom = Math.min(zoomX, zoomY);
            // Cap max zoom out to prevent bugs
            if (camera.zoom < 0.1) camera.zoom = 0.1;
            
            uiZoom.innerText = camera.zoom.toFixed(1);
            draw();
        }

        // --- DRAWING HELPERS ---
        function getColor(val) {
            let norm = Math.log(val) / Math.log(maxCount || 1); 
            if (val === 1) norm = 0; 
            if (norm > 1) norm = 1;
            
            if (norm < 0.25) return `rgb(80, 0, 150)`;  
            if (norm < 0.50) return `rgb(200, 0, 50)`;  
            if (norm < 0.75) return `rgb(255, 140, 0)`; 
            return `rgb(255, 255, ${255 * (norm - 0.75) * 4})`; 
        }

        // --- MAIN DRAW ---
        function draw() {
            // Clear
            ctx.fillStyle = '#0b0b0b';
            ctx.fillRect(0, 0, canvas.width, canvas.height);

            const cx = canvas.width / 2;
            const cy = canvas.height / 2;

            // --- 1. DYNAMIC GRID SYSTEM ---
            // Determine grid step based on zoom
            let step = 1;
            if (camera.zoom < 10) step = 10;
            if (camera.zoom < 2) step = 50;
            if (camera.zoom < 0.5) step = 100;
            if (camera.zoom < 0.1) step = 500;

            // Calculate visible range
            const startX = Math.floor((camera.x - cx / camera.zoom) / step) * step;
            const endX = Math.ceil((camera.x + cx / camera.zoom) / step) * step;
            const startZ = Math.floor((camera.y - cy / camera.zoom) / step) * step;
            const endZ = Math.ceil((camera.y + cy / camera.zoom) / step) * step;

            ctx.lineWidth = 1;
            ctx.font = "10px monospace";
            ctx.fillStyle = "#888"; // Text color

            // Draw X Lines (Vertical)
            for (let x = startX; x <= endX; x += step) {
                let screenX = (x - camera.x) * camera.zoom + cx;
                
                // Line Style
                ctx.beginPath();
                if (x === 0) ctx.strokeStyle = "#44ff44"; // Origin X is Green
                else ctx.strokeStyle = "#222"; 
                ctx.moveTo(screenX, 0); ctx.lineTo(screenX, canvas.height);
                ctx.stroke();

                // Text Label
                if (step >= 10 || camera.zoom > 15) {
                    ctx.fillText(x, screenX + 2, 12); // Top coordinates
                }
            }

            // Draw Z Lines (Horizontal)
            for (let z = startZ; z <= endZ; z += step) {
                let screenZ = (z - camera.y) * camera.zoom + cy;
                
                // Line Style
                ctx.beginPath();
                if (z === 0) ctx.strokeStyle = "#44ff44"; // Origin Z is Green
                else ctx.strokeStyle = "#222"; 
                ctx.moveTo(0, screenZ); ctx.lineTo(canvas.width, screenZ);
                ctx.stroke();

                // Text Label
                if (step >= 10 || camera.zoom > 15) {
                    ctx.fillText(z, 5, screenZ - 2); // Left coordinates
                }
            }

            // --- 2. DRAW BLOCKS ---
            mapData.forEach(block => {
                const [x, z, count] = block;
                const screenX = (x - camera.x) * camera.zoom + cx;
                const screenZ = (z - camera.y) * camera.zoom + cy;

                // Simple Culling
                if (screenX < -camera.zoom || screenX > canvas.width || 
                    screenZ < -camera.zoom || screenZ > canvas.height) return;

                ctx.fillStyle = getColor(count);
                // Make blocks overlap slightly to prevent cracks
                let size = camera.zoom < 1 ? camera.zoom : camera.zoom + 0.5;
                ctx.fillRect(screenX, screenZ, size, size);
            });

            // --- 3. CURRENT PLAYER ---
            if (currentPos) {
                const screenX = (currentPos[0] - camera.x) * camera.zoom + cx;
                const screenZ = (currentPos[1] - camera.y) * camera.zoom + cy;
                
                ctx.fillStyle = '#00ff00';
                ctx.fillRect(screenX, screenZ, camera.zoom, camera.zoom);
                
                // Crosshair indicator
                if (camera.zoom < 5) {
                    // If zoomed out far, draw a big circle around player so you don't lose them
                    ctx.beginPath();
                    ctx.strokeStyle = '#00ff00';
                    ctx.lineWidth = 2;
                    ctx.arc(screenX, screenZ, 10, 0, 2*Math.PI);
                    ctx.stroke();
                } else {
                    ctx.strokeStyle = 'white';
                    ctx.lineWidth = 2;
                    ctx.strokeRect(screenX, screenZ, camera.zoom, camera.zoom);
                }
            }
        }

        // --- NETWORKING ---
        async function fetchData() {
            try {
                const res = await fetch('/api/map-data');
                const json = await res.json();
                
                mapData = json.blocks;
                currentPos = json.current;
                uiPoints.innerText = mapData.length;

                // Max Calculation
                maxCount = 1;
                mapData.forEach(b => { if(b[2] > maxCount) maxCount = b[2]; });

                // First Load Behavior
                if (isFirstLoad && currentPos) {
                    camera.x = currentPos[0];
                    camera.y = currentPos[1];
                    isFirstLoad = false;
                }
                
                uiStatus.innerText = "ONLINE";
                uiStatus.style.color = "#00ffcc";
                draw();
            } catch (err) {
                console.error(err);
                uiStatus.innerText = "OFFLINE";
                uiStatus.style.color = "red";
            }
        }

        // Init
        resize();
        fetchData();
        setInterval(fetchData, 1000);

    </script>
</body>
</html>
    """