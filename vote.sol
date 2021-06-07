// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract VoteProject {
    struct Voter {
        address addr;
        bool voted; // 默认没投
        uint256 weight; // 权重
    }

    struct Candidate {
        address addr;
        uint256 amount; // 所得票数
        bool result; // 判断结果
    }

    // mapping类似python中的字典{aaa:111,bbb:222}
    mapping(address => Voter) public voters;
    mapping(address => Candidate) public candidates;

    address public owner;

    constructor() {
        owner = msg.sender;
    }

    event Log(string);

    modifier isOwner() {
        if (owner != msg.sender) {
            emit Log("Not the creator of the contract , no permissions");
            return;
        }
        _;
    }

    // 初始化投票人
    function initVoter(address addr) public {
        if (voters[addr].addr != address(0)) {
            emit Log("It is already initialized");
            return;
        }
        voters[addr] = Voter({addr: addr, voted: false, weight: 1});
    }

    // 初始化候选人
    function initCandidate(address addr) public {
        if(candidates[addr].addr != address(0)){
            emit Log("It is already initialized");
            return;
        }
        candidates[addr] = Candidate({
            addr:addr,
            amount:0,
            result:false
        });
    }

    // 投票
    function vote(address addr) public {
            Voter storage v = voters[msg.sender];
            if(v.voted || v.addr==addr){
                emit Log('The vote has already been cast');
                return;
            }
            // 对应候选人票数
            candidates[addr].amount+=1;
            // 更改投票人状态
            voters[msg.sender].voted=true;
    }

    // 比较
    function result(address addr1,address addr2) public isOwner returns (Candidate memory) {
        if(candidates[addr1].amount>candidates[addr2].amount){
            candidates[addr1].result = true;
            return candidates[addr1];
        }else if(candidates[addr2].amount>candidates[addr1].amount){
            candidates[addr2].result = true;
            return candidates[addr2];
        }
    }
}

