// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract SpaceCoinIco {
  enum CurrentPhase {
    Seed,
    General,
    Open
  }

  CurrentPhase public currentPhase;
  mapping(address => bool) private whitelist;
  mapping(address => uint) private amountContributedByAddress;
  address public owner;
  uint public totalContributions;

  constructor() {
    owner = msg.sender;
    currentPhase = CurrentPhase.Seed;
  }

  modifier onlyOwner() {
    require(msg.sender == owner, "Unauthorized: owner only");
    _;
  }

  function updateWhitelist(address[] calldata _addresses) external onlyOwner() {
    for (uint i = 0; i < _addresses.length; i++) {
      whitelist[_addresses[i]] = true;
    }
  }

  function movePhaseForward() external onlyOwner() {
    require(currentPhase != CurrentPhase.Open, "Already in final Phase");
    if (currentPhase == CurrentPhase.Seed) {
      currentPhase = CurrentPhase.General;
    }

    if (currentPhase == CurrentPhase.General) {
      currentPhase = CurrentPhase.Open;
      // send tokens for all existing contributions
    }
  }

  function purchaseSpaceCoin() external payable {
    if (currentPhase == CurrentPhase.Seed) {
      require(msg.value < 1500 ether, "Limit of 1500 ether");
      require(totalContributions + msg.value <= 15000 ether, "Total contributions cannot exceed 15000 ether");
      
      totalContributions += msg.value;
      amountContributedByAddress[msg.sender] += msg.value;
    }
    if (currentPhase == CurrentPhase.General) {
      require(msg.value < 1000 ether, "Limit of 1500 ether");
      require(totalContributions + msg.value <= 30000 ether, "Total contributions cannot exceed 30000 ether");
      totalContributions += msg.value;
      amountContributedByAddress[msg.sender] += msg.value;
    }
    if (currentPhase == CurrentPhase.Open) {
      require(totalContributions + msg.value <= 30000 ether, "Total contributions cannot exceed 30000 ether");
      totalContributions += msg.value;
      amountContributedByAddress[msg.sender] += msg.value;
      //sendTokens
    }
  }

  function sendTokens(address _address, uint _amount) internal {
    
  }

}