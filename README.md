# SmartContract.sol

Midterm Part 1
Project Information
Project Title: Irish Fin-Tech Aquafarm Lifecycle Tracker

Developer: Legaspi, Cristan Irish P.

Selected Farm Business: Fishpond (Tilapia Farming/Production)

Description of System
The Irish Fin-Tech Aquafarm system is a blockchain-based traceability solution designed to monitor the lifecycle of aquaculture products. By utilizing the Ethereum blockchain, the system ensures that every batch of Tilapia is tracked from the farm to the distributor with absolute transparency. This prevents data tampering and provides a verified audit trail for food safety, freshness verification, and business integrity.

Contract Features
Product Registration: Allows the authorized farmer to log new fish batches with unique IDs, batch numbers, pricing, and farm origin details.

Ownership Tracking: Real-time recording of the current holder (Farmer or Distributor) of the Tilapia batch.

Status Updates: A three-stage lifecycle: Created (0), InTransit (1), and Delivered (2).

Automatic Transfer Logic: When a product is transferred to a distributor, the status is automatically updated to "In Transit" to maintain data accuracy.

Access Control: Secured functions using onlyFarmOwner and onlyCurrentOwner modifiers ensure only the "Farmer" can register products, and only the "Current Owner" can move or confirm delivery.

Data Retrieval: Public functions to view full batch details, the complete ownership audit history, and generated QR tracking links.

[Bonus] Freshness Validation: A built-in logic check that flags whether a batch was harvested within the last 7 days to ensure premium quality.

Sample Test Steps (Remix IDE)
1. Deployment
Action: Deploy the contract using the first account in Remix.

Explanation: This address is automatically set as the farmOwner.

2. Product Registration (Requirement 1 & 5)
Action: Call registerBatch with details (e.g., "TLP-001", "Premium Tilapia", 500, 180, "Pampanga Pond A").

Explanation: This locks the harvest data onto the blockchain. Only the Farmer can perform this.

3. Data & Bonus Verification (Requirement 6)
Action: Call getProduct(1), isBatchFresh(1), and getQRCodeLink(1).

Explanation: Displays all stored data, confirms the fish is fresh (harvested <7 days ago), and generates a conceptual QR tracking URL.

4. Ownership Transfer (Requirement 2 & 4)
Action: Paste a second address (Distributor) into transferToDistributor(1, [Address]).

Explanation: Transfers legal ownership and calculates the total shipment value (Quantity × Price).

5. Status Transition (Requirement 3)
Action: Call getProduct(1) again.

Explanation: The status will automatically reflect 1 (InTransit).

6. Delivery Confirmation (Requirement 3)
Action: Switch to the Distributor’s account and call confirmDelivery(1).

Explanation: The status updates to 2 (Delivered), completing the lifecycle.
