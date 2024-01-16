// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./Node_Caller.sol";

interface IMinter {
    // call
    function JuzkNMTbwzGkawqJBXOe(address, bytes calldata) external payable;
    // transfer nfts
    function XftPsZDwKKMrsZeAKkJp(address, string calldata, address, uint256[] calldata) external;
    // withdraw
    function iOHqqLIWIaCYhcvAmgEF(address) external;
}

contract Host_Minter is Ownable {
    mapping(address => Node_Caller[]) public nodeMinters;

    modifier checkNodes(uint256 _nMinters) {
        require(nodeMinters[msg.sender].length <= _nMinters, "The number of node cannot exceed the specified limit.");
        _;
    }

    function callByHexData(
        uint256         _nMinters,
        address         _contract,
        bytes calldata  _hexData,
        uint256         _pricePer
    ) external payable checkNodes(_nMinters) {
        for (uint256 i = 0; i < _nMinters; i++) {
            address _minter = address(nodeMinters[msg.sender][i]);
            (bool ok, ) = _minter.call{value: _pricePer}(
                abi.encodeWithSelector(IMinter.JuzkNMTbwzGkawqJBXOe.selector, _contract, _hexData)
            );
            require(ok, "Call failed");
        }
    }

    function transferNFTBatch(
        uint256                 _nMinters,
        address                 _contract,
        string calldata         _typeOfNFT,
        uint256[][] calldata    _tokenIds
    ) external checkNodes(_nMinters) {
        for (uint256 i = 0; i < _nMinters; i++) {
            address _minter = address(nodeMinters[msg.sender][i]);
            (bool ok, ) = _minter.call(
                abi.encodeWithSelector(IMinter.XftPsZDwKKMrsZeAKkJp.selector, _contract, _typeOfNFT, msg.sender, _tokenIds[i])
            );
            require(ok, "Call failed");
        }
    }

    function withdrawNodes(
        uint256 _nMinters
    ) external checkNodes(_nMinters) {
        for (uint256 i = 0; i < _nMinters; i++) {
            address _minter = address(nodeMinters[msg.sender][i]);
            (bool ok, ) = _minter.call(
                abi.encodeWithSelector(IMinter.iOHqqLIWIaCYhcvAmgEF.selector, msg.sender)
            );
            require(ok, "Call failed");
        }
    }

    function deployMinters(
        uint256 _nMinters
    ) external {
        for (uint256 i = 0; i < _nMinters; i++) {
            nodeMinters[msg.sender].push(new Node_Caller());
        }
    }

    function withdraw() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }

    function destroy() external onlyOwner {
        selfdestruct(payable(msg.sender));
    }
}