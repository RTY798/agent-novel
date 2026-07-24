# Agent Novel Framework v12

[中文说明](README_ZH.md) · [技能入口](SKILL.md) · [示例](examples/)

An AI-assisted long-form fiction framework that keeps the author in control of story decisions while making continuity, planning, and review reproducible.

## What it solves

- Writing every chapter from a stable, minimal context packet instead of dumping the whole novel into a prompt.
- Treating story facts as structured data, so locations, inventory, injuries, and knowledge do not drift.
- Separating narrative quality from superficial anti-AI rules.
- Varying chapter workflow by primary function: emotional, action, or bridge.

## Quick start

```bash
npm install
npm run init -- "My Novel"
# Fill in projects/My Novel/project/story-bible.md and state/story-state.json.
# Create a chapter card, then ask your writing agent: “Write Chapter 1 using this card.”
npm run check:state -- projects/My Novel/state/story-state.json
```

## Core principles

1. **Facts are data; prose is art.** State validation is strict. Sentence-level style is advisory.
2. **A chapter owes the reader a change.** It need not create a new mystery; resolution, recovery, or emotional payment can be the change.
3. **Use workflows as scaffolding, not shackles.** An intentionally unconventional chapter may skip style checks, never factual checks.
4. **The author owns irreversible choices.** AI proposes options and drafts; the author decides deaths, relationships, themes, and publication.

## Repository layout

```text
agent-novel-framework-v12/
├── SKILL.md                         # Instructions for an AI writing agent
├── README_ZH.md                     # Complete Chinese guide
├── package.json                     # Zero-dependency Node.js commands
├── scripts/
│   ├── init-project.mjs             # Creates a novel project from templates
│   ├── validate-state.mjs           # Validates factual state
│   └── preflight-chapter.mjs        # Checks chapter-card completeness
├── templates/
│   ├── project-brief.template.md
│   ├── story-bible.template.md
│   ├── story-state.template.json
│   ├── chapter-card.template.md
│   ├── chapter-log.template.jsonl
│   └── review.template.json
├── references/
│   ├── chapter-types.md
│   ├── context-loading.md
│   ├── quality-policy.md
│   └── decision-variants.md
└── examples/
    └── chapter-card.example.md
```

## License

MIT
