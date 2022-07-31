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
      .catch(() => {});

    Merchant.findOneAndRemove({ accountId })
      .then((value) => {
        if (value != null) {
          return res.status(200).json({ message: "deleted" });
        }
      })
      .catch(() => {});

    Rider.findOneAndRemove({ accountId })
      .then((value) => {
        if (value != null) {
          return res.status(200).json({ message: "deleted" });
        }
      })
      .catch(() => {});

    return res.status(400).json({ message: "failed" });
  } catch (error) {
    console.log(error);
  }
};

module.exports = {
  deleteProfile,
};
