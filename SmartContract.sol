// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title Fishpond Supply Chain Traceability
 * @author Legaspi, Cristan Irish P.
 * @notice System to track Tilapia batches from Farm to Distributor.
 */
contract FishpondTraceability {
    
    // 3. Status Updates (Requirement)
    enum Status { Created, InTransit, Delivered }

    struct Product {
        uint256 id;
        string batchNumber;      // BONUS: Batch Tracking
        string name;
        uint256 quantity; 
        uint256 pricePerKg;      // BONUS: Price Tracking
        string origin;
        uint256 dateCreated;     // BONUS: Timestamp Validation
        address currentOwner;
        Status status;
    }

    address public farmOwner;
    uint256 public productCount;
    
    // 6. Data Retrieval (Requirement)
    mapping(uint256 => Product) public products;
    mapping(uint256 => address[]) public history;

    event ProductRegistered(uint256 id, string batchNumber, address owner);
    event TransferInitiated(uint256 id, address from, address to, uint256 totalValue);
    event DeliveryConfirmed(uint256 id, address distributor);

    // 5. Access Control (Requirement)
    modifier onlyFarmOwner() {
        require(msg.sender == farmOwner, "Only the farmer can register products");
        _;
    }

    modifier onlyCurrentOwner(uint256 _id) {
        require(msg.sender == products[_id].currentOwner, "Not the current owner");
        _;
    }

    constructor() {
        farmOwner = msg.sender;
    }

    // 1. Product Registration (Requirement)
    function registerBatch(
        string memory _batchNum, 
        string memory _name, 
        uint256 _quantity, 
        uint256 _price, 
        string memory _origin
    ) public onlyFarmOwner {
        productCount++;
        products[productCount] = Product(
            productCount,
            _batchNum,
            _name,
            _quantity,
            _price,
            _origin,
            block.timestamp, // BONUS: Timestamp Validation
            farmOwner,
            Status.Created
        );
        
        history[productCount].push(farmOwner);
        emit ProductRegistered(productCount, _batchNum, farmOwner);
    }

    // 2 & 4. Ownership Tracking & Transfer Function (Requirement)
    function transferToDistributor(uint256 _id, address _newOwner) public onlyCurrentOwner(_id) {
        Product storage product = products[_id];
        require(product.status == Status.Created, "Batch must be in Created status to start transit");

        // BONUS: Payment Simulation (Price x Quantity)
        uint256 totalValue = product.quantity * product.pricePerKg;

        // Update Ownership & Status
        product.currentOwner = _newOwner;
        product.status = Status.InTransit;

        history[_id].push(_newOwner);
        emit TransferInitiated(_id, msg.sender, _newOwner, totalValue);
    }

    // NEW: Explicit Delivery Function
    function confirmDelivery(uint256 _id) public onlyCurrentOwner(_id) {
        Product storage product = products[_id];
        require(product.status == Status.InTransit, "Batch must be In Transit to confirm delivery");

        product.status = Status.Delivered;
        emit DeliveryConfirmed(_id, msg.sender);
    }

    // 6. Data Retrieval Functions
    function getProduct(uint256 _id) public view returns (Product memory) {
        return products[_id];
    }

    function getOwnershipHistory(uint256 _id) public view returns (address[] memory) {
        return history[_id];
    }

    // BONUS: QR Code Reference (Concept)
    function getQRCodeLink(uint256 _id) public view returns (string memory) {
        string memory baseURL = "https://irish-aquafarm.io/track?id=";
        return string(abi.encodePacked(baseURL, uintToString(_id)));
    }

    // BONUS: Freshness Validation
    function isBatchFresh(uint256 _id) public view returns (bool) {
        return (block.timestamp - products[_id].dateCreated) < 7 days;
    }

    // Helper for QR string conversion
    function uintToString(uint256 v) internal pure returns (string memory) {
        if (v == 0) return "0";
        uint256 j = v; uint256 len;
        while (j != 0) { len++; j /= 10; }
        bytes memory bstr = new bytes(len);
        uint256 k = len;
        while (v != 0) {
            k = k - 1;
            uint8 temp = (48 + uint8(v - (v / 10) * 10));
            bstr[k] = bytes1(temp);
            v /= 10;
        }
        return string(bstr);
    }
}