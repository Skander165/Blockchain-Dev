pragma solidity ^0.5.0;

import "./DappToken.sol";
import "./DaiToken.sol";

contract TokenFarm {
    //All code goes here
    string public  name = "Dapp Token Farm";
    DappToken public dappToken;
    DaiToken public daiToken;
    address public owner;

    address[] public stakers;
    mapping(address => uint) public stakingBalance;
    mapping(address => bool) public hasStaked;
    mapping(address => bool) public isStaking;

    constructor(DappToken _dappToken, DaiToken _daiToken) public {
        dappToken = _dappToken;
        daiToken = _daiToken;
        owner = msg.sender;
    }

    //1. Stake Tokens (Deposit)
    function stakeTokens(uint _amount) public {
        //require amount greater than 0
        require(_amount > 0, "amount cannot be 0");

        //Transfer Mock Dai Tokens To This Contract For Staking
        daiToken.transferFrom(msg.sender, address(this), _amount);

        //update staking balance
        stakingBalance[msg.sender] += _amount;

        //add users to stakers array *only* if they haven't staked already
        if (!hasStaked[msg.sender]) {
            stakers.push(msg.sender);
        }

        //update staking status
        hasStaked[msg.sender] = true;
        isStaking[msg.sender] = true;
        
    }

    //2. Unstaking Tokens (Withdraw)
    function unstakeTokens() public {
        //Fetch the Staking Balance
        uint balance = stakingBalance[msg.sender];

        //require amount greater than 0
        require(balance > 0, "staking balance cannot be 0");

        //transfer Mock Dai tokens to this contract for staking
        daiToken.transfer(msg.sender, balance);

        //reset staking balance
        stakingBalance[msg.sender] = 0;
        
        //update staking status
        isStaking[msg.sender] = false; 
    }


    //3. Issuing Tokens
    function issueTokens() public {
        //only owner can call this function
        require(msg.sender == owner, "caller must be the owner" );

        //issue tokens to all stakers
        for (uint i = 0; i<stakers.length; i++) {
            address recipient = stakers[i];
            uint balance = stakingBalance[recipient];
            if (balance > 0) {
                dappToken.transfer(recipient, balance); 
            }
        }
    }}