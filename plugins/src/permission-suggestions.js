import { mkdir, readFile, writeFile } from "node:fs/promises";
import { Plugin } from "@opencode/plugin";

export default Plugin.define({
  id: "permission-suggestions",
  async setup(ctx) {
    const logDirectory = "/working-dir/.opencode";
    const logFile = "/working-dir/.opencode/permission-suggestions.json";
    const controller = new AbortController();

    await mkdir(logDirectory, { recursive: true });

    async function updatePermissionFile(action, resources) {
      let suggestions = { permissions: [] };

      try {
        suggestions = JSON.parse(await readFile(logFile, "utf8"));
      } catch (error) {
        if (error.code !== "ENOENT") throw error;
      }

      suggestions.permissions ??= [];
      if (suggestions.permission) {
        const actions = { bash: "shell", task: "subagent", write: "edit", patch: "edit" };
        const legacy = [];
        for (const [name, value] of Object.entries(suggestions.permission)) {
          for (const [resource, effect] of Object.entries(
            typeof value === "string" ? { "*": value } : value,
          )) {
            legacy.push({ action: actions[name] ?? name, resource, effect });
          }
        }
        suggestions.permissions.unshift(...legacy);
        delete suggestions.permission;
      }

      for (const resource of resources.length === 0 ? ["*"] : resources) {
        if (!suggestions.permissions.some(
          (rule) => rule.action === action && rule.resource === resource && rule.effect === "allow",
        )) {
          suggestions.permissions.push({ action, resource, effect: "allow" });
        }
      }

      const fields = Object.entries(suggestions).map(([entryKey, entryValue]) => {
        if (entryKey === "permissions" && entryValue.length > 0) {
          const rules = entryValue.map((rule) => {
            const entries = Object.entries(rule).map(
              ([fieldKey, fieldValue]) => `${JSON.stringify(fieldKey)}: ${JSON.stringify(fieldValue)}`,
            );
            return `    { ${entries.join(", ")} }`;
          });
          return `  "permissions": [\n${rules.join(",\n")}\n  ]`;
        }
        return `  ${JSON.stringify(entryKey)}: ${JSON.stringify(entryValue, null, 2).replaceAll("\n", "\n  ")}`;
      });
      const output = `{\n${fields.join(",\n")}\n}`;

      await writeFile(
        logFile,
        `${output}\n`,
        "utf8",
      );
    }

    const subscription = (async () => {
      for await (const event of ctx.event.subscribe({ signal: controller.signal })) {
        if (controller.signal.aborted) break;
        if (event.type !== "permission.asked") continue;

        const { action, resources } = event.data;
        try {
          await updatePermissionFile(action, resources);
        } catch (error) {
          console.error("Failed to update permission suggestions:", error);
        }
      }
    })().catch((error) => {
      if (!controller.signal.aborted) {
        console.error("Permission suggestions subscription failed:", error);
      }
    });

    return async () => {
      controller.abort();
      await subscription;
    };
  },
});
