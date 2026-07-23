# Documentation Sync Skill

Checklist for keeping stable docs aligned with PWASkyline implementation.

## When to Use

Use after any task that changes architecture, source layout, build behavior, dependencies, public output policy, or durable project facts.

## Checklist

- [ ] Update the owning architecture chunk when a boundary rule changes.
- [ ] Update `ARCH_INDEX.md` when adding/removing architecture IDs.
- [ ] Update `SOURCE_MAP.md` when paths, generated-output rules, or ownership changes.
- [ ] Update `MODULES.md` when modules, targets, dependencies, or feature ownership changes.
- [ ] Update `PROJECT_MEMORY.md` for durable verified facts.
- [ ] Update `OPEN_DECISIONS.md` for unresolved questions.
- [ ] Update `TASKS.md` / `TASKS_ARCHIVE.md` when task status changes.
- [ ] Keep transient validation output in `.artifacts/**` instead of stable docs.

