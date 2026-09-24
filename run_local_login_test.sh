#!/bin/bash
# Sets up and runs the login-only test server in one shot.
# Run this from inside the healthcare-backend folder:
#   bash run_local_login_test.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "==> Working in: $SCRIPT_DIR"

# 1. Create venv if it doesn't exist yet
if [ ! -d "venv" ]; then
  echo "==> Creating virtual environment..."
  python3 -m venv venv
fi

# 2. Activate it
echo "==> Activating virtual environment..."
source venv/bin/activate

# 3. Install ONLY the light auth-test requirements (not the full requirements.txt)
echo "==> Installing minimal auth-only dependencies..."
pip install --quiet --upgrade pip
pip install --quiet -r requirements-auth-test.txt

# 4. Set required env vars if not already set in your shell
if [ -z "$JWT_SECRET" ]; then
  export JWT_SECRET="4185d0b1c52b1bc597b785e62ad5b0d98130d1178030de86440b748f86066944"
  echo "==> JWT_SECRET not set — using a generated default for local testing."
fi

if [ -z "$INITIAL_ADMIN_PASSWORD" ]; then
  export INITIAL_ADMIN_PASSWORD="TestPassword123!"
  echo "==> INITIAL_ADMIN_PASSWORD not set — using default: TestPassword123!"
fi

echo ""
echo "==> Starting the auth-only test server on http://localhost:8000"
echo "==> Admin login will be: admin / admin@superhumanly.ai / $INITIAL_ADMIN_PASSWORD"
echo "==> Leave this running. Open a NEW terminal and run test_login_curl.sh to test it."
echo ""

python test_auth_server.py
