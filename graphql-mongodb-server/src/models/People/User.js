import mongoose from "mongoose";
import { Post } from "../Post";

export const User = mongoose.model("User", {
  name: String,
  posts: [Post.schema],
  friends: [
    {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
    },
  ],
  enrolledEvents: [
    {
      type: mongoose.Schema.Types.ObjectId,
      ref: "OrganizerEvent",
    },
  ],
});
