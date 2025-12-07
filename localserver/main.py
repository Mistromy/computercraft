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
        body { margin: 0; background: #080808; overflow: hidden; font-family: 'Segoe UI', monospace; color: white; }
        canvas { display: block; }
        
        /* UI Panel */
        #ui { 
            position: absolute; top: 10px; left: 10px; 
            background: rgba(15, 15, 15, 0.95); 
            padding: 15px; 
            border: 1px solid #333; 
            border-radius: 8px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.7);
            min-width: 200px;
            backdrop-filter: blur(5px);
        }
        
        .stat-row { display: flex; justify-content: space-between; margin-bottom: 6px; font-size: 13px; color: #aaa; }
        .stat-val { font-weight: bold; color: #00ffcc; font-family: monospace; font-size: 14px;}
        
        /* Buttons */
        .btn-group { display: flex; gap: 10px; margin-top: 15px; }
        button {
            background: #222; color: #ddd; border: 1px solid #444;
            padding: 8px 12px; cursor: pointer; border-radius: 4px;
            font-size: 12px; flex: 1; transition: all 0.2s;
            font-weight: bold;
        }
        button:hover { background: #333; border-color: #666; color: white; }
        button:active { background: #00ffcc; color: black; border-color: #00ffcc;}

        #status { font-weight: bold; }
    </style>
</head>
<body>
    <div id="ui">
        <div style="border-bottom: 1px solid #333; padding-bottom: 8px; margin-bottom: 12px; font-weight:bold; letter-spacing: 1px; color: #fff;">SYSTEM TRACKER</div>
        
        <div class="stat-row"><span>STATUS:</span> <span id="status" style="color: lime">Connecting...</span></div>
        <div class="stat-row"><span>MOUSE:</span> <span id="coords" class="stat-val">0, 0</span></div>
        <div class="stat-row"><span>ZOOM:</span> <span id="zoomLvl" class="stat-val">10.0x</span></div>
        <div class="stat-row"><span>BLOCKS:</span> <span id="pointCount" class="stat-val">0</span></div>

        <div class="btn-group">
            <button onclick="centerOnPlayer()">JUMP TO PLAYER</button>
            <button onclick="fitMap()">FIT SCREEN</button>
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
            // Zoom towards mouse pointer logic could go here, but center zoom is simpler
            if (e.deltaY < 0) camera.zoom *= (1 + zoomSpeed);
            else camera.zoom /= (1 + zoomSpeed);
            uiZoom.innerText = camera.zoom.toFixed(1) + "x";
            draw();
        });

        // --- BUTTON ACTIONS ---
        function centerOnPlayer() {
            if (currentPos) {
                camera.x = currentPos[0];
                camera.y = currentPos[1];
                camera.zoom = 30; // Close up zoom
                draw();
            }
        }

        function fitMap() {
            if (mapData.length === 0) return;
            let minX = Infinity, maxX = -Infinity, minZ = Infinity, maxZ = -Infinity;
            mapData.forEach(b => {
                if (b[0] < minX) minX = b[0]; if (b[0] > maxX) maxX = b[0];
                if (b[1] < minZ) minZ = b[1]; if (b[1] > maxZ) maxZ = b[1];
            });
            const width = maxX - minX + 1; // +1 for block width
            const height = maxZ - minZ + 1;
            camera.x = minX + width / 2;
            camera.y = minZ + height / 2;
            // Calculate zoom with padding
            const padding = 100;
            const zoomX = (canvas.width - padding) / width;
            const zoomY = (canvas.height - padding) / height;
            camera.zoom = Math.min(zoomX, zoomY);
            if (camera.zoom < 0.1) camera.zoom = 0.1; 
            
            uiZoom.innerText = camera.zoom.toFixed(1) + "x";
            draw();
        }

        // --- NEW: SMOOTH COLOR GRADIENT ---
        // Define color stops for the gradient (R, G, B)
        // Deep Purple -> Violet -> Red -> Orange -> Yellow -> White
        const colorStops = [
            [30, 0, 60],    // 0.0 (Darkest)
            [90, 0, 140],   // 0.2
            [180, 0, 50],   // 0.4
            [255, 80, 0],   // 0.6
            [255, 200, 0],  // 0.8
            [255, 255, 240] // 1.0 (Brightest)
        ];

        function getColor(val) {
            // 1. Normalize value logarithmically (0.0 to 1.0)
            let norm = Math.log(val) / Math.log(maxCount || 1); 
            if (val <= 1) norm = 0; 
            if (norm > 1) norm = 1;

            // 2. Find which two color stops we are between
            // Map norm (0-1) to indices (0 - 5)
            let rawIndex = norm * (colorStops.length - 1);
            let idx1 = Math.floor(rawIndex);
            let idx2 = Math.min(idx1 + 1, colorStops.length - 1);
            
            // 3. Calculate interpolation factor 't' (how far between the two stops)
            let t = rawIndex - idx1; 

            let c1 = colorStops[idx1];
            let c2 = colorStops[idx2];

            // 4. Linear Interpolate RGB values
            let r = Math.floor(c1[0] + t * (c2[0] - c1[0]));
            let g = Math.floor(c1[1] + t * (c2[1] - c1[1]));
            let b = Math.floor(c1[2] + t * (c2[2] - c1[2]));

            return `rgb(${r}, ${g}, ${b})`;
        }

        // --- MAIN DRAW ---
        function draw() {
            ctx.fillStyle = '#080808'; // Slightly lighter background
            ctx.fillRect(0, 0, canvas.width, canvas.height);

            const cx = canvas.width / 2;
            const cy = canvas.height / 2;

            // --- 1. DYNAMIC GRID ---
            let step = 1;
            if (camera.zoom <= 15) step = 10;
            if (camera.zoom <= 3) step = 50;
            if (camera.zoom <= 0.8) step = 100;
            if (camera.zoom <= 0.2) step = 500;

            const startX = Math.floor((camera.x - cx / camera.zoom) / step) * step;
            const endX = Math.ceil((camera.x + cx / camera.zoom) / step) * step;
            const startZ = Math.floor((camera.y - cy / camera.zoom) / step) * step;
            const endZ = Math.ceil((camera.y + cy / camera.zoom) / step) * step;

            ctx.lineWidth = 1;
            ctx.font = "11px monospace";
            ctx.fillStyle = "#666";

            // Draw X Lines
            for (let x = startX; x <= endX; x += step) {
                let screenX = (x - camera.x) * camera.zoom + cx;
                ctx.beginPath();
                ctx.strokeStyle = (x === 0) ? "#336633" : "#1a1a1a"; 
                ctx.moveTo(screenX, 0); ctx.lineTo(screenX, canvas.height);
                ctx.stroke();
                if (step >= 10 || camera.zoom > 20) ctx.fillText(x, screenX + 4, 14);
            }

            // Draw Z Lines
            for (let z = startZ; z <= endZ; z += step) {
                let screenZ = (z - camera.y) * camera.zoom + cy;
                ctx.beginPath();
                ctx.strokeStyle = (z === 0) ? "#336633" : "#1a1a1a"; 
                ctx.moveTo(0, screenZ); ctx.lineTo(canvas.width, screenZ);
                ctx.stroke();
                if (step >= 10 || camera.zoom > 20) ctx.fillText(z, 6, screenZ - 4);
            }

            // --- 2. DRAW BLOCKS (With smooth colors) ---
            // Disable anti-aliasing for sharp block edges
            ctx.imageSmoothingEnabled = false; 

            mapData.forEach(block => {
                const [x, z, count] = block;
                const screenX = (x - camera.x) * camera.zoom + cx;
                const screenZ = (z - camera.y) * camera.zoom + cy;

                if (screenX < -camera.zoom || screenX > canvas.width || 
                    screenZ < -camera.zoom || screenZ > canvas.height) return;

                ctx.fillStyle = getColor(count);
                // Use a slight overlap (0.6) to prevent sub-pixel rendering gaps
                let overlap = camera.zoom < 1 ? 0 : 0.6;
                ctx.fillRect(screenX, screenZ, camera.zoom + overlap, camera.zoom + overlap);
            });

            // --- 3. CURRENT PLAYER ---
            if (currentPos) {
                const screenX = (currentPos[0] - camera.x) * camera.zoom + cx;
                const screenZ = (currentPos[1] - camera.y) * camera.zoom + cy;
                
                // Draw glowing crosshair
                ctx.strokeStyle = '#00ff00';
                ctx.lineWidth = 2;
                ctx.beginPath();
                // Horizontal line
                ctx.moveTo(screenX - 10, screenZ + camera.zoom/2);
                ctx.lineTo(screenX + camera.zoom + 10, screenZ + camera.zoom/2);
                // Vertical line
                ctx.moveTo(screenX + camera.zoom/2, screenZ - 10);
                ctx.lineTo(screenX + camera.zoom/2, screenZ + camera.zoom + 10);
                ctx.stroke();
                
                // Draw box
                ctx.fillStyle = 'rgba(0, 255, 0, 0.3)';
                ctx.fillRect(screenX, screenZ, camera.zoom, camera.zoom);
                ctx.strokeRect(screenX, screenZ, camera.zoom, camera.zoom);
            }
        }

        // --- NETWORKING ---
        async function fetchData() {
            try {
                const res = await fetch('/api/map-data');
                const json = await res.json();
                
                mapData = json.blocks;
                currentPos = json.current;
                uiPoints.innerText = mapData.length.toLocaleString();

                maxCount = 1;
                mapData.forEach(b => { if(b[2] > maxCount) maxCount = b[2]; });

                if (isFirstLoad && currentPos && mapData.length > 0) {
                    centerOnPlayer();
                    isFirstLoad = false;
                } else if (isFirstLoad && mapData.length > 0) {
                    fitMap();
                    isFirstLoad = false;
                }
                
                uiStatus.innerText = "ONLINE";
                uiStatus.style.color = "#00ffcc";
                draw();
            } catch (err) {
                console.error(err);
                uiStatus.innerText = "CONNECTION LOST";
                uiStatus.style.color = "#ff3333";
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