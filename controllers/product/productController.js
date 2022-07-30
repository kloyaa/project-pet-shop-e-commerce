const Product = require("../../models/product");
const cloudinary = require("../../services/img-upload/cloundinary");

const uploadProductImages = async (req, res) => {
  const filePath = req.file.path;
  const options = {
    folder:
      process.env.CLOUDINARY_FOLDER +
      `/merchant/products/${req.body.merchantName}`,
    unique_filename: true,
  };
  const uploadedImg = await cloudinary.uploader.upload(filePath, options);

  return res.status(200).json(uploadedImg);
};

const createProduct = async (req, res) => {
  try {
    return new Product(req.body)
      .save()
      .then((value) => res.status(200).json(value))
      .catch((err) => res.status(400).json(err.errors));
  } catch (error) {
    console.error(error);
  }
};

const getProducts = async (req, res) => {
  try {
    const { accountId, availability } = req.query;
    try {
      return Product.find({ accountId, availability })
        .sort({ _id: -1 })
        .then((value) => res.status(200).json(value))
        .catch((err) => res.status(400).json(err));
    } catch (err) {
      return res.status(400).json(err);
    }
  } catch (error) {
    console.error(error);
  }
};
const getAllProducts = async (req, res) => {
  try {
    try {
      return Product.find()
        .sort({ _id: -1 })
        .then((value) => res.status(200).json(value))
        .catch((err) => res.status(400).json(err));
    } catch (err) {
      return res.status(400).json(err);
    }
  } catch (error) {
    console.error(error);
  }
};
const deleteProduct = async (req, res) => {
  try {
    const id = req.params.id;
    Product.findByIdAndDelete(id)
      .then((value) => {
        if (!value) return res.status(400).json({ message: "_id not found" });
        return res.status(200).json({ message: "_id deleted" });
      })
      .catch((err) => res.status(400).json(err));
  } catch (error) {
    console.log(error);
  }
};

module.exports = {
  createProduct,
  uploadProductImages,
  getProducts,
  getAllProducts,
  deleteProduct,
};
