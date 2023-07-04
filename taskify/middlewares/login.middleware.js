const { Router } = require("express");
const router = Router();

const jwt = router.use((req, res, next) => {
  if (!req.session.user) {
    res.redirect("/users/signin");
  } else {
    next();
  }
});

module.exports = jwt;
