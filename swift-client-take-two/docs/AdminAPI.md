# AdminAPI

All URIs are relative to *https://localhost/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createNonModeratedTroov**](AdminAPI.md#createnonmoderatedtroov) | **POST** /admin/nonModeratedUpload/troov/create | Create a new troov date for this user without content moderation
[**deleteSupportRequestsForUser**](AdminAPI.md#deletesupportrequestsforuser) | **DELETE** /admin/deleteSupportRequestsForUser/{userId} | Delete all support requests for a user
[**getCacheHealthMetrics**](AdminAPI.md#getcachehealthmetrics) | **GET** /admin/cacheHealthMetrics | Get cache health metrics
[**getSupportRequestsForUser**](AdminAPI.md#getsupportrequestsforuser) | **GET** /admin/getSupportRequestsForUser/{userId} | Get all support requests for a user
[**getUserById**](AdminAPI.md#getuserbyid) | **GET** /admin/getUser/{userId} | Find a user profile by ID
[**getUserProfiles**](AdminAPI.md#getuserprofiles) | **GET** /admin/getAllUsers | Get all users
[**sendChatToAllActiveUsers**](AdminAPI.md#sendchattoallactiveusers) | **POST** /admin/sendChatToAllActiveUsers | Send a chat message to all active users
[**uploadNonModeratedProfilePhoto**](AdminAPI.md#uploadnonmoderatedprofilephoto) | **POST** /admin/nonModeratedUpload/profilePhoto/{userId} | Save profile photo without image moderation


# **createNonModeratedTroov**
```swift
    open class func createNonModeratedTroov(troov: Troov, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Create a new troov date for this user without content moderation

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let troov = troov(troovId: "troovId_example", createdBy: userProfileWithUserId(age: 123, activityInterests: [troovActivity(category: troovActivityCategory(), name: "name_example", emoji: "emoji_example")], almaMater: ["almaMater_example"], bio: "bio_example", company: "company_example", education: education(), ethnicity: [ethnicity()], firstName: "firstName_example", gender: gender(), height: userProfile_height(length: 123, unit: "unit_example"), interestedIn: [nil], lowResThumbnail: profileMedia(mediaId: "mediaId_example", mediaType: "mediaType_example", rank: 123, size: 123, mediaUrl: "mediaUrl_example", createdAt: Date()), numDatesCompleted: 123, numDatesFlaked: 123, occupation: "occupation_example", profileMedia: [nil], politics: politicalAffiliation(), relationshipInterests: [relationshipInterest()], religion: religion(), verified: false, userId: "userId_example"), status: troovStatus(), locationDetails: locationIndicator(hidden: false, queryableLocation: locationQueryable(name: "name_example", placeId: "placeId_example", queryableCoordinates: coordinates(latitude: 123, longitude: 123), queryableGeoHash: "queryableGeoHash_example", hiddenRadius: locationQueryable_hiddenRadius(length: 123, unit: "unit_example"), address: Address(streetNumber: "streetNumber_example", streetName: "streetName_example", unit: "unit_example", neighborhood: "neighborhood_example", city: "city_example", stateOrProvince: "stateOrProvince_example", postalCode: "postalCode_example", country: "country_example")), location: location(name: "name_example", placeId: "placeId_example", coordinates: nil, geoHash: "geoHash_example", address: nil), distanceFromSearchLocation: locationIndicator_distanceFromSearchLocation(length: 123, unit: "unit_example")), troovCoreDetails: troovCoreDetails(title: "title_example", details: "details_example", startTime: Date(), expenseRating: expenseRating(), tags: ["tags_example"], relationshipInterests: [nil]), matchRequests: [troovMatchRequest(status: "status_example", requester: nil, requestedAt: Date(), expiresAt: Date(), statusUpdatedAt: Date(), lastStatus: "lastStatus_example", openingChatMessage: "openingChatMessage_example", chatSessionId: "chatSessionId_example", troovId: "troovId_example")], matchRequestsCount: 123, confirmedMatchRequest: nil, indexedFields: troov_indexedFields(matchRequestUserIds: ["matchRequestUserIds_example"], confirmedUserIds: ["confirmedUserIds_example"], notifyUserIds: ["notifyUserIds_example"], activityCategorySubLabels: ["activityCategorySubLabels_example"]), createdAt: Date(), lastUpdatedAt: Date(), participantReviews: [troovReview(troovReviewId: "troovReviewId_example", reviewerUserId: "reviewerUserId_example", troovCreatorUserId: "troovCreatorUserId_example", rating: 123, notes: "notes_example", allParticipantsShowedUp: false, participantsMatchedProfileAttributes: false, createdAt: Date(), lastUpdatedAt: Date())], viewedBy: ["viewedBy_example"], distinctViewsCount: 123, suitabilityScore: 123, activitySubLabels: [nil], activityCategories: [nil], isTestTroov: false) // Troov | New troov to be created

// Create a new troov date for this user without content moderation
AdminAPI.createNonModeratedTroov(troov: troov) { (response, error) in
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

# **deleteSupportRequestsForUser**
```swift
    open class func deleteSupportRequestsForUser(userId: String, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Delete all support requests for a user

Deletes all support requests for a user

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let userId = "userId_example" // String | The User Id

// Delete all support requests for a user
AdminAPI.deleteSupportRequestsForUser(userId: userId) { (response, error) in
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
 **userId** | **String** | The User Id | 

### Return type

Void (empty response body)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getCacheHealthMetrics**
```swift
    open class func getCacheHealthMetrics(completion: @escaping (_ data: [CacheHealthMetrics]?, _ error: Error?) -> Void)
```

Get cache health metrics

Returns cache health metrics

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient


// Get cache health metrics
AdminAPI.getCacheHealthMetrics() { (response, error) in
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

[**[CacheHealthMetrics]**](CacheHealthMetrics.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getSupportRequestsForUser**
```swift
    open class func getSupportRequestsForUser(userId: String, completion: @escaping (_ data: [SupportChatResponse]?, _ error: Error?) -> Void)
```

Get all support requests for a user

Returns all support requests for a user

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let userId = "userId_example" // String | The User Id

// Get all support requests for a user
AdminAPI.getSupportRequestsForUser(userId: userId) { (response, error) in
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
 **userId** | **String** | The User Id | 

### Return type

[**[SupportChatResponse]**](SupportChatResponse.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getUserById**
```swift
    open class func getUserById(userId: String, completion: @escaping (_ data: User?, _ error: Error?) -> Void)
```

Find a user profile by ID

Returns a single profile object

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let userId = "userId_example" // String | ID of user profile

// Find a user profile by ID
AdminAPI.getUserById(userId: userId) { (response, error) in
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

[**User**](User.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getUserProfiles**
```swift
    open class func getUserProfiles(completion: @escaping (_ data: [UserProfile]?, _ error: Error?) -> Void)
```

Get all users

Returns all user profiles

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient


// Get all users
AdminAPI.getUserProfiles() { (response, error) in
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

[**[UserProfile]**](UserProfile.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **sendChatToAllActiveUsers**
```swift
    open class func sendChatToAllActiveUsers(body: String, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Send a chat message to all active users

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let body = "body_example" // String | Chat message to be sent

// Send a chat message to all active users
AdminAPI.sendChatToAllActiveUsers(body: body) { (response, error) in
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
 **body** | **String** | Chat message to be sent | 

### Return type

Void (empty response body)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: text/plain
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **uploadNonModeratedProfilePhoto**
```swift
    open class func uploadNonModeratedProfilePhoto(userId: String, profilePhoto: URL? = nil, profilePhotoRank: ProfilePhotoRank_uploadNonModeratedProfilePhoto? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Save profile photo without image moderation

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let userId = "userId_example" // String | The User Id
let profilePhoto = URL(string: "https://example.com")! // URL |  (optional)
let profilePhotoRank = "profilePhotoRank_example" // String |  (optional) (default to ._0)

// Save profile photo without image moderation
AdminAPI.uploadNonModeratedProfilePhoto(userId: userId, profilePhoto: profilePhoto, profilePhotoRank: profilePhotoRank) { (response, error) in
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
 **userId** | **String** | The User Id | 
 **profilePhoto** | **URL** |  | [optional] 
 **profilePhotoRank** | **String** |  | [optional] [default to ._0]

### Return type

Void (empty response body)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: multipart/form-data
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

