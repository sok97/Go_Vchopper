# Build Stage
FROM golang:1.24-alpine AS builder

WORKDIR /app

# Install build dependencies
RUN apk add --no-cache git

# Copy go module files
COPY go.mod go.sum ./
RUN go mod download

# Copy source code
COPY . .

# Build the application
RUN go build -o video-chopper .

# Runtime Stage
FROM alpine:latest

WORKDIR /app

# Install runtime dependencies (ffmpeg is required)
RUN apk add --no-cache ffmpeg

# Copy the binary from the builder stage
COPY --from=builder /app/video-chopper .

# Entrypoint
ENTRYPOINT ["./video-chopper"]
