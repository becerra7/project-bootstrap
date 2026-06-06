---
name: parallel-agents
description: >-
  How to orchestrate multiple agents/subagents effectively — when to fan out work
  in parallel, how to scope each so contexts don't collide, hand-off contracts,
  and which model each should use. Use for large or multi-part tasks, or when work
  can be split into independent tracks.
---

# Parallel agents — divide work without chaos

A multi-agent setup is only faster if the work is genuinely independent and the
hand-offs are clean. Default to a single agent for small tasks; fan out when the
gains are real.

## When to parallelize
- **Independent tracks**: e.g. backend (Supabase schema + use cases) and design
  (manifest + screens) for the same feature can proceed in parallel, then meet at
  the ViewModel.
- **Wide, read-heavy exploration**: spawn explore subagents over different areas
  at once.
- **Best-of-N / experiments**: try alternative approaches in isolated worktrees.
- **Noisy subtasks**: isolate a big refactor/search so it doesn't bloat the main
  context (also a token-efficiency win).

## When NOT to
- Tightly coupled edits to the same files (merge pain).
- Tasks that must be sequential by dependency (schema before mapper before UI).
- Anything small enough for one agent — orchestration has overhead.

## How to scope a subagent (the hand-off contract)
Give each subagent: a single clear objective, the exact files/area it owns, the
inputs it needs (it can't see the main conversation), the conventions to follow
(reference the `conventions` skill), and the exact result to return. Keep their
ownership **non-overlapping** to avoid edit conflicts.

## Roles in this kit
- `product-architect` (plan/ideate, read-only) → `scaffolder` (skeleton) →
  `design-engineer` (UI) ∥ backend work → `release-engineer` (CI/deploy).
- Fan out `design-engineer` and backend in parallel for a feature; converge at the
  ViewModel/UiState.

## Model selection per agent
Match model to task: cheap/fast for mechanical subagents (boilerplate, renames),
strong for architecture/design/debugging. (See `token-efficiency`.)

## Convergence
Define where parallel tracks meet (usually the ViewModel + a build), who
integrates, and run the build + `project-docs` update once at the merge point.
Keep one branch/PR per logical change even if multiple agents contributed.
