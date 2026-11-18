const fs = require('fs');
const path = require('path');
const crypto = require('crypto');
const zlib = require('zlib');
const directory = process.argv[2];
const digest = b => crypto.createHash('sha256').update(b).digest('hex');
const result = {directory, files: []};
for (const target of ['app', 'service']) {
  const file = path.join(directory, target + '.wasm');
  const bytes = fs.readFileSync(file);
  const sha256 = digest(bytes);
  const valid = WebAssembly.validate(bytes);
  const gzipMatches = digest(zlib.gunzipSync(fs.readFileSync(file + '.gz'))) === sha256;
  const brotliMatches = digest(zlib.brotliDecompressSync(fs.readFileSync(file + '.br'))) === sha256;
  if (!valid || !gzipMatches || !brotliMatches) throw new Error('Artifact check failed: ' + file);
  result.files.push({target, bytes: bytes.length, sha256, valid, gzipMatches, brotliMatches});
}
for (const file of ['app.js', 'service.js', 'main.html', 'site.webmanifest']) {
  if (!fs.statSync(path.join(directory, file)).size) throw new Error('Missing output: ' + file);
}
process.stdout.write(JSON.stringify(result, null, 2) + '\n');
