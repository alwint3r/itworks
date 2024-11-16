# Builder stage
FROM golang:1.23-alpine AS builder

WORKDIR /app

# Copy go mod files
COPY go.* ./
RUN go mod download

# Copy source code
COPY . .

# Build static binary
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-w -s" -o /app/server ./cmd/server

# Final stage
FROM scratch

# Copy binary from builder
COPY --from=builder /app/server /server

# Expose default port
EXPOSE 8080

# Set environment variable
ENV PORT=8080

# Run the binary
ENTRYPOINT ["/server"]

