# zerobounce-delphi-api-v2

**v2.0.0** — Delphi console example for validating a single email with the [Zero Bounce API v2](https://www.zerobounce.net/docs/).

## Runnable example

Open and build **`ValidateEmailExample.dpr`** in the root of this repo. It uses Indy (IdHTTP, IdSSLOpenSSL) and `System.JSON` — no forms, no VCL UI.

### Requirements

- Delphi (XE6 or later with `System.JSON`) or Free Pascal with Indy
- [Indy](https://www.indyproject.org/) (IdHTTP, IdSSLOpenSSL) — included in recent Delphi installs
- OpenSSL DLLs next to the executable for HTTPS, e.g. from [Indy OpenSSL binaries](https://indy.fulgan.com/SSL/)

### Run

```text
ValidateEmailExample.exe <email_to_validate> [api_key]
```

If `api_key` is omitted, the program uses the `ZEROBOUNCE_API_KEY` environment variable.

**Examples:**

```bash
# API key as second argument
ValidateEmailExample.exe user@example.com your_api_key_here

# API key from environment
set ZEROBOUNCE_API_KEY=your_api_key_here
ValidateEmailExample.exe user@example.com
```

Output: `Valid: <status>` or `Invalid: <status>` (and optional `sub_status`).

## Unit tests

Build and run **`TestValidateEmail.dpr`** (no Indy or API key required). It tests:

- **UrlEncode** — empty, alphanumeric, `@`, full email, spaces, dots, hyphens
- **IsValidStatus** — `valid` / `invalid` / `unknown` (case-insensitive), catch-all, spamtrap, status with sub_status

```text
TestValidateEmail.exe
```

Result: `N passed, 0 failed` with exit code 0 on success.

## Project layout

| File | Purpose |
|------|--------|
| `ValidateEmailExample.dpr` | Main console app (API validation) |
| `ZeroBounceValidate.pas` | Shared helpers: `UrlEncode`, `IsValidStatus` |
| `TestValidateEmail.dpr` | Console test runner for the helpers |

---

For the full Zero Bounce SDK (all endpoints, batch, bulk file, scoring, find email, domain search), use the [zero-bounce-pascal](https://github.com/zerobounce/zero-bounce-pascal) repository.
