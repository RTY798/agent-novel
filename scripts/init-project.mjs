import { cp, mkdir, readFile, writeFile } from "node:fs/promises";
import { basename, join, resolve } from "node:path";

/** Create a minimal novel project from the repository templates. */
async function main() {
  const title = process.argv.slice(2).join(" ").trim();
  if (!title) {
    throw new Error('Usage: npm run init -- "Novel Title"');
  }

  const root = resolve("projects", title);
  const templateRoot = resolve("templates");
  const directories = ["project", "state", "cards", "drafts", "reviews"];

  await Promise.all(directories.map((directory) => mkdir(join(root, directory), { recursive: true })));
  await cp(templateRoot, join(root, "templates"), { recursive: true });

  const replacements = [
    ["project-brief.template.md", join(root, "project", "project-brief.md")],
    ["story-bible.template.md", join(root, "project", "story-bible.md")],
    ["story-state.template.json", join(root, "state", "story-state.json")],
    ["chapter-log.template.jsonl", join(root, "state", "chapter-log.jsonl")]
  ];

  for (const [source, target] of replacements) {
    const content = await readFile(join(templateRoot, source), "utf8");
    await writeFile(target, content.replaceAll("{{TITLE}}", title), "utf8");
  }

  console.log(`Created ${basename(root)} at ${root}`);
}

main().catch((error) => {
  console.error(`Init failed: ${error.message}`);
  process.exitCode = 1;
});
