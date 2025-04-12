package main

import (
	"io"
	"log"
	"net"
)

func main() {
	addr := ":9000"
	l, err := net.Listen("tcp", addr)
	if err != nil {
		log.Fatal(err)
	}
	defer l.Close()
	log.Println("Echo server on", addr)

	for {
		conn, err := l.Accept()
		if err != nil {
			log.Println(err)
			continue
		}
		go func(c net.Conn) {
			defer c.Close()
			io.Copy(c, c)
		}(conn)
	}
}
