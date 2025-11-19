#!/bin/bash

# Setup script for dbt project
echo "🚀 Setting up dbt project..."

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 is not installed. Please install Python 3.8 or higher."
    exit 1
fi

echo "✅ Python found: $(python3 --version)"

# Create virtual environment
if [ ! -d "venv" ]; then
    echo "📦 Creating virtual environment..."
    python3 -m venv venv
    echo "✅ Virtual environment created"
else
    echo "✅ Virtual environment already exists"
fi

# Activate virtual environment
echo "🔄 Activating virtual environment..."
source venv/bin/activate

# Install requirements
echo "📥 Installing dbt dependencies..."
pip install --upgrade pip
pip install -r requirements.txt

# Check if dbt is installed
if command -v dbt &> /dev/null; then
    echo "✅ dbt installed successfully: $(dbt --version | head -n 1)"
else
    echo "❌ dbt installation failed"
    exit 1
fi

# Create .dbt directory if it doesn't exist
if [ ! -d "$HOME/.dbt" ]; then
    echo "📁 Creating ~/.dbt directory..."
    mkdir -p "$HOME/.dbt"
fi

# Check if profiles.yml exists
if [ ! -f "$HOME/.dbt/profiles.yml" ]; then
    echo "⚠️  profiles.yml not found in ~/.dbt/"
    echo "📋 You need to create it. See profiles.yml.example for reference"
    echo ""
    echo "Quick setup:"
    echo "  1. Copy profiles.yml.example to ~/.dbt/profiles.yml"
    echo "  2. Update it with your GCP project ID and service account key path"
    echo ""
    read -p "Would you like to copy the example now? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        cp profiles.yml.example "$HOME/.dbt/profiles.yml"
        echo "✅ Copied profiles.yml.example to ~/.dbt/profiles.yml"
        echo "⚠️  Remember to edit it with your actual credentials!"
    fi
else
    echo "✅ profiles.yml found at ~/.dbt/profiles.yml"
fi

echo ""
echo "🎉 Setup complete!"
echo ""
echo "Next steps:"
echo "  1. Ensure your Google Cloud credentials are set up"
echo "  2. Update ~/.dbt/profiles.yml with your project details"
echo "  3. Test connection: dbt debug"
echo "  4. Run your models: dbt run"
echo ""
echo "For detailed instructions, see SETUP.md"
echo ""
echo "To activate the virtual environment in the future:"
echo "  source venv/bin/activate"

