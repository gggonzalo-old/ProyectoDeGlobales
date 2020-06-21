require("dotenv").config();

import { ApolloServer } from "apollo-server-express";
import express from "express";
import mongoose from "mongoose";
import { typeDefs } from "./typeDefs";
import { resolvers } from "./resolvers";
import { OrganizerEvent } from "./models/Bussiness/OrganizerEvent";

const startServer = async () => {
  const app = express();

  const server = new ApolloServer({
    typeDefs,
    resolvers,
    introspection: true,
    playground: true,
  });

  server.applyMiddleware({ app });

  await mongoose.connect(
    `mongodb+srv://${process.env.DB_USER}:${process.env.DB_PASSWORD}@proyectodeglobales-rmjad.mongodb.net/db?retryWrites=true&w=majority`,
    {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    }
  );

  const db = mongoose.connection.db;
  const collections = {
    organizers: db.collection("organizers"),
    events: db.collection("events"),
    prizes: db.collection("prizes"),
  };

  collections.events.countDocuments((err, count) => {
    if (count == 0)
      collections.events.insertMany([
        {
          _id: "UNASepara",
          name: "Separación de residuos",
          description:
            "¡Ayudános a limpiar el medio ambiente mientras aprendés a clasificar residuos y conocés nuevos amigos!",
          date: new Date(),
          price: 1000,
          place: "Centro de acopio UNA",
          imageURL:
            "http://www.unasostenible.una.ac.cr/images/phocagallery/Centro-acopio-institucional-2013/Separacion-materiales.jpg",
          usersEnrolled: [],
          usersInterested: [],
        },
        {
          _id: "ManoAlPirro",
          name: "Dale una mano al Pirro",
          description: `Este mes se viene una Jornada de Limpieza de Río en el marco de la "3ra Limpieza Nacional por los Océanos" organizada por Naturenetic. Acompáñanos y dale vos también una mano al Río Pirro`,
          date: new Date(),
          price: 1000,
          place: "Río Pirro, Heredia",
          imageURL:
            "https://www.elmundo.cr/wp-content/uploads/2017/03/UNA-Heredia-Pirro-recuperar-rios-urbanos.jpg",
          usersEnrolled: [],
          usersInterested: [],
        },
        {
          _id: "FrenteAlCovid",
          name: "Ayuda a comunidades afectadas por el COVID-19",
          description:
            "En apoyo a las comunidades indígenas o afectadas por el COVID-19, nos comprometemos a comprar alimentos y llevarlos a los lugares necesitados.",
          date: new Date(),
          price: 1500,
          place:
            "Parque Polideportivo Aranjuez. Barrio Aranjuez, San José. De Iglesia Santa Teresita 300m Norte, 300m Oeste.",
          imageURL:
            "https://img.evbuc.com/https%3A%2F%2Fcdn.evbuc.com%2Fimages%2F101147302%2F307492173837%2F1%2Foriginal.20200516-161753?h=2000&w=720&auto=format%2Ccompress&q=75&sharp=10&s=ce125577ff5c593ef22b2205a1f05da9",
          usersEnrolled: [],
          usersInterested: [],
        },
      ]);
  });

  collections.organizers.countDocuments((err, count) => {
    if (count == 0)
      collections.organizers.insertMany([
        {
          name: "Sustainabelle",
          description:
            "Contribuir, mediante  todas nuestras actividades, a una eficiente gestión de los recursos que permita ayudar a la conservación de los mismos de manera que estén disponibles para las generaciones presentes y futura.",
          imageURL: "https://gansosbucket.s3.amazonaws.com/Sustainabelle.png",
          events: ["UNASepara"],
        },
        {
          name: "Naturenetic",
          description:
            "Contribuir a la conservación y manejo sostenible de los recursos naturales y del medio ambiente desde la justicia y solidaridad, participando en la ejecución y administración de proyectos estratégicos de desarrollo ambiental en el ámbito local y nacional.",
          imageURL: "https://gansosbucket.s3.amazonaws.com/Naturenetic.png",
          events: ["ManoAlPirro"],
        },
        {
          name: "Opportunate",
          description:
            "Promover el derecho de toda persona, en especial de la infancia y juventud, a disfrutar de una vida digna y plena en igualdad de oportunidades, partiendo del desarrollo integral de las capacidades individuales y colectivas como medio para transformar la sociedad y erradicar la pobreza.",
          imageURL: "https://gansosbucket.s3.amazonaws.com/Opportunate.png",
          events: ["FrenteAlCovid"],
        },
      ]);
  });

  collections.prizes.countDocuments((err, count) => {
    if (count == 0)
      collections.prizes.insertMany([
        {
          name: "GRANIGOLO - 2 shakes a escoger",
          description:
            "En POPS tenemos la mejor Milkshake, porque podés combinar tus 2 sabores de helado favoritos.",
          cost: 750,
          imageURL:
            "https://gansosbucket.s3.amazonaws.com/POPS+-+2+shakes+a+escoger.png",
          QRURL: "https://gansosbucket.s3.amazonaws.com/QR+1.png",
        },
        {
          name: "BISUTERÍA COSI - Kit de Keratina alisante brasileña",
          description: `- 1 unidad Acondicionador 40ml\n- 1 unidad Champú 40ml\n- 1 unidad Alisado Brasileño con aceite de jojoba 90ml\n- Medidas de la caja: 14,5cm x 7cm x 3,5cm\n- Peso: 225 gramos\n- Instrucciones de uso al dorso de la caja`,
          cost: 2000,
          imageURL:
            "https://gansosbucket.s3.amazonaws.com/Bisuter%C3%ADa+Cosi+-+Kit+de+Keratina+alisante+brasile%C3%B1a.jpg",
          QRURL: "https://gansosbucket.s3.amazonaws.com/QR+2.png",
        },
        {
          name: "VIKINGO'S PIZZA - Pizza Grande de 12 slices",
          description:
            "En Vikingo's pizza Tibás tenemos un sabor único y una gran variedad en nuestro menú, lasagnas espaguetis ensaladas calzone birkaflauta vikin roll y mucho más.",
          cost: 1250,
          imageURL:
            "https://gansosbucket.s3.amazonaws.com/VIKINGO'S+PIZZA+-+Pizza+Grande+de+12+slices.jpg",
          QRURL: "https://gansosbucket.s3.amazonaws.com/QR+3.png",
        },
      ]);
  });

  app.listen({ port: process.env.PORT || 3000 }, () =>
    console.log(`🚀 Server ready!`)
  );
};

startServer();
