const fs = require("fs");

const contentDir = fs.readdirSync('.');

contentDir
  .filter(file => file.endsWith('.js'))
  .forEach(file =>
    fs.readFile(file, { encoding: 'utf-8' }, (err, data) => {
      if (err) { console.error(err); return; }
      console.log(data);
    })
  );





