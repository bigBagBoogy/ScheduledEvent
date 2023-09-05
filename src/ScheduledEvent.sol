// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "src/DateTimeLibrary.sol";

contract ScheduledEvent {
    using DateTimeLibrary for uint256;

    uint256 constant SECONDS_PER_DAY = 24 * 60 * 60;
    uint256 constant SECONDS_PER_HOUR = 60 * 60;
    uint256 constant SECONDS_PER_MINUTE = 60;
    uint256 public s_executionThreshold; // Number of blocks or time before executing
    uint256 public targetTime; // next end of month (minutes from 1970/01/01)

    constructor() {
        // Get the current timestamp
        uint256 currentTime = getCurrentTime();

        // Calculate the timestamp for the end of the current month
        uint256 currentYear;
        uint256 currentMonth;
        (currentYear, currentMonth,) = timestampToDate(currentTime);

        // Add one to the current month to get the next month
        if (currentMonth == 12) {
            currentYear += 1;
            currentMonth = 1;
        } else {
            currentMonth += 1;
        }

        // Set the day to 1 and time to 00:00:00
        uint256 nextMonthStart = timestampFromDate(currentYear, currentMonth, 1);

        // Subtract one second to get the end of the current month
        targetTime = nextMonthStart - 1;
    }

    function getCurrentTime() public view returns (uint256) {
        return block.timestamp;
    }

    function calculateRemainingBlocks(uint256 targetBlockNumber) public view returns (uint256) {
        require(block.number < targetBlockNumber, "Event already passed");
        return targetBlockNumber - block.number;
    }

    function calculateRemainingTime(uint256 targetBlockNumber) public view returns (uint256) {
        require(block.number < targetBlockNumber, "Event already passed");
        uint256 timeCurrently = getCurrentTime();
        return targetBlockNumber - timeCurrently;
    }

    function convertTargetTimeToTargetBlockNumber(uint256 targetTime) public pure returns (uint256 targetBlockNumber) {
        // Use appropriate function from library to do this;
        targetTime = targetBlockNumber.toTimestamp();
    }

    function calculateAverageBlocktime(uint256 startingBlockNumber) public view returns (uint256) {
        uint256 timestamp = getCurrentTime();
        uint256 blocksMined = startingBlockNumber - block.number;
        uint256 minutesPassed = timestamp - startingBlockNumber.toTimestamp();
        return (minutesPassed == 0) ? 0 : (blocksMined * 1 minutes) / minutesPassed;
    }

    function scheduleEvent(uint256 targetBlockNumber) public {
        require(calculateRemainingBlocks(targetBlockNumber) <= s_executionThreshold, "Threshold not met");
        // Perform the event's action here
        // You might want to add more conditions or logic to ensure the event is executed correctly.
    }

    function getMinute(uint256 timestamp) internal pure returns (uint256 minute) {
        uint256 secs = timestamp % SECONDS_PER_HOUR;
        minute = secs / SECONDS_PER_MINUTE;
    }

    function addMinutes(uint256 timestamp, uint256 _minutes) internal pure returns (uint256 newTimestamp) {
        newTimestamp = timestamp + _minutes * SECONDS_PER_MINUTE;
        require(newTimestamp >= timestamp);
    }
}
