// SPDX-License-Identifier: MIT
pragma solidity 0.8.31;

contract tips {

    address owner;

    constructor() {
        owner = msg.sender;
    }

    // =========================
    // Modifiers
    // =========================

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call");
        _;
    }

    // =========================
    // Fund Functions
    // =========================

    // 1. Put fund in smart contract
    function addtips() public payable {}

    // 2. View balance
    function viewtips() public view returns (uint) {
        return address(this).balance;
    }

    // =========================
    // Waitress Structure
    // =========================

    struct Waitress {
        address payable walletAddress;
        string name;
        uint percent;
    }

    Waitress[] waitress;

    // 5. View waitress
    function viewWaitress() public view returns (Waitress[] memory) {
        return waitress;
    }

    // =========================
    // Internal Transfer
    // =========================

    function _transferFunds(address payable recipient, uint amount) internal {
        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Transfer failed.");
    }

    // =========================
    // Distribute Balance
    // =========================

function distributeBalance() public {
    require(address(this).balance > 0, "No Money");
    require(waitress.length > 0, "No Waitress");

    uint totalamount = address(this).balance;
    uint totalPercent = 0;

    // รวม percent ทั้งหมด
    for (uint i = 0; i < waitress.length; i++) {
        totalPercent += waitress[i].percent;
    }

    require(totalPercent > 0, "Invalid percent");

    // แจกเงินตามสัดส่วนจริง
    for (uint j = 0; j < waitress.length; j++) {
        uint distributeAmount =
            (totalamount * waitress[j].percent) / totalPercent;

        _transferFunds(
            waitress[j].walletAddress,
            distributeAmount
        );
    }
}

    // =========================
    // Remove Waitress
    // =========================

    function removeWaitress(address walletAddress) public onlyOwner {
        if (waitress.length >= 1) {
            for (uint i = 0; i < waitress.length; i++) {
                if (waitress[i].walletAddress == walletAddress) {

                    // Shift elements left
                    for (uint j = i; j < waitress.length - 1; j++) {
                        waitress[j] = waitress[j + 1];
                    }

                    waitress.pop();
                    break;
                }
            }
        }
    }

    // =========================
    // Add Waitress
    // =========================

function addWaitress(
    address payable walletAddress,
    string memory name,
    uint percent
) public onlyOwner {

    bool waitressExist = false;
    uint totalPercent = percent; // เริ่มจาก percent ที่จะเพิ่ม

    for (uint i = 0; i < waitress.length; i++) {

        // เช็คซ้ำ address
        if (waitress[i].walletAddress == walletAddress) {
            waitressExist = true;
        }

        // รวม percent เดิม
        totalPercent += waitress[i].percent;
    }

    // 🔥 ฟ้อง error ถ้าเกิน 100%
    require(totalPercent <= 100, "Total percent exceeds 100%");

    if (!waitressExist) {
        waitress.push(
            Waitress(walletAddress, name, percent)
        );
    }
}
}