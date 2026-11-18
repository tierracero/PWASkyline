const fs = require('fs');
const path = require('path');
const crypto = require('crypto');
const zlib = require('zlib');
const {execFileSync} = require('child_process');
const digest = bytes => crypto.createHash('sha256').update(bytes).digest('hex');
const temporary = fs.mkdtempSync('/tmp/pwaskyline-compression-');
const results = [];
try {
  for (const directory of ['DevPublic', 'DistPublic']) {
    for (const target of ['app', 'service']) {
      const file = path.join(directory, target + '.wasm');
      const original = fs.readFileSync(file);
      if (!WebAssembly.validate(original)) throw new Error('Invalid WASM: ' + file);
      const sha256 = digest(original);
      const matches = (suffix, decode) => {
        try { return digest(decode(fs.readFileSync(file + suffix))) === sha256; }
        catch { return false; }
      };
      const gzipBefore = matches('.gz', zlib.gunzipSync);
      const brotliBefore = matches('.br', zlib.brotliDecompressSync);
      if (!gzipBefore) {
        const output = path.join(temporary, directory + '-' + target + '.wasm.gz');
        const fd = fs.openSync(output, 'w');
        try {
          execFileSync('/usr/bin/gzip', [directory === 'DistPublic' ? '-9' : '-2', '-c', file], {stdio:['ignore', fd, 'pipe']});
        } finally { fs.closeSync(fd); }
        fs.copyFileSync(output, file + '.gz');
        fs.unlinkSync(output);
      }
      if (!brotliBefore) {
        const output = path.join(temporary, directory + '-' + target + '.wasm.br');
        execFileSync('/usr/bin/brotli', ['-q', directory === 'DistPublic' ? '11' : '4', file, '-f', '-o', output]);
        fs.copyFileSync(output, file + '.br');
        fs.unlinkSync(output);
      }
      const unchangedWASM = digest(fs.readFileSync(file)) === sha256;
      const gzipMatches = matches('.gz', zlib.gunzipSync);
      const brotliMatches = matches('.br', zlib.brotliDecompressSync);
      if (!unchangedWASM || !gzipMatches || !brotliMatches) throw new Error('Compression validation failed: ' + file);
      results.push({file, gzipBefore, brotliBefore, unchangedWASM, sha256, gzipMatches, brotliMatches});
    }
  }
  process.stdout.write(JSON.stringify(results, null, 2) + '\n');
} finally { fs.rmSync(temporary, {recursive:true, force:true}); }
