"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.Post = void 0;

var _mongoose = _interopRequireDefault(require("mongoose"));

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

var Post = _mongoose.default.model("Post", {
  date: Date,
  description: String,
  imageUrl: String,
  usersWhoLiked: [{
    type: _mongoose.default.Schema.Types.ObjectId,
    ref: "User"
  }]
});

exports.Post = Post;
//# sourceMappingURL=Post.js.map