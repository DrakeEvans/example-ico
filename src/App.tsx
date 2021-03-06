import './App.css';
import { useState, useEffect } from 'react';
import { ethers } from 'ethers';
import SpaceCoinIco from './data/abi/contracts/space-coin-ico.sol/SpaceCoinIco.json';

// Update with the contract address logged out to the CLI when it was deployed
const spaceCoinIcoAddress = '0x6e8ff733b47A1eC9968C5532f42530CDCe58Ba15';

function App() {
  // store greeting in local state
  const [balance, setBalance] = useState<string | undefined>();
  const [formBalance, setFormBalance] = useState<string | undefined>();
  const [totalContribution, setTotalContribution] = useState<string | undefined>();
  const [errorMessage, setErrorMessage] = useState<string | undefined>();

  // request access to the user's MetaMask account
  async function requestAccount() {
    await (window as any).ethereum.request({ method: 'eth_requestAccounts' });
    console.log('account requested');
  }

  // call the smart contract, read the current greeting value
  async function fetchTotalContribution() {
    if (typeof (window as any).ethereum !== 'undefined') {
      await requestAccount();
      const provider = new ethers.providers.Web3Provider((window as any).ethereum);

      const spaceCoinIco = new ethers.Contract(spaceCoinIcoAddress, SpaceCoinIco, provider);
      try {
        const data = await spaceCoinIco.totalContributions();
        console.log('🚀 ~ file: App.tsx ~ line 34 ~ fetchTotalContribution ~ data', data.toString());
        const displayBalance = ethers.utils.formatEther(data).toString();
        setTotalContribution(displayBalance);
        console.log('data: ', displayBalance);
      } catch (err) {
        console.log('Error: ', err);
      }
    }
  }

  // call the smart contract, read the current greeting value
  async function fetchBalance() {
    if (typeof (window as any).ethereum !== 'undefined') {
      await requestAccount();
      const provider = new ethers.providers.Web3Provider((window as any).ethereum);
      const signer = provider.getSigner();

      const spaceCoinIco = new ethers.Contract(spaceCoinIcoAddress, SpaceCoinIco, provider);
      try {
        const address = await signer.getAddress();
        console.log('🚀 ~ file: App.tsx ~ line 36 ~ fetchBalance ~ address', address);
        const data = await spaceCoinIco.amountContributedByAddress(address);
        const displayBalance = ethers.utils.formatEther(data.mul(5));
        setBalance(displayBalance);
        console.log('data: ', displayBalance);
      } catch (err) {
        console.log('Error: ', err);
      }
    }
  }

  // call the smart contract, send an update
  async function purchaseSpaceCoin() {
    try {
      if (!formBalance) {
        setErrorMessage('Error: Input a balance');
        return;
      }
      console.log('purchase Spacecoin');
      if (typeof (window as any).ethereum !== 'undefined') {
        await requestAccount();
        const provider = new ethers.providers.Web3Provider((window as any).ethereum);
        const signer = provider.getSigner();
        const contract = new ethers.Contract(spaceCoinIcoAddress, SpaceCoinIco, signer);
        const transaction = await contract.purchaseSpaceCoin({ value: ethers.utils.parseEther(formBalance as string) });
        setErrorMessage('Broadcasting transaction');
        await transaction.wait();
        setErrorMessage('');
        console.log('transactiondone');
        await fetchBalance();
        await fetchTotalContribution();
      }
    } catch (err: any) {
      setErrorMessage(`Error: ${err.message}`);
    }
  }

  // async function checkWhitelist() {
  //   console.log("purchase checkWhitelist")
  //   if (typeof (window as any).ethereum !== 'undefined') {
  //     await requestAccount();
  //     const provider = new ethers.providers.Web3Provider((window as any).ethereum);
  //     const signer = provider.getSigner();
  //     const contract = new ethers.Contract(spaceCoinIcoAddress, SpaceCoinIco, signer);
  //     const myAddress = await signer.getAddress()
  //     console.log("🚀 ~ file: App.tsx ~ line 68 ~ checkWhitelist ~ myAddress", myAddress)
  //     const dataWhitelist = await contract.whitelist(myAddress);
  //     console.log("🚀 ~ file: App.tsx ~ line 68 ~ checkWhitelist ~ dataWhitelist", dataWhitelist);
  //   }
  // }

  useEffect(() => {
    console.log('useeffect started');
    requestAccount();
    fetchTotalContribution();
    fetchBalance();
  });

  return (
    <div className="App">
      <header className="App-header">
        <div>{`Total Project Contributions (ether): ${totalContribution}`}</div>
        <div>{`Your Future SpaceCoin Balance: ${balance}`}</div>
        {/* <button onClick={fetchBalance}>Fetch Number of tokens</button> */}
        <button onClick={purchaseSpaceCoin}>Purchase SpaceCoin</button>
        {/* <button onClick={checkWhitelist}>Check Whitelist</button> */}
        <input onChange={(e) => setFormBalance(e.target.value)} placeholder="Amount To Purchase" />
        <div>{`${errorMessage ?? ''}`}</div>
      </header>
    </div>
  );
}

export default App;
