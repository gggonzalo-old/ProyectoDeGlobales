import mongoose from "mongoose";

export const Prize = mongoose.model("Prize", {
  name: String,
  description: String,
  cost: Number,
  imageURL: String,
  QRURL: String,
});
