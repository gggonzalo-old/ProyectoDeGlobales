"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.Organizer = void 0;

var _mongoose = _interopRequireDefault(require("mongoose"));

var _Post = require("../Post");

var _OrganizerEvent = require("./OrganizerEvent");

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

var Organizer = _mongoose.default.model("Organizer", {
  name: String,
  description: String,
  imageUrl: String,
  posts: [_Post.Post.schema],
  events: [_OrganizerEvent.OrganizerEvent.schema]
});

exports.Organizer = Organizer;
//# sourceMappingURL=Organizer.js.map