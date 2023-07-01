const fs = require("fs");
const path = require("path");
const util = require("util");

//--------------------------
const text1 = fs.readFileSync(path.resolve("./src/README.md"), {
  encoding: "utf-8",
});

console.log("Sync file reading");
console.log(text1);

//-----------------------------
const text2 = fs.readFile(
  path.resolve("./src/README.md"),
  { encoding: "utf-8" },
  (error, data) => {
    if (error) {
      console.log("Error file reading");
    } else {
      console.log("Data:", data);
    }
  }
);
console.log("ASync file reading");
//--------------------------------

const readAsync = util.promisify(fs.readFileSync);

readAsync("./src/README.md", { encoding: "utf-8" })
  .then((data) => console.log(data))
  .catch((err) => console.log("Error file reading"));
