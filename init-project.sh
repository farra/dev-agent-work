#!/bin/bash

# init-project.sh - Initialize dev-agent-work system in a new project
# Usage: ./init-project.sh <target_directory>

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored messages
print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Function to show usage
show_usage() {
    echo "Usage: $0 <target_directory>"
    echo
    echo "Initialize dev-agent-work system in a target directory."
    echo
    echo "Arguments:"
    echo "  target_directory    Path to the directory where dev-agent-work should be initialized"
    echo
    echo "Examples:"
    echo "  $0 /path/to/my-project"
    echo "  $0 ../new-project"
    echo "  $0 ~/projects/awesome-app"
    echo
    echo "This script will copy the following files:"
    echo "  - work/WORK-template.org"
    echo "  - WORK.org"
    echo "  - AGENTS.md"
    echo "  - .claude/commands/ (all slash commands)"
}

# Check if correct number of arguments provided
if [ $# -ne 1 ]; then
    print_error "Error: Exactly one argument required."
    echo
    show_usage
    exit 1
fi

TARGET_DIR="$1"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

print_info "Initializing dev-agent-work system..."
print_info "Source: $SCRIPT_DIR"
print_info "Target: $TARGET_DIR"

# Validate target directory
if [ ! -d "$TARGET_DIR" ]; then
    print_error "Target directory does not exist: $TARGET_DIR"
    echo
    read -p "Create directory $TARGET_DIR? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        mkdir -p "$TARGET_DIR"
        print_success "Created directory: $TARGET_DIR"
    else
        print_error "Aborted."
        exit 1
    fi
fi

# Check if target directory is writable
if [ ! -w "$TARGET_DIR" ]; then
    print_error "Target directory is not writable: $TARGET_DIR"
    exit 1
fi

# Create necessary directories
print_info "Creating directory structure..."
mkdir -p "$TARGET_DIR/work"
mkdir -p "$TARGET_DIR/.claude/commands"

# Copy essential files
print_info "Copying essential files..."

# Copy work template
if [ -f "$SCRIPT_DIR/work/WORK-template.org" ]; then
    cp "$SCRIPT_DIR/work/WORK-template.org" "$TARGET_DIR/work/"
    print_success "Copied work/WORK-template.org"
else
    print_error "Source file not found: work/WORK-template.org"
    exit 1
fi

# Copy WORK.org
if [ -f "$SCRIPT_DIR/WORK.org" ]; then
    cp "$SCRIPT_DIR/WORK.org" "$TARGET_DIR/"
    print_success "Copied WORK.org"
else
    print_error "Source file not found: WORK.org"
    exit 1
fi

# Copy AGENTS.md
if [ -f "$SCRIPT_DIR/AGENTS.md" ]; then
    cp "$SCRIPT_DIR/AGENTS.md" "$TARGET_DIR/"
    print_success "Copied AGENTS.md"
else
    print_error "Source file not found: AGENTS.md"
    exit 1
fi

# Copy slash commands
print_info "Copying slash commands..."
for cmd_file in "$SCRIPT_DIR/.claude/commands"/*.md; do
    if [ -f "$cmd_file" ]; then
        cp "$cmd_file" "$TARGET_DIR/.claude/commands/"
        print_success "Copied $(basename "$cmd_file")"
    fi
done

# Note: README.md and LICENSE are not copied as they are specific to this template project
print_info "Skipping README.md and LICENSE (project-specific files)"

echo
print_success "🎉 dev-agent-work system initialized successfully!"
echo
print_info "Next steps:"
echo "  1. cd $TARGET_DIR"
echo "  2. Customize WORK.org with your project details"
echo "  3. Configure sync settings for your issue tracker"
echo "  4. Start your first work session with: /work-start \"your task\""
echo
print_info "Files created:"
echo "  - work/WORK-template.org"
echo "  - WORK.org"
echo "  - AGENTS.md"
echo "  - .claude/commands/ (3 slash commands)"
echo
print_info "For more information, see AGENTS.md or the original project:"
echo "  https://github.com/farra/dev-agent-work"