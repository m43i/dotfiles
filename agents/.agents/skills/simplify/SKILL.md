---
name: simplify
description: Simplify and refine recently modified code for clarity and consistency. Use after writing code to improve readability without changing functionality.
---

Review changes in the current branch, or in the state the user specifies. Apply these criteria without changing behavior:

1. **Names**: Shorten verbose names while keeping them clear. Prefer human-readable concepts (`baseline`) over compound phrases that are more mechanical / academic (`lastObservedDiskContent`).

2. **Combine related concepts**: If two types, functions, or constants overlap significantly, merge them. The fewer distinct concepts a reader must hold in their head, the better. *Example: two union types sharing 3 of 4 values → one type with shorter value names.*

3. **Derivability**: If a value can be computed from other values already in scope, don't pass or store it separately. Removing derivable state often simplifies signatures, types, and control flow in one move. *Example: an `isDirty` parameter that's always derived from computing `editorContent !== baseline` can be dropped.*

4. **Inline trivial helpers**: Prefer inlining very small helpers (roughly 1-3 lines) when they are only used to shuffle obvious logic around. Small wrappers often add indirection without adding meaning.

5. **Avoid ceremonial transforms**: Be skeptical of `normalize*`, `finalize*`, and `sanitize*` functions/helpers. These are often thin reshaping steps that can be inlined at the call site or folded into the main flow unless they capture real reusable behavior.

6. **Scope**: Only touch code in the specified scope. Validate your work does not break existing functionality.
