const { Customer, Merchant, Rider } = require("../../models/profile");

const deleteProfile = async (req, res) => {
  try {
    const accountId = req.params.id;

    Customer.findOneAndRemove({ accountId });
    Merchant.findOneAndRemove({ accountId });
    Rider.findOneAndRemove({ accountId });

    return res.status(200).json({ message: "success" });
  } catch (error) {
    console.log(error);
  }
};

module.exports = {
  deleteProfile,
};
