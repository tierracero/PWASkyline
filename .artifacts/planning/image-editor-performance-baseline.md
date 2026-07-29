# Image Editor Performance Baseline

Date: 2026-07-29

Branch: `performance/image-editor-and-css`

Phase: 0 — inspection only

## Scope and constraints

This baseline covers the existing image-editor lifecycle and the cropper input/render path. No production source, public API, DOM identifier, visual style, timing, or behavior was changed in this phase.

The review is scoped to the Swift Web application architecture (`SWWEB-001`, `SWWEB-002`) and its packaged static JavaScript/CSS assets (`PWA-001`, `PWA-003`).

No browser trace was collected and no build or test command was run. Repository governance requires explicit user confirmation before builds/tests, and Phase 0 can establish the first optimization target from the static call path without modifying production code. The findings below are therefore code-path evidence, not runtime frame-time measurements.

## Lifecycle trace

### Creation and insertion

`ImageEditor` has eleven creation sites under `Sources/App`. Each creates an editor and passes it to `addToDom(...)`.

`addToDom` wraps the editor in `SuperView`. The wrapper:

- covers the available host area;
- applies the existing transparent-black backdrop and blur;
- animates the content into view;
- observes removal of the editor content; and
- removes itself after the content is removed.

The editor closes through `self.remove()` from the close button and after a successful save.

### Build and listener registration

`ImageEditor.buildUI()`:

1. loads cached watermark definitions or calls `API.custPOCV1.getIconWaterMark`;
2. registers a listener on `fileInput.$files`; and
3. registers a listener on the global `WebApp.current.wsevent`.

Both listener closures strongly capture the editor.

### DOM insertion and initial image loading

`ImageEditor.didAddToDOM()`:

1. reads `imageEditorThumpDiv` width and height;
2. creates a temporary image loader for the original image;
3. after that image loads, assigns the same original URL to the thumbnail, general/WAP, and logo images;
4. calculates initial dimensions and position; and
5. initializes the thumbnail cropper with `jcrop("imageEditorThump", ...)`.

The browser may satisfy the three visible/hidden image requests from cache, but all three image elements are populated during initial setup even though only one editing step is active.

### Step navigation

- Thumbnail -> WAP: reads `imageEditorThumpBox`, changes the active step, and lazily initializes the WAP cropper once.
- WAP -> logo/watermark: reads `imageEditorWapBox`, changes the active step, and calculates the logo workspace.
- Logo/watermark -> finish: validates the crop values and submits the result.
- Back navigation only changes `editStep`; it does not destroy cropper instances.

Inactive step roots use the HTML `hidden` state. This prevents normal painting/layout of those branches, but their image objects, State listeners, cropper objects, and JavaScript callbacks remain allocated.

### Watermark creation

Choosing a watermark creates a random 12-character item ID and calls:

```text
jcrop("imageEditorWaterMark", itemID, imageURL, width, height)
```

`main.js` attaches another Jcrop stage to the same `imageEditorWaterMark` image for every watermark. It stores only the latest stage in the global `_item` variable. Earlier stages are not explicitly destroyed.

### Close and removal

`ImageEditor.didRemoveFromDOM()` removes listeners from these editor-owned State values:

- `imageIsLoaded`
- `relativeHeight`
- `relativeWidth`
- `top`
- `left`
- `logoRelativeHeight`
- `logoRelativeWidth`
- `logoTop`
- `logoLeft`
- `editStep`
- `imageEditorProcessingViewText`

It does not remove or neutralize:

- the `fileInput.$files` listener;
- the global `WebApp.current.wsevent` listener;
- cropper instances;
- cropper DOM listeners;
- the global `_item` reference;
- a pending crop drag; or
- asynchronous image/API/WebSocket callbacks already in flight.

The current `State.listen` API returns no listener token. `removeAllListeners()` is the only removal API, so it is unsafe for an individual editor to clear the shared global WebSocket State. A weak capture can prevent the global closure from retaining the editor, but the dead closure would remain registered.

The file listener forms an editor-owned retain cycle:

```text
ImageEditor -> fileInput -> files State -> listener closure -> ImageEditor
```

That listener can be cleared from the owned `fileInput.$files` State during removal or changed to a weak capture in a later lifecycle phase.

## JavaScript call path

```text
ImageEditor.swift
  -> getAttribute.swift jcrop(...)
  -> main.js jcrop(...) / jcropWithImage(...)
  -> Jcrop.attach(...)
  -> jcrop.js drag helper
  -> Widget mover or resize handle
  -> Widget.render(...)
  -> crop.update DOM event
  -> ShadeManager.adjust(...)
```

The bridge in `getAttribute.swift` exposes creation only. There is no Swift-to-JavaScript destroy bridge.

## DOM identifier inventory

| Identifier | Created/used by ImageEditor | Other project references | Finding |
| --- | --- | --- | --- |
| `imageThumpContainer` | Assigned to both the thumbnail and WAP containers | None | Confirmed duplicate ID inside one editor. It is not externally referenced. |
| `imageEditorThump` | Thumbnail image and Jcrop host | `SocialManagerView.swift` | Publicly reused by a separate legacy editor; simultaneous editors could collide. |
| `imageEditorWap` | WAP/general image and Jcrop host | None | Unique to `ImageEditor`. |
| `imageEditorWaterMark` | Logo/watermark image and repeated Jcrop host | None | Unique to `ImageEditor`; reused for multiple attach calls in one session. |
| `imageEditorThumpDiv` | Thumbnail workspace measurement root | `SocialManagerView.swift` | Reused by a separate legacy editor. |
| `imageEditorWapDiv` | WAP workspace measurement root | None | Unique to `ImageEditor`. |
| `iconLogoDiv` | Logo workspace root | `SocialManagerView.swift` | Reused by a separate legacy editor. |
| `imageEditorWMImg` | Watermark image wrapper | None | Unique to `ImageEditor`. |
| `imageEditorWMDiv` | Watermark workspace measurement root | None | Unique to `ImageEditor`. |
| `imageEditorThumpBox` | Generated by `main.js` as `${id}Box` | Read by `ImageEditor` | Must remain stable unless Swift and JavaScript change together. |
| `imageEditorWapBox` | Generated by `main.js` as `${id}Box` | Read by `ImageEditor` | Must remain stable unless Swift and JavaScript change together. |
| random `itemID` | Watermark crop widget ID | Read by `ImageEditor` | Session-local identifier. |
| `${itemID}Img` | Image inserted into a watermark widget | Read by `_getImgeHeight` | Its `offsetHeight` is read during every watermark render. |

The duplicate `imageThumpContainer` can be corrected later without external reference updates, but it is not part of the cropper hot-path fix and should not be mixed into Phase 1.

## Listener and ownership inventory

| Source | Registration | Removal today | Retention/work risk |
| --- | --- | --- | --- |
| Editor-owned `@State` values | Swift UI bindings/listeners | Selected States cleared in `didRemoveFromDOM()` | Partially handled; only the explicitly listed States are cleared. |
| `fileInput.$files` | `buildUI()` | Not removed | Strong editor-owned cycle. |
| `WebApp.current.wsevent` | `buildUI()` | Not removed | Global State closure strongly retains the editor indefinitely. |
| Temporary loader image `onLoad`/`onError` | `didAddToDOM()` | Not cancelled | Callback may arrive after close and mutate detached editor state. |
| Thumbnail/general/logo image callbacks | Image setup and background removal | Not cancelled | In-flight callbacks may outlive DOM presence. |
| Cropper drag start | `mousedown`/`touchstart` on stage/widgets/handles | Helper `remove()` exists but its handle is not retained | Listener lives for the cropper/DOM lifetime. |
| Active drag move/end | global `mousemove` plus document mouse/touch end/move | Removed only when drag ends | Closing mid-drag can leave active global listeners until an end event occurs. |
| Widget focus/keyboard/crop events | Anonymous DOM listeners | No explicit removal | Cannot be individually detached by current code. |
| Shade `crop.update` | Anonymous listener on stage | No explicit removal | Lives with stage; repeated attach increases listener count. |
| `_item` | Latest watermark stage assigned globally | Never cleared | Retains at least the latest watermark stage after editor removal. |

`Stage.destroy()` in the bundled cropper is empty. `ImageStage.destroy()` unwraps its image and removes its wrapper, but it does not provide complete listener cleanup. Even adding a destroy bridge will require a deliberate ownership implementation rather than merely calling the existing empty method.

## Cropper hot path

The drag helper handles every raw `mousemove` or `touchmove` immediately. It has no animation-frame gate.

For a widget move or handle resize:

1. drag-start dimensions and the starting crop rectangle are measured once;
2. each raw pointer event calculates a new rectangle;
3. `Widget.render()` writes `top`, `left`, `width`, and `height`;
4. `Widget.render()` emits `crop.update`;
5. `ShadeManager.adjust()` reads the stage rectangle through offsets; and
6. the shade manager updates all four shade elements.

Static per-move work is approximately:

- 4 crop-widget style writes;
- 1 `offsetHeight` read for watermark widgets through `_getImgeHeight()` after crop style writes;
- one synchronous `crop.update` dispatch;
- 4 stage layout reads (`offsetLeft`, `offsetTop`, `offsetWidth`, `offsetHeight`); and
- approximately 7 shade style assignments.

Square thumbnail/WAP widgets avoid the `_getImgeHeight()` read because `${cropperId}Img` is absent, but they still perform stage layout reads after widget writes. This read-after-write sequence is a forced-layout risk on every raw move.

Because browser pointer events can arrive faster than display refresh, the same visual frame may process multiple complete render/layout/shade cycles. This is the highest-confidence cause of visible crop movement stutter.

## Prioritized findings

1. **P0 — unrestricted raw pointer processing:** every move event performs the complete crop render and shade update. This is the narrowest and safest first optimization.
2. **P0 — read-after-write layout pressure:** stage offsets are read after crop styles are written; watermark rendering adds another `offsetHeight` read.
3. **P1 — global Swift listener retains every closed editor:** the WebSocket State listener strongly captures `ImageEditor` and has no per-listener removal API.
4. **P1 — file-input listener cycle:** an owned State listener strongly captures its owner and is not cleared.
5. **P1 — incomplete cropper ownership/destruction:** no instance registry or Swift destroy bridge exists; `Stage.destroy()` is empty.
6. **P1 — repeated watermark attach:** repeated attachments can create nested image stages; `_item` overwrites only the reference, not the prior stage.
7. **P2 — eager image population:** three editor image elements receive the same source during initial setup even though only one step is visible.
8. **P2 — duplicate static DOM ID:** `imageThumpContainer` appears twice but has no external references.
9. **Separate correctness audit:** `finishEdition()` assigns `relativeWidth` to `relativeHieght` and `logoRelativeWidth` to `logoRelativeHeight`. These suspicious payload mappings must not be changed as part of a performance patch without separate behavioral verification.

## Exact Phase 1 proposal

Phase 1 should modify only:

```text
Sources/Service/skyline/js/jcrop.js
```

Target function:

```text
the shared drag helper at jcrop.js lines 398-433
```

Proposed implementation:

1. Store only the latest pending pointer delta.
2. Schedule `requestAnimationFrame` only when no frame is already pending.
3. Apply at most one movement callback per animation frame.
4. Preserve the existing drag-start callback and its cached measurements.
5. On drag end:
   - compute/store the final pointer delta;
   - cancel a pending frame;
   - synchronously apply the latest unrendered position once; and
   - call the existing end callback exactly once so `crop.change` remains single.
6. Extend the helper's existing `remove()` cleanup to cancel a pending frame and detach any active global move/end listeners.
7. Keep mouse and touch handling for this phase. Pointer Events would enlarge the compatibility patch and are not required to obtain frame coalescing.

Files explicitly unchanged in Phase 1:

```text
Sources/App/Snippits/ImageEditor.swift
Sources/App/Functions/getAttribute.swift
Sources/Service/skyline/js/main.js
Sources/Service/skyline/css/jcrop.css
Sources/App/Functions/addToDom.swift
```

Behavior and appearance to preserve:

- crop rectangle coordinates and constraints;
- aspect-ratio enforcement;
- handle behavior;
- final `crop.change` timing and count;
- mouse and touch support;
- crop/shade appearance;
- all DOM IDs/classes; and
- all CSS and animation values.

Recommended Phase 1 verification, after explicit build/test approval:

- focused application build;
- manual thumbnail crop move and resize;
- manual WAP crop move and resize;
- manual watermark move and resize;
- mouse and touch-input smoke checks where available;
- verify the final pointer position is not lost on release;
- verify one final `crop.change` per drag;
- browser Performance panel comparison of render calls and frame cadence; and
- reviewed diff plus git status.

Preferred Phase 1 commit:

```text
perf(jcrop): coalesce drag updates with animation frames
```

## Phase 0 conclusion

The first implementation should be a one-file animation-frame coalescing patch in the shared cropper drag helper. It directly reduces redundant work without changing layout, styling, crop constraints, Swift APIs, DOM identifiers, or editor workflow.

Lifecycle cleanup, forced-layout removal, eager image loading, duplicate IDs, and broader CSS/theme work should remain separate phases with separate review and commits.
