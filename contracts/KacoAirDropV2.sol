//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract KacoAirDropV2 is Ownable{
    address public immutable token;
    bytes32 public merkleRoot;

    mapping(address => uint) public claimedRewards;

    // This event is triggered whenever a call to #claim succeeds.
    event Claimed(uint256 index, address account, uint256 amount);

    constructor(address token_, bytes32 merkleRoot_) {
        token = token_;
        merkleRoot = merkleRoot_;
    }

    function updateMerkleRoot(bytes32 _merkleRoot) external onlyOwner{
        merkleRoot = _merkleRoot;
    }

    /**
     * No caller permissioning needed since token is transfered to the account argument,
     * if the account is not in the merkleTree then the proof is invalid.
     * User can only submit claim for full claimable amount, otherwise proof verification will fail.
     */

    function claim(
        uint256 index,
        address account,
        uint256 amount,
        bytes32[] calldata merkleProof
    ) external {
        uint canClaimedReward = amount - claimedRewards[account];
        require(canClaimedReward > 0, "none rewards.");

        // Verify the merkle proof.
        bytes32 leaf = keccak256(abi.encodePacked(index, account, amount));
        require(
            MerkleProof.verify(merkleProof, merkleRoot, leaf),
            "Invalid proof."
        );

        // Mark it claimed and send the token to user.
        claimedRewards[account] = amount;
        require(
            IERC20(token).transfer(account, canClaimedReward),
            "Transfer failed."
        );

        emit Claimed(index, account, canClaimedReward);
    }
}
