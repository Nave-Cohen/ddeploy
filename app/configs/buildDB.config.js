const fs = require("fs");
const path = require("path");
const util = require("util");
const exec = util.promisify(require("child_process").exec);

const scriptPath = path.join(__dirname, "init.sql");
const envPath = path.join(__dirname, "..", ".env");

function validateEnv() {
  return fs.existsSync(envPath);
}

function updateScript() {
  require("dotenv").config();

  const scriptSql = fs.readFileSync(scriptPath, "utf8");
  let scriptArray = scriptSql.split(/\r?\n/);
  scriptArray[0] = `CREATE DATABASE  IF NOT EXISTS \`${process.env.MYSQL_DATABASE}\` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;`;
  scriptArray[1] = `USE \`${process.env.MYSQL_DATABASE}\``;
  fs.writeFileSync(scriptPath, scriptArray.join("\r\n"));
}

async function buildDb() {
  const host = process.env.MYSQL_HOST;
  const user = process.env.MYSQL_USER;
  const command = `mysql -h ${host} -u ${user} -p < ${scriptPath}`;

  try {
    await exec(command);
    console.log(`${process.env.MYSQL_DATABASE} created successfully.`);
    return 0;
  } catch (error) {
    console.error(error.stderr);
    return 1;
  }
}

async function main() {
  if (validateEnv()) {
    updateScript();
    const status = await buildDb();
    process.exit(status);
  } else {
    console.error(".env file not found");
    process.exit(1);
  }
}

main();
