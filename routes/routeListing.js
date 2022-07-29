const express = require("express");
const router = express.Router();

const listing = require("../controllers/listing/listingController");

// @path: api/merchant/listing
// @Description: Create listing
router.post("/merchant/listing", (req, res) =>
    listing.createListing(req, res)
);

// @path: api/merchant/listing/upload
// @Description: Create listing
router.post("/merchant/listing/upload", (req, res) =>
    listing.uploadListingImages(req, res)
);

// @path: api/merchant/listing/623fea2e9fe8e253fd772601
// @Description: Get listings
router.get("/merchant/listing", (req, res) =>
    listing.getListings(req, res)
);

// @path: api/merchant/listing/623fea2e9fe8e253fd772601
// @Description: Delete listing
router.delete("/merchant/listing/:id", (req, res) =>
    listing.deleteListing(req, res)
);

module.exports = router;
