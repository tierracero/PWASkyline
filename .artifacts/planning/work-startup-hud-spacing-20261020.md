# Work boot HUD spacing / shortened legs refinement (2026-10-20)
## Scope
Work startup decorative SVG + its scoped CSS and owning architecture note only. Do not edit main.html, inner startup card, readiness/status/progress behavior, unrelated user changes or generated public files.
## Adjustments
- Reduce completed HUD opacity from 0.5 to 0.25 (75% transparent) without altering fade-in.
- Widen responsive HUD container, but also move SVG side brackets and all side perspective/target connectors outward in SVG coordinates so spacing improves even when viewport caps the container.
- Shorten the four long diagonal corner-bracket legs by roughly one quarter, retaining symmetric angles, upper scale and blue-white style.
- Keep all HUD decoration non-interactive and hidden <=900px.
## Audit
Inspect final source/diff/status; leave compilation and browser preview pending explicit confirmation.
