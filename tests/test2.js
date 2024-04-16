const axios = require('axios');

async function runIntegrationTests() {
  try {
    // Update the account
    const updateUserResponse = await axios.put('http://127.0.0.1:8080/v2/user/self', {
      lastName: "updatedLastname",
      firstName: "updatedFirstname"
    }, {
      auth: {
        username: 'testuser',
        password: 'testpassword'
      }
    });

    // Ensure account update was successful
    if (updateUserResponse.status !== 200) {
      throw new Error('Failed to update user');
    }

    // Retrieve updated user data with basic authentication
    const getUserResponse = await axios.get('http://127.0.0.1:8080/v2/user/self', {
      auth: {
        username: 'testuser',
        password: 'testpassword'
      }
    });

    // Ensure user data retrieval was successful
    if (getUserResponse.status !== 200) {
      throw new Error('Failed to retrieve user data');
    }

    // Ensure account was updated
    const updatedUser = getUserResponse.data;
    if (updatedUser.lastName !== "updatedLastname" || updatedUser.firstName !== "updatedFirstname") {
      throw new Error('Account was not updated correctly');
    }

    console.log('Integration tests passed successfully');
  } catch (error) {
    console.error('Integration tests failed:', error.message);
    process.exit(1);
  }
}

runIntegrationTests();
