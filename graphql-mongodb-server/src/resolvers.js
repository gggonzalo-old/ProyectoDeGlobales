import { User } from "./models/People/User";
import { Post } from "./models/People/Post";
import { Organizer } from "./models/Bussiness/Organizer";
import { OrganizerEvent } from "./models/Bussiness/OrganizerEvent";

export const resolvers = {
  Query: {
    getUsers: () => User.find(),
    getUserPosts: async (_, { _user }) =>
      await (_user ? User.findById(_user) : User.findOne()).posts,
  },
  Mutation: {
    createOrganizer: async (_, { name, description, imageUrl }) => {
      const organizer = new Organizer({
        name: name,
        description: description,
        imageUrl: imageUrl,
        events: [],
      });
      await organizer.save();

      return organizer;
    },
    createEvent: async (_, { _organizer, name, description, imagesUrls }) => {
      const organizer = await (_organizer
        ? Organizer.findById(_organizer)
        : Organizer.findOne());
      const event = new OrganizerEvent({
        name: name,
        description: description,
        imagesUrls: imagesUrls,
      });

      await event.save();
      organizer.events.push(event._id);
      await organizer.save();

      return event;
    },
    createUser: async (_, { name }) => {
      const user = new User({
        name: name,
        posts: [],
        friends: [],
        enrolledEvents: [],
      });
      await user.save();

      return user;
    },
    createPost: async (_, { _user, description }) => {
      const user = await User.findById(_user);
      const post = new Post({
        description: description,
        imageUrl: `www.images.com/${_user}`,
      });

      user.posts.push(post);
      await user.save();

      return post;
    },
    addFriend: async (_, { _user, _friend }) => {
      const user = await User.findById(_user);
      const friend = await User.findById(_friend);

      if (!user || !friend) return false;

      user.friends.push(_friend);
      await user.save();
      friend.friends.push(_user);
      await friend.save();

      return true;
    },
    enrollEvent: async (_, { _user, _event }) => {
      const user = await User.findById(_user);

      if (!user) return false;

      user.enrolledEvents.push(_event);
      await user.save();

      return true;
    },
  },
};
