import { gql } from "apollo-server-express";

export const typeDefs = gql`
  type Organizer {
    _id: String!
    name: String!
    description: String!
    imageUrl: String!
    events: [String!]!
  }
  type Event {
    _id: String!
    name: String!
    description: String!
    imagesUrls: [String!]!
  }
  type User {
    _id: String!
    name: String!
    posts: [Post!]!
    friends: [String!]!
    enrolledEvents: [String!]!
  }
  type Post {
    _id: String!
    description: String!
    imageUrl: String!
  }
  type Query {
    getUserPosts(_user: String!): [Post!]!
    getUsers: [User!]!
  }
  type Mutation {
    createOrganizer(
      name: String!
      description: String!
      imageUrl: String!
    ): Organizer!
    createEvent(
      _organizer: String!
      name: String!
      description: String!
      imagesUrls: [String!]!
    ): Event!
    createUser(name: String!): User!
    createPost(_user: String!, description: String!): Post!
    addFriend(_user: String!, _friend: String!): Boolean
    enrollEvent(_user: String!, _event: String!): Boolean
  }
`;
