"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.typeDefs = void 0;

var _apolloServerExpress = require("apollo-server-express");

function _templateObject() {
  var data = _taggedTemplateLiteral(["\n  scalar Date\n\n  type Organizer {\n    _id: String!\n    name: String!\n    description: String!\n    imageUrl: String!\n    posts: [Post!]!\n    events: [OrganizerEvent!]!\n  }\n  type OrganizerEvent {\n    _id: String!\n    name: String!\n    description: String!\n    imagesUrls: [String!]!\n    usersEnrolled: [User!]!\n  }\n  type User {\n    _id: String!\n    name: String!\n    posts: [Post!]!\n    friends: [User!]!\n    enrolledEvents: [OrganizerEvent!]!\n  }\n  type Post {\n    _id: String!\n    date: Date!\n    description: String!\n    imageUrl: String!\n    usersWhoLiked: [User!]!\n  }\n\n  type Query {\n    getUser(_user: String!): User!\n    getUsers: [User!]!\n    getOrganizer(_organizer: String!): Organizer!\n  }\n  type Mutation {\n    createOrganizer(\n      name: String!\n      description: String!\n      imageUrl: String!\n    ): Organizer!\n    createOrganizerPost(_organizer: String!, description: String!): Post!\n    createEvent(\n      _organizer: String!\n      name: String!\n      description: String!\n      imagesUrls: [String!]!\n    ): OrganizerEvent!\n    createUser(name: String!): User!\n    createUserPost(_user: String!, description: String!): Post!\n    addFriend(_user: String!, _friend: String!): Boolean\n    enrollEvent(_user: String!, _event: String!): Boolean\n    likeOrganizerPost(_user: String!, _post: String!): Boolean\n    likeUserPost(_user: String!, _post: String!): Boolean\n  }\n"]);

  _templateObject = function _templateObject() {
    return data;
  };

  return data;
}

function _taggedTemplateLiteral(strings, raw) { if (!raw) { raw = strings.slice(0); } return Object.freeze(Object.defineProperties(strings, { raw: { value: Object.freeze(raw) } })); }

var typeDefs = (0, _apolloServerExpress.gql)(_templateObject());
exports.typeDefs = typeDefs;
//# sourceMappingURL=typeDefs.js.map