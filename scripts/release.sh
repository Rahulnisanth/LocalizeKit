#!/bin/bash

# AI Localizer Release Script
# This script helps prepare and publish the package to pub.dev

set -e

echo "🚀 AI Localizer Release Script"
echo "================================"

# Check if we're in the right directory
if [ ! -f "pubspec.yaml" ]; then
    echo "❌ Error: pubspec.yaml not found. Please run this script from the package root."
    exit 1
fi

# Get current version
CURRENT_VERSION=$(grep 'version:' pubspec.yaml | sed 's/version: //')
echo "📦 Current version: $CURRENT_VERSION"

# Check if git is clean
if [ -n "$(git status --porcelain)" ]; then
    echo "⚠️  Warning: Git working directory is not clean."
    echo "   Please commit or stash your changes before releasing."
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Run tests
echo "🧪 Running tests..."
dart test

# Run analysis
echo "🔍 Running analysis..."
dart analyze

# Check if package is ready for publishing
echo "📋 Checking package readiness..."
dart pub publish --dry-run

echo ""
echo "✅ Package is ready for release!"
echo ""
echo "📝 To publish to pub.dev:"
echo "   1. Update version in pubspec.yaml"
echo "   2. Run: dart pub publish"
echo ""
echo "📝 To publish to GitHub:"
echo "   1. Create a git tag: git tag v$CURRENT_VERSION"
echo "   2. Push the tag: git push origin v$CURRENT_VERSION"
echo ""
echo "🎉 Happy releasing!" 