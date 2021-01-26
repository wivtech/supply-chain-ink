const { ApiPromise, WsProvider } = require("@polkadot/api");
const { CodePromise, BlueprintPromise } = require('@polkadot/api-contract');
const { Keyring } = require('@polkadot/keyring');
const fs = require("fs").promises;

const LOCAL_NODE = "ws://127.0.0.1:9944";

async function main() {
    let argv = require("yargs/yargs")(process.argv.slice(2))
        .usage("Deploy and instantiate a contract in one go")
        .options({
            url: { alias: "u", default: LOCAL_NODE },
            suri: { alias: "s", default: "//Alice" },
            wasm: { alias: "w", demand: true }, //file
            metadata: { alias: "m", demand: true }, //file
            endowment: { alias: "e", demand: true },
            gas: { alias: "g", global: true }
        })
        .argv;

    let wasm = await fs.readFile(argv.wasm);
    let metadata = await fs.readFile(argv.metadata, "utf8");
    console.log(metadata);

    const wsProvider = new WsProvider(argv.url);

    const api = await ApiPromise.create({ provider: wsProvider });
    const keyring = new Keyring({ type: "sr25519" });
    const signer = keyring.addFromUri(argv.suri);

    const code = new CodePromise(api, metadata, wasm);
    console.log(code);

    let blueprint;
    const unsub1 = await code
        .createBlueprint()
        .signAndSend(signer, (result) => {
            if (result.status.isInBlock || result.status.isFinalized) {
                blueprint = result.blueprint;
                unsub1();
            }
        });
    console.log(blueprint);

    let contract;
    const unsub2 = await blueprint.tx
        .new(argv.endowment, argv.gas)
        .signAndSend(signer, (result) => {
            if (result.status.isInBlock || result.status.isFinalized) {
                contract = result.contract;
                unsub2();
            }
        });
    console.log(contract);

    console.log("The contract is instantiated");
}

main().catch(console.error);
