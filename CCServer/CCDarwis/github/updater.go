package updater

import (
	"log"
	"os/exec"
)

func gitpull() {
	cmd := exec.Command("git", "pull")
	log.Println("Updating from github...")
	cmd.Stdout = log.Writer()
	cmd.Stderr = log.Writer()
	err := cmd.Run()
	if err != nil {
		log.Println("Oopsie!", err)
		return
	}
}
