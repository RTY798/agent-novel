import { readFile } from "node:fs/promises";

/** Validate the minimum factual-state contract used by the framework. */
async function main() {
  const filePath = process.argv[2];
  if (!filePath) {
    throw new Error("Usage: npm run check:state -- path/to/story-state.json");
  }

  const data = JSON.parse(await readFile(filePath, "utf8"));
  const errors = [];
  const requiredTopLevel = ["schema_version", "chapter", "clock", "characters", "resources", "relationships", "active_hooks"];

  for (const key of requiredTopLevel) {
    if (!(key in data)) errors.push(`Missing top-level field: ${key}`);
  }
  if (!Number.isInteger(data.chapter) || data.chapter < 0) {
    errors.push("chapter must be a non-negative integer");
  }
  if (!data.characters || typeof data.characters !== "object" || Object.keys(data.characters).length === 0) {
    errors.push("characters must contain at least one character");
  }
  for (const [name, character] of Object.entries(data.characters ?? {})) {
    for (const field of ["location", "condition", "inventory", "knowledge"]) {
      if (!(field in character)) errors.push(`${name} is missing ${field}`);
    }
    if (!Array.isArray(character.inventory)) errors.push(`${name}.inventory must be an array`);
    if (!Array.isArray(character.knowledge)) errors.push(`${name}.knowledge must be an array`);
  }
  const hookIds = new Set();
  for (const hook of data.active_hooks ?? []) {
    if (!hook.id || !hook.question) errors.push("Each active hook requires id and question");
    if (hookIds.has(hook.id)) errors.push(`Duplicate hook id: ${hook.id}`);
    hookIds.add(hook.id);
  }

  if (errors.length > 0) {
    console.error("STATE INVALID");
    errors.forEach((error) => console.error(`- ${error}`));
    process.exitCode = 1;
    return;
  }
  console.log(`STATE OK: chapter ${data.chapter}; ${Object.keys(data.characters).length} characters; ${(data.active_hooks ?? []).length} active hooks.`);
}

main().catch((error) => {
  console.error(`State validation failed: ${error.message}`);
  process.exitCode = 1;
});
