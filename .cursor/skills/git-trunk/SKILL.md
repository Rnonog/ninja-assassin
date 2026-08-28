---
name: git-trunk
description: Git worktree per task, rebase onto origin/main before commit, push to GitHub main. Use for every feature, bugfix, or improvement in ninja-assassin; never force-push main.
---

# Git Trunk

Remote: `origin` = `https://github.com/Rnonog/ninja-assassin.git`. Zielbranch: `main`.

## Worktree anlegen

Befehle vom **Haupt-Checkout** ausführen (nicht aus einem bestehenden Worktree), sonst entstehen verschachtelte Worktrees:

```bash
git fetch origin
git worktree add -b task/<slug> .worktrees/<slug> origin/main
```

`<slug>`: kurz, kebab-case, z. B. `dev-workflow`, `katana-combo`.

Danach Agent-Root auf den Worktree setzen (`move_agent_to_root` auf `.worktrees/<slug>`). Nur dort Dateien ändern. `.worktrees/` steht in `.gitignore`.

## Commit und Push

```bash
git fetch origin
git rebase origin/main
git add …
git commit -m "…"
git push origin HEAD:main
```

- Rebase **vor** dem Commit, nochmals vor Push wenn `origin/main` weitergelaufen ist.
- Kein `push --force` auf `main`.
- Keine Hooks überspringen (`--no-verify` nur wenn der User es ausdrücklich verlangt).
- Kein Commit von Secrets (`.env`, Credentials).

## Aufräumen

```bash
git worktree remove .worktrees/<slug>
git branch -d task/<slug>
```

Nur nach erfolgreichem Push auf `main`.
