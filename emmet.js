#!/usr/bin/env node

import expand from "emmet";

const args = process.argv.slice(2);
const isStylesheet = args.includes("--stylesheet");
const abbr = args.find((arg) => !arg.startsWith("--"))?.trim() || "";

if (!abbr) {
  console.error("No abbreviation provided");
  process.exit(1);
}

try {
  const result = expand(abbr, { type: isStylesheet ? "stylesheet" : "markup" });
  console.log(result);
  process.exit(0);
} catch (err) {
  console.error(err.originalMessage || err.message || String(err));
  process.exit(1);
}
