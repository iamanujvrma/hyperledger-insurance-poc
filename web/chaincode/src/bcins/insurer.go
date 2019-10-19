package main

import (
	"encoding/json"

	"github.com/hyperledger/fabric/core/chaincode/shim"
	pb "github.com/hyperledger/fabric/protos/peer"
)

func viewOpenAssets(stub shim.ChaincodeStubInterface, args []string) pb.Response {
	results := []interface{}{}
	resultsIterator, err := stub.GetStateByPartialCompositeKey(prefixAsset, []string{})
	if err != nil {
		return shim.Error(err.Error())
	}
	defer resultsIterator.Close()

	for resultsIterator.HasNext() {
		kvResult, err := resultsIterator.Next()
		if err != nil {
			return shim.Error(err.Error())
		}

		asset := Asset{}
		err = json.Unmarshal(kvResult.Value, &asset)
		if err != nil {
			return shim.Error(err.Error())
		}

		if asset.Insured {
			continue
		}

		owner, err := asset.Owner(stub)
		if err != nil {
			return shim.Error(err.Error())
		}
		if owner == nil {
			return shim.Error("Error acquiring owner.")
		}

		result := struct {
			UUID             string `json:"uuid"`
			AssetType        string `json:"asset_type"`
			Identifier       string `json:"identifier"`
			Value            int64  `json:"value"`
			DurationInMonths int    `json:"duration_in_months"`
			Owner            owner  `json:"owner"`
			IsInsured        bool   `json:"is_insured"`
		}{}

		// Fetch key and set other properties
		prefix, keyParts, err := stub.SplitCompositeKey(kvResult.Key)
		if err != nil {
			return shim.Error(err.Error())
		}

		if len(keyParts) < 2 {
			result.UUID = prefix
		} else {
			result.UUID = keyParts[1]
		}

		result.Owner = owner
		result.AssetType = asset.AssetType
		result.Identifier = asset.Identifier
		result.Value = asset.Value
		result.DurationInMonths = asset.DurationInMonths

		results = append(results, result)
	}

	assetsAsBytes, err := json.Marshal(results)
	if err != nil {
		return shim.Error(err.Error())
	}
	return shim.Success(assetsAsBytes)
}

func makeInsuranceOffer(stub shim.ChaincodeStubInterface, args []string) pb.Response {
	return shim.Success(nil)
}

func approveClaim(stub shim.ChaincodeStubInterface, args []string) pb.Response {
	return shim.Success(nil)
}

func denyClaim(stub shim.ChaincodeStubInterface, args []string) pb.Response {
	return shim.Success(nil)
}
