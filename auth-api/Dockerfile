# Use a minimal base image for building the Auth API
FROM golang:1.21 AS builder
WORKDIR /app
COPY . .
RUN go mod download && go build -o auth-api .

# Create a minimal production image
FROM alpine:latest
WORKDIR /root/
COPY --from=builder /app/auth-api .
CMD ["./auth-api"]
