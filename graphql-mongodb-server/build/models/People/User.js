"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.User = void 0;

var _mongoose = _interopRequireDefault(require("mongoose"));

var _Post = require("../Post");

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

var User = _mongoose.default.model("User", {
  name: String,
  posts: [_Post.Post.schema],
  friends: [{
    type: _mongoose.default.Schema.Types.ObjectId,
    ref: "User"
  }],
  enrolledEvents: [{
    type: _mongoose.default.Schema.Types.ObjectId,
    ref: "OrganizerEvent"
  }]
});

exports.User = User;
//# sourceMappingURL=User.js.map