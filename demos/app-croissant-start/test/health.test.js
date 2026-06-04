const assert = require('assert');
const test = require('node:test');
const http = require('http');
const app = require('../src/app');

function request(server, path) {
  const { port } = server.address();
  return new Promise((resolve, reject) => {
    http.get(`http://127.0.0.1:${port}${path}`, (res) => {
      let data = '';
      res.on('data', chunk => data += chunk);
      res.on('end', () => resolve({ statusCode: res.statusCode, body: data }));
    }).on('error', reject);
  });
}

test('GET /health returns OK', async () => {
  const server = app.listen(0);
  try {
    const response = await request(server, '/health');
    assert.strictEqual(response.statusCode, 200);
    assert.match(response.body, /OK/);
  } finally {
    server.close();
  }
});
