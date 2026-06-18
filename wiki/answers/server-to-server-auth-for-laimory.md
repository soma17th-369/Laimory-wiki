---
title: Server-to-server auth for Laimory
kind: answer
status: active
updated: 2026-06-19
tags: [backend, security, server-to-server, ai-server, auth]
---

# Server-to-server auth for Laimory

## Scope

Laimory's relevant server-to-server boundary is app server -> AI server dispatch and AI server -> app server callback.

As of the 2026-06-19 server implementation, Spring Security is not yet used for this path. AI callbacks use:

```text
POST /s/api/{applicationVersion}/timeline/drafts/{taskId}/callback
```

The callback is verified with a task-scoped one-time header:

```http
Callback-Token: <token>
```

The app server generates a 256-bit random token when it creates the draft task, passes the raw token to the AI dispatcher, stores only `SHA-256(callbackToken)` in Redis, and validates callback requests with constant-time comparison.

## Current Recommendation

For the current MVP, `Callback-Token` is the right fit. The protected surface is not a broad internal API; it is a callback for a specific app-created timeline draft task. The important question is "does this callback have the task-specific token the app server issued?" rather than "does this caller have a long-lived global internal secret?"

Requirements:

- Treat `/s/api/**` as server-to-server only.
- Restrict access with private networking, security groups, or reverse proxy allowlists where possible.
- Use TLS.
- Generate `Callback-Token` with at least 256 bits of cryptographic randomness.
- Store only the token hash in Redis.
- Bind the token to a specific task and TTL.
- Do not log the raw token or sensitive callback payload.
- After a task reaches `SUCCESS` or `FAILED`, do not persist again for the same task.

Private networking is useful but not sufficient by itself. It reduces exposure, but it does not prove that a callback is for a task the app server created. `Callback-Token` supplies that task-level proof.

## Improvement Path

1. MVP now: keep one-time per-task `Callback-Token`, plus network restriction and TLS.
2. Near term: add HMAC-SHA256 request signing if callback body tamper/replay risk becomes important.
   - Headers could be `Laimory-Client-Id`, `Laimory-Timestamp`, `Laimory-Nonce`, and `Laimory-Signature`.
   - Signature input should include HTTP method, path, timestamp, nonce, and SHA-256 body hash.
   - Redis can store nonce TTLs for replay defense.
3. Production with more internal services: use OAuth 2.0 client credentials and Spring Security Resource Server.
   - Use short-lived tokens.
   - Restrict audience and scopes.
   - Verify issuer, audience, expiration, not-before, scope/action, and signature algorithm.
4. Higher security or service mesh/cloud-native deployment: add mTLS.
   - mTLS gives service identity at the transport layer.
   - The stronger version is mTLS plus sender-constrained OAuth tokens or private-key JWT client authentication.

## Method Comparison

| Method | Strength | Weakness | Fit for Laimory |
|---|---|---|---|
| Static API key/shared secret header | Very simple, low code cost | Replayable if leaked; weak rotation/audit/scoping | Not needed for current callback-only MVP if `Callback-Token` is used |
| Per-task callback token | Binds callback to an app-created task; easy with Redis | Correlation, not full service identity; body tamper protection depends on TLS unless HMAC is added | Best current MVP fit |
| HMAC signed request | Binds request body/path/time; can block replay with nonce | More implementation work; shared symmetric key still exists | Best next step for current app server/AI callback |
| JWT bearer token | Standard token shape; can carry issuer/audience/scope/expiry | Stolen bearer token can be replayed unless constrained | Good when Spring Security and token issuer exist |
| OAuth 2.0 client credentials | Standard machine-to-machine authorization; scopes and short TTL | Needs authorization server and configuration | Best production baseline once auth infra exists |
| mTLS | Strong service identity; no application shared secret in headers | Certificate issuance/rotation and proxy setup overhead | Good for production/private infra, especially with service mesh |
| mTLS-bound token/private_key_jwt | Strong mainstream hardening; reduces stolen-token misuse | Highest operational complexity | Later-stage hardening, not MVP |

## External References

- RFC 6749 OAuth 2.0 defines the client credentials grant for clients accessing protected resources on their own behalf.
- RFC 9700 OAuth 2.0 Security BCP recommends sender-constrained tokens such as mTLS/DPoP, audience restriction, minimum privilege, client authentication, and end-to-end TLS.
- RFC 8705 defines OAuth 2.0 mTLS client authentication and certificate-bound access tokens.
- RFC 8725 and OWASP REST Security guidance emphasize explicit JWT algorithm verification and issuer/audience/expiry claim validation.
- RFC 6648 deprecates the old convention of adding `X-` prefixes to newly defined application protocol parameters, so new custom headers should prefer meaningful names such as `Callback-Token`.

## Linked Sources

- [[2026-06-19-notes-timeline-implementation-reconciliation]]
- [[2026-06-17-notes-timeline-draft-api-thought-process]]
- [[2026-06-15-markdown-notion-epic-system-initial-setup]]
- [[laimory]]

