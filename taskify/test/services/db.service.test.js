const { expect } = require('chai');
const { register, login, pool } = require('../../services/db.service');
const User = require('../../entities/user');
async function clearDb() {
  const users = ['testuser', 'newuser', 'existuser'];
  for (const user of users) {
    try {
      // Clean up the inserted data
      await pool.query('DELETE FROM users WHERE username = ?', [user]);
    } catch {
      /* empty */
    }
  }
}
before(async () => {
  await clearDb();
});
after(async () => {
  await clearDb();
  await pool.end();
});
describe('db.services - register', () => {
  // Tests that the function successfully registers a new user with valid username, email, and password.
  it('test_register_successfully_registers_new_user', async () => {
    const result = await register('testuser', 'testuser@test.com', 'password123');

    expect(result instanceof User).equal(true);
  });

  // Tests that the function returns false when attempting to register a new user with an existing username.
  it('test_register_fails_with_existing_username', async () => {
    // Create a separate connection object
    const result = await register('testuser', 'newemail@test.com', 'newpassword');
    expect(result.message).equal("Duplicate entry 'testuser' for key 'users.username'");
  });

  // Tests that the function returns false when attempting to register a new user with an existing email.
  it('test_register_fails_with_existing_email', async () => {
    // Create a separate connection object
    const result = await register('newuser', 'testuser@test.com', 'newpassword');
    expect(result.message).equal("Duplicate entry 'testuser@test.com' for key 'users.email'");
  });

  // Tests that the function returns false when attempting to register a new user with a username, email, or password that exceeds the maximum length allowed by the database.
  it('test_register_fails_with_max_length_exceeded', async () => {
    const longString = 'a'.repeat(256); // Generating a string that exceeds the maximum length allowed by the database
    const result = await register(longString, 'newemail@test.com', 'newpassword');
    expect(result.message).equal("Data too long for column 'username' at row 1");
  });
});

describe('db.services - login', () => {
  // Tests that a user can successfully log in with a valid username and password.
  it('test_login_valid_username_and_password', async () => {
    const result = await login('testuser', 'password123');
    expect(result instanceof User).equal(true);
  });

  // Tests that a user can successfully log in with a valid email and password.
  it('test_login_valid_email_and_password', async () => {
    const result = await login('testuser@test.com', 'password123');
    expect(result instanceof User).equal(true);
  });

  // Tests that a user cannot log in with an invalid username and password.
  it('test_login_invalid_username_and_password', async () => {
    const result = await login('invaliduser', 'invalidpassword');
    expect(result).equal(null);
  });

  // Tests that a user cannot log in with an invalid email and password.
  it('test_login_invalid_email_and_password', async () => {
    const result = await login('invaliduser@test.com', 'invalidpassword');
    expect(result).equal(null);
  });
});
