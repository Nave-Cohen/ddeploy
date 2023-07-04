const sessions = require("express-session");
const mysqlStore = require("express-mysql-session")(sessions);
const { pool } = require("./db.service");
const db_config = require("../configs/db.config");

const day = 1000 * 60 * 60 * 24;
module.exports = sessions({
  store: new mysqlStore(db_config.options, pool),
  secret: db_config.JWTTOKEN,
  resave: false,
  saveUninitialized: false,
  cookie: {
    maxAge: day,
    secure: false,
    httpOnly: true,
  },
});
