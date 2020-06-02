"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.resolvers = void 0;

var _User = require("./models/People/User");

var _Post = require("./models/Post");

var _Organizer = require("./models/Bussiness/Organizer");

var _OrganizerEvent = require("./models/Bussiness/OrganizerEvent");

var _graphql = require("graphql");

var _language = require("graphql/language");

function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

var resolvers = {
  Date: new _graphql.GraphQLScalarType({
    name: "Date",
    description: "Date custom scalar type",

    parseValue(value) {
      return new Date(value);
    },

    serialize(value) {
      return value;
    },

    parseLiteral(ast) {
      if (ast.kind === _language.Kind.INT) {
        return new Date(+ast.value);
      }

      return null;
    }

  }),
  Query: {
    getUser: function () {
      var _getUser = _asyncToGenerator(function* (_, _ref) {
        var {
          _user
        } = _ref;
        return yield _User.User.findById(_user).populate("friends").populate("enrolledEvents").populate("posts.usersWhoLiked");
      });

      function getUser(_x, _x2) {
        return _getUser.apply(this, arguments);
      }

      return getUser;
    }(),
    getUsers: function () {
      var _getUsers = _asyncToGenerator(function* () {
        return yield _User.User.find();
      });

      function getUsers() {
        return _getUsers.apply(this, arguments);
      }

      return getUsers;
    }(),
    getOrganizer: function () {
      var _getOrganizer = _asyncToGenerator(function* (_, _ref2) {
        var {
          _organizer
        } = _ref2;
        return yield _Organizer.Organizer.findById(_organizer).populate("events.usersEnrolled");
      });

      function getOrganizer(_x3, _x4) {
        return _getOrganizer.apply(this, arguments);
      }

      return getOrganizer;
    }()
  },
  Mutation: {
    createOrganizer: function () {
      var _createOrganizer = _asyncToGenerator(function* (_, _ref3) {
        var {
          name,
          description,
          imageUrl
        } = _ref3;
        var organizer = yield _Organizer.Organizer.create({
          name: name,
          description: description,
          imageUrl: imageUrl,
          posts: [],
          events: []
        });
        return organizer;
      });

      function createOrganizer(_x5, _x6) {
        return _createOrganizer.apply(this, arguments);
      }

      return createOrganizer;
    }(),
    createOrganizerPost: function () {
      var _createOrganizerPost = _asyncToGenerator(function* (_, _ref4) {
        var {
          _organizer,
          description
        } = _ref4;
        var post = new _Post.Post({
          date: new Date(),
          description: description,
          imageUrl: "www.images.com/".concat(_organizer),
          organizersWhoLiked: []
        });
        yield _Organizer.Organizer.findByIdAndUpdate({
          _id: _organizer
        }, {
          $push: {
            posts: post
          }
        }, {
          useFindAndModify: false
        });
        return post;
      });

      function createOrganizerPost(_x7, _x8) {
        return _createOrganizerPost.apply(this, arguments);
      }

      return createOrganizerPost;
    }(),
    createEvent: function () {
      var _createEvent = _asyncToGenerator(function* (_, _ref5) {
        var {
          _organizer,
          name,
          description,
          imagesUrls
        } = _ref5;
        var organizerEvent = new _OrganizerEvent.OrganizerEvent({
          name: name,
          description: description,
          imagesUrls: imagesUrls,
          usersEnrolled: []
        });
        yield _Organizer.Organizer.findByIdAndUpdate({
          _id: _organizer
        }, {
          $push: {
            events: organizerEvent
          }
        }, {
          useFindAndModify: false
        });
        return organizerEvent;
      });

      function createEvent(_x9, _x10) {
        return _createEvent.apply(this, arguments);
      }

      return createEvent;
    }(),
    createUser: function () {
      var _createUser = _asyncToGenerator(function* (_, _ref6) {
        var {
          name
        } = _ref6;
        var user = yield _User.User.create({
          name: name,
          posts: [],
          friends: [],
          enrolledEvents: []
        });
        return user;
      });

      function createUser(_x11, _x12) {
        return _createUser.apply(this, arguments);
      }

      return createUser;
    }(),
    createUserPost: function () {
      var _createUserPost = _asyncToGenerator(function* (_, _ref7) {
        var {
          _user,
          description
        } = _ref7;
        var post = new _Post.Post({
          date: new Date(),
          description: description,
          imageUrl: "www.images.com/".concat(_user),
          usersWhoLiked: []
        });
        yield _User.User.findByIdAndUpdate({
          _id: _user
        }, {
          $push: {
            posts: post
          }
        }, {
          useFindAndModify: false
        });
        return post;
      });

      function createUserPost(_x13, _x14) {
        return _createUserPost.apply(this, arguments);
      }

      return createUserPost;
    }(),
    addFriend: function () {
      var _addFriend = _asyncToGenerator(function* (_, _ref8) {
        var {
          _user,
          _friend
        } = _ref8;
        yield _User.User.findByIdAndUpdate({
          _id: _user
        }, {
          $push: {
            friends: _friend
          }
        }, {
          useFindAndModify: false
        });
        yield _User.User.findByIdAndUpdate({
          _id: _friend
        }, {
          $push: {
            friends: _user
          }
        }, {
          useFindAndModify: false
        });
        return true;
      });

      function addFriend(_x15, _x16) {
        return _addFriend.apply(this, arguments);
      }

      return addFriend;
    }(),
    enrollEvent: function () {
      var _enrollEvent = _asyncToGenerator(function* (_, _ref9) {
        var {
          _user,
          _event
        } = _ref9;
        yield _User.User.findByIdAndUpdate({
          _id: _user
        }, {
          $push: {
            enrolledEvents: _event
          }
        }, {
          useFindAndModify: false
        });
        yield _Organizer.Organizer.findOneAndUpdate({
          "events._id": _event
        }, {
          $push: {
            "events.$.usersEnrolled": _user
          }
        }, {
          useFindAndModify: false
        });
        return true;
      });

      function enrollEvent(_x17, _x18) {
        return _enrollEvent.apply(this, arguments);
      }

      return enrollEvent;
    }(),
    likeOrganizerPost: function () {
      var _likeOrganizerPost = _asyncToGenerator(function* (_, _ref10) {
        var {
          _user,
          _post
        } = _ref10;
        yield _Organizer.Organizer.findOneAndUpdate({
          "posts._id": _post
        }, {
          $push: {
            "posts.$.usersWhoLiked": _user
          }
        }, {
          useFindAndModify: false
        });
        return true;
      });

      function likeOrganizerPost(_x19, _x20) {
        return _likeOrganizerPost.apply(this, arguments);
      }

      return likeOrganizerPost;
    }(),
    likeUserPost: function () {
      var _likeUserPost = _asyncToGenerator(function* (_, _ref11) {
        var {
          _user,
          _post
        } = _ref11;
        yield _User.User.findOneAndUpdate({
          "posts._id": _post
        }, {
          $push: {
            "posts.$.usersWhoLiked": _user
          }
        }, {
          useFindAndModify: false
        });
        return true;
      });

      function likeUserPost(_x21, _x22) {
        return _likeUserPost.apply(this, arguments);
      }

      return likeUserPost;
    }()
  }
}; // getFriends: async (_, { _user }) =>
// await User.find({
//   _id: {
//     $in: User.findById(_user).friends,
//   },
// }),
// getUsersEnrolled: async (_, { _event }) =>
// await User.find({ enrolledEvents: _event })
// getUsersWhoLikedPost: async (_, { _post }) =>
// await User.find({
//   _id: {
//     $in: (await User.findOne({ "posts._id": _post })).posts.id(_post)
//       .usersWhoLiked,
//   },
// })

exports.resolvers = resolvers;
//# sourceMappingURL=resolvers.js.map