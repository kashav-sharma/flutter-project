// controllers/contactController.js
const User = require('../models/User');

exports.checkContacts = async (req, res) => {
  try {
    const { phoneNumbers } = req.body;

    if (!phoneNumbers || !Array.isArray(phoneNumbers)) {
      return res.status(400).json({ error: "Invalid input" });
    }

    // Normalize phone numbers (remove leading 0s, country codes, etc. if needed)
    const cleanedNumbers = phoneNumbers.map(num => num.replace(/[^0-9]/g, ''));

    const users = await User.find({ phone: { $in: cleanedNumbers } })
      .select('name phone profileImage');

    res.status(200).json(users);
  } catch (err) {
    console.error('Error checking contacts:', err);
    res.status(500).json({ error: 'Server error' });
  }
};
