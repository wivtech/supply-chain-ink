# WiV Supply Chain - Smart Contract (!INK)

A smart contract for WIV Supply Chain

This Smart Contract allows users to securely collect and store information about each unique asset’s provenance and transaction history, whilst holding and insuring the unique asset in a professionally managed storage facility.

The control flow is the following:

- Each asset is identified by a unique id;
- Anyone can add a a new asset that is subject to approval;
- The owner of an asset can transfer it to other account;
- The owner of an asset can delete it permanently;
- Administrator account validate the assets added from any other user;
- Administrator can assign a role to any account;
- Administrator account in set to "Alice" well know account;
- The owner account can delegate a proxy account to manage a single asset or all the owned assets;
- The owner account can add/delete description, photo,etc. The validation date should be considered from app client to consider trusted the changes done.
- An account with the "Shipper" role can update the location of the assets without being the owner.
- Administrator role can do any change
- To add a new category for an asset, the category description must be stored before.
- Metadata should be an [IPFS address](https://www.ipfs.io)
- Photos can be added as [IPFS address](https://www.ipfs.io)
- The proxy control flow is not yet managed for now.
- The assets not approved shall be considered as a draft/proposal.
- Asset data changed after the last approval shall be considered as proposal and not verified.

This smart contract offers 42 functions (extrisincs and reading calls) that have been grouped to keep it simple. The terminology refers to the real world, for example the classic call to "mint()" for adding a new token/asset has been renamed to assetNew(). 

Here the list of function (extrisincs and reading calls):

## Assets
- assetNew (id: AssetId): Result<(), Error>

Creates a new asset.
- assetDelete (id: AssetId): Result<(), Error>

  Deletes an existing asset. Only the owner can do it
- assetTransfer (destination: AccountId, id: AssetId): Result<(), Error>

  Transfers the asset from the caller to a different account.
- assetGetOwner (id: AssetId): Option<AccountId>

  Returns the owner of an asset id
- assetVerify (id: AssetId): bool

  Verifies if an asset id is present in the storage, it returns true/false


### Assets - Description  
- assetDescriptionNew (id: AssetId, desc: Hash): Result<(), Error>
  Adds the description of an asset, only the owner can do it
- assetDescriptionDelete (id: AssetId): Result<(), Error>
  Removes the description of an asset, only the owner can do it
- assetDescriptionGet (id: AssetId): Option<Hash>
  Returns the description of an asset id
- assetDescriptionVerify (id: AssetId): bool
  Verifies if an asset description is present in the storage

### Assets - Photo
- assetPhotoNew (id: AssetId, photoipfs: Hash): Result<(), Error>
  Adds the IPFS address of an asset's photo, only the owner can do it
- assetPhotoDelete (id: AssetId): Result<(), Error>
  Removes the ipfs address of an asset's photo, only the owner can do it
- assetPhotoGet (id: AssetId): Option<Hash>
  Returns the ipfs address of the asset's photo
- assetPhotoVerify (id: AssetId): bool
  Verifies the IPFS address of the asset photo is stored

 ### Assets - Category 
- assetCategoryNew (id: AssetId, categoryid: u32): Result<(), Error>
  Stores the category of an asset, only owner can do it, the category id must be already stored using "categoryDescriptionNew"
- assetCategoryDelete (id: AssetId): Result<(), Error>
  Removes the category of an asset, only the owner can do it
- assetCategoryVerify (id: AssetId): bool
  Verifies if an asset category is present in the storage, it returns true/false

### Assets - Location
- assetLocationNew (id: AssetId, location: Hash): Result<(), Error>
  Adds the location of an asset by coordinates in decimal format, comma separated: xxx.xxxxxxx,yyyy.yyyyyy only owner can do it
- assetLocationDelete (id: AssetId): Result<(), Error>
  Remove the location of an asset id, only the owner can do it
- assetLocationGet (id: AssetId): Option<Hash>
  Returns the location coordinates of an asset
- assetLocationVerify (id: AssetId): bool
  Verify if there is a location stored for an asset id

### Assets - Metadata
- assetMetadataNew (id: AssetId, metadata: Hash): Result<(), Error>
  Add other metadata to an asset as ipfs address, only the owner can do it
- assetMetadataDelete (id: AssetId): Result<(), Error>
  Removes metadata of an asset id, only the owner can do it
- assetMetadataGet (id: AssetId): Option<Hash>
  Returns the metada ipfs address of an asset
- assetMetadataVerify (id: AssetId): bool
  Verifies if there is metadata stored for an asset id

### Assets - Validation
- assetValidationNew (id: AssetId, accountid: AccountId): Result<(), Error>
  Validate an asset from an administrator account
- assetValidationDelete (id: AssetId): Result<(), Error>
  Remove the validation of an asset id, only an administrator can do it
- assetValidationGet (id: AssetId): Option<AccountId>
  Returns the validation account of an asset
- assetValidationVerify (id: AssetId): bool
  Verify if there is a validation stored for an asset id

### Asset - Proxy
- assetGetDelegatedAccount (id: AssetId): Option<AccountId>
  Returns the deletegated account ID for this asset if any.

### Asset - Categories Description
- categoryDescriptionNew (id: u32, description: Hash): Result<(), Error>
  Add a category description, you can store categories for an asset that are not yet stored here.
- categoryDescriptionDelete (id: u32): Result<(), Error>
  Removes the metadata of an asset id, only the owner can do it
- categoryDescriptionGet (id: AssetId): Option<Hash>
  Returns the description of an asset category
- categoryDescriptionVerify (id: u32): bool
  Verifies if there is a category description stored, returns true/false

## Accounts
- accountAssetsNumber (owner: AccountId): u32
  Returns the number of the assets owneed from an account
- accountDelegateForAllAsset (to: AccountId, approved: bool): Result<(), Error>
  Delegate or undelegate an account to manage all the asset on behalf of the caller
- accountDelegateSingleAsset (to: AccountId, id: AssetId): Result<(), Error>
  Delegate an account to transfer the specified asset on behalf of the caller.
- accountVerifyDelegatedForAllAsset (owner: AccountId, operator: AccountId): bool
  Returns `true` if the operator is approved by the owner to manage any asset.
- accountRoleNew (accountid: AccountId, role: u32): Result<(), Error>
  Writes new role operator, only administrator can do it
- accountRoleDelete (accountid: AccountId): Result<(), Error>
  Removes an operator role, only the Administrator can do it
- accountRoleGet (accountid: AccountId): Option<u32>
  Returns the operator role
- accountRoleVerify (accountid: AccountId): bool
 Verifies if there is a role stored for the operator


### Requirements
Install Rust compiler: https://www.rust-lang.org
Install Make utility: https://www.gnu.org/software/make/

Install the toolchain as follows:

```bash
rustup component add rust-src --toolchain nightly
rustup target add wasm32-unknown-unknown --toolchain stable
```

Install the Canvas Substrate Node to test the Smart Contract:

```bash
cargo install canvas-node --git https://github.com/paritytech/canvas-node.git --tag v0.1.4 --force --locked
```

Install the Contract plugin:

```bash
cargo install cargo-contract --vers 0.8.0 --force --locked
```

For additional info to install the Smart Contract Plugin, check the [official documentation](https://substrate.dev/substrate-contracts-workshop/#/)

### How to Build
To build the smart contract

```bash
cd wiv-supply-chain-ink
cargo +nightly contract build
```

Inside the folder "target" your will find the smart contract package:

wivSupplyChain.contract

### How to Run

Run the Substrate Canvas Node:

```bash
canvas purge-chain --dev
canvas --dev
```

Connect to this user interface and select the localnode (tested with Google Chrome, some issues using Safari):

https://ipfs.io/ipns/dotapps.io/ 

the well know and official link:  https://github.com/paritytech/canvas-node  does not work with this smart contract for an unknow reason.

Click on "Developer", "Contracts" and "Upload Wasm" select wivSupplyChain.contract.
Deploy the contract and you will have access to all the functions available.

### Super-Administrator Account
The super-administrator account is hard coded in lib.rs with "Alice", you should change it for production:
```rust
/// Get hard coded super administrator AccountId ###### CUSTOMIZE ADMINISTRATOR #######
fn  administrator_accountid() -> Option<AccountId> {   
    //Administrator hexadecimal Account 
    //Alice account decoding 5GrwvaEF5zXb26Fz9rcQpDWS57CtERHpNehXCPcNoHGKutQY in hex: 0xd43593c715fdd31c61141abd04a99fd6822c8558854ccde39a5684e7a56da27d
    let accountid32: [u8;32] = hex_literal::hex!["d43593c715fdd31c61141abd04a99fd6822c8558854ccde39a5684e7a56da27d"].into();
    Some(ink_env::AccountId::from(accountid32))
}
```
The hard-coded administrato can assign the role of administrator to other accounts.


