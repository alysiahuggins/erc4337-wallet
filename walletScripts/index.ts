import { ethers } from 'ethers';
import { Client, Presets } from "userop";
import dotenv from 'dotenv';
dotenv.config();
import updateDotenv from 'update-dotenv'
import { ERC20_ABI } from "./abi";

async function main() {


  // Create a random private key or read existing one from environment variable
  const bundlerRpcUrl = process.env.BUNDLER_RPC;
  let privateKey = process.env.PRIVATE_KEY;
  const paymasterRpcUrl = process.env.PAYMASTER_RPC_URL || "";
  const mumbaiRpcUrl = process.env.MUMBAI_RPC_URL;

  if(privateKey === undefined){
    const newPrivateKey = ethers.Wallet.createRandom().privateKey;
    await updateDotenv({PRIVATE_KEY:newPrivateKey});
    privateKey = newPrivateKey;
  }

  // Create a wallet instance from the private key
  const owner = new ethers.Wallet(privateKey!);

  // Entry point and factory addresses for Polygon Mumbai testnet
  const entryPointAddress = '0x5FF137D4b0FDCD49DcA30c7CF57E578a026d2789';
  const factoryAddress = '0x1767f4E178d51ED64131a81A70B5dCF59C774c43'; //if you redeploy the wallet factory then replace this address with the new contract address

  const paymasterContext = {type: "payg"};
  const paymaster = Presets.Middleware.verifyingPaymaster(
    paymasterRpcUrl,
    paymasterContext
  );

  const smartAccount = await Presets.Builder.SimpleAccount.init(
    owner,
    bundlerRpcUrl!,
    {
      entryPoint: entryPointAddress,
      factory: factoryAddress,
      paymasterMiddleware: paymaster,
    },
  );
  console.log('smart wallet address', smartAccount.getSender());

  const client = await Client.init(bundlerRpcUrl!, {
    entryPoint: entryPointAddress,
  });

  const provider = new ethers.providers.JsonRpcProvider(mumbaiRpcUrl);

  //simple transfer
  console.log("Simple ETH Transfer Event");
  const simpleTransferResult = await client.sendUserOperation(
    smartAccount.execute(smartAccount.getSender(), 0, "0x"),
  );
  const simpleTransferEvent = await simpleTransferResult.wait();
  console.log(`Simple Transaction hash: ${simpleTransferEvent?.transactionHash}`);


  //mint erc20 tokens to this wallet
  console.log("Mint Erc20 Tokens");
  const erc20Address = '0x3e646f4d11E26c65c55dC4707d9335ed6bb04E8B';
  const erc20 = new ethers.Contract(erc20Address, ERC20_ABI, provider);
  const to = smartAccount.getSender();
  const mintAmount = ethers.utils.parseEther("1");
  const mintResult = await client.sendUserOperation(
    smartAccount.execute(erc20.address, 0, erc20.interface.encodeFunctionData("mint", [to, mintAmount])),
  );
  const mintEvent = await mintResult.wait();
  console.log(`Mint Transaction hash: ${mintEvent?.transactionHash}`);


  //batch approve and transfer
  console.log("Batch Transfer Erc20 Tokens");
  let transferAmount1 = ethers.utils.parseEther("0.001");
  let transferAmount2 = ethers.utils.parseEther("0.01");

  let dest = [
    erc20.address, 
    erc20.address
  ];
  let data = [
    erc20.interface.encodeFunctionData("transfer", [to, transferAmount1]), 
    erc20.interface.encodeFunctionData("transfer", [to, transferAmount2])
  ];
  const batchResult = await client.sendUserOperation(
    smartAccount.executeBatch(dest, data),
  );
  const batchEvent = await batchResult.wait();
  console.log(`Batch Transaction hash: ${batchEvent?.transactionHash}`);

  
}

main().catch(console.error);