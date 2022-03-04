// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.12;

contract Election {

    //Storing Candidate & Voter information

    struct Candidate {
        string name;
        uint256 voteCount;

    }

    struct Voter {
        bool voted;
        uint voteIndex; // The candidate the voter has voted for
        uint weight;

    }

    address public owner;
    string public name;
    mapping(address => Voter) public voters; // to store voter information
    Candidate[] public candidates; // creating a struct of the candidates
    uint public endElection; //time untill the election ends

    event ElectionResult(string _name, uint voteCount); //passing the election results as an event

    // Creating an election poll

    function election(string memory _name, uint durationMinutes, string memory candidate1, string memory candidate2 ) public {
        owner = msg.sender;
        name = _name;
        endElection = block.timestamp + (durationMinutes * 1 minutes); // the contract will accept voting starting from the current Block timestamp untill the specified minutes

        candidates.push(Candidate(candidate1, 0));
        candidates.push(Candidate(candidate2, 1));
    }

    //as the owner of the smart contract authorize people to vote using their address

        function authorize(address voter) public {

            require(msg.sender == owner); // Only owner can execute the smart contract
            require(!voters[voter].voted);

            voters[voter].weight = 1;

        }

        //adding the vote function 

        function vote(uint voteIndex) public { 
            require(block.timestamp < endElection); // vote is allwed only if the election hasn't ended yet
            require(!voters[msg.sender].voted);

            voters[msg.sender].voted = true; //No longer give the right to vote the 2nd time
            voters[msg.sender].voteIndex = voteIndex; //Increase the vote of the candidate everytime a new vote is set

            candidates[voteIndex].voteCount += voters[msg.sender].weight;




        }

        //ending the election before the stated time duration

        function end() public {
            require(msg.sender == owner);
            require(block.timestamp >= endElection);

            //getting the result of the Elections

            for(uint i = 0; i < candidates.length; i++){
               emit ElectionResult(candidates[i].name, candidates[i].voteCount);
            }
        }



    

}
