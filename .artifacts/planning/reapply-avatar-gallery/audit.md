# Source audit — 2026-10-13

- Restored only the reviewed gallery hunks in the uploader and asset-item image-list argument, plus three governance updates.
- Guarded all five existing files against the exact reviewed baseline before writing; source/doc content matches the staged patch.
- `git apply --check --whitespace=error` passed before application; `git apply --reverse --check` passed afterward, confirming the exact patch is present.
- Existing 22px upload icon, title/upload arrangement, MediaViewer implementation and unrelated user edits were preserved.
- Avatar-first, empty/default-list, at-most-four-dot, selected-image-index and upload/state refresh paths were inspected in source.
- Existing MediaViewer honors the selected index and supports absolute sources and disabled media actions; it was not edited.
- Before/after status snapshots and the exact restoration diff are retained here.
- No build, test, full compilation, browser execution, staging, commit, reset, clean or checkout command was run.
