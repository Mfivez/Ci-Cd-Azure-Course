const http = require('http');
const { app } = require('./app');

const port = Number(process.env.PORT || 8080);

const server = http.createServer(app);

server.listen(port, '0.0.0.0', () => {
  console.log(`Croissant API listening on port ${port}`);
});
