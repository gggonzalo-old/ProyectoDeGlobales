import mongoose from "mongoose";

export const Organizer = mongoose.model("Organizer", {
  name: String,
  description: String,
  imageUrl: String,
  events: [
    {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Event",
    },
  ],
});
