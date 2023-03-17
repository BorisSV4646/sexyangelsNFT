// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC721.sol";
import "./Counters.sol";

contract SexyangelsNFT is ERC721 {
    Counters.Counter private _nextTokenId;
    using Counters for Counters.Counter;

    uint256 public _tokenPrice = 3500000000000000; //0.0035 ETH
    uint256 constant MAXSUPLAY = 2222;
    string public _name = "SexyAngels";
    string public _symbol = "SA";
    bool public saleIsActive = true;
    address private _owner;

    constructor() ERC721(_name, _symbol) {
        _owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == _owner, "Not an owner");
        _;
    }

    receive() external payable {}

    function startMint() public payable {
        uint256 currentTokenId = _nextTokenId.current();
        _nextTokenId.increment();
        address to = msg.sender;
        super._safeMint(to, currentTokenId, "");
    }

    function _mint(address to, uint256 tokenId) internal override {
        require(saleIsActive, "Sale must be active to mint");
        require(to == _msgSender(), "You can only buy with your wallet");
        require(to != address(0), "ERC721: mint to the zero address");
        require(!_exists(tokenId), "ERC721: token already minted");
        require(_tokenPrice <= msg.value, "Ether value sent is not correct");
        require(MAXSUPLAY >= tokenId, "Too mach tokkens");

        _beforeTokenTransfer(address(0), to, tokenId, 1);

        require(!_exists(tokenId), "ERC721: token already minted");

        unchecked {
            _balances[to] += 1;
        }

        _owners[tokenId] = to;

        emit Transfer(address(0), to, tokenId);

        _afterTokenTransfer(address(0), to, tokenId, 1);
    }

    function flipSaleState() public onlyOwner {
        saleIsActive = !saleIsActive;
    }

    function withdraw() public onlyOwner {
        uint256 balance = address(this).balance;
        payable(msg.sender).transfer(balance);
    }

    function setPrice(uint256 _newPrice) public onlyOwner {
        _tokenPrice = _newPrice;
    }

    function getPrice() public view returns (uint256) {
        return _tokenPrice;
    }
}
