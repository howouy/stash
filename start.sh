#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Add Go, MinGW and make to PATH
export PATH="/c/Users/eryeer/go/go1.24.4/bin:/c/Users/eryeer/AppData/Local/Microsoft/WinGet/Packages/BrechtSanders.WinLibs.POSIX.UCRT_Microsoft.Winget.Source_8wekyb3d8bbwe/mingw64/bin:/c/Program Files (x86)/GnuWin32/bin:$PATH"

echo "==> Starting Stash backend..."
mkdir -p "$SCRIPT_DIR/.local"
cd "$SCRIPT_DIR/.local"
STASH_CONFIG_FILE=config.yml go run -v \
  -tags "sqlite_stat4 sqlite_math_functions" \
  -ldflags "-X 'github.com/stashapp/stash/internal/build.buildstamp=$(date +%Y-%m-%d)' \
            -X 'github.com/stashapp/stash/internal/build.githash=dev' \
            -X 'github.com/stashapp/stash/internal/build.version=dev' \
            -X 'github.com/stashapp/stash/internal/build.officialBuild=false'" \
  ../cmd/stash &
BACKEND_PID=$!

echo "==> Waiting for backend to be ready..."
until curl -s http://localhost:9999/ > /dev/null 2>&1; do
  sleep 2
done
echo "==> Backend is up at http://localhost:9999"

echo "==> Starting Stash frontend..."
cd "$SCRIPT_DIR/ui/v2.5"
npm run start -- --host &
FRONTEND_PID=$!

echo ""
echo "==> Stash is running!"
echo "    Frontend: http://localhost:3000"
echo "    Backend:  http://localhost:9999"
echo ""
echo "Press Ctrl+C to stop both services."

# Open browser
sleep 3
start http://localhost:3000

# Wait and clean up on Ctrl+C
trap "echo ''; echo 'Stopping...'; kill $BACKEND_PID $FRONTEND_PID 2>/dev/null; exit 0" INT TERM
wait
