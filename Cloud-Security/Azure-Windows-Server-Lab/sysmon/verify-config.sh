#!/bin/bash
# Verify that the Sysmon configuration has the required fixes applied

CONFIG_FILE="$(dirname "$0")/sysmonconfig-export.xml"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "❌ Configuration file not found at: $CONFIG_FILE"
    echo ""
    echo "To obtain the fixed configuration:"
    echo "1. Read SYSMON-CONFIG-FIX.md for file transfer instructions"
    echo "2. Copy sysmonconfig-export.xml from dc01-lab:"
    echo "   Location: C:\Users\hazvinei\sysmon-install\sysmonconfig-export.xml"
    exit 1
fi

echo "Verifying Sysmon configuration fixes..."
echo ""

# Check for proper ImageLoad configuration
if grep -q '<ImageLoad onmatch="include">.*<Image condition="end with">lsass.exe</Image>' "$CONFIG_FILE"; then
    echo "✓ Event 7 (ImageLoad): Correct field name 'Image' detected"
    imageload_ok=1
else
    echo "❌ Event 7 (ImageLoad): Fix not detected or incorrect"
    imageload_ok=0
fi

# Check for proper RawAccessRead configuration
if grep -q '<RawAccessRead onmatch="include">.*<Image condition="end with">lsass.exe</Image>' "$CONFIG_FILE"; then
    echo "✓ Event 9 (RawAccessRead): Correct field name 'Image' detected"
    rawaccess_ok=1
else
    echo "❌ Event 9 (RawAccessRead): Fix not detected or incorrect"
    rawaccess_ok=0
fi

# Check for broken elements
if grep -q '<ImageLoad[^>]*>.*<TargetImage' "$CONFIG_FILE"; then
    echo "❌ BROKEN: Found TargetImage in ImageLoad section"
    imageload_broken=1
else
    imageload_broken=0
fi

if grep -q '<RawAccessRead[^>]*>.*<TargetImage' "$CONFIG_FILE"; then
    echo "❌ BROKEN: Found TargetImage in RawAccessRead section"
    rawaccess_broken=1
else
    rawaccess_broken=0
fi

echo ""
if [ $imageload_ok -eq 1 ] && [ $rawaccess_ok -eq 1 ] && [ $imageload_broken -eq 0 ] && [ $rawaccess_broken -eq 0 ]; then
    echo "✅ Configuration is correctly fixed and ready to commit!"
    exit 0
else
    echo "❌ Configuration verification failed"
    echo ""
    echo "Expected fixes:"
    echo "  - Event 7 (ImageLoad): <TargetImage> should be <Image>"
    echo "  - Event 9 (RawAccessRead): <TargetImage> should be <Image>"
    exit 1
fi
