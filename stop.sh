#!/usr/bin/env bash

echo "==> Stopping Stash..."

# Kill backend (Go process on port 9999)
BACKEND_PID=$(netstat -ano 2>/dev/null | grep ":9999" | grep "LISTENING" | awk '{print $5}' | head -1)
if [ -n "$BACKEND_PID" ]; then
  taskkill //PID $BACKEND_PID //F > /dev/null 2>&1
  echo "    Backend stopped (PID $BACKEND_PID)"
else
  echo "    Backend not running"
fi

# Kill frontend (Node process on port 3000)
FRONTEND_PID=$(netstat -ano 2>/dev/null | grep ":3000" | grep "LISTENING" | awk '{print $5}' | head -1)
if [ -n "$FRONTEND_PID" ]; then
  taskkill //PID $FRONTEND_PID //F > /dev/null 2>&1
  echo "    Frontend stopped (PID $FRONTEND_PID)"
else
  echo "    Frontend not running"
fi

echo "==> Done."
