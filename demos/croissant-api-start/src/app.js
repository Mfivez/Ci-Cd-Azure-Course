const products = [
  { id: 1, name: 'Croissant beurre', price: 1.4 },
  { id: 2, name: 'Pain au chocolat', price: 1.6 },
  { id: 3, name: 'Croissant amande', price: 2.2 }
];

function sendJson(res, statusCode, payload) {
  const body = JSON.stringify(payload);
  res.writeHead(statusCode, {
    'Content-Type': 'application/json; charset=utf-8',
    'Content-Length': Buffer.byteLength(body)
  });
  res.end(body);
}

function app(req, res) {
  const url = new URL(req.url, `http://${req.headers.host || 'localhost'}`);

  if (url.pathname === '/') {
    return sendJson(res, 200, {
      message: 'Bienvenue sur Croissant API',
      endpoints: ['/health', '/version', '/products']
    });
  }

  if (url.pathname === '/health') {
    return sendJson(res, 200, {
      status: 'ok',
      service: 'croissant-api'
    });
  }

  if (url.pathname === '/version') {
    return sendJson(res, 200, {
      name: 'croissant-api',
      version: process.env.APP_VERSION || 'local',
      environment: process.env.ENVIRONMENT_NAME || 'local',
      logLevel: process.env.LOG_LEVEL || 'info'
    });
  }

  if (url.pathname === '/products') {
    return sendJson(res, 200, { products });
  }

  return sendJson(res, 404, {
    error: 'not_found',
    path: url.pathname
  });
}

module.exports = { app };
