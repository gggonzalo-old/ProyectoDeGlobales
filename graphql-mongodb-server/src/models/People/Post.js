import mongoose from "mongoose";
import { PostComment } from "./PostComment";

export const Post = mongoose.model("Post", {
  date: Date,
  description: String,
  imageURL: String,
  comments: [PostComment.schema],
  eventTag: String,
  verified: Boolean,
  usersWhoLiked: [
    {
      type: String,
      ref: "User",
    },
  ],
});
