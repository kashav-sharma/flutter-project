const express = require('express');
const router = express.Router();
const authController = require('../controllers/authController');
const imageController = require('../controllers/imageController');
const contactController = require('../controllers/contactController');
const upload = require('../middleware/upload');

router.post('/register', authController.register);
router.post('/verify-otp', authController.verifyOTP);
router.post('/update-profile', authController.updateProfile);
router.post('/upload-image',upload.single('image'),imageController.imageUpload);
router.post('/check-contacts', contactController.checkContacts);

module.exports = router;


