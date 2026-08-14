import express from 'express';

const app = express();

app.disable('x-powered-by');
app.use(express.json());

app.get('/', (req, res) => {
  res.status(200).json({
    message: 'DevOps CI/CD Deployment Portfolio API',
    status: 'running'
  });
});

app.get('/health', (req, res) => {
  res.status(200).json({
    status: 'healthy'
  });
});

app.get('/version', (req, res) => {
  res.status(200).json({
    version: process.env.APP_VERSION || '1.0.0',
    buildId: process.env.BUILD_ID || 'local'
  });
});

app.get('/api/status', (req, res) => {
  res.status(200).json({
    status: 'operational',
    environment: process.env.NODE_ENV || 'development',
    version: process.env.APP_VERSION || '1.0.0',
    buildId: process.env.BUILD_ID || 'local',
    nodeVersion: process.version
  });
});

app.use((req, res) => {
  res.status(404).json({
    error: 'Not Found',
    path: req.originalUrl
  });
});

app.use((err, _req, res, _next) => {
  console.error('Unhandled application error:', err);

  res.status(500).json({
    error: 'Internal Server Error'
  });
});

export default app;
