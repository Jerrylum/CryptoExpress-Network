# Introduction

This is the network component of CryptoExpress.

# Usage

First, you need to initialize the repository and download the binary executables:

```bash
./install.sh
```

Then, start the test network with Fabric orderer, 3 organizations with 1 peer node.

```bash
cd test-network && sudo ./initNetwork.sh <chaincode_path>
```
