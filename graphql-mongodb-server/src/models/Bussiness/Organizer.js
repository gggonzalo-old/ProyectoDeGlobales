import mongoose from "mongoose";

export const Organizer = mongoose.model("Organizer", {
  name: String,
  description: String,
  imageURL: String,
  events: [
    {
      type: String,
      ref: "OrganizerEvent",
    },
  ],
});
