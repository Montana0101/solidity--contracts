// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Crowd {
    // 投资人
    struct Funder {
        address addr;
        uint256 money;
    }

    // 众筹商品
    struct Product {
        address payable addr;
        uint256 goal;
        uint256 amount;
        uint256 follower;
        mapping(uint256 => Funder) funders;
    }

    // 需要众筹的商品
    Product[] public products;

    // 初始化商品
    function publish(address payable addr, uint256 goal)
        public
        returns (uint256)
    {
        Product storage p = products.push();
        p.addr = addr;
        p.goal = goal*10**18;
        p.amount = 0;
        p.follower = 0;
        return products.length;
    }

    // 众筹
    function crowd(uint256 index) public payable {
        Product storage p = products[index];
        p.funders[p.follower++] = Funder(msg.sender, msg.value);
        p.amount += msg.value;
    }

    // 是否众筹成功
    function result(uint256 index) public payable returns (bool) {
        Product storage p = products[index];
        if (p.goal < p.amount) {
            return false;
        }
        uint256 amount = p.amount;
        p.addr.transfer(amount);
        p.amount = 0;
        return true;
    }
}
