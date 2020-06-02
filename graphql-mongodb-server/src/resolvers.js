import { User } from "./models/People/User";
import { Post } from "./models/Post";
import { Organizer } from "./models/Bussiness/Organizer";
import { OrganizerEvent } from "./models/Bussiness/OrganizerEvent";
import { GraphQLScalarType } from "graphql";
import { Kind } from "graphql/language";

export const resolvers = {
  Date: new GraphQLScalarType({
    name: "Date",
    description: "Date custom scalar type",
    parseValue(value) {
      return new Date(value);
    },
    serialize(value) {
      return value;
    },
    parseLiteral(ast) {
      if (ast.kind === Kind.INT) {
        return new Date(+ast.value);
      }

      return null;
    },
  }),
  Query: {
    getUser: async (_, { _user }) =>
      await User.findById(_user)
        .populate("friends")
        .populate("enrolledEvents")
        .populate("posts.usersWhoLiked"),
    getUsers: async () => await User.find(),
    getOrganizer: async (_, { _organizer }) =>
      await Organizer.findById(_organizer).populate("events.usersEnrolled"),
  },
  Mutation: {
    createOrganizer: async (_, { name, description, imageUrl }) => {
      const organizer = await Organizer.create({
        name: name,
        description: description,
        imageUrl: imageUrl,
        posts: [],
        events: [],
      });

      return organizer;
    },
    createOrganizerPost: async (_, { _organizer, description }) => {
      const post = new Post({
        date: new Date(),
        description: description,
        imageUrl: `www.images.com/${_organizer}`,
        organizersWhoLiked: [],
      });

      await Organizer.findByIdAndUpdate(
        { _id: _organizer },
        { $push: { posts: post } },
        { useFindAndModify: false }
      );

      return post;
    },
    createEvent: async (_, { _organizer, name, description, imagesUrls }) => {
      const organizerEvent = new OrganizerEvent({
        name: name,
        description: description,
        imagesUrls: imagesUrls,
        usersEnrolled: [],
      });

      await Organizer.findByIdAndUpdate(
        { _id: _organizer },
        { $push: { events: organizerEvent } },
        { useFindAndModify: false }
      );

      return organizerEvent;
    },
    createUser: async (_, { name }) => {
      const user = await User.create({
        name: name,
        posts: [],
        friends: [],
        enrolledEvents: [],
      });

      return user;
    },
    createUserPost: async (_, { _user, description }) => {
      const post = new Post({
        date: new Date(),
        description: description,
        imageUrl: `www.images.com/${_user}`,
        usersWhoLiked: [],
      });

      await User.findByIdAndUpdate(
        { _id: _user },
        { $push: { posts: post } },
        { useFindAndModify: false }
      );

      return post;
    },
    addFriend: async (_, { _user, _friend }) => {
      await User.findByIdAndUpdate(
        { _id: _user },
        { $push: { friends: _friend } },
        { useFindAndModify: false }
      );
      await User.findByIdAndUpdate(
        { _id: _friend },
        { $push: { friends: _user } },
        { useFindAndModify: false }
      );

      return true;
    },
    enrollEvent: async (_, { _user, _event }) => {
      await User.findByIdAndUpdate(
        { _id: _user },
        { $push: { enrolledEvents: _event } },
        { useFindAndModify: false }
      );
      await Organizer.findOneAndUpdate(
        { "events._id": _event },
        { $push: { "events.$.usersEnrolled": _user } },
        { useFindAndModify: false }
      );

      return true;
    },
    likeOrganizerPost: async (_, { _user, _post }) => {
      await Organizer.findOneAndUpdate(
        { "posts._id": _post },
        { $push: { "posts.$.usersWhoLiked": _user } },
        { useFindAndModify: false }
      );

      return true;
    },
    likeUserPost: async (_, { _user, _post }) => {
      await User.findOneAndUpdate(
        { "posts._id": _post },
        { $push: { "posts.$.usersWhoLiked": _user } },
        { useFindAndModify: false }
      );

      return true;
    },
  },
};

// getFriends: async (_, { _user }) =>
// await User.find({
//   _id: {
//     $in: User.findById(_user).friends,
//   },
// }),

// getUsersEnrolled: async (_, { _event }) =>
// await User.find({ enrolledEvents: _event })

// getUsersWhoLikedPost: async (_, { _post }) =>
// await User.find({
//   _id: {
//     $in: (await User.findOne({ "posts._id": _post })).posts.id(_post)
//       .usersWhoLiked,
//   },
// })
