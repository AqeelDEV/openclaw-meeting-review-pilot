# Aqeel - Elchai OpenClaw Assessment Package

Repository:
`https://github.com/AqeelDEV/openclaw-meeting-review-pilot`

## Start here

1. Read `Aqeel_Elchai_OpenClaw_Assessment.pdf`.
2. Open `SUBMISSION_EMAIL.md` for the ready-to-send email.
3. Run the local prototype:

```powershell
npm install
npm run dev
```

4. Run verification:

```powershell
npm test
```

5. Recreate the PDF:

```powershell
python scripts/generate_assessment_pdf.py
```

## Package map

- `app/` - local review dashboard
- `openclaw/workspace/skills/meeting-action-tracker/` - controlled workspace skill
- `openclaw/safe-config.example.json` - hardened pilot configuration
- `openclaw/runtime/package.json` - OpenClaw 2026.7.1 and supported Node pin
- `evidence/inputs/` - five synthetic transcripts
- `evidence/outputs/` - validated replay results
- `evidence/prompts/` - full baseline and hardened prompts
- `evidence/logs/` - prompt/input/output/reviewer JSONL records
- `evidence/openclaw-validation/` - real CLI, doctor, and audit evidence
- `evidence/screenshots/` - browser QA screenshots
- `evidence/pdf-render/` - all 12 rendered PDF pages and visual QA
- `evidence/test-results/` - automated and browser QA summary
- `tests/` - executable contract and server-rendering tests

## Integrity disclosure

`openai/gpt-5.6-terra` is selected for a future pilot but was not invoked. No
account, API key, OAuth session, or live OpenClaw gateway was used. All meeting
content and outputs are synthetic evidence replays. No confidential Elchai or
personal data is included.
