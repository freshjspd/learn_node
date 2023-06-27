const fs = require("fs");

const data = fs.readFileSync('./readme.md', {
    encoding: 'utf8'
});

console.log(data);
