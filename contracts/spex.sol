// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "@zondax/filecoin-solidity/contracts/v0.8/MinerAPI.sol";
import "@zondax/filecoin-solidity/contracts/v0.8/types/MinerTypes.sol";

contract SPEX {

    struct ListMiner {
        string id;
        address seller;
        uint price;
        uint listTime;
        string email;
    }

    struct HistoryRecord {
        string id;
        address seller;
        address buyer;
        uint price;
        uint dealTime;
    }

    mapping(string => address) _contractMiners;

    mapping(string => ListMiner) _listMiners;

    mapping (address => uint) _name;

    string[] _listMinerIds;

    address _feeTo;
    address _manager;

    int _feeRate;

    constructor(address manager, address feeTo, int feeRate) {
        _manager = manager;
        _feeTo = feeTo;
        _feeRate = feeRate;
    }

    function changeFeeTo(address newFeeTo) public {
        require(msg.sender == _manager, "Must manager can change");
        _feeTo = newFeeTo;
    }

    function changeFeeRate(int newFeeRate) public {
        require(msg.sender == _manager, "Must manager can change");
        _feeRate = newFeeRate;
    }

    function confirmChangeOwnerToSpex(string calldata minerId, string calldata sign) public {
        // verify signature
        // accept miner

        _contractMiners[minerId] = msg.sender;
    }

    function listMiner(string calldata minerId, uint price, string calldata email) public {
        require(_contractMiners[minerId]==msg.sender, "You are not the owner of miner");
        require(_listMiners[minerId].listTime == 0, "Miner already list");
        ListMiner memory miner = ListMiner ({
            id: minerId,
            seller: msg.sender,
            price: price,
            listTime: block.timestamp,
            email: email
        });
        _listMiners[minerId] = miner;
        _listMinerIds.push(minerId);
    }

    function changePrice(string calldata minerId, uint price) public {
        require(_contractMiners[minerId]==msg.sender, "You are not the owner of miner");
        ListMiner memory miner = _listMiners[minerId];
        miner.price = price;
    }

    function changeOwner(string calldata minerId, string calldata newOwner) public {
        require(_contractMiners[minerId]==msg.sender, "You are not the owner of miner");
        require(_listMiners[minerId].listTime == 0, "You must cancel list first");
        // set owner to new owner
    }

    function cancelList(string calldata minerId) public {
        require(_contractMiners[minerId]==msg.sender, "You are not the owner of miner");
        require(_listMiners[minerId].listTime == 0, "Miner not list");
        delete _listMiners[minerId];
    }

    // function buyMiner(string calldata minerId) public {
    //     ListMiner calldata listMiner = _listMiners[minerId];
    //     require(listMiner.listTime == 0, "Miner not list");
    //     ListMiner.seller.transfer()
    //     delete _listMiners[minerId];
    // }

    function getListMiners() view public {
        
    }


    function getHistoryRecords() view public {
        
    }

    // function getAvailableBalance(bytes memory target) public returns (int256) {
    //     MinerTypes.GetAvailableBalanceReturn memory r = MinerAPI.getAvailableBalance(target);
    //     return 123;
    // }
}