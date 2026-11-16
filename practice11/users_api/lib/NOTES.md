
## Level 5 — Network Tests

### Test 1: Airplane Mode
- Network: Airplane Mode enabled
- Expected: NoConnectionException
- Actual time: ___ seconds
- Result: Passed

### Test 2: Wi-Fi without Internet
- Network: Connected Wi-Fi without Internet
- Timeout: 10 seconds
- Actual time: ___ seconds
- Expected: NoConnectionException
- Result: Passed

### POST Test
- Endpoint: POST /users
- Status: 201
- Created user ID: 11
- Duplicate requests: 0
- Result: Passed

### Screenshots
- screenshot_timeout.png
- screenshot_200.png
