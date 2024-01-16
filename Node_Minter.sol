// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";

interface IERC721 {
    function safeTransferFrom(address, address, uint256) external;
}

interface IERC1155 {
    function balanceOf(address, uint256) external view returns (uint256);
    function safeTransferFrom(address, address, uint256, uint256, bytes calldata) external;
}

contract Node_Minter is Ownable, ERC721Holder, ERC1155Holder {

    // call
    function JuzkNMTbwzGkawqJBXOe(address _contract, bytes calldata encodedFunctionCall) external payable onlyOwner {
        (bool success, ) = address(_contract).call{value: msg.value}(encodedFunctionCall);
        require(success, "Error calling the other contract");
    }

    // transfer nfts
    function XftPsZDwKKMrsZeAKkJp(address _contract, string calldata _typeOfNFT, address _to, uint256[] calldata _tokenIds) external onlyOwner {
        bytes32 typeOfNFT = bytes32(bytes(_typeOfNFT));
        require(typeOfNFT == bytes32("ERC721") || typeOfNFT == bytes32("ERC1155"), "Invalid NFT type");

        for (uint256 i = 0; i < _tokenIds.length; i++) {
            if (typeOfNFT == bytes32("ERC721")) {
                IERC721(_contract).safeTransferFrom(address(this), _to, _tokenIds[i]);
            }
            else {
                uint256 values = IERC1155(_contract).balanceOf(address(this), _tokenIds[i]);
                IERC1155(_contract).safeTransferFrom(address(this), _to, _tokenIds[i], values, "");
            }

        }
    }

    // withdraw
    function iOHqqLIWIaCYhcvAmgEF(address _to) external onlyOwner {
        payable(_to).transfer(address(this).balance);
    }
}