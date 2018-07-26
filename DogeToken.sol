pragma solidity ^0.4.24;

import './SafeMath.sol';
import './IERC20.sol';

contract DogeToken is IERC20 {
    
    //cosmetic vars
    string public constant  name = "DogeToken";
    string public constant  symbol = "DTN";
    uint8  public constant decimals = 0;
    uint256 public totalSupply = 100000000;
   
    
    //internal vars
    
   
    uint256 public constant _rate = 1000;
    uint256 public _inCirculation = 0;
    address public owner;
   
    
    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) internal allowed;
    
     constructor() public{
        //give some to the creator
        owner = msg.sender;
        balances[owner] = 1000; 
        _inCirculation = SafeMath.add(_inCirculation, 1000);
    }
    
    function() public payable{
        buyTokens();
    }
    
    function buyTokens() public payable {
      
       uint256 tokens = SafeMath.mul(_rate, msg.value);
       tokens = SafeMath.div(tokens, 1 ether);
       require(msg.value > 0 && (tokens + _inCirculation) <= totalSupply);
       _inCirculation = SafeMath.add(_inCirculation, tokens);
       balances[msg.sender] = SafeMath.add(balances[msg.sender], tokens);
       owner.transfer(msg.value);
        
    }
    
    
    function balanceOf(address _owner) public view returns (uint256 balance){
        return balances[_owner];
    }
    function transfer(address _to, uint256 _value) public returns (bool success){
        require(balances[msg.sender] >= _value && _value > 0);
        balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);
        balances[_to] = SafeMath.add(balances[_to], _value);
        emit Transfer(msg.sender, _to, _value);
        return true;
    }
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
        require (allowed[_from][msg.sender] >= _value && balances[_from] >= _value && _value > 0);
        balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);
        balances[_to] = SafeMath.add(balances[_to], _value);
        allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _value);
        emit Transfer(_from, _to, _value);
        return true;
    }
    function approve(address _spender, uint256 _value) public returns (bool success){
        allowed[msg.sender][_spender] = SafeMath.add(allowed[msg.sender][_spender],_value); 
        emit Approval(msg.sender, _spender, _value);
        return true;
    }
    function allowance(address _owner, address _spender) public view returns (uint256 remaining){
        return allowed[_owner][_spender];
    }
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    
    
}
