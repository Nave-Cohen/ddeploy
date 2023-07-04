const { Router } = require("express"),
  dbService = require("../services/db.service"),
  router = Router();

router.use("/:query", (req, res, next) => {
  if (
    req.session.user &&
    req.params.query !== "logout" &&
    req.params.query !== "profile"
  ) {
    res.redirect("/");
  } else {
    next();
  }
});
//render login
router.get("/signin", function (req, res) {
  renderSignTabs(res, "signin", "signup");
});

router.post("/signin", async function (req, res) {
  var user = await dbService.login(req.body.username, req.body.password);
  if (user) {
    if (req.body.checkbox) {
      req.session.cookie.maxAge = 1000 * 60 * 60 * 24 * 365;
    }
    req.session.user = user;
    res.sendStatus(200);
  } else {
    res.sendStatus(500);
  }
});

//render register
router.get("/signup", function (req, res) {
  renderSignTabs(res, "signup", "signin");
});

router.post("/signup", async function (req, res) {
  var user = await dbService.register(
    req.body.username,
    req.body.email,
    req.body.password
  );
  if (user) {
    req.session.user = user;
    user.name = user.username;
    user.letter = user.username.charAt(0);
    res.sendStatus(200);
  } else {
    res.sendStatus(500);
  }
});

function renderSignTabs(res, activeTab, inactiveTab) {
  res.render(`ejs/sign-tabs.ejs`, {
    title: "Sign-" + activeTab.slice(4),
    active: activeTab,
    notactive: inactiveTab,
  });
}

router.post("/profile", async function (req, res) {
  var user = await dbService.editProfile(req.body);
  if (user) {
    req.session.user.name = req.body.username;
    req.session.user.email = req.body.email;
    req.session.user.letter = req.body.username.charAt(0);
    res.sendStatus(200);
  } else {
    res.sendStatus(500);
  }
});

//render logout
router.get("/logout", function (req, res) {
  res.clearCookie("connect.sid");
  req.session.destroy();
  res.redirect("/users/signin");
});

module.exports = router;
