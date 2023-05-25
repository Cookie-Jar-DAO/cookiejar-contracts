## Cookie Jar

### Base CookieJar

CookieJar is a module for a DAO (Decentralized Autonomous Organization) or similar type of organization, that allows
certain members to make claims (potentially for funds or other assets) at certain intervals.

The contract is making use of several imported libraries and contracts, including those from Gnosis Safe Contracts,
Zodiac, and OpenZeppelin.

Below is a high-level overview of the contract:

---

## Overview

### State:

`PERC_POINTS` is a constant representing percentage points, used for calculations.

`POSTER_TAG` is a string constant used for tagging posts related to this contract.

`SUSTAINABILITY_FEE` is the fee charged on each transaction, set at 1%.

`POSTER_ADDR` and `SUSTAINABILITY_ADDR` are addresses for the poster and sustainability fee, respectively.

`cookieAmount` is the amount of "cookie" (possibly a token or other asset) that can be claimed.

`cookieToken` is the address of the token that is being distributed.

`periodLength` is the length of the period between claims.

claims is a mapping of addresses to timestamps, used to track when each address last made a claim.

---

### Events:

`Setup` is emitted when the contract is set up.

`GiveCookie` is emitted when a "cookie" is given to an address.

---

### Functions:

`setUp` is used to set up the contract, including the target Safe, period length, cookie amount, and cookie token.

`reachInJar` is a public function that can be called by members to make a claim. It checks if the caller is a member and
if the claim period is valid, gives the cookie to the caller or another specified address, and posts the reason for the
claim.

`giveCookie` is a private function that handles the transfer of the cookie to the specified address, after taking out
the sustainability fee.

`postReason` is an internal function that posts the reason for a claim, along with a unique identifier.

`assessReason` allows members to assess the reason for a claim, either up or down.

`canClaim` is a view function that checks if the caller is able to make a claim.

`isAllowList` is a view function that checks if the caller is a member. Currently, it always returns true, but it is
marked as virtual, indicating that it is expected to be overridden in a derived contract.

`isValidClaimPeriod` is a view function that checks if the caller is within the valid claim period.

`bytes32ToString` is a utility function that converts a bytes32 value to a string.

This contract can be seen as a fundamental part of a larger ecosystem where members can claim tokens or other assets,
provide reasons for their claims, and assess others' claims. The purpose of the sustainability fee and its use are not
detailed in this contract, but one can assume it goes towards maintaining the system or funding communal resources.
