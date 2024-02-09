const express = require('express');
const router = express.Router();
const checkHealthMiddleware = require('../middlewares/checkHealthMiddleware');
const healthController = require('../controllers/healthController');

router.get('/', checkHealthMiddleware, healthController.checkHealth);

module.exports = router;
