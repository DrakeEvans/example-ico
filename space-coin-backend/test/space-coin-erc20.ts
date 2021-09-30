import { expect } from 'chai';
import { ethers } from 'hardhat';

const deploySpaceCoin = async (initialSupply: number) => {
  const Manager = await ethers.getContractFactory('SpaceCoin');
  const manager = await Manager.deploy(initialSupply);
  await manager.deployed();
  const [owner, ...addresses] = await ethers.getSigners();
  return { owner, addresses };
};

describe('SpaceCoin Contract', () => {
  describe('checkTier function', () => {
    it('It should return the correct amounts', async () => {
      const { owner, addresses } = await deploySpaceCoin(500000);
    });
  });
});
