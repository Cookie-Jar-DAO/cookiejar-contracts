const fs = require("fs");
const path = require("path");

const broadcastDirectory = "./broadcast"; // Replace with your broadcast folder path
const outDirectory = "./out"; // Replace with your out folder path
const deployments = {};
const processedFiles = new Set();

function getABI(contractName) {
  // stupid lazy hack to get the ABI
  const dirname = contractName.replace("Zodiac", "");
  const abiFilePath = path.join(
    outDirectory,
    `${dirname}.sol/${contractName}.json`
  );
  if (fs.existsSync(abiFilePath)) {
    const abiData = JSON.parse(fs.readFileSync(abiFilePath, "utf-8"));
    return abiData.abi;
  } else {
    console.log(`ABI file not found for ${contractName}`);
  }
  return null;
}

function processFile(filePath, chainId) {
  if (processedFiles.has(filePath)) {
    return; // Skip files that have already been processed
  }
  processedFiles.add(filePath);

  const data = JSON.parse(fs.readFileSync(filePath, "utf-8"));
  data.transactions.forEach((transaction) => {
    if (
      transaction.contractName &&
      transaction.contractAddress &&
      transaction.hash &&
      transaction.transactionType === "CREATE2"
    ) {
      const deployment = {
        contractName: transaction.contractName,
        contractAddress: transaction.contractAddress,
        transactionHash: transaction.hash,
        abi: getABI(transaction.contractName),
      };

      if (!deployments[chainId]) {
        deployments[chainId] = [];
      }
      deployments[chainId].push(deployment);
    }
  });
}

function processDirectory(directoryPath) {
  fs.readdirSync(directoryPath).forEach((fileOrDir) => {
    const fullPath = path.join(directoryPath, fileOrDir);
    if (fs.lstatSync(fullPath).isDirectory()) {
      processDirectory(fullPath); // Recursive call for subdirectories
    } else if (fileOrDir === "run-latest.json") {
      const chainId = path.basename(directoryPath);
      processFile(fullPath, chainId);
    }
  });
}

processDirectory(broadcastDirectory);

fs.writeFileSync("deployments.json", JSON.stringify(deployments, null, 2));
