pragma solidity >=0.4.22 <0.8.0;

contract DudleToken {
    string public constant name = "DudleTokenRV";
    string public constant symbol = "DTV";
    uint8 public constant decimals = 18;
    uint256 public totalSupply;
    address[] public owners;
    
    struct pool {
        mapping(address => bool) voters;
        uint256 voterNumber;
    }
    
    mapping(address => pool) pools;
    mapping(address => uint256) balances;
    mapping(address => bool) ownership;
    mapping(address => mapping(address => uint256)) allowed;
    
    uint256 totalReward;
    uint256 lastDivideRewardTime;
    
    struct TokenHolder {
        uint256 balance;
        uint256 balanceUpdateTime;
        uint256 rewardWithdrawTime;
    }
    
    mapping(address => TokenHolder) holders;
    
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _from, address indexed _to, uint256 _value);
    
    constructor () public {
        ownership[msg.sender] = true;
        owners.push(msg.sender);
        ownership[0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2] = true;
        owners.push(0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2);
    }
    
    function mint (address _to, uint256 _value) public onlyOwners{
        require(totalSupply + _value >= totalSupply && balances[_to] + _value >= balances[_to]);
        balances[_to] += _value;
        totalSupply += _value;
    }
    
    function allowance(address _owner, address _spender) public view returns (uint256) {
        return allowed[_owner][_spender];
    }
    
    function balanceOf(address _owner) public view returns (uint256) {
        return balances[_owner];
    }
    
    function transfer(address _to, uint256 _value) public {
        require(balances[msg.sender] >= _value && balances[_to] + _value >= balances[_to] && _value > 0);
        balanceChanges(msg.sender);
        balanceChanges(_to);
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
    }
    
    function transferFrom (address _from, address _to, uint256 _value) public {
        require(balances[_from] >= _value && balances[_to] + _value >= balances[_to] && allowed[_from][msg.sender] >= _value && _value > 0);
        balanceChanges(_from);
        balanceChanges(_to);
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
    
    function vote(address _addr) public onlyOwners{
        require(!pools[_addr].voters[msg.sender], "this address already voted");
        pools[_addr].voterNumber++;
        pools[_addr].voters[msg.sender] = true;
        owners.push(_addr);
    }
    
    function addNewOwner (address _newOwner) public onlyOwners{
        require(pools[_newOwner].voterNumber > owners.length / 2);
        bool noMatches;
        for (uint256 i = 0; i < owners.length; i++) {
            if (owners[i] != _newOwner && i == owners.length - 1) {
                noMatches = true;
            }
        }
        if (noMatches) {
            owners.push(_newOwner);
            ownership[_newOwner] = true;
            noMatches = false;
            pools[_newOwner].voterNumber = 0;
            for (uint256 i = 0; i < owners.length; i++) {
                delete pools[_newOwner].voters[owners[i]];
            }
        }
    }

    modifier onlyOwners() {
        require(ownership[msg.sender] = true);
        _;
    }
    
    //Devidends system

    function reward () public returns (uint256) {
        if (holders[msg.sender].rewardWithdrawTime >= lastDivideRewardTime) {
            return 0;
        }
        uint256 balance;
        if (holders[msg.sender].rewardWithdrawTime <= lastDivideRewardTime) {
            balance = balances[msg.sender];
        } else {
            balance = holders[msg.sender].balance;
        }
        return totalReward * balance / totalSupply;
    }
    
    function divideUpReward() public onlyOwners {
        require(lastDivideRewardTime + 2 minutes < block.timestamp);
        lastDivideRewardTime = block.timestamp;
        totalReward = address(this).balance;
    }
    
    function balanceChanges(address _who) public {
        if (holders[_who].balanceUpdateTime <= lastDivideRewardTime) {
            holders[_who].balanceUpdateTime = block.timestamp;
            holders[_who].balance = balances[_who];
        }
    }
    
    function withdrawReward() public returns (uint256) {
        uint256 value = reward();
        if (value == 0) {
            return 0;
        }
        if (!msg.sender.send(value)) {
            return 0;
        }
        if (balances[msg.sender] == 0) {
            delete holders[msg.sender];
        } else {
            holders[msg.sender].rewardWithdrawTime = block.timestamp;
        }
        msg.sender.send(value);
        return value;
    }
}