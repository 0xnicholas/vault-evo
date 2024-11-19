# Vault-Evo

VaultEvo是一种可用于任何DeFi协议的(noncustodial)Vault主动管理协议，它使任何人都可以创建一个Vault，并用于多个DeFi市场。其产品形态类似于TradFi中的资产管理。

VaultEvo的用户是LP，他们希望从DeFi协议中赚取收入，而不必总是管理其头寸的风险。存款的主动管理通过一组不同角色 (owner, mananger and guardian) 来进行，这些角色主要负责管理用户资金的分配和控制DeFi市场的策略。

- VaultEvo是ERC-4626 vault, with ERC-2612 permit. 
- 一个VaultEvo专用于一种资产，用户可以根据可用的流动性随时supply/withdraw.
- Factory合约
- Manager可以从产生的总利息中提取performance fee(up to 50%)
- 每个Market都有一个supply上限，以保证LP对特定市场的最大敞口
- Vault流动性的分配可以多种方式进行：
    - Manual Allocation: 通过异步函数指定从哪个市场撤出多少流动性，以及向每个市场提供多少流动性。该操作的gas fee由函数调用者支付（Manager）。
    - Supply Queue: 每次Deposit时，按指定顺序向市场供应资金(Atomically)。在达到队列中的所有市场上限后，剩余资金作为闲置流动性(idle liquidity)留在Vault中。
    - Withdraw queue: ...

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


## Vault References

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

---

## _Memo
| Follow up | Solutions |
|----|----|
|- Vault与Canal协议的耦合度太高 | 封装接口，以标准接口对外集成DeFi协议,canal只是其中一例|
|- 新增了角色Curator | 考虑与Allocator合为Managers |
