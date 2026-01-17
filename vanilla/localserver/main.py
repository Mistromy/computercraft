import sqlite3
import os
import math
from fastapi import FastAPI
from fastapi.responses import HTMLResponse
from pydantic import BaseModel
from typing import List, Optional

app = FastAPI()

# --- CONFIG ---
DB_PATH = 'localserver/track.db'
if not os.path.exists('localserver'):
    os.makedirs('localserver')

class Ping(BaseModel):
    id: int  
    x: float
    z: float

# --- DATABASE SETUP ---
def init_db():
    conn = sqlite3.connect(DB_PATH)
    c = conn.cursor()
    c.execute("PRAGMA journal_mode=WAL;") 
    
    # 1. Raw History
    c.execute('''CREATE TABLE IF NOT EXISTS pings (
                 row_id INTEGER PRIMARY KEY AUTOINCREMENT,
                 device_id TEXT, x REAL, z REAL,
                 timestamp DATETIME DEFAULT CURRENT_TIMESTAMP)''')

    # 2. The Cache
    c.execute('''CREATE TABLE IF NOT EXISTS heatmap_cache (
                 x INTEGER, 
                 z INTEGER, 
                 hit_count INTEGER DEFAULT 1,
                 PRIMARY KEY (x, z))''')
                 
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

# --- API: BATCH LOGGING (FIXED) ---
@app.post("/api/batch")
def log_batch(pings: List[Ping]):
    if not pings:
        return {"status": "empty"}

    with sqlite3.connect(DB_PATH) as conn:
        c = conn.cursor()
        
        # A. Get interpolation start point
        c.execute("SELECT x, z FROM pings ORDER BY row_id DESC LIMIT 1")
        last_row = c.fetchone()
        
        # 1. Insert Raw Data
        raw_data = [(p.id, p.x, p.z) for p in pings]
        c.executemany("INSERT INTO pings (device_id, x, z) VALUES (?, ?, ?)", raw_data)
        
        # 2. Calculate Blocks
        blocks_to_update = []
        
        current_start_x = int(math.floor(last_row[0])) if last_row else int(math.floor(pings[0].x))
        current_start_z = int(math.floor(last_row[1])) if last_row else int(math.floor(pings[0].z))

        for p in pings:
            end_x, end_z = int(math.floor(p.x)), int(math.floor(p.z))
            
            if abs(current_start_x - end_x) > 50 or abs(current_start_z - end_z) > 50:
                blocks_to_update.append((end_x, end_z))
            else:
                line_points = get_points_on_line(current_start_x, current_start_z, end_x, end_z)
                blocks_to_update.extend(line_points)
            
            current_start_x, current_start_z = end_x, end_z

        # 3. Update Cache (THE FIX IS HERE)
        # We now explicitly pass (bx, bz) as the second argument to c.execute
        for (bx, bz) in blocks_to_update:
            c.execute('''
                INSERT INTO heatmap_cache (x, z, hit_count) VALUES (?, ?, 1)
                ON CONFLICT(x, z) DO UPDATE SET hit_count = hit_count + 1
            ''', (bx, bz)) # <--- This tuple was missing before!
            
        conn.commit()
    return {"status": "success"}

# --- API: MAP DATA ---
@app.get("/api/map-data")
def get_map_data():
    with sqlite3.connect(DB_PATH) as conn:
        c = conn.cursor()
        c.execute("SELECT x, z, hit_count FROM heatmap_cache")
        blocks = c.fetchall() 
        
        c.execute("SELECT x, z FROM pings ORDER BY row_id DESC LIMIT 1")
        last = c.fetchone()
        
    current = [int(last[0]), int(last[1])] if last else None

    return {
        "blocks": [list(b) for b in blocks],
        "current": current
    }

# --- FRONTEND ---
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
        .btn-group { display: flex; gap: 10px; margin-top: 15px; }
        button {
            background: #222; color: #ddd; border: 1px solid #444;
            padding: 8px 12px; cursor: pointer; border-radius: 4px;
            font-size: 12px; flex: 1; transition: all 0.2s; font-weight: bold;
        }
        button:hover { background: #333; border-color: #666; color: white; }
        button:active { background: #00ffcc; color: black; border-color: #00ffcc;}
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

        let camera = { x: 0, y: 0, zoom: 15 }; 
        let isDragging = false;
        let lastMouse = { x: 0, y: 0 };
        let mapData = [];
        let currentPos = null;
        let maxCount = 1;
        let isFirstLoad = true;

        function resize() {
            canvas.width = window.innerWidth;
            canvas.height = window.innerHeight;
            draw();
        }
        window.addEventListener('resize', resize);
        
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
            uiZoom.innerText = camera.zoom.toFixed(1) + "x";
            draw();
        });

        function centerOnPlayer() { if (currentPos) { camera.x = currentPos[0]; camera.y = currentPos[1]; camera.zoom = 30; draw(); } }
        function fitMap() {
            if (mapData.length === 0) return;
            let minX = Infinity, maxX = -Infinity, minZ = Infinity, maxZ = -Infinity;
            mapData.forEach(b => { if (b[0] < minX) minX = b[0]; if (b[0] > maxX) maxX = b[0]; if (b[1] < minZ) minZ = b[1]; if (b[1] > maxZ) maxZ = b[1]; });
            const w = maxX - minX + 1, h = maxZ - minZ + 1;
            camera.x = minX + w / 2; camera.y = minZ + h / 2;
            camera.zoom = Math.min((canvas.width - 100) / w, (canvas.height - 100) / h);
            if(camera.zoom < 0.1) camera.zoom = 0.1;
            uiZoom.innerText = camera.zoom.toFixed(1) + "x";
            draw();
        }

        const colorStops = [[30,0,60], [90,0,140], [180,0,50], [255,80,0], [255,200,0], [255,255,240]];
        function getColor(val) {
            let norm = Math.log(val) / Math.log(maxCount || 1); 
            if (val <= 1) norm = 0; if (norm > 1) norm = 1;
            let rawIndex = norm * (colorStops.length - 1);
            let idx1 = Math.floor(rawIndex);
            let idx2 = Math.min(idx1 + 1, colorStops.length - 1);
            let t = rawIndex - idx1; 
            let c1 = colorStops[idx1], c2 = colorStops[idx2];
            return `rgb(${Math.floor(c1[0]+t*(c2[0]-c1[0]))}, ${Math.floor(c1[1]+t*(c2[1]-c1[1]))}, ${Math.floor(c1[2]+t*(c2[2]-c1[2]))})`;
        }

        function draw() {
            ctx.fillStyle = '#080808'; ctx.fillRect(0, 0, canvas.width, canvas.height);
            const cx = canvas.width / 2, cy = canvas.height / 2;
            
            // Grid
            let step = 1; if(camera.zoom<=15) step=10; if(camera.zoom<=3) step=50; if(camera.zoom<=0.8) step=100;
            const startX = Math.floor((camera.x - cx/camera.zoom)/step)*step;
            const endX = Math.ceil((camera.x + cx/camera.zoom)/step)*step;
            const startZ = Math.floor((camera.y - cy/camera.zoom)/step)*step;
            const endZ = Math.ceil((camera.y + cy/camera.zoom)/step)*step;
            
            ctx.lineWidth = 1; ctx.font = "11px monospace"; ctx.fillStyle = "#666";
            for (let x=startX; x<=endX; x+=step) {
                let sx = (x-camera.x)*camera.zoom+cx; ctx.beginPath(); ctx.strokeStyle = (x===0)?"#336633":"#1a1a1a"; ctx.moveTo(sx,0); ctx.lineTo(sx,canvas.height); ctx.stroke();
                if(step>=10 || camera.zoom>20) ctx.fillText(x, sx+4, 14);
            }
            for (let z=startZ; z<=endZ; z+=step) {
                let sz = (z-camera.y)*camera.zoom+cy; ctx.beginPath(); ctx.strokeStyle = (z===0)?"#336633":"#1a1a1a"; ctx.moveTo(0,sz); ctx.lineTo(canvas.width,sz); ctx.stroke();
                if(step>=10 || camera.zoom>20) ctx.fillText(z, 6, sz-4);
            }

            // Blocks
            ctx.imageSmoothingEnabled = false; 
            mapData.forEach(b => {
                const [x, z, c] = b;
                const sx = (x-camera.x)*camera.zoom+cx;
                const sz = (z-camera.y)*camera.zoom+cy;
                if(sx<-camera.zoom || sx>canvas.width || sz<-camera.zoom || sz>canvas.height) return;
                ctx.fillStyle = getColor(c);
                let over = camera.zoom<1 ? 0 : 0.6;
                ctx.fillRect(sx, sz, camera.zoom+over, camera.zoom+over);
            });

            // Player
            if(currentPos) {
                const sx = (currentPos[0]-camera.x)*camera.zoom+cx;
                const sz = (currentPos[1]-camera.y)*camera.zoom+cy;
                ctx.strokeStyle = '#00ff00'; ctx.lineWidth = 2; ctx.beginPath();
                ctx.moveTo(sx-10, sz+camera.zoom/2); ctx.lineTo(sx+camera.zoom+10, sz+camera.zoom/2);
                ctx.moveTo(sx+camera.zoom/2, sz-10); ctx.lineTo(sx+camera.zoom/2, sz+camera.zoom+10); ctx.stroke();
                ctx.fillStyle = 'rgba(0, 255, 0, 0.3)'; ctx.fillRect(sx, sz, camera.zoom, camera.zoom); ctx.strokeRect(sx, sz, camera.zoom, camera.zoom);
            }
        }

        async function fetchData() {
            try {
                const res = await fetch('/api/map-data');
                if(!res.ok) throw new Error("Err");
                const json = await res.json();
                mapData = json.blocks;
                currentPos = json.current;
                uiPoints.innerText = mapData.length.toLocaleString();
                maxCount = 1; mapData.forEach(b => { if(b[2] > maxCount) maxCount = b[2]; });
                if(isFirstLoad && mapData.length > 0) { fitMap(); isFirstLoad = false; }
                uiStatus.innerText = "ONLINE"; uiStatus.style.color = "#00ffcc";
                draw();
            } catch (err) { uiStatus.innerText = "CONNECTION LOST"; uiStatus.style.color = "#ff3333"; }
        }

        resize(); fetchData(); setInterval(fetchData, 1000);
    </script>
</body>
</html>
    """