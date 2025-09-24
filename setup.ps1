# Requires PowerShell 7+
$ErrorActionPreference = "Stop"

Write-Host "🔧 Starting environment setup..."

# 1️⃣ Install Node dependencies
Write-Host "📦 Installing Node dependencies with PNPM..."
pnpm install

# 2️⃣ Run generate-env only if root .env exists
if (Test-Path ".env") {
    if (Test-Path "./generate-env.ps1") {
        Write-Host "🔐 .env found — running generate-env.ps1..."
        & "./generate-env.ps1"
    } else {
        Write-Host "⚠️ generate-env.ps1 script not found or not executable"
        exit 1
    }
} else {
    Write-Host "ℹ️ No root .env file found — skipping generate-env"
}

# 3️⃣ Install Python dependencies (FastAPI backend)
Write-Host "🐍 Setting up Python virtual environment..."
Set-Location "apps/backend-fastapi"
python -m venv .venv
& "$PWD\.venv\Scripts\Activate.ps1"
poetry install
deactivate
Set-Location "../.."

# 4️⃣ Generate Prisma client
Write-Host "🧬 Generating Prisma client..."
Set-Location "apps/backend-nestjs"
npx prisma migrate deploy
npx prisma generate
pnpm run db:seed
Set-Location "../.."

Write-Host "✅ Setup complete!"
Write-Host "ℹ️ To activate the Python environment, run:"
Write-Host "   .\.venv\Scripts\Activate.ps1"
Write-Host "ℹ️ To start the development server, run:"
Write-Host "   pnpm dev"