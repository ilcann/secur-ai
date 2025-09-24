#!/usr/bin/env bash
set -e

echo "🔧 Starting environment setup..."

# 1️⃣ Install Node dependencies
echo "📦 Installing Node dependencies with PNPM..."
pnpm install

# 2️⃣ Run generate-env only if root .env exists
if [ -f ".env" ]; then
  if [ -x "./generate-env.sh" ]; then
    echo "🔐 .env found — running generate-env..."
    chmod +x ./generate-env.sh
    ./generate-env.sh
  else
    echo "⚠️ generate-env.sh script not found or not executable"
    exit 1
  fi
else
  echo "ℹ️ No root .env file found — skipping generate-env"
fi

# 3️⃣ Install Python dependencies (FastAPI backend)
echo "🐍 Setting up Python virtual environment..."
cd apps/backend-fastapi
python3 -m venv .venv
source .venv/bin/activate
poetry install
deactivate
cd -

# 4️⃣ Generate Prisma client
echo "🧬 Generating Prisma client..."
cd apps/backend-nestjs
npx prisma generate
cd -

echo "✅ Setup complete!"
echo "ℹ️ To activate the Python environment, run:"
echo "   source apps/backend-fastapi/.venv/bin/activate"
echo "ℹ️ To start the development server, run:"
echo "   pnpm dev"
