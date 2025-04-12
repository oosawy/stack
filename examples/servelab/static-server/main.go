package main

import (
	"log"
	"net/http"
)

func main() {
	fs := http.FileServer(http.Dir("."))
	http.Handle("/", fs)

	log.Println("Static server on :8080")
	log.Fatal(http.ListenAndServe(":8080", nil))
}
