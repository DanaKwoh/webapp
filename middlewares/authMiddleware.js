const basicAuth = require('basic-auth');
const User = require('../models/User');

const authenticateUser = async (req, res, next) => {
  try {
    const credentials = basicAuth(req);
    if (!credentials || !credentials.name || !credentials.pass) {
      return res.status(401).json({ error: 'Unauthorized: Missing credentials' });
    }

    // Find user by username
    const user = await User.findOne({ where: { username: credentials.name } });
    if (!user) {
      return res.status(401).json({ error: 'Unauthorized: User not found' });
    }

    // Check if password is correct
    const isPasswordValid = await user.validPWD(credentials.pass);
    if (!isPasswordValid) {
      return res.status(401).json({ error: 'Unauthorized: Incorrect password' });
    }

    // Set req.user with user information
    req.user = {
      id: user.id,
      username: user.username,
    };
    next();
  } catch (error) {
    console.error('Authentication error:', error);
    res.status(error.status).json({ error: error.message });
  }
};

module.exports = authenticateUser;

