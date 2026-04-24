import { readFileSync, writeFileSync, copyFileSync, mkdirSync } from "node:fs";
import { resolve } from "node:path";

const root = process.cwd();
const distDir = resolve(root, "dist");
const templatePath = resolve(root, "site-config.template.js");
const outputConfigPath = resolve(distDir, "site-config.js");

mkdirSync(distDir, { recursive: true });
copyFileSync(resolve(root, "index.html"), resolve(distDir, "index.html"));

const required = {
  SUPABASE_URL: process.env.SUPABASE_URL,
  SUPABASE_ANON_KEY: process.env.SUPABASE_ANON_KEY
};

const missing = Object.entries(required)
  .filter(([, value]) => !value)
  .map(([key]) => key);

if (missing.length > 0) {
  console.error(`Missing required environment variables: ${missing.join(", ")}`);
  process.exit(1);
}

const template = readFileSync(templatePath, "utf8");
const configFile = template
  .replace("__SUPABASE_URL__", required.SUPABASE_URL)
  .replace("__SUPABASE_ANON_KEY__", required.SUPABASE_ANON_KEY);

writeFileSync(outputConfigPath, configFile);
