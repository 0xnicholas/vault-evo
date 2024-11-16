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