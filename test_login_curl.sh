#!/bin/bash
# Tests login against the server started by run_local_login_test.sh.
# Run this in a SECOND terminal window while that server is still running:
#   bash test_login_curl.sh

PASSWORD="${INITIAL_ADMIN_PASSWORD:-TestPassword123!}"

echo "==> Testing login against http://localhost:8000 ..."
echo ""

curl -s -i http://localhost:8000/v1/auth/login \
  -X POST \
  -H "Content-Type: application/json" \
  -d "{\"username\":\"admin\",\"email\":\"admin@superhumanly.ai\",\"password\":\"$PASSWORD\"}"

echo ""
echo ""
echo "==> Expect: HTTP/1.1 200 OK with an access_token in the JSON body above."
echo "==> If you see 'Connection refused', the server from run_local_login_test.sh isn't running."
