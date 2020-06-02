import mongoose from "mongoose";
import { Post } from "../Post";
import { OrganizerEvent } from "./OrganizerEvent";

export const Organizer = mongoose.model("Organizer", {
  name: String,
  description: String,
  imageUrl: String,
  posts: [Post.schema],
  events: [OrganizerEvent.schema],
});
