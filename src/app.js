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

export default app;
