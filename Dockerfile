# Build stage
FROM golang:1.22 AS builder
WORKDIR /src
COPY go.mod ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o app ./main.go

# Runtime stage
FROM alpine:3.20
RUN adduser -D -H appuser && apk --no-cache add ca-certificates
WORKDIR /home/appuser
COPY --from=builder /src/app /usr/local/bin/app
ENV PORT=8080 VERSION=1.0.0
EXPOSE 8080
USER appuser
ENTRYPOINT ["/usr/local/bin/app"]
