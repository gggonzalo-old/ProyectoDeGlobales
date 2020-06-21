import { User } from "./models/People/User";
import { Post } from "./models/People/Post";
import { Organizer } from "./models/Bussiness/Organizer";
import { Prize } from "./models/App/Prize";
import { GraphQLScalarType } from "graphql";
import { Kind } from "graphql/language";
import { PostComment } from "./models/People/PostComment";
import { OrganizerEvent } from "./models/Bussiness/OrganizerEvent";

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
    event: async (_, { _event }) => {
      const organizer = await Organizer.findOne({
        "events._id": _event,
      }).lean();

      const event = await OrganizerEvent.findById(_event)
        .populate("usersEnrolled")
        .populate("usersInterested")
        .lean();

      return new Object({
        ...event,
        owner: organizer,
      });
    },
    events: async (_, { filter }) => {
      const query = await OrganizerEvent.aggregate([]);

      console.log(query);

      // const query = await Organizer.aggregate([
      //   { $unwind: "$events" },
      //   {
      //     $lookup: {
      //       from: "users",
      //       localField: "events.usersEnrolled",
      //       foreignField: "_id",
      //       as: "events.usersEnrolled",
      //     },
      //   },
      //   {
      //     $lookup: {
      //       from: "users",
      //       localField: "events.usersInterested",
      //       foreignField: "_id",
      //       as: "events.usersInterested",
      //     },
      //   },
      //   {
      //     $match: {
      //       "events.name": { $regex: ".*" + filter + ".*", $options: "i" },
      //     },
      //   },
      //   {
      //     $group: {
      //       _id: null,
      //       events: { $addToSet: "$events" },
      //     },
      //   },
      //   { $project: { _id: 0, events: 1 } },
      // ]);

      return query.length > 0
        ? query[0]["events"]
            .sort(
              (e1, e2) =>
                new Date(e1.date).getTime() - new Date(e2.date).getTime()
            )
            .map(
              async (event) =>
                new Object({
                  ...event,
                  owner: await Organizer.findOne({ "events._id": event._id }),
                })
            )
        : [];
    },
    post: async (_, { _post }) => {
      const user = await User.findOne({ "posts._id": _post })
        .populate("posts.usersWhoLiked")
        .populate("posts.comments.user")
        .lean();
      const post = user.posts.find((post) => post._id == _post);

      return new Object({
        ...post,
        owner: user,
      });
    },
    posts: async (_, { eventTag }) => {
      const query = await User.aggregate([
        { $unwind: "$posts" },
        { $match: { "posts.eventTag": eventTag } },
        {
          $group: {
            _id: null,
            posts: { $addToSet: "$posts" },
          },
        },
        { $project: { _id: 0, posts: 1 } },
      ]);

      return query.length > 0
        ? query[0]["posts"].map(
            async (post) =>
              new Object({
                ...post,
                owner: await User.findOne({ "posts._id": post._id }),
              })
          )
        : [];
    },
    user: async (_, { _user }) => {
      console.log(
        await User.findById(_user)
          .populate({
            path: "friends",
            populate: {
              path: "posts",
              populate: {
                path: "usersWhoLiked",
              },
            },
          })
          .populate("enrolledEvents")
          .populate("attractiveEvents")
          .populate({
            path: "posts",
            populate: {
              path: "usersWhoLiked",
            },
          })
          .populate("posts.comments.user")
      );

      return await User.findById(_user)
        .populate({
          path: "friends",
          populate: {
            path: "posts",
            populate: {
              path: "usersWhoLiked",
            },
          },
        })
        .populate("enrolledEvents")
        .populate("attractiveEvents")
        .populate({
          path: "posts",
          populate: {
            path: "usersWhoLiked",
          },
        })
        .populate("posts.comments.user");
    },
    users: async (_, { _user, filter }) => {
      const userFriends = (await User.findById(_user)).friends;

      return (
        await User.find({
          _id: { $ne: _user },
          $or: [
            { username: { $regex: ".*" + filter + ".*", $options: "i" } },
            { name: { $regex: ".*" + filter + ".*", $options: "i" } },
          ],
        })
          .populate("friends")
          .populate("enrolledEvents")
          .populate("attractiveEvents")
          .populate({
            path: "posts",
            populate: {
              path: "usersWhoLiked",
            },
          })
          .populate("posts.comments.user")
          .lean()
      )
        .map(
          (friend) =>
            new Object({
              ...friend,
              isFriend: userFriends.some((friendId) => friendId === friend._id),
            })
        )
        .sort((user) => (user.isFriend ? -1 : 1));
    },
    organizer: async (_, { _organizer }) =>
      await Organizer.findById(_organizer)
        .populate("events.usersEnrolled")
        .populate("events.usersInterested"),
    prizes: async (_, { filter }) =>
      (
        await Prize.find({
          name: { $regex: ".*" + filter + ".*", $options: "i" },
        }).lean()
      ).sort((p1, p2) => p1.cost - p2.cost),
  },
  Mutation: {
    createUser: async (_, { _id, username, name, photoURL }) => {
      const user = await User.create({
        _id: _id,
        username: username,
        name: name,
        photoURL: photoURL,
        points: 0,
        posts: [],
        prizesClaimed: [],
        eventTags: [],
        friends: [],
        enrolledEvents: [],
        attractiveEvents: [],
      });

      return user;
    },
    createUserPost: async (_, { _user, description, eventTag, imageURL }) => {
      const post = new Post({
        date: new Date(),
        description: description,
        imageURL: imageURL,
        eventTag: eventTag,
        verified: false,
        comments: [],
        usersWhoLiked: [],
      });

      await User.findByIdAndUpdate(
        { _id: _user },
        { $push: { posts: post }, $pull: { eventTags: eventTag } },
        { useFindAndModify: false }
      );

      return true;
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
    toggleEventEnrollment: async (_, { _user, _event }) => {
      const event = (
        await Organizer.findOne({ "events._id": _event })
      ).events.id(_event);

      if (event.usersEnrolled.some((userId) => userId === _user)) {
        await User.findByIdAndUpdate(
          { _id: _user },
          { $pull: { enrolledEvents: _event, eventTags: event._id } },
          { useFindAndModify: false }
        );
        await Organizer.findOneAndUpdate(
          { "events._id": _event },
          { $pull: { "events.$.usersEnrolled": _user } },
          { useFindAndModify: false }
        );
      } else {
        await User.findByIdAndUpdate(
          { _id: _user },
          { $push: { enrolledEvents: _event, eventTags: event._id } },
          { useFindAndModify: false }
        );
        await Organizer.findOneAndUpdate(
          { "events._id": _event },
          { $push: { "events.$.usersEnrolled": _user } },
          { useFindAndModify: false }
        );
      }

      return true;
    },
    toggleEventInInterested: async (_, { _user, _event }) => {
      const event = (
        await Organizer.findOne({ "events._id": _event })
      ).events.id(_event);

      if (event.usersInterested.some((userId) => userId === _user)) {
        await User.findByIdAndUpdate(
          { _id: _user },
          { $pull: { attractiveEvents: _event } },
          { useFindAndModify: false }
        );
        await Organizer.findOneAndUpdate(
          { "events._id": _event },
          { $pull: { "events.$.usersInterested": _user } },
          { useFindAndModify: false }
        );
      } else {
        await User.findByIdAndUpdate(
          { _id: _user },
          { $push: { attractiveEvents: _event } },
          { useFindAndModify: false }
        );
        await Organizer.findOneAndUpdate(
          { "events._id": _event },
          { $push: { "events.$.usersInterested": _user } },
          { useFindAndModify: false }
        );
      }

      return true;
    },
    toggleUserPostLike: async (_, { _user, _post }) => {
      const post = (await User.findOne({ "posts._id": _post })).posts.id(_post);

      if (post.usersWhoLiked.some((userId) => userId === _user))
        await User.findOneAndUpdate(
          { "posts._id": _post },
          { $pull: { "posts.$.usersWhoLiked": _user } },
          { useFindAndModify: false }
        );
      else
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
    claimPrize: async (_, { _prize, _user }) => {
      const prizeCost = (await Prize.findById(_prize)).cost;
      const user = await User.findById(_user);

      if (user.points >= prizeCost) {
        await User.findByIdAndUpdate(
          _user,
          {
            $push: {
              prizesClaimed: _prize,
            },
            $inc: {
              points: -prizeCost,
            },
          },
          { useFindAndModify: false }
        );

        return true;
      }

      return false;
    },

    verifyPost: async (_, { _post }) => {
      const user = await User.findOne({ "posts._id": _post });
      const eventTag = user.posts.id(_post).eventTag;
      const event = (
        await Organizer.findOne({
          "events._id": eventTag,
        })
      ).events.id(eventTag);

      await User.findOneAndUpdate(
        { "posts._id": _post },
        {
          $set: { "posts.$.verified": true },
          $inc: {
            points: Math.floor(event.price * 0.25),
          },
        },
        {
          useFindAndModify: false,
        }
      );

      return true;
    },
  },
};
