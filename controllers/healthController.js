const sequelize = require('../connection');

const checkHealth = async (req, res) => {
  try {
    // Check database connectivity
    await sequelize.authenticate();
    console.log('Connection succeed!');
    res.status(200).header('Cache-Control', 'no-cache').send();
  } catch (error) {
    console.error('Database connection error:\n', error);
    res.status(503).header('Cache-Control', 'no-cache').send();
  }
};

module.exports = { checkHealth };
