import mongoose from "mongoose";

export const OrganizerEvent = mongoose.model(
  "OrganizerEvent",
  {
    _id: String,
    name: String,
    description: String,
    date: Date,
    price: Number,
    place: String,
    imageURL: String,
    usersEnrolled: [
      {
        type: String,
        ref: "User",
      },
    ],
    usersInterested: [
      {
        type: String,
        ref: "User",
      },
    ],
  },
  "events"
);
