require('dotenv').config();
const axios = require('axios');
const User = require('../models/User');
const generateOTP = require('../utils/generateOTP');
const jwt = require('jsonwebtoken');

const OTP_EXPIRY_MINUTES = 5;

exports.register = async (req, res) => {
  try {
    const { phone } = req.body;

    if (!phone) return res.status(400).json({ message: 'Phone number is required' });

    const otp = generateOTP();
    const otpExpires = new Date(Date.now() + OTP_EXPIRY_MINUTES * 60000);

    let user = await User.findOne({ phone });

    if (user) {
      user.otp = otp;
      user.otpExpires = otpExpires;
    } else {
      user = new User({ phone, otp, otpExpires });
    }

    await user.save();

    // ✅ Send OTP using 2Factor API
    const smsUrl = `https://2factor.in/API/V1/${process.env.TWOFACTOR_API_KEY}/SMS/${phone}/${otp}/OTP1`;

try {
  await axios.get(smsUrl);
} catch (e) {
  console.error('Error sending OTP:', e.message);
}


    res.status(200).json({ message: 'OTP sent to phone number' });
  } catch (err) {
    console.error('Registration error:', err.message);
    res.status(500).json({ message: 'Registration failed' });
  }
};

exports.verifyOTP = async (req, res) => {
  try {
    const { phone, otp } = req.body;

    if (!phone || !otp) {
      return res.status(400).json({ message: 'Phone and OTP are required' });
    }

    let user = await User.findOne({ phone });
    let isNewUser = false;

    // If user doesn't exist, create new
    if (!user) {
      user = new User({ phone, otp, otpExpires: new Date(Date.now() + 5 * 60 * 1000) });
      await user.save();
      isNewUser = true;
    }

    // OTP validation
    if (user.otp !== otp) {
      return res.status(400).json({ message: 'Invalid OTP' });
    }

    if (user.otpExpires < new Date()) {
      return res.status(400).json({ message: 'OTP expired' });
    }

    // Generate JWT
    const token = jwt.sign({ id: user._id }, process.env.JWT_SECRET, { expiresIn: '1d' });

    // Clear OTP
    user.otp = null;
    user.otpExpires = null;
    await user.save();

    // Respond with full info
    res.status(200).json({
      message: 'OTP verified successfully',
      token,
      userId: user._id,
      isNewUser,
    });
  } catch (err) {
    console.error('OTP verification error:', err.message);
    res.status(500).json({ message: 'OTP verification failed' });
  }
};

// Update user profile after OTP verification
exports.updateProfile = async (req, res) => {
  const { phone, name, profileImage } = req.body;

  if (!phone || !name) {
    return res.status(400).json({ message: 'Phone and name are required' });
  }

  try {
    const user = await User.findOne({ phone });

    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }

    // if (!user.isVerified) {
    //   return res.status(403).json({ message: 'User is not verified' });
    // }

    user.name = name;
    user.profileImage = profileImage; // can be a filename or URL
    await user.save();

    res.status(200).json({ message: 'Profile updated successfully', user });
  } catch (error) {
    console.error('Error updating profile:', error);
    res.status(500).json({ message: 'Server error' });
  }
};

