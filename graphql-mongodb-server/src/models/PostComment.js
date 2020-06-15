import mongoose from "mongoose";

export const PostComment = mongoose.model(
  "PostComment",
  mongoose.Schema(
    {
      content: String,
      user: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "User",
      },
      date: Date,
    },
    { _id: false }
  )
);
