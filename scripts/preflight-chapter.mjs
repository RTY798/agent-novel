import { readFile } from "node:fs/promises";

/** Check whether a Markdown chapter card contains every required planning field. */
async function main() {
  const filePath = process.argv[2];
  if (!filePath) {
    throw new Error("Usage: npm run check:card -- path/to/chapter-card.md");
  }
  const card = await readFile(filePath, "utf8");
  const requiredLabels = [
    "chapter_type:", "viewpoint / tense:", "time / location:", "chapter objective:",
    "obstacle:", "irreversible or meaningful choice:", "recorded consequence:",
    "reader promise", "ending state:", "## Story Contract", "## Scene beats"
  ];
  const missing = requiredLabels.filter((label) => !card.includes(label));
  if (missing.length > 0) {
    console.error("CHAPTER CARD INCOMPLETE");
    missing.forEach((label) => console.error(`- Missing: ${label}`));
    process.exitCode = 1;
    return;
  }
  console.log("CHAPTER CARD OK: all required planning fields are present.");
}

main().catch((error) => {
  console.error(`Card validation failed: ${error.message}`);
  process.exitCode = 1;
});
