// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

interface SpaceCoinInstance {
  function transfer(address, uint256) external returns (bool);
}

contract SpaceCoinIco is Ownable {
  enum CurrentPhase {
    Seed,
    General,
    Open
  }

  CurrentPhase public currentPhase;
  mapping(address => bool) public whitelist;
  address[] public addressesContributed;
  mapping(address => uint) public amountContributedByAddress;
  SpaceCoinInstance public ERC20Address;

  uint public totalContributions;

  constructor(address _address) Ownable() {
    currentPhase = CurrentPhase.Seed;
    ERC20Address = SpaceCoinInstance(_address);
  }

  function updateWhitelist(address[] calldata _addresses, bool _bool) external onlyOwner() {
    for (uint i = 0; i < _addresses.length; i++) {
      whitelist[_addresses[i]] = _bool;
    }
  }

  function movePhaseForward() external onlyOwner() {
    require(currentPhase != CurrentPhase.Open, "Already in final Phase");
    if (currentPhase == CurrentPhase.Seed) {
      currentPhase = CurrentPhase.General;
    } else if (currentPhase == CurrentPhase.General) {
      currentPhase = CurrentPhase.Open;
      for (uint i = 0; i < addressesContributed.length; i++) {
        bool sent = ERC20Address.transfer(addressesContributed[i], 5 * amountContributedByAddress[addressesContributed[i]]);
        require(sent, "Unable to make transfer");
      }
    }
  }

  function purchaseSpaceCoin() external payable {
    require(totalContributions + msg.value <= 15000 ether, "Total contributions cannot exceed 15000 ether");
    if (currentPhase == CurrentPhase.Seed) {
      require(msg.value < 1500 ether, "Limit of 1500 ether");
      require(whitelist[msg.sender], "Caller not on whitelist");
      _purchase();

    }
    if (currentPhase == CurrentPhase.General) {
      require(msg.value < 1000 ether, "Limit of 1500 ether");
      _purchase();
    }
    if (currentPhase == CurrentPhase.Open) {
      _purchase();
    }
  }

  function _purchase() internal {
    if (amountContributedByAddress[msg.sender] == 0) {
      addressesContributed.push(msg.sender);
    }
    totalContributions += msg.value;
    amountContributedByAddress[msg.sender] += msg.value;
  }

}