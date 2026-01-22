package main

import (
	"fmt"
	"log"
	"net/http"

	"github.com/gorilla/websocket"
)

// type Config struct {
// 	Port             int    `json:"port"`
// 	McServerIP       string `json:"mc_server_ip"`
// 	McServerPort     int    `json:"mc_server_port"`
// 	DebugMode        bool   `json:"debug_mode"`
// 	TargetBlock      string `json:"target_block"`
// 	MaxMinerPerFleet int    `json:"max_miner_per_fleet"`
// }

// func getDefaultConfig() Config {
// 	return Config{
// 		Port:             8080,
// 		McServerIP:       "",
// 		McServerPort:     25565,
// 		DebugMode:        false,
// 		TargetBlock:      "minecraft:ancient_debris",
// 		MaxMinerPerFleet: 6,
// 	}
// }

type Location struct {
	X int `json:"x"`
	Y int `json:"y"`
	Z int `json:"z"`
}

type Target struct {
	Location Location `json:"location"`
	Type     string   `json:"type"`
}

type Xform struct {
	Position  Location  `json:"position"`
	Direction Direction `json:"rotation"`
}

type Direction int

const (
	South Direction = iota
	East
	North
	West
)

type Scan struct {
	Targets        []Target `json:"targets"`
	TurtleLocation Xform    `json:"turtle_location"`
}

type TurtleData struct {
	Name      string `json:"name"`
	Fuel      int    `json:"fuel"`
	Transform Xform  `json:"transform"`
	Error     string `json:"error"`
}

type MinerMsg struct {
	Name      string   `json:"name"`
	Fuel      int      `json:"fuel"`
	Transform Xform    `json:"transform"`
	Target    Location `json:"target"`
	Status    string   `json:"status"`
}

type CommanderMsg struct {
	Fuel      int   `json:"fuel"`
	Transform Xform `json:"transform"`
	Scan      `json:"scan"`
}

var upgrader = websocket.Upgrader{
	CheckOrigin: func(r *http.Request) bool { return true },
}

func main() {
	fmt.Println("Server Starting...")

	http.HandleFunc("/cstatus", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "Commander is online.")
	})
	http.HandleFunc("/ws/swarm", SwarmConnection)
	http.HandleFunc("/ws/commander", CommanderConnection)
	log.Fatal(http.ListenAndServe(":8080", nil))
}
func SwarmConnection(w http.ResponseWriter, r *http.Request) {
	ws, err := upgrader.Upgrade(w, r, nil)
	if err != nil {
		log.Println(err)
		return
	}
	defer ws.Close()

	for {
		var miner MinerMsg

		err := ws.ReadJSON(&miner)
		if err != nil {
			log.Println("Error reading JSON:", err)
			break
		}

		log.Printf("Received data from %s: Status=%s, Fuel=%d, Position=(%d,%d,%d), Target=(%d,%d,%d)\n",
			miner.Name, miner.Status, miner.Fuel,
			miner.Transform.Position.X, miner.Transform.Position.Y, miner.Transform.Position.Z,
			miner.Target.X, miner.Target.Y, miner.Target.Z)
	}
}

func CommanderConnection(w http.ResponseWriter, r *http.Request) {
	ws, err := upgrader.Upgrade(w, r, nil)
	if err != nil {
		log.Println(err)
		return
	}
	defer ws.Close()

	for {
		var msg CommanderMsg

		err := ws.ReadJSON(&msg)
		if err != nil {
			log.Println("Error reading JSON:", err)
			break
		}
	}
}

func RotateAxis(Transform Xform) (int, int) {
	switch Transform.Direction {
	case 0:
		return Transform.Position.X, Transform.Position.Z
	case 1:
		return -Transform.Position.Z, Transform.Position.X
	case 2:
		return -Transform.Position.X, -Transform.Position.Z
	case 3:
		return Transform.Position.Z, -Transform.Position.X
	}
	return 0, 0
}
