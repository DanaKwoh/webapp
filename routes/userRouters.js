// Add router
const express = require('express')
const router = express.Router()
const authenticateUser = require('../middlewares/authMiddleware');
const UserController = require('../controllers/userController');

router.post('/self', UserController.createUser);
router.put('/self', authenticateUser, UserController.updateUser);
router.get('/self', authenticateUser, UserController.getUser);

module.exports = router;