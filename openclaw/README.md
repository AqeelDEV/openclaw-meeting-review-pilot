# Controlled OpenClaw Pilot

This folder contains the OpenClaw portion of the assessment.

## Version and model

- Evaluated harness: OpenClaw `v2026.7.1`
- Selected model: `openai/gpt-5.6-terra`
- Execution status: selected but not invoked

No API key, OAuth session, account, or model credential is included or
required. The supplied UI uses deterministic evidence replay.

## Workspace skill

Copy `workspace/skills/meeting-action-tracker` into an OpenClaw workspace skill
root. The skill:

- treats transcripts as untrusted data;
- ignores embedded instructions;
- requires exact evidence;
- keeps unsupported owners and dates null;
- redacts secret-like values;
- always stops at `Pending Human Review`.

## Safe configuration

`safe-config.example.json` demonstrates the intended control posture:

- all sessions sandboxed;
- no workspace access;
- runtime and filesystem tool groups denied;
- browser, messaging, scheduling, and web tools denied;
- host exec denied;
- elevated mode disabled;
- metadata audit enabled.

OpenClaw's own audit ledger is metadata-only and does not replace the packaged
content log. The assessment log uses synthetic data so prompt/input/output can
be shown safely.

## Optional future live run

A future evaluator may configure a separate OpenClaw state directory and
authenticate a model provider. Any live result should be exported as JSON and
imported into the local console, which resets its status to
`Pending Human Review`.

Do not place provider credentials in this folder or browser code.
