package main

import (
	"fmt"
	"net/http"
	"os"
	"time"
)

func main() {
	start := time.Now()
	for {
		resp, err := http.Get("http://localhost:10808/services/fibonacci-deployment")
		if err != nil {
			fmt.Println(err)
			time.Sleep(1 * time.Second)
			continue
		}

		if resp.StatusCode != 200 {
			fmt.Println(resp.StatusCode)
			time.Sleep(1 * time.Second)
			continue
		}

		end := time.Now()
		fmt.Printf("Took %v\n", end.Sub(start))
		os.Exit(0)
	}
}
