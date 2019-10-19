package main

import (
	"encoding/json"

	"github.com/hyperledger/fabric/core/chaincode/shim"
)

// Key consists of prefix + identifier + UUID of the asset
type Asset struct {
	AssetType        string `json:"asset_type"`
	Identifier       string `json:"identifier"`
	Value            int64  `json:"value"`
	DurationInMonths int    `json:"duration_in_months"`
	OwnerID          string `json:"owner_id"`
	IsInsured        bool   `json:"is_insured"`
}

// Key consists of prefix + name + UUID of the owner
type owner struct {
	Name         string  `json:"name"`
	Balance      float64 `json:"balance"`
	NoClaimYears int     `json:"no_claim_years"`
}

func (c *Asset) Owner(stub shim.ChaincodeStubInterface) (*Owner, error) {
	if len(c.OwnerID) == 0 {
		return nil, nil
	}

	resultsIterator, err := stub.GetStateByPartialCompositeKey(prefixOwner, []string{})
	if err != nil {
		return nil, err
	}
	defer resultsIterator.Close()

	for resultsIterator.HasNext() {
		kvResult, err := resultsIterator.Next()
		if err != nil {
			return nil, err
		}

		_, keyParams, err := stub.SplitCompositeKey(kvResult.Key)
		if len(keyParams) != 2 {
			continue
		}

		if keyParams[1] == c.OwnerID {
			owner := &Owner{}
			err := json.Unmarshal(kvResult.Value, owner)
			if err != nil {
				return nil, err
			}
			return owner, nil
		}
	}
	return nil, nil
}
