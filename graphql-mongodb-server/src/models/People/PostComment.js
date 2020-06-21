import mongoose from "mongoose";

export const PostComment = mongoose.model(
  "PostComment",
  mongoose.Schema(
    {
      content: String,
      user: {
        type: String,
        ref: "User",
      },
      date: Date,
    },
    { _id: false }
  )
);
