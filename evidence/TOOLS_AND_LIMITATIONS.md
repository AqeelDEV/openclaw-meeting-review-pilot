# Tools Used and Known Limitations

## Tools used

- Codex for research, implementation, and document assembly
- OpenClaw v2026.7.1 package for local CLI/version validation where the
  available runtime permits
- GPT-5.6 Terra as the selected production model, not invoked
- React/vinext local dashboard
- Node.js contract tests
- ReportLab for PDF generation
- Poppler and PDF text extraction for visual and structural PDF QA
- In-app browser for local interaction and responsive testing

## Known limitations

- No live OpenClaw model turn was executed because account and API credentials
  were intentionally excluded.
- Evidence outputs are deterministic simulations and are labeled as such.
- Synthetic fixtures are small and do not prove performance on real Elchai
  meetings, accents, transcription errors, or domain language.
- OpenClaw's metadata audit ledger does not store prompt/input/output content,
  so the assessment includes a separate synthetic content log.
- Sandboxing reduces blast radius but is not a perfect security boundary.
- Model behavior, pricing, provider access, and tool capabilities can change.
- No external meeting, CRM, email, calendar, or messaging integration was
  enabled or tested.
- The pilot does not establish privacy, data-residency, retention, or legal
  approval for confidential company information.
