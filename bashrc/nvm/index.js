const fs = require("fs");
const path = require("path");

const NODE_VERSION_FILENAME = ".node-version";
const cwd = path.resolve(process.cwd());
const directories = cwd.split(path.sep).filter(Boolean);

for (let i = directories.length - 1; i >= 0; --i) {
  const parts = ["/", ...directories.slice(0, i), NODE_VERSION_FILENAME];
  const filepath = path.join(...parts);
  if (fs.existsSync(filepath)) {
    const file = fs.readFileSync(filepath, "utf-8");
    const version = file
      .split("\n")
      .filter(Boolean)
      .join("");
    console.log(version);
    process.exit(0);
  }
}

console.log("N/A");
process.exit(1);
