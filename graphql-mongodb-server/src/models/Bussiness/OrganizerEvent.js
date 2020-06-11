import mongoose from "mongoose";

export const OrganizerEvent = mongoose.model(
  "OrganizerEvent",
  {
    name: String,
    description: String,
    date: Date,
    price: Number,
    imageUrl: String,
    usersEnrolled: [
      {
        type: mongoose.Schema.Types.ObjectId,
        ref: "User",
      },
    ],
  },
  "events"
);
