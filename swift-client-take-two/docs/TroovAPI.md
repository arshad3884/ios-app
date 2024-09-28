# TroovAPI

All URIs are relative to *https://localhost/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**acceptJoinRequestFromUser**](TroovAPI.md#acceptjoinrequestfromuser) | **PUT** /troov/{troovId}/confirm/{userId} | Cancel troov user
[**cancelTroovForUser**](TroovAPI.md#canceltroovforuser) | **PUT** /troov/{troovId}/cancelTroovForUser/{userId} | Cancel user&#39;s troov
[**cancelTroovJoinRequestForUser**](TroovAPI.md#canceltroovjoinrequestforuser) | **PUT** /troov/{troovId}/cancelJoinRequestForUser/{userId} | Cancel user join request for this troov
[**createTroovForUser**](TroovAPI.md#createtroovforuser) | **POST** /troov/create | Create a new troov date for this user
[**declineJoinRequestFromUser**](TroovAPI.md#declinejoinrequestfromuser) | **PUT** /troov/{troovId}/declineJoinRequestFromUser/{userId} | Decline join request from user
[**deleteTroov**](TroovAPI.md#deletetroov) | **DELETE** /troov/delete/{troovId} | Delete a troov
[**getAllCompletedTroovs**](TroovAPI.md#getallcompletedtroovs) | **GET** /troov/status/completed/{userId} | Get all troovs with status completed for user
[**getAllConfirmedAndPendingReviewTroovs**](TroovAPI.md#getallconfirmedandpendingreviewtroovs) | **GET** /troov/status/confirmedAndPendingReview/{userId} | Get all troovs with status confirmed and pending review for user
[**getAllConfirmedTroovs**](TroovAPI.md#getallconfirmedtroovs) | **GET** /troov/status/confirmed/{userId} | Get all troovs with status confirmed for user
[**getAllPendingTroovs**](TroovAPI.md#getallpendingtroovs) | **GET** /troov/status/open/{userId} | Get all troovs created by the user with status OPEN
[**getPendingMatchRequestsForTroov**](TroovAPI.md#getpendingmatchrequestsfortroov) | **GET** /troov/{troovId}/pendingMatchRequests | Get all match requests which are pending for this troov
[**getPendingTroovPicksForUser**](TroovAPI.md#getpendingtroovpicksforuser) | **GET** /troov/createdBy/{userId}/status/open | Get all troovs created by this user with status open
[**getTroovActivityTaxonomy**](TroovAPI.md#gettroovactivitytaxonomy) | **GET** /troov/getTroovActivityTaxonomy | Get all troov activity taxonomy
[**getTroovById**](TroovAPI.md#gettroovbyid) | **GET** /troov/{troovId} | Find a troov by ID
[**getTroovByIdWithImageDownloadUrls**](TroovAPI.md#gettroovbyidwithimagedownloadurls) | **GET** /troov/{troovId}/withImageDownloadUrls | Find a troov by ID with image download URLs
[**getTroovsCreatedByUser**](TroovAPI.md#gettroovscreatedbyuser) | **GET** /troov/createdBy/{userId} | Get all troovs created by this user
[**getTroovsWithPendingJoinRequestsForUser**](TroovAPI.md#gettroovswithpendingjoinrequestsforuser) | **GET** /troov/getTroovsWithPendingJoinRequestsForUser/{userId} | Get all troovs with a pending join request for this user
[**markTroovAsViewedByUser**](TroovAPI.md#marktroovasviewedbyuser) | **PUT** /troov/{troovId}/viewedBy/{userId} | Mark troov as viewed by user
[**requestToJoinTroov**](TroovAPI.md#requesttojointroov) | **PUT** /troov/{troovId}/requestToJoinTroov/{userId} | Update troov with interested user
[**reviewFromParticipant**](TroovAPI.md#reviewfromparticipant) | **PUT** /troov/{troovId}/reviewFromParticipant/{userId} | Review a troov participant
[**updateTroov**](TroovAPI.md#updatetroov) | **PUT** /troov/{troovId} | Update an existing troov


# **acceptJoinRequestFromUser**
```swift
    open class func acceptJoinRequestFromUser(troovId: String, userId: String, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Cancel troov user

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let troovId = "troovId_example" // String | Id of troov
let userId = "userId_example" // String | Id of user to be confirmed

// Cancel troov user
TroovAPI.acceptJoinRequestFromUser(troovId: troovId, userId: userId) { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **troovId** | **String** | Id of troov | 
 **userId** | **String** | Id of user to be confirmed | 

### Return type

Void (empty response body)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **cancelTroovForUser**
```swift
    open class func cancelTroovForUser(troovId: String, userId: String, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Cancel user's troov

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let troovId = "troovId_example" // String | Id of troov
let userId = "userId_example" // String | Id of user

// Cancel user's troov
TroovAPI.cancelTroovForUser(troovId: troovId, userId: userId) { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **troovId** | **String** | Id of troov | 
 **userId** | **String** | Id of user | 

### Return type

Void (empty response body)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **cancelTroovJoinRequestForUser**
```swift
    open class func cancelTroovJoinRequestForUser(troovId: String, userId: String, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Cancel user join request for this troov

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let troovId = "troovId_example" // String | Id of troov
let userId = "userId_example" // String | Id of user

// Cancel user join request for this troov
TroovAPI.cancelTroovJoinRequestForUser(troovId: troovId, userId: userId) { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **troovId** | **String** | Id of troov | 
 **userId** | **String** | Id of user | 

### Return type

Void (empty response body)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createTroovForUser**
```swift
    open class func createTroovForUser(troov: Troov, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Create a new troov date for this user

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let troov = troov(troovId: "troovId_example", createdBy: userProfileWithUserId(age: 123, activityInterests: [troovActivity(category: troovActivityCategory(), name: "name_example", emoji: "emoji_example")], almaMater: ["almaMater_example"], bio: "bio_example", company: "company_example", education: education(), ethnicity: [ethnicity()], firstName: "firstName_example", gender: gender(), height: userProfile_height(length: 123, unit: "unit_example"), interestedIn: [nil], lowResThumbnail: profileMedia(mediaId: "mediaId_example", mediaType: "mediaType_example", rank: 123, size: 123, mediaUrl: "mediaUrl_example", createdAt: Date()), numDatesCompleted: 123, numDatesFlaked: 123, occupation: "occupation_example", profileMedia: [nil], politics: politicalAffiliation(), relationshipInterests: [relationshipInterest()], religion: religion(), verified: false, userId: "userId_example"), status: troovStatus(), locationDetails: locationIndicator(hidden: false, queryableLocation: locationQueryable(name: "name_example", placeId: "placeId_example", queryableCoordinates: coordinates(latitude: 123, longitude: 123), queryableGeoHash: "queryableGeoHash_example", hiddenRadius: locationQueryable_hiddenRadius(length: 123, unit: "unit_example"), address: Address(streetNumber: "streetNumber_example", streetName: "streetName_example", unit: "unit_example", neighborhood: "neighborhood_example", city: "city_example", stateOrProvince: "stateOrProvince_example", postalCode: "postalCode_example", country: "country_example")), location: location(name: "name_example", placeId: "placeId_example", coordinates: nil, geoHash: "geoHash_example", address: nil), distanceFromSearchLocation: locationIndicator_distanceFromSearchLocation(length: 123, unit: "unit_example")), troovCoreDetails: troovCoreDetails(title: "title_example", details: "details_example", startTime: Date(), expenseRating: expenseRating(), tags: ["tags_example"], relationshipInterests: [nil]), matchRequests: [troovMatchRequest(status: "status_example", requester: nil, requestedAt: Date(), expiresAt: Date(), statusUpdatedAt: Date(), lastStatus: "lastStatus_example", openingChatMessage: "openingChatMessage_example", chatSessionId: "chatSessionId_example", troovId: "troovId_example")], matchRequestsCount: 123, confirmedMatchRequest: nil, indexedFields: troov_indexedFields(matchRequestUserIds: ["matchRequestUserIds_example"], confirmedUserIds: ["confirmedUserIds_example"], notifyUserIds: ["notifyUserIds_example"], activityCategorySubLabels: ["activityCategorySubLabels_example"]), createdAt: Date(), lastUpdatedAt: Date(), participantReviews: [troovReview(troovReviewId: "troovReviewId_example", reviewerUserId: "reviewerUserId_example", troovCreatorUserId: "troovCreatorUserId_example", rating: 123, notes: "notes_example", allParticipantsShowedUp: false, participantsMatchedProfileAttributes: false, createdAt: Date(), lastUpdatedAt: Date())], viewedBy: ["viewedBy_example"], distinctViewsCount: 123, suitabilityScore: 123, activitySubLabels: [nil], activityCategories: [nil], isTestTroov: false) // Troov | New troov to be created

// Create a new troov date for this user
TroovAPI.createTroovForUser(troov: troov) { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **troov** | [**Troov**](Troov.md) | New troov to be created | 

### Return type

Void (empty response body)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **declineJoinRequestFromUser**
```swift
    open class func declineJoinRequestFromUser(troovId: String, userId: String, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Decline join request from user

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let troovId = "troovId_example" // String | Id of troov
let userId = "userId_example" // String | Id of user

// Decline join request from user
TroovAPI.declineJoinRequestFromUser(troovId: troovId, userId: userId) { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **troovId** | **String** | Id of troov | 
 **userId** | **String** | Id of user | 

### Return type

Void (empty response body)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteTroov**
```swift
    open class func deleteTroov(troovId: String, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Delete a troov

Deletes a troov

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let troovId = "troovId_example" // String | ID of troov

// Delete a troov
TroovAPI.deleteTroov(troovId: troovId) { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **troovId** | **String** | ID of troov | 

### Return type

Void (empty response body)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getAllCompletedTroovs**
```swift
    open class func getAllCompletedTroovs(userId: String, completion: @escaping (_ data: [Troov]?, _ error: Error?) -> Void)
```

Get all troovs with status completed for user

Returns a list of all user's completed troovs

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let userId = "userId_example" // String | ID of user profile

// Get all troovs with status completed for user
TroovAPI.getAllCompletedTroovs(userId: userId) { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userId** | **String** | ID of user profile | 

### Return type

[**[Troov]**](Troov.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getAllConfirmedAndPendingReviewTroovs**
```swift
    open class func getAllConfirmedAndPendingReviewTroovs(userId: String, completion: @escaping (_ data: [Troov]?, _ error: Error?) -> Void)
```

Get all troovs with status confirmed and pending review for user

Returns a list of all user's confirmed and pending review troovs

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let userId = "userId_example" // String | ID of user profile

// Get all troovs with status confirmed and pending review for user
TroovAPI.getAllConfirmedAndPendingReviewTroovs(userId: userId) { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userId** | **String** | ID of user profile | 

### Return type

[**[Troov]**](Troov.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getAllConfirmedTroovs**
```swift
    open class func getAllConfirmedTroovs(userId: String, completion: @escaping (_ data: [Troov]?, _ error: Error?) -> Void)
```

Get all troovs with status confirmed for user

Returns a list of all user's confirmed troovs

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let userId = "userId_example" // String | ID of user profile

// Get all troovs with status confirmed for user
TroovAPI.getAllConfirmedTroovs(userId: userId) { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userId** | **String** | ID of user profile | 

### Return type

[**[Troov]**](Troov.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getAllPendingTroovs**
```swift
    open class func getAllPendingTroovs(userId: String, completion: @escaping (_ data: [Troov]?, _ error: Error?) -> Void)
```

Get all troovs created by the user with status OPEN

Returns a list of all user's created troovs with status OPEN

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let userId = "userId_example" // String | ID of user profile

// Get all troovs created by the user with status OPEN
TroovAPI.getAllPendingTroovs(userId: userId) { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userId** | **String** | ID of user profile | 

### Return type

[**[Troov]**](Troov.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getPendingMatchRequestsForTroov**
```swift
    open class func getPendingMatchRequestsForTroov(troovId: String, completion: @escaping (_ data: [TroovMatchRequest]?, _ error: Error?) -> Void)
```

Get all match requests which are pending for this troov

Returns all troov's pending match requests

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let troovId = "troovId_example" // String | Id of troov

// Get all match requests which are pending for this troov
TroovAPI.getPendingMatchRequestsForTroov(troovId: troovId) { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **troovId** | **String** | Id of troov | 

### Return type

[**[TroovMatchRequest]**](TroovMatchRequest.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getPendingTroovPicksForUser**
```swift
    open class func getPendingTroovPicksForUser(userId: String, completion: @escaping (_ data: [Troov]?, _ error: Error?) -> Void)
```

Get all troovs created by this user with status open

Returns all user's open picks

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let userId = "userId_example" // String | Id of user

// Get all troovs created by this user with status open
TroovAPI.getPendingTroovPicksForUser(userId: userId) { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userId** | **String** | Id of user | 

### Return type

[**[Troov]**](Troov.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getTroovActivityTaxonomy**
```swift
    open class func getTroovActivityTaxonomy(completion: @escaping (_ data: [TroovActivity]?, _ error: Error?) -> Void)
```

Get all troov activity taxonomy

Returns all troov activity taxonomy

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient


// Get all troov activity taxonomy
TroovAPI.getTroovActivityTaxonomy() { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**[TroovActivity]**](TroovActivity.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getTroovById**
```swift
    open class func getTroovById(troovId: String, completion: @escaping (_ data: Troov?, _ error: Error?) -> Void)
```

Find a troov by ID

Returns a single troov date

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let troovId = "troovId_example" // String | ID of troov

// Find a troov by ID
TroovAPI.getTroovById(troovId: troovId) { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **troovId** | **String** | ID of troov | 

### Return type

[**Troov**](Troov.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getTroovByIdWithImageDownloadUrls**
```swift
    open class func getTroovByIdWithImageDownloadUrls(troovId: String, completion: @escaping (_ data: Troov?, _ error: Error?) -> Void)
```

Find a troov by ID with image download URLs

Returns a single troov date with image download URLs

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let troovId = "troovId_example" // String | ID of troov

// Find a troov by ID with image download URLs
TroovAPI.getTroovByIdWithImageDownloadUrls(troovId: troovId) { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **troovId** | **String** | ID of troov | 

### Return type

[**Troov**](Troov.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getTroovsCreatedByUser**
```swift
    open class func getTroovsCreatedByUser(userId: String, completion: @escaping (_ data: [Troov]?, _ error: Error?) -> Void)
```

Get all troovs created by this user

Returns all user's troovs

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let userId = "userId_example" // String | Id of user

// Get all troovs created by this user
TroovAPI.getTroovsCreatedByUser(userId: userId) { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userId** | **String** | Id of user | 

### Return type

[**[Troov]**](Troov.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getTroovsWithPendingJoinRequestsForUser**
```swift
    open class func getTroovsWithPendingJoinRequestsForUser(userId: String, completion: @escaping (_ data: [Troov]?, _ error: Error?) -> Void)
```

Get all troovs with a pending join request for this user

Returns all user's pending join requests

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let userId = "userId_example" // String | Id of user

// Get all troovs with a pending join request for this user
TroovAPI.getTroovsWithPendingJoinRequestsForUser(userId: userId) { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userId** | **String** | Id of user | 

### Return type

[**[Troov]**](Troov.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **markTroovAsViewedByUser**
```swift
    open class func markTroovAsViewedByUser(troovId: String, userId: String, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Mark troov as viewed by user

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let troovId = "troovId_example" // String | Id of troov
let userId = "userId_example" // String | Id of user

// Mark troov as viewed by user
TroovAPI.markTroovAsViewedByUser(troovId: troovId, userId: userId) { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **troovId** | **String** | Id of troov | 
 **userId** | **String** | Id of user | 

### Return type

Void (empty response body)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **requestToJoinTroov**
```swift
    open class func requestToJoinTroov(troovId: String, userId: String, chat: Chat? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Update troov with interested user

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let troovId = "troovId_example" // String | Id of troov
let userId = "userId_example" // String | Id of user
let chat = chat(id: "id_example", createdAt: Date(), createdByUserId: "createdByUserId_example", createdByFirstName: "createdByFirstName_example", messageContent: "messageContent_example", likedByUserIds: ["likedByUserIds_example"]) // Chat | Opening chat message if applicable (optional)

// Update troov with interested user
TroovAPI.requestToJoinTroov(troovId: troovId, userId: userId, chat: chat) { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **troovId** | **String** | Id of troov | 
 **userId** | **String** | Id of user | 
 **chat** | [**Chat**](Chat.md) | Opening chat message if applicable | [optional] 

### Return type

Void (empty response body)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **reviewFromParticipant**
```swift
    open class func reviewFromParticipant(troovId: String, userId: String, troovReview: TroovReview? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Review a troov participant

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let troovId = "troovId_example" // String | Id of troov
let userId = "userId_example" // String | Id of user
let troovReview = troovReview(troovReviewId: "troovReviewId_example", reviewerUserId: "reviewerUserId_example", troovCreatorUserId: "troovCreatorUserId_example", rating: 123, notes: "notes_example", allParticipantsShowedUp: false, participantsMatchedProfileAttributes: false, createdAt: Date(), lastUpdatedAt: Date()) // TroovReview | New troov to be created (optional)

// Review a troov participant
TroovAPI.reviewFromParticipant(troovId: troovId, userId: userId, troovReview: troovReview) { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **troovId** | **String** | Id of troov | 
 **userId** | **String** | Id of user | 
 **troovReview** | [**TroovReview**](TroovReview.md) | New troov to be created | [optional] 

### Return type

Void (empty response body)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateTroov**
```swift
    open class func updateTroov(troovId: String, troov: Troov, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Update an existing troov

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let troovId = "troovId_example" // String | ID of troov
let troov = troov(troovId: "troovId_example", createdBy: userProfileWithUserId(age: 123, activityInterests: [troovActivity(category: troovActivityCategory(), name: "name_example", emoji: "emoji_example")], almaMater: ["almaMater_example"], bio: "bio_example", company: "company_example", education: education(), ethnicity: [ethnicity()], firstName: "firstName_example", gender: gender(), height: userProfile_height(length: 123, unit: "unit_example"), interestedIn: [nil], lowResThumbnail: profileMedia(mediaId: "mediaId_example", mediaType: "mediaType_example", rank: 123, size: 123, mediaUrl: "mediaUrl_example", createdAt: Date()), numDatesCompleted: 123, numDatesFlaked: 123, occupation: "occupation_example", profileMedia: [nil], politics: politicalAffiliation(), relationshipInterests: [relationshipInterest()], religion: religion(), verified: false, userId: "userId_example"), status: troovStatus(), locationDetails: locationIndicator(hidden: false, queryableLocation: locationQueryable(name: "name_example", placeId: "placeId_example", queryableCoordinates: coordinates(latitude: 123, longitude: 123), queryableGeoHash: "queryableGeoHash_example", hiddenRadius: locationQueryable_hiddenRadius(length: 123, unit: "unit_example"), address: Address(streetNumber: "streetNumber_example", streetName: "streetName_example", unit: "unit_example", neighborhood: "neighborhood_example", city: "city_example", stateOrProvince: "stateOrProvince_example", postalCode: "postalCode_example", country: "country_example")), location: location(name: "name_example", placeId: "placeId_example", coordinates: nil, geoHash: "geoHash_example", address: nil), distanceFromSearchLocation: locationIndicator_distanceFromSearchLocation(length: 123, unit: "unit_example")), troovCoreDetails: troovCoreDetails(title: "title_example", details: "details_example", startTime: Date(), expenseRating: expenseRating(), tags: ["tags_example"], relationshipInterests: [nil]), matchRequests: [troovMatchRequest(status: "status_example", requester: nil, requestedAt: Date(), expiresAt: Date(), statusUpdatedAt: Date(), lastStatus: "lastStatus_example", openingChatMessage: "openingChatMessage_example", chatSessionId: "chatSessionId_example", troovId: "troovId_example")], matchRequestsCount: 123, confirmedMatchRequest: nil, indexedFields: troov_indexedFields(matchRequestUserIds: ["matchRequestUserIds_example"], confirmedUserIds: ["confirmedUserIds_example"], notifyUserIds: ["notifyUserIds_example"], activityCategorySubLabels: ["activityCategorySubLabels_example"]), createdAt: Date(), lastUpdatedAt: Date(), participantReviews: [troovReview(troovReviewId: "troovReviewId_example", reviewerUserId: "reviewerUserId_example", troovCreatorUserId: "troovCreatorUserId_example", rating: 123, notes: "notes_example", allParticipantsShowedUp: false, participantsMatchedProfileAttributes: false, createdAt: Date(), lastUpdatedAt: Date())], viewedBy: ["viewedBy_example"], distinctViewsCount: 123, suitabilityScore: 123, activitySubLabels: [nil], activityCategories: [nil], isTestTroov: false) // Troov | Troov with updated details. Will only update fields provided

// Update an existing troov
TroovAPI.updateTroov(troovId: troovId, troov: troov) { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **troovId** | **String** | ID of troov | 
 **troov** | [**Troov**](Troov.md) | Troov with updated details. Will only update fields provided | 

### Return type

Void (empty response body)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

