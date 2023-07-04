class User {
  constructor(user) {
    this.id = user.id;
    this.name = user.username;
    this.email = user.email;
    this.letter = user.username.charAt(0);
  }
}
module.exports = User;
