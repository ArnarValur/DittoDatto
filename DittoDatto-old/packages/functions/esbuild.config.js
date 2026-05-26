const esbuild = require("esbuild");
const { glob } = require("glob");
const path = require("path");

async function build() {
  // Find all function entry points
  const entryPoints = ["src/index.ts"];

  await esbuild.build({
    entryPoints,
    bundle: true,
    platform: "node",
    target: "node20",
    outdir: "lib",
    format: "cjs", // CommonJS for Firebase Functions
    sourcemap: true,
    external: [
      // Don't bundle Firebase packages - they're provided at runtime
      "firebase-admin",
      "firebase-functions",
    ],
  });

  console.log("Build complete!");
}

build().catch((err) => {
  console.error(err);
  process.exit(1);
});
