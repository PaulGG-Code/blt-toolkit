## BLT Toolkit
![](https://img.shields.io/badge/kali-2023.3-blue)

<p align="center">
  <img src="https://raw.githubusercontent.com/PaulGG-Code/blt-toolkit/main/assets/blt.png?token=GHSAT0AAAAAACIB5SWR5JQWSRMIU7NDYSL4ZLZ6HCA" alt=BLT width="500" height="500" >
</p>
  

# EVM Tools Installation Script

This script automates the installation of various tools for blockchain security and Ethereum Virtual Machine (EVM) development, streamlining the setup process for developers in this field.

## Features

- **Automated Installation**: Simplifies the setup of multiple EVM tools.
- **User-Friendly Interface**: Offers an easy-to-use command-line interface.
- **Customizable Options**: Users can choose specific tools to install.
- **Detailed Logging**: Captures all outputs and errors in a log file.

## Prerequisites

- Linux-based OS (Ubuntu/Debian recommended)
- Root access or ability to use `sudo`
- Internet connection

## Installation

```bash
git clone https://github.com/PaulGG-Code/blt-toolkit
cd blt-toolkit
chmod +x blt-toolkit.sh
./installer.sh --all
```

## Options

```
--help          Display this help and exit."
--all           Install all tools without prompting."
--default       Run the default installation."
-i [TOOL]       Install specific tools. Multiple tools can be specified."
                  Available tools: manticore, mythril, slither, solgraph, echidna, brownie, certora-cli, foundry, ganache-cli, geth, hardhat 
                                   hevm, scribble, truffle, errcheck, go-geiger, golangci-lint, gosec, staticcheck, nancy, unconvert, anchorcli
                                   chainbridge, near-cli, polkadot-js, polygon-cli, sandbox, solana-cli, substrate-front-end, substrate-node, cargo-deny
```

### Available Tools

- **Manticore**: A symbolic execution tool for analysis of binaries and smart contracts.
- **Mythril**: A security analysis tool for Ethereum smart contracts.
- **Slither**: A static analysis framework for Solidity contracts.
- **Solgraph**: Visualizes Solidity contract security and structure.
- **Echidna**: An Ethereum smart contract fuzzer for security testing.
- **Brownie**: A Python-based development and testing framework for smart contracts.
- **Certora-CLI**: A tool for formal verification of smart contracts.
- **Foundry**: A development environment, testing framework, and asset pipeline for Ethereum.
- **Ganache-CLI**: A personal blockchain for Ethereum development.
- **Geth**: An Ethereum node implementation written in Go.
- **Hardhat**: An Ethereum development environment for professionals.
- **HEVM**: An EVM for Haskell.
- **Scribble**: A runtime verification tool for Solidity contracts.
- **Truffle**: A development environment, testing framework, and asset pipeline for blockchains using the EVM.
- **Errcheck**: A Go program for checking for unchecked errors in go programs.
- **Go-Geiger**: A tool to count dangerous function calls in Go code.
- **Golangci-Lint**: A linters aggregator for Go.
- **GoSec**: A static code analyzer for Go projects.
- **Staticcheck**: A state of the art linter for the Go programming language.
- **Nancy**: A tool for identifying and reporting third party dependencies with known vulnerabilities.
- **Unconvert**: A Go tool to remove unnecessary type conversions.
- **AnchorCLI**: A command-line interface for the Anchor Protocol.
- **ChainBridge**: A modular multi-directional blockchain bridge to interact with multiple networks.
- **Near-CLI**: A command-line interface for NEAR Protocol.
- **Polkadot-JS**: JavaScript API for Polkadot and Substrate nodes.
- **Polygon-CLI**: A command-line interface for Polygon.
- **Sandbox**: A local test environment for Algorand.
- **Solana-CLI**: A command-line tool for the Solana blockchain.
- **Substrate Front-End**: A front-end template for Substrate-based blockchains.
- **Substrate Node**: A node template for Substrate-based blockchains.
- **Cargo-Deny**: A tool for linting your Rust project’s dependencies.

## Tools Comparaison:

*Note: This table provides a general overview of the features offered by each tool. Some tools may have additional specific functionalities not covered in this table.*

| Feature / Tool                     | Manticore | Mythril | Slither | Solgraph | Echidna | Brownie | Certora-CLI | Foundry | Ganache-CLI | Geth | Hardhat | HEVM | Scribble | Truffle | Errcheck | Go-Geiger | Golangci-Lint | GoSec | Staticcheck | Nancy | Unconvert | AnchorCLI | ChainBridge | Near-CLI | Polkadot-JS | Polygon-CLI | Sandbox | Solana-CLI | Substrate Front-End | Substrate Node | Cargo-Deny |
|------------------------------------|-----------|---------|---------|----------|---------|---------|-------------|---------|-------------|------|---------|------|----------|---------|----------|-----------|---------------|-------|-------------|-------|-----------|-----------|-------------|----------|-------------|--------------|---------|------------|----------------------|----------------|-------------|
| Symbolic Execution                 | X         | X       |         |          |         |         |             |         |             |      |         |      |          |         |          |           |               |       |             |       |           |           |             |          |             |              |         |            |                      |                |             |
| Static Analysis                    |           | X       | X       |          |         |         |             |         |             |      |         |      |          |         | X        | X         | X             | X     | X           |       | X         |           |             |          |             |              |         |            |                      |                |             |
| Dynamic Analysis                   | X         |         |         |          | X       |         |             |         |             |      |         |      |          |         |          |           |               |       |             |       |           |           |             |          |             |              |         |            |                      |                |             |
| Fuzz Testing                       |           |         |         |          | X       |         |             |         |             |      |         |      |          |         |          |           |               |       |             |       |           |           |             |          |             |              |         |            |                      |                |             |
| Visual Representation              |           |         |         | X        |         |         |             |         |             |      |         |      |          |         |          |           |               |       |             |       |           |           |             |          |             |              |         |            |                      |                |             |
| Smart Contract Development         |           |         |         |          |         | X       |             | X       |             |      | X       |      |          | X       |          |           |               |       |             |       |           |           |             |          |             |              |         |            |                      |                |             |
| Formal Verification                |           | X       |         |          |         |         | X           |         |             |      |         |      |          |         |          |           |               |       |             |       |           |           |             |          |             |              |         |            |                      |                |             |
| Blockchain Simulation              |           |         |         |          |         |         |             |         | X           | X    |         |      |          |         |          |           |               |       |             |       |           |           |             |          |             |              | X       |            |                      |                |             |
| IDE Integration                    |           |         |         |          |         | X       |             |         |             |      | X       |      |          | X       |          |           |               |       |             |       |           |           |             |          |             |              |         |            |                      |                |             |
| Security Best Practices            |           | X       | X       |          |         |         |             |         |             |      |         |      | X        |         |          |           |               |       |             |       |           |           |             |          |             |              |         |            |                      |                |             |
| Custom Script Execution            |           |         |         |          |         | X       |             | X       |             |      | X       | X    |          | X       |          |           |               |       |             |       |           | X         | X           | X        | X           | X            |         | X          | X                    | X              |             |
| Dependency Vulnerability Scanning  |           |         |         |          |         |         |             |         |             |      |         |      |          |         |          |           |               |       |             | X     |           |           |             |          |             |              |         |            |                      |                |             |
| Code Coverage Analysis             |           |         |         |          |         | X       |             |         |             |      | X       |      |          |         |          |           |               |       |             |       |           |           |             |          |             |              |         |            |                      |                |             |
| Linting / Code Quality Analysis    |           |         | X       |          |         |         |             |         |             |      |         |      |          |         | X        |           | X             | X     | X           |       | X         |           |             |          |             |              |         |            |                      |                |             |
| Customizability / Extensibility    | X         | X       | X       |          | X       | X       |             | X       |             |      | X       | X    |          | X       |          |           |               |       |             |       |           | X         | X           | X        | X           | X            |         | X          | X                    | X              | X           |
