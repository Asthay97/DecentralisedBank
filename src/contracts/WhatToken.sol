// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.0;

import "./SafeMath.sol";

contract WhatToken {
    using SafeMath for uint256;

    string private _name;
    string private _symbol;
    uint256 private _totalSupply;

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _value
    );

    mapping(address => uint256) private _balanceOf;
    mapping(address => mapping(address => uint256)) private _allowance;

    constructor(
        string memory name_,
        string memory symbol_,
        uint256 _initialSupply
    ) public {
        _name = name_;
        _symbol = symbol_;
        _balanceOf[msg.sender] = _initialSupply;
        _totalSupply = _initialSupply;
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public pure returns (uint8) {
        return 18;
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address _owner) public view returns (uint256) {
        return _balanceOf[_owner];
    }

    function allowance(address owner, address spender)
        public
        view
        returns (uint256)
    {
        return _allowance[owner][spender];
    }

    function transfer(address _to, uint256 _value)
        public
        returns (bool success)
    {
        require(_balanceOf[msg.sender] >= _value);

        _balanceOf[msg.sender] -= _value;
        _balanceOf[_to] += _value;

        emit Transfer(msg.sender, _to, _value);

        return true;
    }

    function approve(address _spender, uint256 _value)
        public
        returns (bool success)
    {
        _allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public returns (bool success) {
        require(_value <= _balanceOf[_from]);
        require(_value <= _allowance[_from][msg.sender]);

        _balanceOf[_from] -= _value;
        _balanceOf[_to] += _value;

        _allowance[_from][msg.sender] -= _value;

        emit Transfer(_from, _to, _value);

        return true;
    }

    function _mint(address account, uint256 amount) internal {
        require(account != address(0));
        _totalSupply = _totalSupply.add(amount);
        _balanceOf[account] = _balanceOf[account].add(amount);
        emit Transfer(address(0), account, amount);
    }
}
