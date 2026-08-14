import test from 'node:test';
import assert from 'node:assert/strict';
import request from 'supertest';

import app from '../src/app.js';

test('GET / returns application status', async () => {
  const response = await request(app)
    .get('/')
    .expect('Content-Type', /json/)
    .expect(200);

  assert.deepEqual(response.body, {
    message: 'DevOps CI/CD Deployment Portfolio API',
    status: 'running'
  });

  assert.equal(response.headers['x-powered-by'], undefined);
});

test('GET /health returns healthy status', async () => {
  const response = await request(app)
    .get('/health')
    .expect('Content-Type', /json/)
    .expect(200);

  assert.deepEqual(response.body, {
    status: 'healthy'
  });
});

test('GET /version returns version and build information', async () => {
  const response = await request(app)
    .get('/version')
    .expect('Content-Type', /json/)
    .expect(200);

  assert.equal(
    response.body.version,
    process.env.APP_VERSION || '1.0.0'
  );

  assert.equal(
    response.body.buildId,
    process.env.BUILD_ID || 'local'
  );
});

test('GET /api/status returns operational information', async () => {
  const response = await request(app)
    .get('/api/status')
    .expect('Content-Type', /json/)
    .expect(200);

  assert.equal(response.body.status, 'operational');

  assert.equal(
    response.body.environment,
    process.env.NODE_ENV || 'development'
  );

  assert.equal(
    response.body.version,
    process.env.APP_VERSION || '1.0.0'
  );

  assert.equal(
    response.body.buildId,
    process.env.BUILD_ID || 'local'
  );

  assert.equal(response.body.nodeVersion, process.version);
});

test('unknown route returns JSON 404 response', async () => {
  const response = await request(app)
    .get('/does-not-exist')
    .expect('Content-Type', /json/)
    .expect(404);

  assert.deepEqual(response.body, {
    error: 'Not Found',
    path: '/does-not-exist'
  });
});
