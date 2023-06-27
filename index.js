console.log('I am in index.js');

/*
require('./math');
require('./math');
require('./math');
require('./math');
require('./math');
*/

/*
const math = require('./math.js');

const res1 = math.sum(2,2);
console.log(res1);

const res2 = math.pow2(5);
console.log(res2);
*/

const {sum, sub} = require('./math.js');
const res3 = sum(5,6);
console.log(res3);


const _ = require('lodash');

console.log(_.sum([2,7,3,4,9,0,1,5]));

console.log(_.concat([10,20,30],[5,6,7,8]));

