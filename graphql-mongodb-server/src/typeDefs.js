import { gql } from "apollo-server-express";

export const typeDefs = gql`
  type Query {
    users: [User!]!
  }
  type User {
    name: String!
  }
  type Mutation {
    createUser(name: String!): User!
  }
`;
