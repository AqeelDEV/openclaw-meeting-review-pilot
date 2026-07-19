# Security guidance

This repository is a credential-free assessment and local demonstration. All
included transcripts and outputs are synthetic.

## Safe use

- Do not paste real meeting transcripts, client material, personal data, API
  keys, OAuth tokens, passwords, or company secrets into the demonstration.
- Keep Evidence Replay as the default execution mode.
- Do not expose the OpenClaw gateway beyond loopback or remove the supplied
  tool-deny policy for this pilot.
- Keep every imported or future live result at `Pending Human Review` until a
  reviewer verifies its evidence.
- Never store provider credentials in browser code, committed configuration,
  screenshots, logs, or audit exports.

## Reporting a concern

If this repository is used during assessment review and a security issue is
found, contact the repository owner privately rather than opening an issue that
could expose sensitive details.

The threat model, known limitations, and pilot entry/exit criteria are described
in `output/Aqeel_Elchai_OpenClaw_Assessment.pdf`.
