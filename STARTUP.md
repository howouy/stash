# Stash Local Development - Startup Guide

## Prerequisites (already installed)
- Go 1.25+
- Node.js 20+
- pnpm (`npm install -g pnpm`)
- gcc/MinGW (WinLibs POSIX UCRT via winget)
- make (GnuWin32 via winget)

---

## Every time you start Stash

Open **Git Bash** (or any bash terminal) and run the following steps:

### Step 1: Set PATH (required every session)
```bash
export PATH="/c/Users/eryeer/AppData/Local/Microsoft/WinGet/Packages/BrechtSanders.WinLibs.POSIX.UCRT_Microsoft.Winget.Source_8wekyb3d8bbwe/mingw64/bin:/c/Program Files (x86)/GnuWin32/bin:$PATH"
```

### Step 2: Start the backend server
Open a terminal, run:
```bash
cd /d/dev/git/ai-agent/ed/stash/.local
STASH_CONFIG_FILE=config.yml go run -v \
  -tags "sqlite_stat4 sqlite_math_functions" \
  -ldflags "-X 'github.com/stashapp/stash/internal/build.buildstamp=$(date +%Y-%m-%d)' \
            -X 'github.com/stashapp/stash/internal/build.githash=dev' \
            -X 'github.com/stashapp/stash/internal/build.version=dev' \
            -X 'github.com/stashapp/stash/internal/build.officialBuild=false'" \
  ../cmd/stash
```
Wait until you see:
```
INFO stash is running at http://localhost:9999/
```

### Step 3: Start the frontend (dev mode)
Open a **second terminal**, run:
```bash
export PATH="/c/Users/eryeer/AppData/Local/Microsoft/WinGet/Packages/BrechtSanders.WinLibs.POSIX.UCRT_Microsoft.Winget.Source_8wekyb3d8bbwe/mingw64/bin:/c/Program Files (x86)/GnuWin32/bin:$PATH"
cd /d/dev/git/ai-agent/ed/stash/ui/v2.5
npm run start -- --host
```
Wait until you see:
```
Local: http://localhost:3000/
```

### Step 4: Open the browser
Go to: **http://localhost:3000**

---

## Stopping Stash
- Press `Ctrl+C` in each terminal to stop the backend and frontend.

---

## One-time setup steps (only needed after cloning or dependency updates)

```bash
# Install UI dependencies
cd /d/dev/git/ai-agent/ed/stash/ui/v2.5
pnpm install --frozen-lockfile

# Generate backend and UI files
mkdir -p /d/dev/git/ai-agent/ed/stash/ui/v2.5/build
touch /d/dev/git/ai-agent/ed/stash/ui/v2.5/build/index.html
cd /d/dev/git/ai-agent/ed/stash
go generate ./cmd/stash
cd ui/v2.5 && npm run gqlgen
```

---

## URLs
| Service  | URL                    |
|----------|------------------------|
| Frontend | http://localhost:3000  |
| Backend  | http://localhost:9999  |
