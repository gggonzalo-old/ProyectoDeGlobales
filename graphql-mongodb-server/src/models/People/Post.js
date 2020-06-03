import mongoose from "mongoose";

export const Post = mongoose.model("Post", {
  description: String,
  imageUrl: String,
});
