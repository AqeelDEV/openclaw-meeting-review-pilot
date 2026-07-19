# OpenClaw Runtime and Security Validation

Validation date: 19 July 2026

Execution scope: project-local runtime and an isolated temporary OpenClaw home/state directory. No provider account, OAuth session, API key, gateway service, or model call was used.

## Runtime pin

- Project-local Node: `v24.15.0`
- Project-local OpenClaw: `2026.7.1 (2d2ddc4)`
- Dependency pin: `openclaw/runtime/package.json`
- System-wide OpenClaw and Node installations were not modified.

## Configuration validation

Command:

```text
openclaw config validate --json
```

Result:

```json
{"valid":true,"warnings":[]}
```

The validated profile uses a loopback-only gateway, env-backed gateway token reference, disabled Control UI and browser, a single workspace skill allowlist, full sandboxing with no workspace access, no elevated tools, and explicit tool denials.

## Skill discovery

Command:

```text
openclaw skills list --eligible --json
```

Result: one eligible skill was exposed to the pilot agent:

```json
{
  "name": "meeting-action-tracker",
  "eligible": true,
  "modelVisible": true,
  "source": "openclaw-workspace",
  "missing": {
    "bins": [],
    "env": [],
    "config": [],
    "os": []
  }
}
```

## Doctor

Command:

```text
openclaw doctor --lint --json --no-workspace-suggestions --only core/doctor/gateway-auth --only core/doctor/gateway-config
```

Result:

```json
{"ok":true,"checksRun":2,"checksSkipped":49,"findings":[]}
```

No repair or fix option was used.

## Security audit

The first normal audit found one critical issue: loopback gateway authentication was missing. The config was corrected to use token authentication through the `OPENCLAW_GATEWAY_TOKEN` SecretRef, with local mode and loopback binding. The corrected normal audit returned:

```json
{
  "summary": {"critical": 0, "warn": 2, "info": 1},
  "secretDiagnostics": [
    "gateway.auth.token: gateway token env var is configured."
  ]
}
```

The warnings were:

- The first validation config path was inside OneDrive. The final validation rerun used local temporary home/state/config paths.
- No trusted proxies are configured. This is intentional because the pilot is loopback-only and must not be reverse-proxied.

Before isolation, the deep scanner also reported a critical `child_process`
pattern in an unrelated personal `brand` skill under the user's home directory.
That skill is not part of this project and was not exposed by the pilot's
one-skill allowlist. It was not modified. The deep audit was rerun with an
isolated temporary home so only the assessment workspace and pinned runtime were
inside the test scope:

```json
{
  "summary": {"critical": 0, "warn": 1, "info": 1},
  "attack_surface": {
    "open_groups": 0,
    "elevated_tools": "disabled",
    "webhooks": "disabled",
    "internal_hooks": "disabled",
    "browser_control": "disabled"
  },
  "gateway_probe": {
    "ok": false,
    "reason": "ECONNREFUSED 127.0.0.1:18789"
  }
}
```

The remaining deep-audit warning is expected: no live gateway was started because the assessment authorizes no credentialed or live model execution. The config, skill, and static attack surface were still audited. No undocumented critical finding remains in the isolated pilot scope.

## Integrity note

The temporary validation token was ephemeral and was not written to the project, evidence logs, screenshot, report, or ZIP. The submission contains only a SecretRef that requires a future operator to supply a real local gateway token.
