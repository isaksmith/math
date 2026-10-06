# Exploration workspace

Personal tracking for working through [openai/math](https://github.com/openai/math). Everything we add lives under `exploration/`; nothing upstream is edited, so `git merge upstream/main` stays conflict-free.

| File | Purpose |
| --- | --- |
| [`REVIEW.md`](REVIEW.md) | Review of the release: claims, what is actually in the repo, trust levels, open questions |
| [`TRACKER.md`](TRACKER.md) | **Generated.** Every family by discipline, with Lean/trace flags, status, and notes |
| [`catalog.csv`](catalog.csv) | **Generated.** Machine-readable family list (for filtering/sorting) |
| `status.csv` | **Hand-edited.** Your status, priority, and one-line notes per family |
| `notes/NNN.md` | Longer notes per family (copy [`notes/_template.md`](notes/_template.md)) |
| `build_tracker.py` | Regenerates `TRACKER.md` and `catalog.csv` |

## Workflow

1. Pick a family from `TRACKER.md`.
2. Add or update its row in `status.csv`. Valid statuses are `unread`, `skimmed`, `reading`, `deep-dive`, `checked` (claim independently verified, for example a Comparator run or a careful read), and `parked`. Priority is free-form (we use `1`–`3`).
3. For anything beyond a one-liner, run `cp exploration/notes/_template.md exploration/notes/NNN.md` and write the notes there. The tracker links to them automatically.
4. Run `python3 exploration/build_tracker.py`, then commit.

## Staying in sync with upstream

```sh
git fetch upstream
git merge upstream/main
python3 exploration/build_tracker.py   # picks up new families / Lean docs
```

The `REASONING_TRACES` map in `build_tracker.py` is hand-maintained, so update it if upstream adds traces.
