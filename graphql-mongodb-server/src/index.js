require("dotenv").config();

import { ApolloServer } from "apollo-server-express";
import express from "express";
import mongoose from "mongoose";
import { typeDefs } from "./typeDefs";
import { resolvers } from "./resolvers";

const startServer = async () => {
  const app = express();

  const server = new ApolloServer({
    typeDefs,
    resolvers,
  });

  server.applyMiddleware({ app });

  await mongoose.connect(
    `mongodb+srv://${process.env.DB_USER}:${process.env.DB_PASSWORD}@proyectodeglobales-rmjad.mongodb.net/db?retryWrites=true&w=majority`,
    {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    }
  );

  app.listen({ port: process.env.PORT || 3000 }, () =>
    console.log(`🚀 Server ready!`)
  );
};

startServer();
