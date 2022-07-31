const { Customer, Merchant, Rider } = require("../../models/profile");

const deleteProfile = async (req, res) => {
  try {
    const accountId = req.params.id;

    Customer.findOneAndRemove({ accountId })
      .then((value) => {
        if (value != null) {
          return res.status(200).json({ message: "deleted" });
        }
      })
      .catch((err) => res.status(400).json(err));

    Merchant.findOneAndRemove({ accountId })
      .then((value) => {
        if (value != null) {
          return res.status(200).json({ message: "deleted" });
        }
      })
      .catch((err) => res.status(400).json(err));

    Rider.findOneAndRemove({ accountId })
      .then((value) => {
        if (value != null) {
          return res.status(200).json({ message: "deleted" });
        }
      })
      .catch((err) => res.status(400).json(err));
  } catch (error) {
    console.log(error);
  }
};

module.exports = {
  deleteProfile,
};
