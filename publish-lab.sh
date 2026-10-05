#!/bin/bash

# Navigate to the repository directory
cd ~/cybersecurity-portfolio || exit

echo "=================================================="
echo "⚡ ZORIN OS LAB PUBLISHER & GIT AUTOMATION ⚡"
echo "=================================================="

# Check repository git status
git status --short

# Ask the user for a commit message description
echo ""
echo -n "📝 Enter a brief description of what you added/changed: "
read -r commit_msg

if [ -z "$commit_msg" ]; then
    commit_msg="Updated cybersecurity portfolio labs and telemetry screenshots"
fi

# Git execution workflow
echo ""
echo "📦 Staging changes and screenshots..."
git add .

echo "💾 Committing local lab work..."
git commit -m "Lab Update: $commit_msg"

echo "🔄 Pulling latest changes from remote to prevent conflicts..."
git pull origin main --rebase

echo "🚀 Pushing changes live to GitHub Pages..."
git push origin main

echo ""
echo "=================================================="
echo "✅ SUCCESS! Your live portfolio site is updating."
echo "=================================================="
