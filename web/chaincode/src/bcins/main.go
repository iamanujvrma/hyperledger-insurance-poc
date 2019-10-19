package main

import (
	"fmt"

	"encoding/json"

	"github.com/hyperledger/fabric/core/chaincode/shim"
	pb "github.com/hyperledger/fabric/protos/peer"
)

const prefixAsset = "asset"
const prefixOwner = "owner"

var logger = shim.NewLogger("main")

type SmartContract struct {
}

var bcFunctions = map[string]func(shim.ChaincodeStubInterface, []string) pb.Response{
	// Policy holders
	"add_asset":              addAsset,
	"accept_insurance_offer": acceptInsuranceOffer,
	"deny_insurance_offer":   denyInsuranceOffer,
	"make_claim":             makeClaim,

	// Insurers
	"view_open_assets":     viewOpenAssets,
	"make_insurance_offer": makeInsuranceOffer,
	"approve_claim":        approveClaim,
	"deny_claim":           denyClaim,
}

// Init callback representing the invocation of a chaincode
func (t *SmartContract) Init(stub shim.ChaincodeStubInterface) pb.Response {
	_, args := stub.GetFunctionAndParameters()

	if len(args) == 1 {
		var contractTypes []struct {
			UUID string `json:"uuid"`
			*ContractType
		}
		err := json.Unmarshal([]byte(args[0]), &contractTypes)
		if err != nil {
			return shim.Error(err.Error())
		}
		for _, ct := range contractTypes {
			contractTypeKey, err := stub.CreateCompositeKey(prefixContractType, []string{ct.UUID})
			if err != nil {
				return shim.Error(err.Error())
			}
			contractTypeAsBytes, err := json.Marshal(ct.ContractType)
			if err != nil {
				return shim.Error(err.Error())
			}
			err = stub.PutState(contractTypeKey, contractTypeAsBytes)
			if err != nil {
				return shim.Error(err.Error())
			}
		}
	}
	return shim.Success(nil)
}

// Invoke Function accept blockchain code invocations.
func (t *SmartContract) Invoke(stub shim.ChaincodeStubInterface) pb.Response {
	function, args := stub.GetFunctionAndParameters()

	if function == "init" {
		return t.Init(stub)
	}
	bcFunc := bcFunctions[function]
	if bcFunc == nil {
		return shim.Error("Invalid invoke function.")
	}
	return bcFunc(stub, args)
}

func main() {
	logger.SetLevel(shim.LogInfo)

	err := shim.Start(new(SmartContract))
	if err != nil {
		fmt.Printf("Error starting Simple chaincode: %s", err)
	}
}
