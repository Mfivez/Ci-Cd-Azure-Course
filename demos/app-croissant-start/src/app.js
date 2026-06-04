const express = require('express');

const app = express();

app.get('/', (req, res) => {
  const environmentName = process.env.ENVIRONMENT_NAME || 'local';
  res.json({
    application: 'Croissant API',
    environment: environmentName,
    message: `Hello from ${environmentName}`
  });
});

app.get('/health', (req, res) => {
  res.status(200).json({ status: 'OK' });
});

app.get('/croissants', (req, res) => {
  res.json([
    { id: 1, name: 'Croissant nature' },
    { id: 2, name: 'Croissant chocolat' },
    { id: 3, name: 'Croissant amandes' }
  ]);
});

module.exports = app;
