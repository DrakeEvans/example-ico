// contracts/GLDToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";

contract SpaceCoin is Ownable, ERC20, ERC20Capped, ERC20Pausable {
    mapping(address => uint) public balances;
    bool public reinvestmentTax = false;

    constructor(uint256 initialSupply) Ownable() ERC20("Space", "SPC") ERC20Capped(initialSupply) {
        _mint(msg.sender, initialSupply);
    }

    function _mint(address _account, uint256 _amount) internal virtual override(ERC20, ERC20Capped) {
        super._mint(_account,  _amount);
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC20, ERC20Pausable) {
        super._beforeTokenTransfer(from, to, amount);
    }

    function startReinvestment() public onlyOwner() {
        reinvestmentTax = true;
    }

    function endReinvestment() public onlyOwner() {
        reinvestmentTax = false;
    }

    function mint(address _account, uint256 _amount) external onlyOwner() {
        _mint(_account, _amount);
    }

}