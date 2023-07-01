module.exports.add = (value1, value2) => {
    return value1 + value2;
};

module.exports.sub = (value1, value2) => {
    return value1 - value2;
};

module.exports.mult = (value1, value2) => {
    return value1 * value2;
};

module.exports.div = (value1, value2) => {
    return value1 / value2;
};

//-----------------------------

const calc = {
    add: function(a,b){ return a+b; },
    sub: function(a,b){ return a-b; },
    pow2: function(a) {return a ** 2;}
}

module.exports = calc;

// ---------------------------

module.exports = "Hello, Node.js!";

//-----------------------------

module.exports.str  = "Hello, Node.js";

//----------------------------

module.exports.anonUser = {
    login: 'anon',
    password: 'anon'
};