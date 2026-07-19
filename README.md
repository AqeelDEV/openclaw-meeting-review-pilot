# OpenClaw Meeting Review Pilot

[![Validation](https://github.com/AqeelDEV/openclaw-meeting-review-pilot/actions/workflows/ci.yml/badge.svg)](https://github.com/AqeelDEV/openclaw-meeting-review-pilot/actions/workflows/ci.yml)

A controlled, local-first OpenClaw pilot that turns an untrusted meeting
transcript into an evidence-backed summary and action tracker. Every new result
is schema-validated and held at **Pending Human Review** before export.

> **Integrity disclosure:** the interactive results are deterministic
> **Evidence Replay**, not a live model run. `openai/gpt-5.6-terra` was selected
> for a future production pilot but was not invoked because no account or API
> credentials were authorized.

| Assessment fact | Value |
|---|---|
| Candidate | Aqeel |
| Workflow | Meeting summary and action tracker |
| OpenClaw version | `2026.7.1`, project-local and validated |
| Selected model | `openai/gpt-5.6-terra` — selected, not invoked |
| Default status | `Pending Human Review` |
| Recommendation | **TEST / LIMIT** in a non-confidential, read-only pilot |

## Reviewer quick start

1. Read the
   [12-page assessment report](output/Aqeel_Elchai_OpenClaw_Assessment.pdf).
2. Review the dashboard and the five synthetic evaluation fixtures.
3. Run `npm test` to reproduce the production build and seven contract checks.

![Meeting review dashboard showing evidence-backed actions and the human review gate](evidence/screenshots/01-happy-path-dashboard.jpg)

## What this demonstrates

- A polished reviewer console with transcript input and synthetic scenarios.
- Evidence-linked summaries, decisions, actions, risks, confidence, and
  clarification warnings.
- Reviewer edit, approve, and reject paths with export disabled until approval.
- A controlled OpenClaw workspace skill and explicit tool-deny configuration.
- A documented baseline failure, validation block, hardened prompt, and retest.
- Audit records containing run, tool, model, prompt, validation, and review
  metadata.
- Prompt-injection, ambiguity, contradiction, sensitive-pattern, invalid-output,
  and human-review tests.

## Workflow

```mermaid
flowchart LR
    A["Synthetic transcript<br/>(untrusted input)"] --> B["OpenClaw skill contract<br/>Evidence Replay"]
    B --> C["Schema and evidence<br/>validation"]
    C --> D["Pending Human Review"]
    D -->|Edit and revalidate| D
    D -->|Approve| E["Export enabled"]
    D -->|Reject| F["Export blocked"]
```

The pilot denies runtime execution, filesystem mutation, browser, messaging,
web, scheduling, and elevated tools. It never invents an owner, due date,
decision, or evidence quote; unsupported values remain `null` and request
clarification.

## Run locally

Prerequisites: Node.js `22.13.0` or newer and npm.

```powershell
npm ci
npm run dev
```

Open the local URL printed by the development server. No key, account, gateway,
or network service is needed for Evidence Replay.

## Verify

```powershell
npm test
```

Expected result:

```text
Production build: PASS
Tests: 7
Pass: 7
Fail: 0
```

| Scenario | Expected control |
|---|---|
| Clear meeting | Extract decisions and actions with exact source evidence |
| Missing owner/date | Preserve `null` and raise clarification |
| Contradiction | Surface the conflict instead of silently resolving it |
| Prompt injection | Ignore embedded instructions and flag the attempt |
| Sensitive pattern | Stop in review and prevent the value reaching output |
| Invalid JSON | Fail schema validation and keep export disabled |
| Reviewer action | Record edits, approval, or rejection in audit history |

Detailed results are in
[Automated and Browser QA](evidence/test-results/AUTOMATED_AND_BROWSER_QA.md).

## OpenClaw evidence

The repository pins OpenClaw `2026.7.1` under `openclaw/runtime/` without
modifying the system-wide runtime. Actual credential-free CLI checks confirmed:

- configuration validation completed with no warnings;
- only `meeting-action-tracker` was eligible in the isolated pilot;
- scoped doctor checks completed cleanly;
- the isolated deep audit reported zero critical findings.

See the
[OpenClaw validation record](evidence/openclaw-validation/VALIDATION.md), the
[workspace skill](openclaw/workspace/skills/meeting-action-tracker/SKILL.md),
and the [safe configuration](openclaw/safe-config.example.json).

## Repository map

| Path | Purpose |
|---|---|
| `app/` | Interactive local review console |
| `openclaw/` | Version pin, workspace skill, schema, and safe config |
| `evidence/inputs/` | Five synthetic transcripts |
| `evidence/outputs/` | Hardened, schema-valid replay results |
| `evidence/prompts/` | Baseline and corrective prompts |
| `evidence/fail-fix/` | Baseline failure and validation evidence |
| `evidence/logs/` | Prompt/input/output/reviewer audit records |
| `evidence/screenshots/` | Browser and responsive-layout evidence |
| `evidence/pdf-render/` | All 12 rendered pages and visual QA record |
| `tests/` | Executable contract and rendering tests |
| `output/` | Final reviewer-facing PDF |

## Security boundaries and limitations

- All transcripts, names, dates, and sensitive patterns are synthetic.
- No Elchai data, personal confidential data, account, API key, OAuth session,
  live OpenClaw gateway, or external integration was used.
- Imported future results are revalidated and reset to `Pending Human Review`.
- Browser-side credentials are intentionally unsupported.
- Evidence Replay proves the workflow and controls, not live-model accuracy,
  latency, cost, or provider reliability.
- The recommendation remains a restricted pilot until measured live runs meet
  the report's accuracy and security exit criteria.

Please do not submit real transcripts or credentials to this demonstration.
See [SECURITY.md](SECURITY.md) for safe handling guidance.

## Primary references

- [OpenClaw skills](https://docs.openclaw.ai/skills)
- [OpenClaw tool policies](https://docs.openclaw.ai/gateway/config-tools)
- [OpenClaw audit records](https://docs.openclaw.ai/cli/audit)
- [OpenAI GPT-5.6 Terra model documentation](https://developers.openai.com/api/docs/models/gpt-5.6-terra)

Prepared by **Aqeel** for the Elchai Group AI Agent & OpenClaw Research Intern
assessment, 19 July 2026.
