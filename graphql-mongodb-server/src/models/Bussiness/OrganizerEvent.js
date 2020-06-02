import mongoose from "mongoose";

export const OrganizerEvent = mongoose.model(
  "OrganizerEvent",
  {
    name: String,
    description: String,
    imagesUrls: [String],
    usersEnrolled: [
      {
        type: mongoose.Schema.Types.ObjectId,
        ref: "User",
      },
    ],
  },
  "events"
);
