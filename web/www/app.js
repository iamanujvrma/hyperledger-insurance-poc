"use strict";

import { Server } from "http";
import express from "express";
import socketIo from "socket.io";
import configureExpress from "./config/express";
import shopRouter, { wsConfig as shopWsConfig } from "./routers/shop.router";

import insuranceRouter, {
  wsConfig as insuranceWsConfig
} from "./routers/insurance.router";

const INSURER_URL = "/insurer";
const POLICY_HOLDER_URL = "/policyholder";

const app = express();
const httpServer = new Server(app);

// // Setup web sockets
// const io = socketIo(httpServer);
// shopWsConfig(io.of(SHOP_ROOT_URL));
// policeWsConfig(io.of(POLICE_ROOT_URL));
// repairShopWsConfig(io.of(REPAIR_SHOP_ROOT_URL));
// insuranceWsConfig(io.of(INSURANCE_ROOT_URL));

configureExpress(app);

app.get("/", (req, res) => {
  res.render("home", { homeActive: true });
});

// Setup routing
app.use(INSURER_URL, insur);
app.use(POLICE_ROOT_URL, policeRouter);


export default httpServer;
