import { gql } from "apollo-server-express";

export const typeDefs = gql`
  scalar Date

  type Organizer {
    _id: ID!
    name: String!
    description: String!
    imageURL: String!
    events: [OrganizerEvent!]!
  }
  type OrganizerEvent {
    _id: ID!
    name: String!
    description: String!
    date: Date!
    price: Int!
    place: String!
    imageURL: String!
    usersEnrolled: [User!]!
    usersInterested: [User!]!
    owner: Organizer
  }
  type User {
    _id: ID!
    username: String!
    name: String!
    photoURL: String!
    posts: [Post!]!
    prizesClaimed: [Prize!]!
    eventTags: [String!]!
    friends: [User!]!
    enrolledEvents: [OrganizerEvent!]!
    attractiveEvents: [OrganizerEvent!]!
    isFriend: Boolean
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
    imageURL: String!
    eventTag: String!
    verified: Boolean!
    comments: [PostComment!]!
    usersWhoLiked: [User!]!
    owner: User
  }
  type Prize {
    _id: ID!
    name: String!
    description: String!
    cost: Int!
    imageURL: String!
    QRURL: String!
  }

  type Query {
    event(_event: String!): OrganizerEvent!
    events(filter: String!): [OrganizerEvent!]!
    post(_post: String!): Post!
    posts(eventTag: String!): [Post!]!
    user(_user: String!): User!
    users(_user: String!, filter: String!): [User!]!
    organizer(_organizer: String!): Organizer!
    prizes(filter: String!): [Prize!]!
  }
  type Mutation {
    createUser(
      _id: ID!
      username: String!
      name: String!
      photoURL: String!
    ): User!
    createUserPost(
      _user: String!
      description: String!
      eventTag: String!
      imageURL: String!
    ): Boolean
    addFriend(_user: String!, _friend: String!): Boolean
    toggleEventEnrollment(_user: String!, _event: String!): Boolean
    toggleEventInInterested(_user: String!, _event: String!): Boolean
    toggleUserPostLike(_user: String!, _post: String!): Boolean
    commentUserPost(_post: String!, _user: String!, content: String!): Boolean
    claimPrize(_prize: String!, _user: String!): Boolean

    verifyPost(_post: String!): Boolean
  }
`;
