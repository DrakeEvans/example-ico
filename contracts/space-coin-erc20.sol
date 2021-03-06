// contracts/GLDToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";

contract SpaceCoin is Ownable, ERC20, ERC20Capped, ERC20Pausable {
    mapping(address => uint) public balances;
    bool public reinvestmentTax;
    address public treasuryAddress;

    constructor(uint256 initialSupply) Ownable() ERC20("Space", "SPC") ERC20Capped(initialSupply) ERC20Pausable() {
        ERC20._mint(msg.sender, initialSupply);
        treasuryAddress = msg.sender; 
        reinvestmentTax = false;
    }

    function _mint(address _account, uint256 _amount) internal virtual override(ERC20, ERC20Capped) {
        super._mint(_account,  _amount);
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC20, ERC20Pausable) {
        super._beforeTokenTransfer(from, to, amount);
    }

    function startReinvestment() public onlyOwner() {
        require(reinvestmentTax == false, "Reinvestment tax already started");
        reinvestmentTax = true;
    }

    function endReinvestment() public onlyOwner() {
        require(reinvestmentTax == true, "Reinvestment tax already off");
        reinvestmentTax = false;
    }

    function transfer(address _account, uint256 _amount) public override returns (bool) {
        if (reinvestmentTax) {
            uint tax = _amount / 50;
            super.transfer(treasuryAddress, tax);
            return super.transfer(_account, _amount - tax);
        } else { 
            return super.transfer(_account, _amount);
        }
    }

    function unpause() public onlyOwner() {
        super._unpause();
    }

    function pause() public onlyOwner() {
        super._pause();
    }

    function setTreasuryAddress(address _address) external onlyOwner() {
        treasuryAddress = _address;
    }



}