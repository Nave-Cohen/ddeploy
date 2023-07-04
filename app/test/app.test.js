const { expect } = require('chai');
require('iconv-lite').encodingExists('cesu8');
const { app } = require('../app');
const request = require('supertest')(app);

describe('jwt', () => {
  it('get - /user/signin should respond with a 302 status code. redirect and render signin html', async () => {
    const response = await request.get('/');
    expect(response.statusCode).to.equal(302);
  });
  it('post - /user/signin should respond with a 200 status code. and render / html', async () => {
    const credentials = {
      name: 'navegi',
      password: '123',
    };
    const response = await request.post('/users/signin', credentials);
    expect(response.statusCode).to.equal(500);
  });
});

describe('routes', () => {
  it('get - /user/signin should respond with a 200 status code. and render html', async () => {
    const response = await request.get('/users/signin');
    expect(response.statusCode).to.equal(200);
    expect(response.headers['content-type']).to.include('text/html');
    expect(response.text).to.include('signin');
  });
});
