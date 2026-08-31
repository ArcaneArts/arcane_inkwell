import assert from 'node:assert/strict';
import { readFile, stat } from 'node:fs/promises';

const outputRoot = new URL('../../example/build/jaspr/', import.meta.url);
const expectedBase = '/arcane_lexicon/';
const expectedFont = `${expectedBase}assets/fonts/lucide/lucide.woff2`;
const searchIndex = JSON.parse(
  await readFile(new URL('search-index.json', outputRoot), 'utf8'),
);
const routes = [...new Set(searchIndex.entries.map(({ path }) => path))];
const fontUrls = new Set();

for (const route of routes) {
  const routePath = route === '/' ? 'index.html' : `.${route}/index.html`;
  const html = await readFile(new URL(routePath, outputRoot), 'utf8');
  assert.match(
    html,
    /<base href="\/arcane_lexicon\/"\/>/,
    `${route} does not emit the configured document base`,
  );
  assert.match(
    html,
    /<script src="main\.client\.dart\.js" defer><\/script>/,
    `${route} does not load the compiled client relative to the document base`,
  );
  for (const match of html.matchAll(
    /url\(\s*['"]?([^)'"\s]*fonts\/lucide\/[^)'"\s]+)['"]?\s*\)/gi,
  )) {
    fontUrls.add(match[1]);
  }
}

assert.deepEqual(
  [...fontUrls],
  [expectedFont],
  'generated pages must reference one canonical bundled Lucide font',
);

const client = await readFile(new URL('main.client.dart.js', outputRoot), 'utf8');
assert.match(
  client,
  /data-arcane-client-ready/,
  'compiled client is missing the hydration readiness marker',
);
assert.ok(client.length > 1_000, 'compiled client output is unexpectedly empty');

const font = await stat(
  new URL('assets/fonts/lucide/lucide.woff2', outputRoot),
);
assert.ok(font.isFile() && font.size > 1_000, 'bundled Lucide font is missing');

console.log(
  `Static build contract passed: ${routes.length} routes, subpath base, client, and Lucide font.`,
);
