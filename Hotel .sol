// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract hotel{

    uint256 roomsAvailable;
    uint256 roomsBooked;
    uint256 costOfRoom;
    
    struct Room{
        bool reserved;
        address guest;
        uint256 checkInDate;
    }

    struct Guest{
        uint256 roomNo;
        string name;
        uint256 contactNo;
        string email;
        uint256 guestNum;
        address guest;
    }

    constructor (uint256 _roomsAvailable,uint256 _roomsBooked,uint256 _costOfRoom){
        roomsAvailable=_roomsAvailable;
        roomsBooked=_roomsBooked;
        costOfRoom=_costOfRoom;
    }

    mapping (uint256=>Room) public Rooms;
    mapping (address=>Guest) public Guests;


    event roomBooking(uint256 checkInDate,uint256 price,uint256 roomNo,address guset);
    event romCancelling(uint refund,uint256 roomNo);

    function bookRoom(uint256 _roomNo,uint256 _checkInDate,string memory _name,uint256 _contactNo,string memory _email,uint256 _guestNum)public payable{
        require(roomsAvailable<0,"There are no rooms available");
        require(_roomNo>0&&_roomNo<roomsAvailable,"Room dosen't exist");
        require(msg.value>=costOfRoom,"Cost of one room is more than paid amount");
        require(Rooms[_roomNo].reserved==false,"The room is already reserved");

        roomsAvailable-=1;
        roomsBooked+=1;
        Rooms[_roomNo].reserved=true;
        Rooms[_roomNo].guest=msg.sender;
        Rooms[_roomNo].checkInDate=_checkInDate;

        Guests[msg.sender].name=_name;
        Guests[msg.sender].guestNum=_guestNum;
        Guests[msg.sender].email=_email;
        Guests[msg.sender].contactNo=_contactNo;
        Guests[msg.sender].roomNo=_roomNo;

        //emit roomBooking(_checkInDate,_);
    }

    function cancelRoom(uint256 _roomNo,uint256 _today)public {
        require(Rooms[_roomNo].reserved == true,"There is no room to cancel");
        require(Guests[msg.sender].roomNo == _roomNo,"You did not book this room");

        roomsAvailable+=1;
        roomsBooked-=1;
        Rooms[_roomNo].reserved=false;
        uint256 refund=0;
        uint256 checkInDate=Rooms[_roomNo].checkInDate;
        if(checkInDate-_today<=2){
            refund=0;
        }
        else if (checkInDate-_today>=7){
            refund=costOfRoom;
        }else{
            refund=costOfRoom/2;
        }
    }


}
