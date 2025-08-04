// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Import OpenZeppelin Contracts for ERC-20
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

contract KevinCoinToken is ERC20, ERC20Burnable, Pausable, Ownable {
    uint256 private immutable _cap;

    constructor(
        string memory name_,
        string memory symbol_,
        uint256 initialSupply_,
        uint256 cap_
    ) ERC20(name_, symbol_) {
        require(cap_ >= initialSupply_, "Cap must be >= initial supply");
        _cap = cap_;
        _mint(msg.sender, initialSupply_ * 10 ** decimals());
    }

    function cap() public view returns (uint256) {
        return _cap;
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function mint(address to, uint256 amount) public onlyOwner {
        require(totalSupply() + amount <= _cap, "ERC20Capped: cap exceeded");
        _mint(to, amount);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override whenNotPaused {
        super._beforeTokenTransfer(from, to, amount);
    }
}
