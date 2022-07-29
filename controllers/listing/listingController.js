const Listing = require("../../models/listing");
const cloudinary = require("../../services/img-upload/cloundinary");

const uploadListingImages = async (req, res) => {
    const filePath = req.file.path;
    const options = { 
        folder: process.env.CLOUDINARY_FOLDER + `/merchant/listings/${req.body.merchantName}`, 
        unique_filename: true
    };
    const uploadedImg = await cloudinary.uploader.upload(filePath, options);

    return res.status(200).json(uploadedImg);
}

const createListing = async (req, res) => {
    try {
        return new Listing(req.body)
            .save()
            .then((value) => res.status(200).json(value))
            .catch((err) => res.status(400).json(err.errors));
    } catch (error) {
        console.error(error);
    }
}

const getListings = async (req, res) => {
    try {
        const { accountId, availability } = req.query;
        try {
            console.log(accountId === undefined);
            console.log(accountId === null);

            if(accountId === undefined || accountId === null ) {
                return Listing
                    .find({ availability })
                    .sort({ _id: -1 })
                    .then((value) => res.status(200).json(value))
                    .catch((err) => res.status(400).json(err));
            }
            return Listing
                .find({ accountId, availability })
                .sort({ _id: -1 })
                .then((value) => res.status(200).json(value))
                .catch((err) => res.status(400).json(err));
            
        } catch (err) {
            return res.status(400).json(err);
        }
    } catch (error) {
        console.error(error);
    }
}

const deleteListing = async (req, res) => {
    try {
        const id = req.params.id;
        Listing.findByIdAndDelete(id)
            .then((value) => {
                if (!value) 
                    return res.status(400).json({ message: "_id not found" });
                return res.status(200).json({ message: "_id deleted"});
            })
            .catch((err) => res.status(400).json(err));
    } catch (error) {
        console.log(error);
    }
}

module.exports = {
    createListing,
    uploadListingImages,
    getListings,
    deleteListing
}
