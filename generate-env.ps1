$ErrorActionPreference = "Stop"

$rootEnvFile = ".env"

# Uygulama adı -> ilgili değişken isimleri (boşlukla ayrılmış string)
$apps = @{
    "backend-fastapi" = ""
    "backend-nestjs"  = "DATABASE_URL JWT_SECRET JWT_EXPIRES_IN"
    "frontend-nextjs" = ""
}

# Ortak değişkenler
$commonVars = "NEXTJS_HOST NEXTJS_PORT NESTJS_HOST NESTJS_PORT FASTAPI_HOST FASTAPI_PORT"

foreach ($app in $apps.Keys) {
    $vars   = $apps[$app] -split " "
    $output = "apps/$app/.env"

    Write-Host "Generating $output from $rootEnvFile"

    if (Test-Path $output) {
        Remove-Item $output -Force
    }

    New-Item -ItemType Directory -Force -Path "apps/$app" | Out-Null

    # Ortak değişkenler
    foreach ($var in ($commonVars -split " ")) {
        Select-String -Path $rootEnvFile -Pattern "^$var=" | ForEach-Object {
            $_.Line
        } | Out-File -FilePath $output -Append -Encoding utf8
    }

    # Uygulamaya özel değişkenler
    foreach ($var in $vars) {
        if ($var -ne "") {
            Select-String -Path $rootEnvFile -Pattern "^$var=" | ForEach-Object {
                $_.Line
            } | Out-File -FilePath $output -Append -Encoding utf8
        }
    }
}

Write-Host "Environment files generated."
