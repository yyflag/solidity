pragma solidity ^0.8.0;

// 注意：OpenZeppelin SafeMath 在 Solidity 0.8+ 中已内置，通常不再需要显式导入
// 但如果需要，可以使用 @openzeppelin/contracts 的更新版本

contract CoinFlip {
    uint256 public consecutiveWins;
    uint256 private lastHash;
    uint256 private constant FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

    constructor() {
        consecutiveWins = 0;
    }

    function flip(bool _guess) public returns (bool) {
        // 使用 blockhash() 替代已弃用的 block.blockhash
        uint256 blockValue = uint256(blockhash(block.number - 1));

        // 防止在同一区块内重复调用
        require(blockValue != 0, "Block hash should not be zero");
        require(lastHash != blockValue, "Cannot call twice in the same block");

        lastHash = blockValue;
        
        // 注意：这在 Solidity 0.8+ 中安全，因为已内置溢出检查
        uint256 coinFlip = blockValue / FACTOR;
        bool side = coinFlip == 1;

        if (side == _guess) {
            consecutiveWins++;
            return true;
        } else {
            consecutiveWins = 0;
            return false;
        }
    }
}

contract GatekeeperTwo {
    address public entrant;

    modifier gateOne() {
        require(msg.sender != tx.origin);
        _;
    }

    modifier gateTwo() {
        uint256 x;
        assembly {
            x := extcodesize(caller())
        }
        require(x == 0);
        _;
    }

    modifier gateThree(bytes8 _gateKey) {
        require(uint64(bytes8(keccak256(abi.encodePacked(msg.sender)))) ^ uint64(_gateKey) == type(uint64).max);
        _;
    }

    function enter(bytes8 _gateKey) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
        entrant = tx.origin;
        return true;
    }
}