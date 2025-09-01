#!/bin/bash

# Test Runner Script for UbuiquiteStorePoC
# Usage: ./run_tests.sh [option]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
SCHEME="UbuiquiteStorePoC"
DESTINATION="platform=iOS Simulator,name=iPhone 15"
VERBOSE=false
CLEAN=false

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to show help
show_help() {
    echo "Test Runner Script for UbuiquiteStorePoC"
    echo ""
    echo "Usage: $0 [option]"
    echo ""
    echo "Options:"
    echo "  -h, --help          Show this help message"
    echo "  -v, --verbose       Run tests with verbose output"
    echo "  -c, --clean         Clean build folder before testing"
    echo "  -u, --unit-only     Run only unit tests (skip UI tests)"
    echo "  -s, --simulator     Specify simulator (default: iPhone 15)"
    echo "  -l, --list-sims     List available simulators"
    echo ""
    echo "Examples:"
    echo "  $0                    # Run all tests with default settings"
    echo "  $0 -v                 # Run tests with verbose output"
    echo "  $0 -c                 # Clean and run tests"
    echo "  $0 -u                 # Run only unit tests"
    echo "  $0 -s 'iPhone 15 Pro' # Use specific simulator"
}

# Function to list available simulators
list_simulators() {
    print_status "Available iOS Simulators:"
    xcrun simctl list devices | grep "iPhone\|iPad" | head -20
    echo ""
    print_status "To see all simulators, run: xcrun simctl list devices"
}

# Function to clean build folder
clean_build() {
    print_status "Cleaning build folder..."
    xcodebuild clean -scheme "$SCHEME" -quiet
    print_success "Build folder cleaned"
}

# Function to run tests
run_tests() {
    local test_command="xcodebuild test -scheme \"$SCHEME\" -destination \"$DESTINATION\""
    
    if [ "$VERBOSE" = true ]; then
        test_command="$test_command -verbose"
    fi
    
    if [ "$1" = "unit-only" ]; then
        test_command="$test_command -only-testing:UbuiquiteStorePoCTests"
        print_status "Running unit tests only..."
    else
        print_status "Running all tests..."
    fi
    
    print_status "Command: $test_command"
    echo ""
    
    # Run the tests
    if eval $test_command; then
        print_success "All tests completed successfully!"
    else
        print_error "Tests failed!"
        exit 1
    fi
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -c|--clean)
            CLEAN=true
            shift
            ;;
        -u|--unit-only)
            UNIT_ONLY=true
            shift
            ;;
        -s|--simulator)
            DESTINATION="platform=iOS Simulator,name=$2"
            shift 2
            ;;
        -l|--list-sims)
            list_simulators
            exit 0
            ;;
        *)
            print_error "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

# Main execution
echo "🚀 UbuiquiteStorePoC Test Runner"
echo "=================================="
echo ""

# Check if we're in the right directory
if [ ! -f "UbuiquiteStorePoC.xcodeproj/project.pbxproj" ]; then
    print_error "This script must be run from the UbuiquiteStorePoC directory"
    print_error "Current directory: $(pwd)"
    exit 1
fi

print_status "Project: $SCHEME"
print_status "Destination: $DESTINATION"
print_status "Verbose: $VERBOSE"
print_status "Clean: $CLEAN"
echo ""

# Clean if requested
if [ "$CLEAN" = true ]; then
    clean_build
    echo ""
fi

# Run tests
if [ "$UNIT_ONLY" = true ]; then
    run_tests "unit-only"
else
    run_tests
fi

echo ""
print_success "Test execution completed!"
