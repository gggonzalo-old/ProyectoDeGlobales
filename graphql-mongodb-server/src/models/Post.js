import mongoose from "mongoose";

export const Post = mongoose.model("Post", {
  date: Date,
  description: String,
  imageUrl: String,
  usersWhoLiked: [
    {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
    },
  ],
});
