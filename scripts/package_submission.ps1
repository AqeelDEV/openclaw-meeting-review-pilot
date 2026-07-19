$ErrorActionPreference = "Stop"

$root = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "..")).Path
$outputRoot = [System.IO.Path]::GetFullPath((Join-Path $root "output"))
$packageRoot = [System.IO.Path]::GetFullPath(
  (Join-Path $outputRoot "package\Aqeel_Elchai_OpenClaw_Assessment_Supporting_Files")
)
$zipPath = [System.IO.Path]::GetFullPath(
  (Join-Path $outputRoot "Aqeel_Elchai_OpenClaw_Assessment_Supporting_Files.zip")
)
$submissionPdfPath = [System.IO.Path]::GetFullPath(
  (Join-Path $outputRoot "Aqeel_Elchai_OpenClaw_Assessment.pdf")
)

if (-not $packageRoot.StartsWith(
  $outputRoot + [System.IO.Path]::DirectorySeparatorChar,
  [System.StringComparison]::OrdinalIgnoreCase
)) {
  throw "Refusing to package outside the workspace output directory."
}

if (Test-Path -LiteralPath $packageRoot) {
  Remove-Item -LiteralPath $packageRoot -Recurse -Force
}
New-Item -ItemType Directory -Force -Path $packageRoot | Out-Null

function Copy-ProjectFile {
  param([Parameter(Mandatory)][string]$RelativePath)

  $source = Join-Path $root $RelativePath
  if (-not (Test-Path -LiteralPath $source)) {
    throw "Required package file is missing: $RelativePath"
  }

  $destination = Join-Path $packageRoot $RelativePath
  $destinationParent = Split-Path -Parent $destination
  New-Item -ItemType Directory -Force -Path $destinationParent | Out-Null
  Copy-Item -LiteralPath $source -Destination $destination -Force
}

function Copy-ProjectDirectory {
  param([Parameter(Mandatory)][string]$RelativePath)

  $source = Join-Path $root $RelativePath
  if (-not (Test-Path -LiteralPath $source -PathType Container)) {
    throw "Required package directory is missing: $RelativePath"
  }

  $destination = Join-Path $packageRoot $RelativePath
  $destinationParent = Split-Path -Parent $destination
  New-Item -ItemType Directory -Force -Path $destinationParent | Out-Null
  Copy-Item -LiteralPath $source -Destination $destination -Recurse -Force
}

$rootFiles = @(
  ".gitignore",
  "README.md",
  "SECURITY.md",
  "PACKAGE_MANIFEST.md",
  "SUBMISSION_EMAIL.md",
  "package.json",
  "package-lock.json",
  "eslint.config.mjs",
  "next.config.ts",
  "postcss.config.mjs",
  "tsconfig.json",
  "vite.config.ts"
)

foreach ($relativePath in $rootFiles) {
  Copy-ProjectFile -RelativePath $relativePath
}

$sourceDirectories = @(
  ".openai",
  "app",
  "build",
  "evidence",
  "public",
  "tests",
  "worker"
)

foreach ($relativePath in $sourceDirectories) {
  Copy-ProjectDirectory -RelativePath $relativePath
}

Copy-ProjectFile -RelativePath "openclaw\README.md"
Copy-ProjectFile -RelativePath "openclaw\safe-config.example.json"
Copy-ProjectDirectory -RelativePath "openclaw\workspace"
Copy-ProjectFile -RelativePath "openclaw\runtime\package.json"
Copy-ProjectFile -RelativePath "openclaw\runtime\package-lock.json"

Copy-ProjectFile -RelativePath "scripts\generate_assessment_pdf.py"
Copy-ProjectFile -RelativePath "scripts\package_submission.ps1"
Copy-ProjectFile -RelativePath "scripts\run-vinext.mjs"

$reportSource = Join-Path $root "output\pdf\Aqeel_Elchai_OpenClaw_Assessment.pdf"
if (-not (Test-Path -LiteralPath $reportSource)) {
  throw "Required PDF is missing: $reportSource"
}
Copy-Item -LiteralPath $reportSource -Destination $submissionPdfPath -Force
Copy-Item -LiteralPath $reportSource -Destination (
  Join-Path $packageRoot "Aqeel_Elchai_OpenClaw_Assessment.pdf"
) -Force

if (Test-Path -LiteralPath $zipPath) {
  Remove-Item -LiteralPath $zipPath -Force
}
Compress-Archive -Path (Join-Path $packageRoot "*") -DestinationPath $zipPath -Force

Add-Type -AssemblyName System.IO.Compression.FileSystem
$archive = [System.IO.Compression.ZipFile]::OpenRead($zipPath)
try {
  $entries = @(
    $archive.Entries |
      ForEach-Object { $_.FullName.Replace("\", "/") }
  )
  $requiredEntries = @(
    "Aqeel_Elchai_OpenClaw_Assessment.pdf",
    "SUBMISSION_EMAIL.md",
    "app/ReviewConsole.tsx",
    "openclaw/safe-config.example.json",
    "openclaw/workspace/skills/meeting-action-tracker/SKILL.md",
    "openclaw/runtime/package.json",
    "evidence/logs/agent-runs.jsonl",
    "evidence/pdf-render/page-12.png",
    "tests/evidence-contract.test.mjs"
  )
  foreach ($requiredEntry in $requiredEntries) {
    if ($entries -notcontains $requiredEntry) {
      throw "ZIP verification failed; missing entry: $requiredEntry"
    }
  }
  if ($entries | Where-Object { $_ -match "(^|/)node_modules/" }) {
    throw "ZIP verification failed; node_modules must not be packaged."
  }

  [PSCustomObject]@{
    ZipPath = $zipPath
    EntryCount = $entries.Count
    SizeBytes = (Get-Item -LiteralPath $zipPath).Length
    Verified = $true
  }
}
finally {
  $archive.Dispose()
}
