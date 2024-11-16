# Vault-Evo

VaultEvo是一种可用于任何DeFi协议的(noncustodial)Vault主动管理协议，它使任何人都可以创建一个Vault，并用于多个DeFi市场。其产品形态类似于TradFi中的资产管理。

VaultEvo的用户是LP，他们希望从DeFi协议中赚取收入，而不必总是管理其头寸的风险。存款的主动管理通过一组不同角色 (owner, mananger and guardian) 来进行，这些角色主要负责管理用户资金的分配和控制DeFi市场的策略。

VaultEvo是ERC-4626 vault, with ERC-2612 permit.

## Roles

### Owner
supreme auth
- Do what the Manager/Guardian can do.
- Set Manager/Guardian, set performance fee&fee recipient.
- Set the rewards recipient.
- Increase/Decrease the timelock.

### Manager(s)
- Set the order of supply&withdraw from markets.(market queue)
- Increase/Decrease the supply cap of any market.
- Revoke the pending cap of any market, force removal of a market.
- Timelock

### Guiardian
- Revoke everything.


## References

### `Market`
- `MarketParams` struct,
- `market` struct,
- `Id` of markets.

### Owner Functions

#### setManager
`function setManager(address newManager) external onlyOwner {}`

#### setSkimRecipient
`function setSkimRecipient(address newSkimRecipient) external onlyOwner {}`

#### submitTimelock
`function submitTimelock(uint256 newTimelock) external onlyOwner {}`

#### setFee
`function setFee(uint256 newFee) external onlyOwner {}`

#### setFeeRecipient
`function setFeeRecipient(address newFeeRecipient) external onlyOwner {}`

#### submitGuardian
`function submitGuardian(address newGuardian) external onlyOwner {}`

### Manager(s) Functions

#### submitCap

`function submitCap(MarketParams memory marketParams, uint256 newSupplyCap) external onlyManager {}`

#### submitMarketRemoval
`function submitMarketRemoval(Id id) external onlyManager {}`

#### setSupplyQueue
`function setSupplyQueue(Id[] calldata newSupplyQueue) external onlyManager {}`

#### updateWithdrawQueue
`function updateWithdrawQueue(uint256[] calldata indexes) external onlyManager {}`

#### reallocate
`function reallocate(MarketAllocation[] calldata allocations) external onlyManager {}`

### Guardian Functions

#### revokePendingTimelock
`function revokePendingTimelock() external onlyGuardian {}`

#### revokePendingGuardian
`function revokePendingGuardian() external onlyGuardian {}`

#### revokePendingCap
`function revokePendingCap(Id id) external onlyGuardian {}`

#### revokePendingMarketRemoval
`function revokePendingMarketRemoval(Id id) external onlyGuardian {}`

### Liquidity


