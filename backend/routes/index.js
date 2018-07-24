const express = require('express');
const crypto = require('crypto');
const os = require('os');
const fs = require('fs');
const path = require('path');
const _ = require('lodash');

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


var facts = fs.readFileSync(fs.openSync(path.resolve(process.cwd(), 'static', 'chuck_norris.txt'), 'r'), {encoding: 'utf8'});

facts = facts.split(/[\r\n]+/);

router.get('/random', function (req, res, next) {
    return res.jsonp({random: _.sample(facts), server:os.hostname()});
});

module.exports = router;
