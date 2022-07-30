const Checkout = require("../../models/checkout");
const { v4: uuidv4 } = require("uuid");

const createCheckout = async (req, res) => {
  try {
    req.body.refNumber = uuidv4().toUpperCase();
    return new Checkout(req.body)
      .save()
      .then((value) => res.status(200).json(value))
      .catch((err) => res.status(400).json(err.errors));
  } catch (error) {
    console.error(error);
  }
};

const getCheckouts = async (req, res) => {
  try {
    const { accountId, status } = req.query;

    return Checkout.find({ "header.customer.accountId": accountId, status })
      .sort({ "date.createdAt": "desc" }) // filter by date
      .select({ __v: 0 }) // Do not return _id and __v
      .then((value) => res.status(200).json(value))
      .catch((err) => res.status(400).json(err));
  } catch (error) {
    console.error(error);
  }
};

const merchantCheckouts = async (req, res) => {
  const { accountId, status } = req.query;

  return Checkout.find({ "header.merchant.accountId": accountId, status })
    .sort({ "date.createdAt": "asc" }) // filter by date
    .select({ __v: 0 }) // Do not return _id and __v
    .then((value) => res.status(200).json(value))
    .catch((err) => res.status(400).json(err));
};

const updateCheckoutStatus = async (req, res) => {
  const { refNumber, status } = req.body;
  try {
    Checkout.findOneAndUpdate(
      { refNumber },
      {
        $set: {
          status,
          "date.updatedAt": Date.now(),
        },
      },
      { runValidators: true, new: true }
    )
      .then((value) => {
        if (!value)
          return res.status(400).json({ message: "refNumber not found" });
        return res.status(200).json(value);
      })
      .catch((err) => res.status(400).json(err));
  } catch (error) {
    console.error(error);
  }
};

const deleteCheckout = async (req, res) => {
  try {
    const id = req.params.id;
    Checkout.findByIdAndDelete(id)
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
  createCheckout,
  getCheckouts,
  merchantCheckouts,
  updateCheckoutStatus,
  deleteCheckout,
};
