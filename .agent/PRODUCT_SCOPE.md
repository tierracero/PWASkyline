# Product Scope

Authoritative product facts and scope boundaries for PWASkyline.

## Current Product

- **Project**: PWASkyline.
- **Product family**: Tierra Cero Skyline 2.0 PWA.
- **Type**: Swift Web / WebAssembly browser application with a Swift service-worker target.
- **Platform**: Web/PWA running in browsers; Swift Package targets macOS build tooling for WebAssembly output.

## Current Implementation State

- `Package.swift` defines executable targets `App` and `Service`.
- `App` is the browser app entry point and uses `Web`, `TCFundamentals`, `TCFireSignal`, `JavaScriptKit`, `WebSocketAPI`, and additional Tierra Cero API core packages.
- `Service` defines the service worker manifest and copies static resources.
- `WebSources/**` contains JavaScript/WASI/webpack bootstrap sources.
- `DevPublic/**` and `DistPublic/**` contain public app/service worker outputs.

## Current Product Areas

PWASkyline includes UI/API flows for:

- Login/session control.
- Service orders and order lifecycle.
- Point of sale and sales history.
- Inventory, product control, transfers, audits, and concessions.
- Fiscal documents, CFDI-related flows, payment complements, credit notes, and Carta Porte support.
- Account/customer management.
- Messaging, chat, email, and social channel integrations.
- Routes, mobile camera/scanner/OCR handoffs, files, and async processing.
- Documentation/manual modules and tutorial resources.
- Rewards and support/hotline flows.

## Out of Scope Unless Explicitly Requested

- Rewriting backend contracts without backend coordination.
- Replacing Swift Web architecture.
- Broad renaming of legacy directories or class names.
- Regenerating all public outputs for a narrow source change.
- Editing dependency lockfiles for unrelated tasks.

## Authoritative References

- Architecture routing: `.agent/ARCH_INDEX.md`.
- Source layout: `.agent/SOURCE_MAP.md`.
- Current module map: `.agent/MODULES.md`.
- Active work: `.agent/TASKS.md`.

