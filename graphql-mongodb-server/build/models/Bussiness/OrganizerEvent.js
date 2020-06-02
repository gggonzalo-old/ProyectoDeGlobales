"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.OrganizerEvent = void 0;

var _mongoose = _interopRequireDefault(require("mongoose"));

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

var OrganizerEvent = _mongoose.default.model("OrganizerEvent", {
  name: String,
  description: String,
  imagesUrls: [String],
  usersEnrolled: [{
    type: _mongoose.default.Schema.Types.ObjectId,
    ref: "User"
  }]
}, "events");

exports.OrganizerEvent = OrganizerEvent;
//# sourceMappingURL=OrganizerEvent.js.map