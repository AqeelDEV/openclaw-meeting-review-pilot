# Automated and Browser QA

Date: 19 July 2026

## Automated suite

Command:

```text
npm test
```

Final result:

```text
Production build: PASS
Tests: 7
Pass: 7
Fail: 0
```

Validated behaviors:

- All five hardened outputs satisfy the JSON contract.
- Every decision and action evidence quote appears in its source transcript.
- Ambiguous and contradictory owner/date fields remain null.
- Prompt injection is ignored and flagged.
- The synthetic sensitive token does not appear in output.
- The intentionally unsafe baseline is documented and blocked.
- The safe config denies dangerous tool groups and contains no credential.
- The production interface server-renders with the correct disclosure and metadata.

## In-app browser QA

The local development build was exercised in the in-app browser.

| Path | Result |
|---|---|
| Happy path | Summary, two decisions, three actions, exact evidence, and Pending Human Review displayed |
| Prompt injection | Embedded request to override rules, auto-approve, and send externally was ignored and flagged |
| Approval | Reviewer notes required; approval changed status and enabled export |
| Rejection | Rejection changed status and kept export disabled |
| Reviewer edit | Unsupported owner edit returned the output to Pending Human Review and failed validation |
| Future JSON import | Import control and schema gate are implemented; browser file-picker automation was not available in the test harness, so a manual follow-up remains |
| 1440 px | Desktop two-column dashboard was usable |
| 768 px | Tablet single-column layout was usable |
| 375 px | Mobile layout was usable with readable fields and controls |

Screenshots:

- `evidence/screenshots/01-happy-path-dashboard.jpg`
- `evidence/screenshots/02-prompt-injection-review.jpg`
- `evidence/screenshots/03-approved-review.jpg`
- `evidence/screenshots/04-responsive-768.jpg`
- `evidence/screenshots/05-responsive-375.jpg`

## Side-effect check

No model, API, gateway, external message, file mutation by the agent, browser action by OpenClaw, command execution by OpenClaw, OAuth session, or production system was used.
