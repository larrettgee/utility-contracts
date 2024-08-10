// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Multicall {
    struct BasicCall {
        address target;
        bytes data;
    }

    struct Call {
        address target;
        bytes data;
        bool success;
    }

    struct Result {
        bool success;
        bytes returnData;
    }

    function simpleMulticall(
        BasicCall[] calldata calls
    ) public payable returns (uint256 blockNumber, bytes[] memory returnData) {
        blockNumber = block.number;
        uint256 length = calls.length;
        returnData = new bytes[](length);
        BasicCall calldata call;
        for (uint256 i = 0; i < length; ) {
            bool success;
            call = calls[i];
            (success, returnData[i]) = call.target.call(call.data);
            require(success, "Multicall3: call failed");
            unchecked {
                ++i;
            }
        }
    }

    function fancyMulticall(
        bool requireSuccess,
        Call[] calldata calls
    ) public payable returns (Result[] memory returnData) {
        uint256 length = calls.length;
        returnData = new Result[](length);
        Call calldata call;
        for (uint256 i = 0; i < length; ) {
            Result memory result = returnData[i];
            call = calls[i];
            (result.success, result.returnData) = call.target.call(call.data);
            if (requireSuccess) require(result.success, "Multicall3: call failed");
            unchecked {
                ++i;
            }
        }
    }
}
