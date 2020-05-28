import { User } from "./models/User";

export const resolvers = {
  Query: {
    users: () => User.find(),
  },
  Mutation: {
    createUser: async (_, { name }) => {
      const kitty = new User({ name: name });
      await kitty.save();
      console.log(kitty);
      return kitty;
    },
  },
};
