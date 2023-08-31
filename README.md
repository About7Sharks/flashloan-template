# Flashloan Template
A set of contracts and tests to take a 1000 WETH flashloan from aave v3 built using forge.

## Usage
create a .env with mainnet rpc url
```
echo "mainnetL=<your_rpc_url>" > .env
```
### Build

```shell
$ forge build
```

### Test

```shell
$ forge test -vvvv
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
