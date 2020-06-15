import { User } from "./models/People/User";
import { Post } from "./models/Post";
import { Organizer } from "./models/Bussiness/Organizer";
import { OrganizerEvent } from "./models/Bussiness/OrganizerEvent";
import { GraphQLScalarType } from "graphql";
import mongoose from "mongoose";
import { Kind } from "graphql/language";
import { PostComment } from "./models/PostComment";

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
    user: async (_, { _user }) =>
      await User.findById(_user)
        .populate("friends")
        .populate("enrolledEvents")
        .populate("posts.usersWhoLiked")
        .populate("posts.comments.user"),
    users: async () =>
      await User.find()
        .populate("friends")
        .populate("enrolledEvents")
        .populate("posts.usersWhoLiked")
        .populate("posts.comments.user"),
    friendsPostsSorted: async (_, { _user }) => {
      console.log(
        await User.aggregate([
          { $match: { _id: { $in: (await User.findById(_user)).friends } } },
          { $unwind: "$posts" },
          {
            $group: {
              _id: null,
              friendsPosts: { $addToSet: "$posts" },
            },
          },
          {
            $project: {
              _id: 0,
              friendsPosts: 1,
            },
          },
          { $sort: { "friendsPosts.date": 1 } },
        ])
      );
    },
    organizer: async (_, { _organizer }) =>
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
        usersWhoLiked: [],
      });

      await Organizer.findByIdAndUpdate(
        { _id: _organizer },
        { $push: { posts: post } },
        { useFindAndModify: false }
      );

      return post;
    },
    createEvent: async (
      _,
      { _organizer, name, description, date, price, imageUrl }
    ) => {
      const organizerEvent = new OrganizerEvent({
        name: name,
        description: description,
        date: date ? date : new Date(),
        price: price,
        imageUrl: imageUrl,
        usersEnrolled: [],
      });

      await Organizer.findByIdAndUpdate(
        { _id: _organizer },
        { $push: { events: organizerEvent } },
        { useFindAndModify: false }
      );

      return organizerEvent;
    },
    createUser: async (_, { _id, username, name, photoUrl }) => {
      const user = await User.create({
        _id: _id,
        username: username,
        name: name,
        photoUrl: photoUrl,
        posts: [],
        friends: [],
        enrolledEvents: [],
      });

      return user;
    },
    createUserPost: async (_, { _user, description, imageUrl }) => {
      const post = new Post({
        date: new Date(),
        description: description,
        imageUrl: imageUrl,
        comments: [],
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
    commentUserPost: async (_, { _post, _user, content }) => {
      await User.findOneAndUpdate(
        { "posts._id": _post },
        {
          $push: {
            "posts.$.comments": new PostComment({
              content: content,
              user: _user,
              date: new Date(),
            }),
          },
        },
        { useFindAndModify: false }
      );

      return true;
    },
  },
};

// friends: async (_, { _user }) =>
// await User.find({
//   _id: {
//     $in: User.findById(_user).friends,
//   },
// }),

// usersEnrolled: async (_, { _event }) =>
// await User.find({ enrolledEvents: _event })

// usersWhoLikedPost: async (_, { _post }) =>
// await User.find({
//   _id: {
//     $in: (await User.findOne({ "posts._id": _post })).posts.id(_post)
//       .usersWhoLiked,
//   },
// })
