const os = require("os");
const util = require("util");
const path = require("path");

const userHostName = os.hostname();
const userHomeDir = os.homedir();
const userCore = os.cpus();
const userInfo = os.userInfo();

console.log(userInfo);
console.log(userHostName);
console.log(userHomeDir);
console.log(userCore);

