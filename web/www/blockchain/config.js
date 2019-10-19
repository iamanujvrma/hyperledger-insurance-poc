import { readFileSync } from "fs";
import { resolve } from "path";

const basePath = resolve(__dirname, "../../certs");
const readCryptoFile = filename =>
  readFileSync(resolve(basePath, filename)).toString();
const config = {
  isCloud: false,
  isUbuntu: false,
  channelName: "default",
  channelConfig: readFileSync(resolve(__dirname, "../../channel.tx")),
  chaincodeId: "bcins",
  chaincodeVersion: "v2",
  chaincodePath: "bcins",
  orderer0: {
    hostname: "orderer0",
    url: "grpcs://orderer0:7050",
    pem: readCryptoFile("ordererOrg.pem")
  },
  hdfcErgoOrg: {
    peer: {
      hostname: "hdfcergo-peer",
      url: "grpcs://hdfcergo-peer:7051",
      eventHubUrl: "grpcs://hdfcergo-peer:7053",
      pem: readCryptoFile("hdfcErgoOrg.pem")
    },
    ca: {
      hostname: "hdfcergo-ca",
      url: "https://hdfcergo-ca:7054",
      mspId: "HdfcErgoOrgMSP"
    },
    admin: {
      key: readCryptoFile("Admin@hdfcergo-org-key.pem"),
      cert: readCryptoFile("Admin@hdfcergo-org-cert.pem")
    }
  },
  tataAigOrg: {
    peer: {
      hostname: "tataaig-peer",
      url: "grpcs://tataaig-peer:7051",
      eventHubUrl: "grpcs://tataaig-peer:7053",
      pem: readCryptoFile("tataAigOrg.pem")
    },
    ca: {
      hostname: "tataaig-ca",
      url: "https://tataaig-ca:7054",
      mspId: "TataAigOrgMSP"
    },
    admin: {
      key: readCryptoFile("Admin@tataaig-org-key.pem"),
      cert: readCryptoFile("Admin@tataaig-org-cert.pem")
    }
  },
  iffcoOrg: {
    peer: {
      hostname: "iffco-peer",
      url: "grpcs://iffco-peer:7051",
      eventHubUrl: "grpcs://iffco-peer:7053",
      pem: readCryptoFile("iffcoOrg.pem")
    },
    ca: {
      hostname: "iffco-ca",
      url: "https://iffco-ca:7054",
      mspId: "IffcoOrgMSP"
    },
    admin: {
      key: readCryptoFile("Admin@iffco-org-key.pem"),
      cert: readCryptoFile("Admin@iffco-org-cert.pem")
    }
  },
  bajajOrg: {
    peer: {
      hostname: "bajaj-peer",
      url: "grpcs://bajaj-peer:7051",
      eventHubUrl: "grpcs://bajaj-peer:7053",
      pem: readCryptoFile("bajajOrg.pem")
    },
    ca: {
      hostname: "bajaj-ca",
      url: "https://bajaj-ca:7054",
      mspId: "BajajOrgMSP"
    },
    admin: {
      key: readCryptoFile("Admin@bajaj-org-key.pem"),
      cert: readCryptoFile("Admin@bajaj-org-cert.pem")
    }
  }
};

if (process.env.LOCALCONFIG) {
  config.orderer0.url = "grpcs://localhost:7050";

  config.hdfcErgoOrg.peer.url = "grpcs://localhost:7051";
  config.tataAigOrg.peer.url = "grpcs://localhost:8051";
  config.iffcoOrg.peer.url = "grpcs://localhost:9051";
  config.bajajOrg.peer.url = "grpcs://localhost:10051";

  config.hdfcErgoOrg.peer.eventHubUrl = "grpcs://localhost:7053";
  config.tataAigOrg.peer.eventHubUrl = "grpcs://localhost:8053";
  config.iffcoOrg.peer.eventHubUrl = "grpcs://localhost:9053";
  config.bajajOrg.peer.eventHubUrl = "grpcs://localhost:10053";

  config.hdfcErgoOrg.ca.url = "https://localhost:7054";
  config.tataAigOrg.ca.url = "https://localhost:8054";
  config.iffcoOrg.ca.url = "https://localhost:9054";
  config.bajajOrg.ca.url = "https://localhost:10054";
}

export default config;
