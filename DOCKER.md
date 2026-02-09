# Docker Setup Guide for Mirai Testing

## 🐳 Why Docker?

Docker provides:
- **Complete isolation** from your host system
- **Easy cleanup** - destroy everything with one command
- **Reproducible environment** - works the same everywhere
- **Network isolation** - contained network for testing
- **Safe experimentation** - no risk to host system

## 📋 Prerequisites

Install Docker and Docker Compose:

```bash
# Ubuntu/Debian
sudo apt-get update
sudo apt-get install -y docker.io docker-compose

# Start Docker service
sudo systemctl start docker
sudo systemctl enable docker

# Add your user to docker group (logout/login after this)
sudo usermod -aG docker $USER
```

Verify installation:
```bash
docker --version
docker-compose --version
```

## 🚀 Quick Start

### 1. Build and Start Everything
```bash
cd /home/runner/work/Mirai-Source-Code/Mirai-Source-Code

# Build and start all services
docker-compose up -d --build
```

This starts:
- MySQL database (port 3306)
- CNC server (port 23 for telnet, 101 for API)
- Scan listener (port 48101)
- Loader service

### 2. Check Services
```bash
# View running containers
docker-compose ps

# View logs
docker-compose logs -f cnc
docker-compose logs -f mysql
docker-compose logs -f scanlistener
```

### 3. Connect to CNC
```bash
# Connect via telnet
telnet localhost 23

# Login credentials:
# Username: admin
# Password: password123
```

### 4. Stop Everything
```bash
# Stop all services
docker-compose down

# Stop and remove volumes (complete cleanup)
docker-compose down -v
```

## 🔧 Building Components Manually

If you prefer to build components yourself inside Docker:

### Build CNC
```bash
# Enter CNC container
docker-compose exec cnc bash

# Inside container
cd /app/mirai
./build.sh debug telnet

# Run CNC manually
./debug/cnc
```

### Build Bot
```bash
# Enter CNC container (has gcc)
docker-compose exec cnc bash

# Build bot for x86
cd /app/mirai
gcc -std=c99 -DDEBUG -DMIRAI_TELNET bot/*.c -static -g -o debug/mirai.dbg

# Run bot (connects to CNC)
./debug/mirai.dbg
```

### Build Loader
```bash
# Enter loader container
docker-compose exec loader bash

# Build
cd /app/loader
./build.sh

# Run loader
./loader
```

## 📊 Service Details

### MySQL Database
- **Container**: mirai-mysql
- **Port**: 3306
- **Root Password**: mirai123
- **Database**: mirai
- **Users**: admin/password123, testuser/test123

Access database:
```bash
# From host
docker-compose exec mysql mysql -u root -pmirai123 mirai

# Show tables
docker-compose exec mysql mysql -u root -pmirai123 -e "USE mirai; SHOW TABLES;"

# Show users
docker-compose exec mysql mysql -u root -pmirai123 -e "USE mirai; SELECT * FROM users;"
```

### CNC Server
- **Container**: mirai-cnc
- **Ports**: 23 (telnet), 101 (API)
- **Binary**: /app/mirai/debug/cnc
- **Config**: /app/mirai/cnc/main.go

Connect:
```bash
telnet localhost 23
```

View logs:
```bash
docker-compose logs -f cnc
```

### Scan Listener
- **Container**: mirai-scanlistener
- **Port**: 48101
- **Binary**: /app/mirai/debug/scanListen
- **Purpose**: Receives scan results from bots

View logs:
```bash
docker-compose logs -f scanlistener
```

### Loader
- **Container**: mirai-loader
- **Port**: 8080
- **Binary**: /app/loader/loader
- **Purpose**: Loads malware onto compromised devices

## 🧪 Testing Workflows

### Test Bot Connection
```bash
# 1. Ensure CNC is running
docker-compose ps

# 2. Enter CNC container
docker-compose exec cnc bash

# 3. Build and run bot
cd /app/mirai
./build.sh debug telnet
./debug/mirai.dbg

# 4. In another terminal, connect to CNC
telnet localhost 23
# Login: admin / password123
# Type: bots
# You should see your bot!
```

### Test Configuration Encoding
```bash
# Enter CNC container
docker-compose exec cnc bash

# Use encoder tool
cd /app/mirai
./debug/enc string "my-test-domain.com"

# Copy the output and update bot/table.c
```

### Monitor Network Traffic
```bash
# Install tcpdump in container
docker-compose exec cnc apt-get update && apt-get install -y tcpdump

# Capture CNC traffic
docker-compose exec cnc tcpdump -i any -n port 23

# In another terminal, connect with telnet
telnet localhost 23
```

## 🔍 Troubleshooting

### CNC Won't Start
```bash
# Check logs
docker-compose logs cnc

# Common issues:
# - MySQL not ready: Wait 10 seconds and try again
# - Port 23 in use: Stop conflicting service or change port

# Check MySQL is running
docker-compose exec mysql mysqladmin -u root -pmirai123 ping
```

### Can't Connect to CNC
```bash
# Check CNC is listening
docker-compose exec cnc netstat -tulpn | grep 23

# Test connection from inside container
docker-compose exec cnc telnet localhost 23

# Check firewall on host
sudo ufw status
```

### Bot Won't Connect
```bash
# 1. Check domain in table.c
docker-compose exec cnc cat /app/mirai/bot/table.c | grep TABLE_CNC_DOMAIN

# 2. Test DNS resolution in container
docker-compose exec cnc ping -c 1 cnc

# 3. Check CNC is reachable
docker-compose exec cnc telnet cnc 23
```

### Database Connection Issues
```bash
# Check MySQL is running
docker-compose ps mysql

# Test connection
docker-compose exec mysql mysql -u root -pmirai123 -e "SELECT 1"

# Check database exists
docker-compose exec mysql mysql -u root -pmirai123 -e "SHOW DATABASES;"

# Recreate database
docker-compose down -v
docker-compose up -d
```

## 🛠️ Advanced Usage

### Custom MySQL Password
Edit `docker-compose.yml`:
```yaml
mysql:
  environment:
    MYSQL_ROOT_PASSWORD: your_custom_password
```

And update `mirai/cnc/main.go`:
```go
const DatabasePass string   = "your_custom_password"
```

Then rebuild:
```bash
docker-compose down -v
docker-compose up -d --build
```

### Add More Users
```bash
docker-compose exec mysql mysql -u root -pmirai123 mirai -e \
  "INSERT INTO users VALUES (NULL, 'newuser', 'newpass', 0, 0, 0, 0, -1, 1, 30, '');"
```

### Expose to Network (DANGEROUS)
⚠️ **Only in isolated test networks!**

Edit `docker-compose.yml`:
```yaml
cnc:
  ports:
    - "0.0.0.0:23:23"  # Listen on all interfaces
```

### Persistent Data
Data is stored in Docker volumes. To backup:
```bash
# Backup MySQL data
docker run --rm \
  -v mirai-source-code_mysql-data:/data \
  -v $(pwd):/backup \
  busybox tar czf /backup/mysql-backup.tar.gz /data

# Restore
docker run --rm \
  -v mirai-source-code_mysql-data:/data \
  -v $(pwd):/backup \
  busybox tar xzf /backup/mysql-backup.tar.gz -C /
```

## 🧹 Cleanup

### Stop Services
```bash
# Stop but keep data
docker-compose stop

# Start again
docker-compose start
```

### Complete Cleanup
```bash
# Stop and remove containers, networks
docker-compose down

# Also remove volumes (database data)
docker-compose down -v

# Remove built images
docker-compose down --rmi all

# Nuclear option - remove everything
docker system prune -a --volumes
```

## 📚 Docker Commands Reference

```bash
# Build images
docker-compose build

# Start services
docker-compose up -d

# Stop services
docker-compose stop

# Restart service
docker-compose restart cnc

# View logs
docker-compose logs -f cnc

# Execute command in container
docker-compose exec cnc bash

# View running containers
docker-compose ps

# View resource usage
docker stats

# Clean up
docker-compose down -v
```

## 🔐 Security Notes

1. **Network Isolation**: Docker network is isolated by default
2. **Port Exposure**: Only exposed ports are accessible from host
3. **Volume Mounts**: Source code is mounted read-write
4. **Container User**: Runs as root (for port 23) - OK for testing
5. **Production**: DO NOT use these containers in production

## 🎯 Best Practices

1. **Always use isolated network**: Don't expose to internet
2. **Regular cleanup**: `docker-compose down -v` when done
3. **Monitor resources**: `docker stats` to check usage
4. **Version control**: Keep docker-compose.yml in git
5. **Documentation**: Update this file with your changes

## 🆘 Common Issues

### Port Already in Use
```bash
# Find what's using port 23
sudo lsof -i :23

# Kill it or change port in docker-compose.yml
```

### Out of Disk Space
```bash
# Clean up Docker
docker system prune -a --volumes

# Check disk usage
docker system df
```

### Permission Denied
```bash
# Add user to docker group
sudo usermod -aG docker $USER

# Logout and login again
```

---

**Happy containerized testing! 🐳**
