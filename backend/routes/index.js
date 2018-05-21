const express = require('express');
const crypto = require('crypto');
const os = require('os');

var router = express.Router();

router.use(function (req, res, next) {
    res.header('Cache-Control', 'private, no-cache, no-store, must-revalidate');
    res.header('Expires', '-1');
    res.header('Pragma', 'no-cache');
    next();
});

router.get('/', function (req, res, next) {
    return res.jsonp({status: 'OK', server: os.hostname()});
});

router.get('/random', function (req, res, next) {

    var randomBytes = Buffer.from(crypto.randomBytes(1024));
    return res.jsonp({random: randomBytes.toString('hex'), server: os.hostname()});
});

module.exports = router;
