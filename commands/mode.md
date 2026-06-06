# Mode

Adopt a behavior preset for how you talk and work, until I change it. Read the
matching file in `.agents/behaviors/` and follow it.

Available presets:
- `terse` — minimal prose, result-first, token-optimized.
- `explain` — teach as you go, brief why + trade-offs.
- `ship-fast` — bias to action, sensible defaults, smallest change that ships.
- `careful-review` — maximize correctness, plan + verify each step.
- `architect` — plan/design first, no code until agreed.

Apply the preset named after the command (e.g. `/mode terse`). If none is given,
list the presets and tell me which is active. You can combine a preset with any
normal request. Presets are tone/working-style only — they never override the
`conventions` guardrails or safety rules.
