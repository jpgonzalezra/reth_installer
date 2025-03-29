# reth installer

A modular and automated installer for deploying an Ethereum node using [Reth](https://github.com/paradigmxyz/reth) and [Lighthouse](https://github.com/sigp/lighthouse), including system setup, firewall rules, secure proxies and snapshots

## What the Installer Does

### `setup_server.sh` (Initial system setup)
1. **Checks for root permissions** to ensure setup can proceed.
2. **Validates required environment variables** (like `RETH_VERSION`, `NODE_CLIENT`, etc).
3. **Updates the system**, installs essential packages like `unzip`, `screen`, `zstd`, etc.
4. **Creates data directories** for Reth and Lighthouse.
5. **Downloads the correct binaries** of Reth and Lighthouse based on your OS and CPU architecture.
6. **Extracts the binaries** into their respective folders.
7. **Reboots the machine** once the system is ready.

### `setup_node.sh` (Node setup and launch)
1. **Loads environment variables** from `.env` and default values.
2. **Detects the OS and CPU architecture** to ensure compatibility.
3. **Runs the firewall setup script** to allow only required ports using UFW.
4. **Installs and configures NGINX**:
   - Generates Basic Auth credentials if not provided.
   - Proxies HTTP (6008), WS (6009), and metrics (6007).
5. **Downloads and extracts snapshot** from Merkle (if `SYNC_FROM=merkle`).
6. **Creates `systemd` services** for both `reth` and `lighthouse`.
7. **Starts the services** and enables them on boot.
8. **Runs a post-install summary** to show you how to check logs, endpoints, and service status.


## Installation Steps

Follow these steps in the given order to set up the project:
1. Download the script
```bash
git clone git@github.com:jpgonzalezra/reth_installer.git
```

2. Setup your .env

3. Run the following command to grant execute permissions to the setup_server.sh script:

```bash
chmod +x setup_server.sh
```

4. Execute the setup_server.sh script with administrative privileges:

```bash
sudo ./setup_server.sh
```

5. After reboot, Run the run.sh script as root:

```bash
sudo ./setup_node.sh
```

## 🙏 Thanks

This project wouldn’t exist without the inspiration from [reth_helper](https://github.com/0xSheller/reth_helper) by [@0xSheller](https://github.com/0xSheller)

Big thanks also to:
- [Paradigm](https://github.com/paradigmxyz) for building [Reth](https://github.com/paradigmxyz/reth)
- [Sigma Prime](https://github.com/sigp) for maintaining [Lighthouse](https://github.com/sigp/lighthouse)

If this tool saved you time or helped you deploy your node, consider ⭐️ starring the repo or contributing back!