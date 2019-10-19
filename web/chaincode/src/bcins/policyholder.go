package main

import (
	"encoding/json"

	"github.com/hyperledger/fabric/core/chaincode/shim"
	pb "github.com/hyperledger/fabric/protos/peer"
)

func addAsset(stub shim.ChaincodeStubInterface, args []string) pb.Response {
	if len(args) != 1 {
		return shim.Error("Invalid argument count.")
	}

	dto := struct {
		UUID             string `json:"uuid"`
		AssetType        string `json:"asset_type"`
		Identifier       string `json:"identifier"`
		Value            int64  `json:"value"`
		DurationInMonths int    `json:"duration_in_months"`
		OwnerID          int32  `json:"owner_id"`
	}{}

	err := json.Unmarshal([]byte(args[0]), &dto)
	if err != nil {
		return shim.Error(err.Error())
	}

	asset := Asset{
		AssetType:        dto.AssetType,
		Identifier:       dto.Identifier,
		Value:            dto.Value,
		DurationInMonths: dto.DurationInMonths,
		OwnerID:          dto.OwnerID,
		IsInsured:        false,
	}

	assetKey, err := stub.CreateCompositeKey(prefixAsset, []string{dto.Identifier, dto.UUID})
	if err != nil {
		return shim.Error(err.Error())
	}

	assetAsBytes, err := json.Marshal(asset)
	if err != nil {
		return shim.Error(err.Error())
	}

	err = stub.PutState(assetKey, assetAsBytes)
	if err != nil {
		return shim.Error(err.Error())
	}

	return shim.Success(nil)
}

func acceptInsuranceOffer(stub shim.ChaincodeStubInterface, args []string) pb.Response {
	return shim.Success(nil)
}

func denyInsuranceOffer(stub shim.ChaincodeStubInterface, args []string) pb.Response {
	return shim.Success(nil)
}

func makeClaim(stub shim.ChaincodeStubInterface, args []string) pb.Response {
	return shim.Success(nil)
}
