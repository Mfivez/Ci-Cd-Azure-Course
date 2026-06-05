const test = require('node:test');
const assert = require('node:assert/strict');
const http = require('node:http');
const { app } = require('../src/app');

function startTestServer() {
  const server = http.createServer(app);
  return new Promise((resolve) => {
    server.listen(0, '127.0.0.1', () => {
      const address = server.address();
      resolve({ server, baseUrl: `http://127.0.0.1:${address.port}` });
    });
  });
}

test('GET /health retourne ok', async () => {
  const { server, baseUrl } = await startTestServer();
  try {
    const response = await fetch(`${baseUrl}/health`);
    const body = await response.json();
    assert.equal(response.status, 200);
    assert.equal(body.status, 'ok');
  } finally {
    server.close();
  }
});

test('GET /version retourne le nom du service', async () => {
  const { server, baseUrl } = await startTestServer();
  try {
    const response = await fetch(`${baseUrl}/version`);
    const body = await response.json();
    assert.equal(response.status, 200);
    assert.equal(body.name, 'croissant-api');
  } finally {
    server.close();
  }
});

test('GET /products retourne une liste de produits', async () => {
  const { server, baseUrl } = await startTestServer();
  try {
    const response = await fetch(`${baseUrl}/products`);
    const body = await response.json();
    assert.equal(response.status, 200);
    assert.ok(Array.isArray(body.products));
    assert.ok(body.products.length >= 1);
  } finally {
    server.close();
  }
});
