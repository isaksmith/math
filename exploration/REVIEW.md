# Review: OpenAI "Sharing AI progress in mathematics" + `openai/math`

Reviewed 2026-10-06, against upstream commit `adc7f1241` (the initial and only commit).

Sources:
- [Sharing AI progress in mathematics](https://openai.com/index/sharing-ai-progress-in-mathematics/) (blog post)
- [openai/math](https://github.com/openai/math) (repository; this fork is [isaksmith/math](https://github.com/isaksmith/math))
- [How the Ideas Came Together: Mathematical Discovery Notes](https://cdn.openai.com/pdf/reasoning-walkthroughs.pdf) (companion PDF, separate from the repo)
- Coverage: [Scientific American](https://www.scientificamerican.com/article/openai-unleashes-hundreds-more-math-results-upon-a-field-already-in-shock/), [Unite.AI](https://www.unite.ai/openai-releases-722-math-manuscripts-from-an-unreleased-ai-model/), [OpenAI community thread](https://community.openai.com/t/first-look-at-mathematics-manuscripts-from-an-internal-frontier-model-at-openai/1403886)

## What is claimed

- 722 manuscripts in 372 result families, produced by an unreleased internal model during evaluation on roughly 4,000 open problems.
- Average compute per result is about three hours of ChatGPT Pro thinking. Almost every result came from a single prompt to a single agent (per a spokesperson quoted by Scientific American).
- Exceptions to the standard procedure are the Riemann zeta zero-free region work and the Hodge conjecture for CM abelian varieties. The Re(s) > 11/12 write-up was human-edited.
- Release practices were shaped by the IAS Advisory Group on Mathematics and AI. OpenAI will fund workshops on understanding AI-produced results and is "working to responsibly release" the model.
- Corrections will ship as new versions, and earlier versions stay accessible.

## What is actually in the repo (verified locally)

| Item | Count / detail |
| --- | --- |
| Result families (`overview.tex`) | 372, numbered 001–376 with gaps, across 17 disciplines |
| Manuscript links | 722; 205 families have one paper, and the largest (034, log abundance) has 14 |
| Families with a Lean doc (`lean/docs/NNN.md`) | 235 of 372 (63%) |
| Lean source files | ~122k under `lean/OAI/`, with **no `sorry`** found |
| Comparator challenge files | ~811 in `lean/ComparatorChallenges/` |
| Reasoning traces | 10 PDFs in `reasoning_traces/` |
| Lean toolchain | `leanprover/lean4:v4.34.1` (already installed here via elan) |
| Clone size | ~3.1 GB, ~133k files |

Lean coverage is uneven by field. Combinatorics (33/37), TCS (32/40), logic (6/6), and functional analysis (10/11) are nearly fully formalized. Topology (3/18) and algebraic and complex geometry (7/36) are mostly not. Note that the headline number-theory items 001 (Milne), 002 (BSD), and 004 (Hilbert's tenth over ℚ) have **no Lean doc**, while 003 (quasi-RH 7/8) does.

## How to read the trust levels

1. **Lean + Comparator.** Each challenge JSON names a challenge module (the statement), a solution module, and the theorem names, and it permits only `propext`, `Quot.sound`, and `Classical.choice`. A passing Comparator run means the stated theorem is proved from standard axioms. The remaining risk is whether the Lean *statement* says what the paper claims. Read `lean/docs/NNN.md` for each family's scope: several docs explicitly narrow the claim (003, for example, has no explicit constant and leaves out the paper's later applications).
2. **The trusted base includes third-party libraries.** `lakefile.lean` pins 20+ external projects (PrimeNumberTheoremAnd, StrongPNT, carleson, ClassFieldTheory, sphere-eversion, gromov, TauCeti, an `iut` repo, and others), and `lean/patches/` carries local patches to many of them. Comparator's axiom check still covers these libraries, but statement fidelity for any definitions imported from them is worth checking. Nothing imports the `iut` dependency directly.
3. **Paper only.** The README warns that unformalized results "could have issues". Treat the 137 families without a Lean doc as unrefereed preprints.

## Open questions and criticisms to keep in mind

- **Compute and prompt transparency.** The IAS recommendations ask for the model, the exact prompt, and the compute for each result. OpenAI published only the average compute plus aggregate statistics, and no prompts (Scientific American).
- **Selection effect.** About 4,000 problems were posed and 372 families published after "requiring an appropriate level of significance". The failure set is not published, so success rates by field cannot be estimated.
- **Novelty versus recombination.** Lean says nothing about whether the ideas are new or a remix of known techniques. The reasoning traces and the Discovery Notes PDF are the only window into this, and those were themselves written by a model summarizing the chains of thought.
- **Large families.** Many families are built from companion papers (for example, 034 has 14 and 237/260 have 13 each). The principal result may depend on the whole stack, so check which paper is load-bearing.
- **Verification on macOS.** Comparator needs `landrun`, a Linux Landlock sandbox. Running the challenges locally will probably require a Linux VM or container. The README also warns that building the full library can exceed `vm.max_map_count`, so build per module.

## Suggested starting points

- **The 10 reasoning-trace families** (007, 017, 087, 102, 159, 197, 221, 271, 287, 362). They are the only ones where we can see how the proof came together.
- **Headline results with Lean**, such as 003 (quasi-RH). Running its Comparator challenge would be the first end-to-end verification exercise.
- **Headline results without Lean**, such as 001, 002, and 004. These are where independent reading adds the most value.
