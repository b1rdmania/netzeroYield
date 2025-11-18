// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract MockFundShare is ERC721, Ownable {
    struct FundShare {
        uint256 value;
        uint256 fundId;
        string fundName;
    }

    mapping(uint256 => FundShare) public shares;
    mapping(uint256 => uint256) private _tokenCounter;
    string private _fundName;

    event FundShareMinted(address indexed to, uint256 indexed tokenId, uint256 value, string fundName);

    constructor(string memory name, string memory symbol, string memory fundName) ERC721(name, symbol) Ownable() {
        _fundName = fundName;
    }

    function mint(address to, uint256 value, uint256 fundId, string memory fundName) external onlyOwner returns (uint256) {
        uint256 tokenId = _tokenCounter[fundId]++;
        _mint(to, tokenId);
        
        shares[tokenId] = FundShare({
            value: value,
            fundId: fundId,
            fundName: fundName
        });

        emit FundShareMinted(to, tokenId, value, fundName);
        return tokenId;
    }

    function getShareValue(uint256 tokenId) external view returns (uint256) {
        require(_ownerOf(tokenId) != address(0), "Token does not exist");
        return shares[tokenId].value;
    }

    function getShareInfo(uint256 tokenId) external view returns (uint256 fundId, string memory fundName, uint256 value) {
        require(_ownerOf(tokenId) != address(0), "Token does not exist");
        FundShare memory share = shares[tokenId];
        return (share.fundId, share.fundName, share.value);
    }

    function getFundName() external view returns (string memory) {
        return _fundName;
    }

    function updateShareValue(uint256 tokenId, uint256 newValue) external onlyOwner {
        require(_ownerOf(tokenId) != address(0), "Token does not exist");
        shares[tokenId].value = newValue;
    }

    function batchMint(address to, uint256[] memory values, uint256 fundId, string memory fundName) external onlyOwner returns (uint256[] memory tokenIds) {
        tokenIds = new uint256[](values.length);
        for (uint256 i = 0; i < values.length; i++) {
            uint256 tokenId = _tokenCounter[fundId]++;
            _mint(to, tokenId);
            
            shares[tokenId] = FundShare({
                value: values[i],
                fundId: fundId,
                fundName: fundName
            });

            emit FundShareMinted(to, tokenId, values[i], fundName);
            tokenIds[i] = tokenId;
        }
        return tokenIds;
    }
}

