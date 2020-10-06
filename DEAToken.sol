//Be name khoda

pragma solidity ^0.6.12;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/AccessControl.sol";
import "./ERC20.sol";

contract DEAToken is ERC20, AccessControl{

	using SafeMath for uint256;


	bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
	bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");
	bytes32 public constant REBASER_ROLE = keccak256("REBASER_ROLE");

	uint256 public rebaseMultiplier = 1e18;
	uint256 public rebaseMultiplierScale = 1e18;

	event Rebase(uint256 oldCoefficient, uint256 newCoefficient);


	constructor() public ERC20("DEA", "DEA") {
		_setupRole(DEFAULT_ADMIN_ROLE, msg.sender);	
		grantRole(keccak256("REBASER_ROLE"), msg.sender);
		_mint(msg.sender, 100e18);
	}

	function mint(address to, uint256 amount) public {
        require(hasRole(MINTER_ROLE, msg.sender), "Caller is not a minter");
        _mint(to, amount.mul(rebaseMultiplierScale).div(rebaseMultiplier));
    }

	function burn(address from, uint256 amount) public {
        require(hasRole(BURNER_ROLE, msg.sender), "Caller is not a burner");
        _burn(from, amount.mul(rebaseMultiplierScale).div(rebaseMultiplier));
    }

	function rebase(uint256 _rebaseMultiplier) public {
		require(hasRole(REBASER_ROLE, msg.sender), "Caller is not a rebaser");
		emit Rebase(rebaseMultiplier, _rebaseMultiplier);
		rebaseMultiplier = _rebaseMultiplier;
	}


	function totalSupply() public view override returns (uint256){
		return super.totalSupply().mul(rebaseMultiplier).div(rebaseMultiplierScale);
	}
	function balanceOf(address account) public view override returns (uint256){
		return super.balanceOf(account).mul(rebaseMultiplier).div(rebaseMultiplierScale);
	}


	function allowance(address owner, address spender) public view override returns (uint256){
		return super.allowance(owner, spender);
	}
	function approve(address spender, uint256 amount) public override returns (bool){
		return super.approve(spender, amount);
	}
	function increaseAllowance(address spender, uint256 addedValue) public override returns (bool) {
        return super.increaseAllowance(spender, addedValue);
    }
	function decreaseAllowance(address spender, uint256 subtractedValue) public override returns (bool) {
        return super.decreaseAllowance(spender, subtractedValue);
    }


	function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        return super.transferFrom(sender, recipient, amount.mul(rebaseMultiplierScale).div(rebaseMultiplier));
    }

	function transfer(address recipient, uint256 amount) public override returns (bool) {
        return super.transfer(recipient, amount.mul(rebaseMultiplierScale).div(rebaseMultiplier));
    }
	
	function _beforeTokenTransfer(address from, address to, uint256 value) internal virtual override {
        emit Transfer(sender, recipient, amount.mul(rebaseMultiplierScale).div(rebaseMultiplier));
    }
}
//Dar panah khoda