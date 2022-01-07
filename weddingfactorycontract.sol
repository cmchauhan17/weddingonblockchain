pragma solidity ^0.4.19;

contract MarriageNotary {

    //creating a factory of certifictaes i.e. creating an array which will store all certificates
    address [] public registeredMarriages;

    //event creating bcs of promise to deliver us the newcertificates address
    event ContractCreated(address contractAddress);

    function createMarriage(string _leftName, string _leftVows, string _rightName, string _rightVows, uint _date) public{
        address newMarriage = new Marriage(msg.sender, _leftName, _leftVows, _rightName, _rightVows, _date);

        //emits the event
        emit ContractCreated(newMarriage);

        //saving the address so that a frontend client can access it
        registeredMarriages.push(newMarriage);
    }

    //helper function to so your webClient can easily retrieve all certificates created by this factory
    function getDeployedMarriages() public view returns (address []){
        return registeredMarriages;
    }
}

contract Marriage {
    // You will declare your global vars here

    // Set owner public var, so everyone can see who owns the contract
    address public owner;

    //Marriage contract details
    string public leftName;
    string public leftVows;
    string public rightName;
    string public rightVows;
    uint public marriageDate;

    constructor(address _owner, string _leftName, string _leftVows, string _rightName, string _rightVows, uint _date) public {
        // You will instantiate your contract here
        owner = _owner;
        leftName = _leftName;
        leftVows = _leftVows;
        rightName = _rightName;
        rightVows = _rightVows;
        marriageDate = _date;
    }

    //ringBell is a payable function that allows people to celebrate the couple's marriage by sending Ethers to the
    //to the marriage contract

    function ringBell() public payable {
        require(msg.value > .0001 ether);
    }

    //Reusable modifier function

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    //To use a modifier, append it to the end of the function

    function collect() external onlyOwner {
        owner.transfer(address(this).balance);
    }

    //Allow only owners to check the balance of the contract

    function getBalance() public view onlyOwner returns (uint) {
        return address(this).balance;
    }
}
