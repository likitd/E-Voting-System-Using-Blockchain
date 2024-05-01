// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

contract Voting {
    struct Candidate {
        string name;
        string party;
        uint256 voteCount;
    }

    Candidate[] public candidates;
    address public owner;
    mapping(address => bool) public voters;

    uint256 public votingStart;
    uint256 public votingEnd;

constructor(string[] memory _candidateNames,string[] memory _party) {
    for (uint256 i = 0; i < _candidateNames.length; i++) {
        candidates.push(Candidate({
            name: _candidateNames[i],
            party:_party[i],
            voteCount: 0
        }));
    }
    owner = msg.sender;
    votingStart = block.timestamp;
    votingEnd = block.timestamp + (90 * 1 minutes);
}

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function addCandidate(string memory _name,string memory _party) public onlyOwner {
        candidates.push(Candidate({
                name: _name,
                party:_party,
                voteCount: 0
        }));
    }

    function vote(uint256 _candidateIndex) public {
        require(!voters[msg.sender], "You have already voted.");
        require(_candidateIndex < candidates.length, "Invalid candidate index.");

        candidates[_candidateIndex].voteCount++;
        voters[msg.sender] = true;
    }

    function getAllVotesOfCandiates() public view returns (Candidate[] memory){
        return candidates;
    }

    function getVotingStatus() public view returns (bool) {
        return (block.timestamp >= votingStart && block.timestamp < votingEnd);
    }

    function getRemainingTime() public view returns (uint256) {
        require(block.timestamp >= votingStart, "Voting has not started yet.");
        if (block.timestamp >= votingEnd) {
            return 0;
    }
        return votingEnd - block.timestamp;
    }
    function getOwner() public view returns (address) {
        return owner;
    }
}