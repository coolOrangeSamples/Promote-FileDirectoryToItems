# Promote File Directory to Vault Items

This sample demonstrates how to use **coolOrange powerVault** (or powerJobs) to promote a list of Autodesk Vault files into matching Vault Items.

The script is intended for Vault administrators and automation users who need to batch-create or synchronize Items from existing vaulted files. This is particularly useful when connecting an existing Vault that does not use Items to Fusion Manage via the Autodesk Connector.

---

## What this script does

- Reads a list of files from a Vault directory
- Creates corresponding Vault Items (if they do not exist)
- Links files to their matching Items
- Can be executed via:
  - powerVault
  - powerJobs Processor

---

## Prerequisites

- Autodesk Vault (Professional)
- Windows PowerShell
- **coolOrange powerVault** or **powerJobs**

---

## Download and install powerVault

1. Download powerVault from:  
   https://download.coolorange.com

2. Install powerVault following the official documentation.

3. Verify installation by opening a PowerShell session and running:

   ```powershell
   Import-Module powerVault
   Open-VaultConnection -Vault TestVault -Server coolOrange1 -User Admin -Password ""
   
