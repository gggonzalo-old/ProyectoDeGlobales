import mongoose from "mongoose";
import { PostComment } from "./PostComment";

export const Post = mongoose.model("Post", {
  date: Date,
  description: String,
  imageUrl: String,
  comments: [PostComment.schema],
  usersWhoLiked: [
    {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
    },
  ],
});
