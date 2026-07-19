import { spawn } from "node:child_process";
import process from "node:process";
import { fileURLToPath } from "node:url";

const command = process.argv[2] ?? "dev";
const cli = fileURLToPath(
  new URL("../node_modules/vinext/dist/cli.js", import.meta.url),
);
const child = spawn(process.execPath, [cli, command], {
  env: {
    ...process.env,
    WRANGLER_LOG_PATH: ".wrangler/wrangler.log",
  },
  stdio: "inherit",
});

child.on("exit", (code) => process.exit(code ?? 1));
