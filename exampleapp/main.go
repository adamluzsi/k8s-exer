package main

import (
	"fmt"
	"log"
	"net/http"
)

func main() {
	// Define a handler function that responds with "Hello, World!"
	helloHandler := func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintln(w, "Hello, World!")
	}

	// Register the handler function for the "/" route
	http.HandleFunc("/", helloHandler)

	// Start the HTTP server on port 8080
	fmt.Println("Server is running on http://localhost:8080")
	if err := http.ListenAndServe(":8080", nil); err != nil {
		log.Fatal(err.Error())
	}
}
