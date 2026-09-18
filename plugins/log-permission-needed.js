import { mkdir, readFile, writeFile } from "node:fs/promises";

export const PermissionSuggestionsPlugin = async ({ directory }) => {
  const logDirectory = "/working-dir/.opencode";
  const logFile = "/working-dir/.opencode/permission-suggestions.json";
  let writes = Promise.resolve();

  await mkdir(logDirectory, { recursive: true });

  async function updatePermissionFile(action, resources) {
    let suggestions = { permission: {} };

    try {
      suggestions = JSON.parse(await readFile(logFile, "utf8"));
    } catch (error) {
      if (error.code !== "ENOENT") throw error;
    }

    suggestions.permission ??= {};

    if (resources.length === 0) {
      suggestions.permission[action] = "allow";
    } else {
      const current = suggestions.permission[action];

      if (typeof current !== "object" || current === null) {
        suggestions.permission[action] = {};
      }

      for (const resource of resources) {
        suggestions.permission[action][resource] = "allow";
      }
    }

    await writeFile(
      logFile,
      `${JSON.stringify(suggestions, null, 2)}\n`,
      "utf8",
    );
  }

  return {
    event: async ({ event }) => {
      if (event.type !== "permission.asked") return;

      const { permission, patterns = [] } = event.properties;

      writes = writes
        .then(() => updatePermissionFile(permission, patterns))
        .catch((error) => {
          console.error("Failed to update permission suggestions:", error);
        });

      await writes;
    },
  };
};
