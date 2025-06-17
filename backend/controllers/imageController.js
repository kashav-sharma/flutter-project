const User = require('../models/User');

exports.imageUpload = (req, res) => {
  if (!req.file) {
    return res.status(400).json({ message: 'No image uploaded' });
  }

  const imageUrl = `uploads/${req.file.filename}`;
  res.status(200).json({ imageUrl });
};
