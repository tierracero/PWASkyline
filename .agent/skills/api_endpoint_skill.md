# API Endpoint Skill

Checklist for tasks involving client API wrappers and backend contracts.

## When to Use

Use before changing files under `Sources/App/API/**` or code that calls API wrappers.

## Checklist

1. Read `architecture/API_AND_BACKEND.md`.
2. If auth/session/global state is touched, read `architecture/SECURITY_AND_STATE.md`.
3. Locate the domain endpoint folder and matching `Domain+Action.swift` file.
4. Verify request path, method, headers, payload type, response type, and error handling.
5. Preserve backend wire-format keys and existing naming conventions.
6. For fiscal/payment/Carta Porte changes, keep the diff small and validation explicit.
7. Check whether relevant payload types come from Tierra Cero private packages before adding local duplicates.

## Review Questions

- Does this change require backend support?
- Are tokens or account/user identifiers handled safely?
- Is callback behavior unchanged for existing callers?
- Is the response parsed in a way compatible with existing backend responses?

