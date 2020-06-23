import mongoose from "mongoose";
import { Post } from "./Post";

export const User = mongoose.model("User", {
  _id: String,
  username: String,
  name: String,
  photoURL: String,
  points: Number,
  posts: [
    {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Post",
    },
  ],
  bookmarkedPosts: [
    {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Post",
    },
  ],
  prizesClaimed: [
    {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Prize",
    },
  ],
  eventTags: [String],
  friends: [
    {
      type: String,
      ref: "User",
    },
  ],
  enrolledEvents: [
    {
      type: String,
      ref: "OrganizerEvent",
    },
  ],
  attractiveEvents: [
    {
      type: String,
      ref: "OrganizerEvent",
    },
  ],
});
