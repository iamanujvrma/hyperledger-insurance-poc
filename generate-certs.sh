#!/bin/sh
set -e

echo
echo "#################################################################"
echo "#######        Generating cryptographic material       ##########"
echo "#################################################################"
PROJPATH=$(pwd)
CLIPATH=$PROJPATH/cli/peers
ORDERERS=$CLIPATH/ordererOrganizations
PEERS=$CLIPATH/peerOrganizations

rm -rf $CLIPATH
$PROJPATH/cryptogen generate --config=$PROJPATH/crypto-config.yaml --output=$CLIPATH

sh generate-cfgtx.sh

rm -rf $PROJPATH/{orderer,hdfcErgoPeer,tataAigPeer,bajajPeer,iffcoPeer}/crypto
mkdir $PROJPATH/{orderer,hdfcErgoPeer,tataAigPeer,bajajPeer,iffcoPeer}/crypto
cp -r $ORDERERS/orderer-org/orderers/orderer0/{msp,tls} $PROJPATH/orderer/crypto
cp -r $PEERS/hdfcergo-org/peers/hdfcergo-peer/{msp,tls} $PROJPATH/hdfcErgoPeer/crypto
cp -r $PEERS/tataaig-org/peers/tataaig-peer/{msp,tls} $PROJPATH/tataAigPeer/crypto
cp -r $PEERS/bajaj-org/peers/bajaj-peer/{msp,tls} $PROJPATH/bajajPeer/crypto
cp -r $PEERS/iffco-org/peers/iffco-peer/{msp,tls} $PROJPATH/iffcoPeer/crypto
cp $CLIPATH/genesis.block $PROJPATH/orderer/crypto/

HDFCERGOCAPATH=$PROJPATH/hdfcErgoCA
TATAAIGCAPATH=$PROJPATH/tataAigCA
BAJAJCAPATH=$PROJPATH/bajajCA
IFFCOCAPATH=$PROJPATH/iffcoCA

rm -rf {$HDFCERGOCAPATH,$TATAAIGCAPATH,$BAJAJCAPATH,$IFFCOCAPATH}/{ca,tls}
mkdir -p {$HDFCERGOCAPATH,$TATAAIGCAPATH,$BAJAJCAPATH,$IFFCOCAPATH}/{ca,tls}
cp $PEERS/hdfcergo-org/ca/* $HDFCERGOCAPATH/ca
cp $PEERS/hdfcergo-org/tlsca/* $HDFCERGOCAPATH/tls
mv $HDFCERGOCAPATH/ca/*_sk $HDFCERGOCAPATH/ca/key.pem
mv $HDFCERGOCAPATH/ca/*-cert.pem $HDFCERGOCAPATH/ca/cert.pem
mv $HDFCERGOCAPATH/tls/*_sk $HDFCERGOCAPATH/tls/key.pem
mv $HDFCERGOCAPATH/tls/*-cert.pem $HDFCERGOCAPATH/tls/cert.pem

cp $PEERS/tataaig-org/ca/* $TATAAIGCAPATH/ca
cp $PEERS/tataaig-org/tlsca/* $TATAAIGCAPATH/tls
mv $TATAAIGCAPATH/ca/*_sk $TATAAIGCAPATH/ca/key.pem
mv $TATAAIGCAPATH/ca/*-cert.pem $TATAAIGCAPATH/ca/cert.pem
mv $TATAAIGCAPATH/tls/*_sk $TATAAIGCAPATH/tls/key.pem
mv $TATAAIGCAPATH/tls/*-cert.pem $TATAAIGCAPATH/tls/cert.pem

cp $PEERS/bajaj-org/ca/* $BAJAJCAPATH/ca
cp $PEERS/bajaj-org/tlsca/* $BAJAJCAPATH/tls
mv $BAJAJCAPATH/ca/*_sk $BAJAJCAPATH/ca/key.pem
mv $BAJAJCAPATH/ca/*-cert.pem $BAJAJCAPATH/ca/cert.pem
mv $BAJAJCAPATH/tls/*_sk $BAJAJCAPATH/tls/key.pem
mv $BAJAJCAPATH/tls/*-cert.pem $BAJAJCAPATH/tls/cert.pem

cp $PEERS/iffco-org/ca/* $IFFCOCAPATH/ca
cp $PEERS/iffco-org/tlsca/* $IFFCOCAPATH/tls
mv $IFFCOCAPATH/ca/*_sk $IFFCOCAPATH/ca/key.pem
mv $IFFCOCAPATH/ca/*-cert.pem $IFFCOCAPATH/ca/cert.pem
mv $IFFCOCAPATH/tls/*_sk $IFFCOCAPATH/tls/key.pem
mv $IFFCOCAPATH/tls/*-cert.pem $IFFCOCAPATH/tls/cert.pem

WEBCERTS=$PROJPATH/web/certs
rm -rf $WEBCERTS
mkdir -p $WEBCERTS
cp $PROJPATH/orderer/crypto/tls/ca.crt $WEBCERTS/ordererOrg.pem
cp $PROJPATH/hdfcErgoPeer/crypto/tls/ca.crt $WEBCERTS/hdfcErgoOrg.pem
cp $PROJPATH/tataAigPeer/crypto/tls/ca.crt $WEBCERTS/tataAigOrg.pem
cp $PROJPATH/bajajPeer/crypto/tls/ca.crt $WEBCERTS/bajajOrg.pem
cp $PROJPATH/iffcoPeer/crypto/tls/ca.crt $WEBCERTS/iffcoOrg.pem
cp $PEERS/hdfcergo-org/users/Admin@hdfcergo-org/msp/keystore/* $WEBCERTS/Admin@hdfcergo-org-key.pem
cp $PEERS/hdfcergo-org/users/Admin@hdfcergo-org/msp/signcerts/* $WEBCERTS/
cp $PEERS/tataaig-org/users/Admin@tataaig-org/msp/keystore/* $WEBCERTS/Admin@tataaig-org-key.pem
cp $PEERS/tataaig-org/users/Admin@tataaig-org/msp/signcerts/* $WEBCERTS/
cp $PEERS/bajaj-org/users/Admin@bajaj-org/msp/keystore/* $WEBCERTS/Admin@bajaj-org-key.pem
cp $PEERS/bajaj-org/users/Admin@bajaj-org/msp/signcerts/* $WEBCERTS/
cp $PEERS/iffco-org/users/Admin@iffco-org/msp/keystore/* $WEBCERTS/Admin@iffco-org-key.pem
cp $PEERS/iffco-org/users/Admin@iffco-org/msp/signcerts/* $WEBCERTS/
