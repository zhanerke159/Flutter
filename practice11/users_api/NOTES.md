# Practice 11 — NOTES

## Level 1 — Postman (verify each line yourself against the real response)

GET /users → 200, `Content-Type: application/json; charset=utf-8`, body is a JSON **array** of **10** users.
GET /users/1 → 200, a single object.
GET /users?id=3 → 200, an **array of one** user (not an object).

### User
| field    | JSON type | Dart type | nullable? |
|----------|-----------|-----------|-----------|
| id       | number    | int       | no |
| name     | string    | String    | no |
| username | string    | String    | no |
| email    | string    | String    | no |
| address  | object    | Address   | no |
| phone    | string    | String    | no (format varies: `1-770-736-8031 x56442`) |
| website  | string    | String?   | treated as optional |
| company  | object    | record    | no |

### address (nested once)
| field   | JSON type | Dart type | nullable? |
|---------|-----------|-----------|-----------|
| street  | string | String | no |
| suite   | string | String | no |
| city    | string | String | no |
| zipcode | string | String | no |
| geo     | object (nested twice) | Geo | no |

### address.geo
| field | JSON type | Dart type | nullable? |
|-------|-----------|-----------|-----------|
| lat   | **string** (`"-37.3159"`) | double (double.parse) | no |
| lng   | **string** | double (double.parse) | no |

### company
| field       | JSON type | Dart type | nullable? |
|-------------|-----------|-----------|-----------|
| name        | string | String | no |
| catchPhrase | string | String | no |
| bs          | string | (not used) | — |

### Statuses
- GET /users/999 → **404**, body `{}`
- POST /users (JSON body + `Content-Type: application/json`) → **201**, server echoes the sent fields and adds `"id": 11`

## Level 5 — Timings (fill in from your own run)
- Airplane mode → Offline view after: **___ s** (expected < 1 s)
- Wi-Fi without internet → Offline view after: **___ s** (expected ≈ 10 s)

## POST from UI
- POST /users → 201, id 11, one request on double tap (DevTools → Network)

## Screenshots
- screenshot_timeout.png
- screenshot_200.png
