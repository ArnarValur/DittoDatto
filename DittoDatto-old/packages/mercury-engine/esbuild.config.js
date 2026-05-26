import esbuild from 'esbuild';

esbuild.build({
  entryPoints: ['src/server.ts'],
  bundle: true,
  platform: 'node',
  target: 'node22',
  outfile: 'dist/server.js',
  format: 'esm',
  sourcemap: true,
  external: [
    'firebase-admin',
    '@hono/node-server',
    'hono',
    'date-fns',
    'zod'
  ],
}).then(() => console.log('✅ esbuild complete!'))
  .catch(() => process.exit(1));
