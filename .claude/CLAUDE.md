# DependencyKit

Dependency injection framework — standalone Swift package (Layer 0). Provides the `DependencyValues` container, `@Dependency` property wrapper, and compile-time safe DI used across all packages in the monorepo.

## Commands

```bash
swift build
swift test
```

---

## Workspace

This package lives inside the Wetaxi iOS monorepo. Dependency layers:

```
Layer 0 — standalone: Netti, DependencyKit, UtilitiesKit
Layer 1 — DesignKit → UtilitiesKit
Layer 2 — CoreKit → DesignKit, UtilitiesKit, DependencyKit, Netti
Layer 3 — PaymentsKit → CoreKit | FlowKit → CoreKit
Layer 4 — RideHailingSDK, TPLSDK, WeSharingSDK-iOS → CoreKit + PaymentsKit
Layer 5 — Wetaxi app → all
```

Full path table and key conventions: `~/Desktop/WORKS/iOS/.claude/CLAUDE.md`

### Cross-package connections

Use the graph-cache vault for dependency lookups:

```bash
# Packages that depend on a given package
grep -rl "\[\[PackageName\]\]" ~/.claude/graph-cache/vault/

# A package's own dependencies
cat ~/.claude/graph-cache/vault/PackageName.md
```

### Graph cache locations

- Per-project structural graph: `~/.claude/graph-cache/<hash>/`
- Cross-package vault (Obsidian links): `~/.claude/graph-cache/vault/`
- Wetaxi semantic graph: `~/Desktop/WORKS/iOS/Wetaxi/graphify-out/graph.json`
