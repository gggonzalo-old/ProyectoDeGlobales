"use strict";

var _apolloServerExpress = require("apollo-server-express");

var _express = _interopRequireDefault(require("express"));

var _mongoose = _interopRequireDefault(require("mongoose"));

var _typeDefs = require("./typeDefs");

var _resolvers = require("./resolvers");

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

require("dotenv").config();

var startServer = /*#__PURE__*/function () {
  var _ref = _asyncToGenerator(function* () {
    var app = (0, _express.default)();
    var server = new _apolloServerExpress.ApolloServer({
      typeDefs: _typeDefs.typeDefs,
      resolvers: _resolvers.resolvers
    });
    server.applyMiddleware({
      app
    });
    yield _mongoose.default.connect("mongodb+srv://".concat(process.env.DB_USER, ":").concat(process.env.DB_PASSWORD, "@proyectodeglobales-rmjad.mongodb.net/db?retryWrites=true&w=majority"), {
      useNewUrlParser: true,
      useUnifiedTopology: true
    });
    app.listen({
      port: process.env.PORT || 3000
    }, () => console.log("\uD83D\uDE80 Server ready!"));
  });

  return function startServer() {
    return _ref.apply(this, arguments);
  };
}();

startServer();
//# sourceMappingURL=index.js.map