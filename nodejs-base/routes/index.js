const express = require('express');
var crypto = require("crypto");


var router = express.Router();

router.get('/', function (req, res, next) {
    return res.jsonp({status: 'OK'});
});

router.get('/random', function (req, res, next) {
    var randomBytes = Buffer.from(crypto.randomBytes(1024));
    return res.jsonp({random: randomBytes.toString('hex')});
});

module.exports = router;
