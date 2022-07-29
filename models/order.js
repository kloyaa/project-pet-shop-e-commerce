const mongoose = require("mongoose");
const Schema = mongoose.Schema;

const enumOrderStatus = [
    "to-pack", 
    "packed", 
    "to-deliver", 
    "delivered"
];

const OrderSchema = new Schema({
    refNumber: {
        type: String,
        required: [true, "orderId is required"],
    },
    header: {
        customer: {
            accountId: {
                type: String,
                required: [true, "customer accountId is required"],
            },
            img: {
                type: String,
                required: [true, "customer img is required"],
            },
            firstName: {
                type: String,
                required: [true, "customer firstName is required"],
              },
            lastName: {
                type: String,
                required: [true, "customer lastName is required"],
            },
            contactNo: {
                type: String,
                required: [true, "customer contactNo is required"],
            },
            address: {
                type: String,
                required: [true, "customer address is required"],
            },
        },
        merchant: {
            accountId: {
                type: String,
                required: [true, "merchant accountId is required"],
            },
            img: {
                type: String,
                required: [true, "merchant img is required"],
            },
            name: {
                type: String,
                required: [true, "merchant name is required"],
            },
            contactNo: {
                type: String,
                required: [true, "merchant contactNo is required"],
            },
            address: {
                type: String,
                required: [true, "merchant address is required"],
            }
        },
    },
    content: {
        items: [], 
        total: {
            type: String,
            required: [true, "total is required"],
        }
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
    status: {
        type: String,
        required: [true, "status is required"],
        enum: enumOrderStatus,
    },
    estimatedDeliveryDateAndTime: {
        type: String,
        required: [true, "estimatedDeliveryDateAndTime is required"],
    }
});

//VALIDATE
//OrderSchema.path('content.addOns').validate((data) => data.length >= 1, 'Length must be >= 1');

module.exports = Order = mongoose.model("orders", OrderSchema);
