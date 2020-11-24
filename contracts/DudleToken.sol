// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.8.0;

import "./Devidends/IterableMapping.sol";

contract DudleToken {
    //Iterable mapping for devidends task
    using IterableMapping for IterableMapping.Map;
    IterableMapping.Map internal map;
    
    string public constant name = "DudleTokenRV";
    string public constant symbol = "DTV";
    uint8 public constant decimals = 18;
    uint256 public totalSupply;
    address[] public owners;
    //variables for send token to holders
    address payable holders;
    uint256 public totalReward;
    
    mapping (address => uint256) balances;
    mapping(address => mapping(address => uint256)) allowed;
    mapping(address => bool) ownership;
    
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _from, address indexed _to, uint256 _value);
    
    constructor () {
        //owner1
        ownership[0x5B38Da6a701c568545dCfcB03FcB875f56beddC4] = true;
        owners.push(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4);
        //owner2
        ownership[0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2] = true;
        owners.push(0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2);
    }
    
    function mint (address _to, uint256 _value) public onlyOwner {
        require(totalSupply + _value >= totalSupply && balances[_to] + _value >= balances[_to]);
        //Iterable mapping balance insert
        map.set(address(_to), _value);
        
        balances[_to] += _value;
        totalSupply += _value;
    }
    
    function allowance(address _owner, address _spender) public view returns (uint256) {
        return allowed[_owner][_spender];
    }
    
    function balanceOf(address _owner) public view returns (uint256) {
        return balances[_owner];
    }
    
    //Iterable mapping balance check
    function balanceOfIM(address _owner) public view returns (uint256) {
        return map.get(address(_owner));
    }
    
    function transfer(address _to, uint256 _value) public {
        require(balances[msg.sender] >= _value && balances[_to] + _value >= balances[_to] && _value > 0);
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
    }
    
    function transferFrom (address _from, address _to, uint256 _value) public {
        require(balances[_from] >= _value && balances[_to] + _value >= balances[_to] && allowed[_from][msg.sender] >= _value && _value > 0);
        balances[_from] -= _value;
        balances[_to] += _value;
        allowed[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
    }
    
    function approve (address _spender, uint256 _value) public {
        require(_value > 0);
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
    }
    
    //Deposit eth to contract function with sendig it to holders after this
    function depositIM() public payable {
        totalReward = msg.value;
        for (uint256 i = 0; i < map.size(); i++) {
            address key = map.getKeyAtIndex(i);
            holders = address(uint160(key));
            holders.transfer(totalReward * map.get(address(key)) / totalSupply);
        }
        if (address(this).balance == 0) {
            totalReward = 0;
        }
    }
    
    modifier onlyOwner() {
        require(ownership[msg.sender]);
        _;
    }
}