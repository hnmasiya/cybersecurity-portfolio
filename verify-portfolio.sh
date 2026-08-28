#!/bin/bash
# Portfolio Verification Script
# Run this to verify your cybersecurity portfolio is fully updated

set -e

echo "🔍 Cybersecurity Portfolio Verification"
echo "======================================"
echo ""

# Check git status
echo "📦 Repository Status:"
git fetch origin main &>/dev/null
if git diff --quiet origin/main; then
    echo "✅ Local main matches remote main"
else
    echo "⚠️  Local main differs from remote"
    exit 1
fi

# Check author attribution
echo ""
echo "👤 Author Attribution:"
claude_count=$(git log --all --format="%an" | grep -c "^Claude$" || true)
if [ "$claude_count" -eq 0 ]; then
    echo "✅ No 'Claude' author references found"
else
    echo "⚠️  Found $claude_count 'Claude' commits (needs cleanup)"
fi

chatgpt_count=$(git log --all --format="%an" | grep -ic "chatgpt" || true)
if [ "$chatgpt_count" -eq 0 ]; then
    echo "✅ No 'ChatGPT' author references found"
else
    echo "⚠️  Found $chatgpt_count 'ChatGPT' commits"
fi

# Check portfolio files
echo ""
echo "📄 Portfolio Files:"
files=(
    "README.md"
    "LAB-COMPLETION-TRACKER.md"
    "Cloud-Security/Azure-Windows-Server-Lab/SYSMON-DEBUGGING-CASE-STUDY.md"
    "Cloud-Security/Azure-Windows-Server-Lab/sysmon/sysmonconfig-export.xml"
)

for file in "${files[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file"
    else
        echo "❌ $file (MISSING)"
    fi
done

# Check labs
echo ""
echo "🧪 Lab Completion:"
lab_count=$(grep -c "| Complete" LAB-COMPLETION-TRACKER.md || true)
echo "✅ $lab_count labs marked Complete"

# Check README highlights
echo ""
echo "📊 README Highlights:"
if grep -q "🎯 Portfolio Highlights" README.md; then
    echo "✅ Portfolio Highlights section present"
else
    echo "❌ Portfolio Highlights section missing"
fi

if grep -q "23/23 Security Labs" README.md; then
    echo "✅ 23/23 labs referenced in README"
else
    echo "❌ 23/23 labs reference missing"
fi

# Final summary
echo ""
echo "======================================"
echo "✅ Portfolio Verification Complete!"
echo ""
echo "Next steps (manual):"
echo "1. Update https://masiya-hub.org to remove #tracker section"
echo "2. Update website to show 23/23 labs complete"
echo "3. Add link to Sysmon case study if desired"
echo ""
