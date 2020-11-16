pragma solidity >=0.4.22 <0.8.0;


contract DudleTokenRV2 {

    string public constant name = "DudleTokenRV2";
    string public constant symbol = "DTV2";
    uint8 public constant decimals = 18;
    uint256 public startTime = block.timestamp + 5 minutes;
    uint256 public totalSupply;
    
    mapping (address => uint) balances;
    
    mapping(address => mapping(address => uint)) allowed;
    
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _from, address indexed _to, uint256 _value);
    event Burned(address indexed _from ,uint256 _amount);
    
    function mint (address _to, uint256 _value) public {
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
    
    function burn(uint256 _value) public {
    	require(balances[msg.sender] >= _value && _value > 0);
    	if (block.timestamp > startTime) {
    	   balances[msg.sender] -= _value;
    	   totalSupply -= _value;
    	   emit Burned(msg.sender ,_value);
    	}
    }
}