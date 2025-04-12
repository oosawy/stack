FROM golang:alpine AS build
WORKDIR /app
COPY . .
RUN go build -o echo-server

FROM alpine
WORKDIR /app
COPY --from=build /app/echo-server .
CMD ["./echo-server"]
