FROM golang:alpine AS build
WORKDIR /app
COPY . .
RUN go build -o static-server

FROM alpine
WORKDIR /app
COPY --from=build /app/static-server .
CMD ["./static-server"]
