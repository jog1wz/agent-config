#!/usr/bin/env node
// Removes the top-level "overrides" key from a package.json, in place.
"use strict";

const fs = require("fs");

const target = process.argv[2];
if (!target) {
  console.error("Usage: strip-overrides.cjs <path-to-package.json>");
  process.exit(1);
}

const raw = fs.readFileSync(target, "utf8");
const pkg = JSON.parse(raw);

if (!("overrides" in pkg)) {
  console.log(`No 'overrides' key in ${target}, nothing to do.`);
  process.exit(0);
}

const removed = pkg.overrides;
delete pkg.overrides;
fs.writeFileSync(target, JSON.stringify(pkg, null, 2) + "\n");
console.log(`Removed overrides from ${target}: ${JSON.stringify(removed)}`);
