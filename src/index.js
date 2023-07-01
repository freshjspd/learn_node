const greeting = require('./greeting.js');
//const {add, sub, div, mult} = require('./calc.js')
const calc = require('./calc.js')

const result = greeting('John', 'Smith');
console.log('RESULT:')
console.log(result);

console.log('CALC module');
console.log(calc);

console.log(calc.add(2,2));
console.log(calc.sub(2,2));
console.log(calc.div(2,2));
console.log(calc.mult(2,2));

const os = require('os');

const userInfo = os.userInfo();
console.log(userInfo);
console.log(os.machine);


