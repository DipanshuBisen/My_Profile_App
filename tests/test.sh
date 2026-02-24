#!/bin/bash

echo "Checking if index.html exists..."
if [ -f index.html ]; then
  echo "index.html found ✅"
else
  echo "index.html missing ❌"
  exit 1
fi

echo "Checking for script.js..."
if [ -f script.js ]; then
  echo "script.js found ✅"
else
  echo "script.js missing ❌"
  exit 1
fi

echo "All basic tests passed 🎉"