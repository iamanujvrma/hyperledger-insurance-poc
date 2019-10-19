#!/bin/sh

CHANNEL_NAME="default"
PROJPATH=$(pwd)
CLIPATH=$PROJPATH/cli/peers

echo
echo "##########################################################"
echo "#########  Generating Orderer Genesis block ##############"
echo "##########################################################"
$PROJPATH/configtxgen -profile FourOrgsGenesis -outputBlock $CLIPATH/genesis.block

echo
echo "#################################################################"
echo "### Generating channel configuration transaction 'channel.tx' ###"
echo "#################################################################"
$PROJPATH/configtxgen -profile FourOrgsChannel -outputCreateChannelTx $CLIPATH/channel.tx -channelID $CHANNEL_NAME
cp $CLIPATH/channel.tx $PROJPATH/web
echo
echo "#################################################################"
echo "####### Generating anchor peer update for HdfcErgoOrg ##########"
echo "#################################################################"
$PROJPATH/configtxgen -profile FourOrgsChannel -outputAnchorPeersUpdate $CLIPATH/HdfcErgoOrgMSPAnchors.tx -channelID $CHANNEL_NAME -asOrg HdfcErgoOrgMSP

echo
echo "#################################################################"
echo "#######    Generating anchor peer update for TataAigOrg   ##########"
echo "#################################################################"
$PROJPATH/configtxgen -profile FourOrgsChannel -outputAnchorPeersUpdate $CLIPATH/TataAigOrgMSPAnchors.tx -channelID $CHANNEL_NAME -asOrg TataAigOrgMSP

echo
echo "##################################################################"
echo "####### Generating anchor peer update for BajajOrg ##########"
echo "##################################################################"
$PROJPATH/configtxgen -profile FourOrgsChannel -outputAnchorPeersUpdate $CLIPATH/BajajOrgMSPAnchors.tx -channelID $CHANNEL_NAME -asOrg BajajOrgMSP

echo
echo "##################################################################"
echo "#######   Generating anchor peer update for IffcoOrg   ##########"
echo "##################################################################"
$PROJPATH/configtxgen -profile FourOrgsChannel -outputAnchorPeersUpdate $CLIPATH/IffcoOrgMSPAnchors.tx -channelID $CHANNEL_NAME -asOrg IffcoOrgMSP
