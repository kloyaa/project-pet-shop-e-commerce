const mongoose = require("mongoose");
const Schema = mongoose.Schema;

const ListingSchema = new Schema({
    accountId: {
        type: String,
        required: [true, "accountId is required"],
    },
    title: {
        type: String,
        required: [true, "title is required"],
    },
    description: {
        type: String,
        required: [true, "description is required"],
    },
    images: [],
    price: {
        type: String,
        required: [true, "price is required"],
    },
    date: {
        createdAt: {
            type: Date,
            default: Date.now,
        },
        updatedAt: {
            type: Date,
        },
    },
    stocksQuantity: {
        type: String,
        required: [true, "stocksQuantity is required"],
    },
    availability: {
        type: Boolean,
        required: [true, "availability is required"],
    },
});

module.exports = Listing = mongoose.model("listings", ListingSchema);
