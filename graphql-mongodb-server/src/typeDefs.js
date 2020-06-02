import { gql } from "apollo-server-express";

export const typeDefs = gql`
  scalar Date

  type Organizer {
    _id: String!
    name: String!
    description: String!
    imageUrl: String!
    posts: [Post!]!
    events: [OrganizerEvent!]!
  }
  type OrganizerEvent {
    _id: String!
    name: String!
    description: String!
    imagesUrls: [String!]!
    usersEnrolled: [User!]!
  }
  type User {
    _id: String!
    name: String!
    posts: [Post!]!
    friends: [User!]!
    enrolledEvents: [OrganizerEvent!]!
  }
  type Post {
    _id: String!
    date: Date!
    description: String!
    imageUrl: String!
    usersWhoLiked: [User!]!
  }

  type Query {
    getUser(_user: String!): User!
    getUsers: [User!]!
    getOrganizer(_organizer: String!): Organizer!
  }
  type Mutation {
    createOrganizer(
      name: String!
      description: String!
      imageUrl: String!
    ): Organizer!
    createOrganizerPost(_organizer: String!, description: String!): Post!
    createEvent(
      _organizer: String!
      name: String!
      description: String!
      imagesUrls: [String!]!
    ): OrganizerEvent!
    createUser(name: String!): User!
    createUserPost(_user: String!, description: String!): Post!
    addFriend(_user: String!, _friend: String!): Boolean
    enrollEvent(_user: String!, _event: String!): Boolean
    likeOrganizerPost(_user: String!, _post: String!): Boolean
    likeUserPost(_user: String!, _post: String!): Boolean
  }
`;
