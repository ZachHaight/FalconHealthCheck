#!/bin/bash
# ESLint Validation Script for Falcon Health Check Visualizer

echo "==============================================="
echo "Falcon Health Check Visualizer - ESLint Check"
echo "==============================================="
echo ""

# Check if ESLint is installed
if ! command -v eslint &> /dev/null; then
    echo "❌ ESLint not found. Please install it first:"
    echo ""
    echo "   npm install -g eslint"
    echo "   # or"
    echo "   npm install eslint --save-dev"
    echo ""
    exit 1
fi

echo "✅ ESLint found: $(eslint --version)"
echo ""

# Run ESLint on the HTML file
echo "Running ESLint on FalconHealthCheckVisualizer.html..."
echo ""

eslint FalconHealthCheckVisualizer.html --ext .html

EXIT_CODE=$?

echo ""
echo "==============================================="

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ SUCCESS: No ESLint errors or warnings found!"
    echo "==============================================="
else
    echo "❌ ESLint found issues. See output above."
    echo "==============================================="
    echo ""
    echo "To auto-fix issues, run:"
    echo "   eslint FalconHealthCheckVisualizer.html --ext .html --fix"
    echo ""
fi

exit $EXIT_CODE
