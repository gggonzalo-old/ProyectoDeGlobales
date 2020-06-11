import { gql } from "apollo-server-express";

export const typeDefs = gql`
  scalar Date

  type Organizer {
    _id: ID!
    name: String!
    description: String!
    imageUrl: String!
    posts: [Post!]!
    events: [OrganizerEvent!]!
  }
  type OrganizerEvent {
    _id: ID!
    name: String!
    description: String!
    date: Date!
    price: Int!
    imageUrl: String!
    usersEnrolled: [User!]!
  }
  type User {
    _id: ID!
    username: String!
    name: String!
    photoUrl: String!
    posts: [Post!]!
    friends: [User!]!
    enrolledEvents: [OrganizerEvent!]!
  }
  type PostComment {
    content: String!
    user: User!
    date: Date!
  }
  type Post {
    _id: ID!
    date: Date!
    description: String!
    imageUrl: String!
    comments: [PostComment!]!
    usersWhoLiked: [User!]!
  }

  type Query {
    user(_user: String!): User!
    users: [User!]!
    friendsPostsSorted(_user: String!): [Post!]!
    organizer(_organizer: String!): Organizer!
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
      date: Date!
      price: Int!
      imageUrl: String!
    ): OrganizerEvent!
    createUser(
      _id: ID!
      username: String!
      name: String!
      photoUrl: String!
    ): User!
    createUserPost(
      _user: String!
      description: String!
      imageUrl: String!
    ): Post!
    addFriend(_user: String!, _friend: String!): Boolean
    enrollEvent(_user: String!, _event: String!): Boolean
    likeOrganizerPost(_user: String!, _post: String!): Boolean
    likeUserPost(_user: String!, _post: String!): Boolean
    commentUserPost(_post: String!, _user: String!, content: String!): Boolean
  }
`;
