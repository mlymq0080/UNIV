// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

contract ConText{
    function _msgSender() internal view returns(address){
        return msg.sender;
    }
}