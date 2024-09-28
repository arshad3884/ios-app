# UserAPI

All URIs are relative to *https://localhost/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**activateUser**](UserAPI.md#activateuser) | **PUT** /user/activate/{userId} | Activate user
[**createUser**](UserAPI.md#createuser) | **POST** /user | Create a new user
[**deactivateUser**](UserAPI.md#deactivateuser) | **PUT** /user/deactivate/{userId} | Deactivate user
[**deleteUser**](UserAPI.md#deleteuser) | **DELETE** /user/delete/{userId} | Delete a user
[**getProfileState**](UserAPI.md#getprofilestate) | **GET** /user/profileState/{userId} | Retrieve activation state of user
[**getUserById**](UserAPI.md#getuserbyid) | **GET** /user/{userId} | Find a user by ID
[**getUserProfileById**](UserAPI.md#getuserprofilebyid) | **GET** /user/profile/{userId} | Find a user profile by ID
[**updateUser**](UserAPI.md#updateuser) | **PUT** /user/{userId} | Update an existing user
[**updateUserProfile**](UserAPI.md#updateuserprofile) | **PUT** /user/profile/{userId} | Update an existing user profile


# **activateUser**
```swift
    open class func activateUser(userId: String, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Activate user

Activates user

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let userId = "userId_example" // String | ID of user to be activated

// Activate user
UserAPI.activateUser(userId: userId) { (response, error) in
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
 **userId** | **String** | ID of user to be activated | 

### Return type

Void (empty response body)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createUser**
```swift
    open class func createUser(user: User, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Create a new user

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let user = user(userId: "userId_example", firstName: "firstName_example", lastName: "lastName_example", active: false, dateOfBirth: 123, email: "email_example", heardOfTroovFrom: marketingChannels(), phoneNumber: phoneNumber(countryName: countryName(), countryCode: countryCode(), countryPhoneCode: countryPhoneCode(), localNumber: "localNumber_example"), numCredits: 123, phoneNumberVerification: phoneVerification(verified: false, latestVerificationCode: 123, latestVerificationId: "latestVerificationId_example", lastVerifiedAt: Date(), verificationCodesSentCount: 123, verificationFailedAttemptsCount: 123, verificationCodeSentAt: Date(), verificationExpiresAt: Date()), iOSDeviceToken: "iOSDeviceToken_example", lastLoggedInAt: Date(), lastUpdatedAt: Date(), createdAt: Date(), userProfile: userProfile(age: 123, activityInterests: [troovActivity(category: troovActivityCategory(), name: "name_example", emoji: "emoji_example")], almaMater: ["almaMater_example"], bio: "bio_example", company: "company_example", education: education(), ethnicity: [ethnicity()], firstName: "firstName_example", gender: gender(), height: userProfile_height(length: 123, unit: "unit_example"), interestedIn: [nil], lowResThumbnail: profileMedia(mediaId: "mediaId_example", mediaType: "mediaType_example", rank: 123, size: 123, mediaUrl: "mediaUrl_example", createdAt: Date()), numDatesCompleted: 123, numDatesFlaked: 123, occupation: "occupation_example", profileMedia: [nil], politics: politicalAffiliation(), relationshipInterests: [relationshipInterest()], religion: religion(), verified: false), blockedUsers: [blockUserRequest(blockeDate: Date(), blockedUserId: "blockedUserId_example", blockerUserId: "blockerUserId_example", uid: "uid_example")], registrationStatus: registrationStep(), troovReviews: [troovReview(troovReviewId: "troovReviewId_example", reviewerUserId: "reviewerUserId_example", troovCreatorUserId: "troovCreatorUserId_example", rating: 123, notes: "notes_example", allParticipantsShowedUp: false, participantsMatchedProfileAttributes: false, createdAt: Date(), lastUpdatedAt: Date())], usageStatistics: usageStatistics(troovsCreatedCount: 123, troovsConfirmedCount: 123, troovJoinRequestsCount: 123, troovsViewedCount: 123), isTestUser: false) // User | New user to be created

// Create a new user
UserAPI.createUser(user: user) { (response, error) in
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
 **user** | [**User**](User.md) | New user to be created | 

### Return type

Void (empty response body)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deactivateUser**
```swift
    open class func deactivateUser(userId: String, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Deactivate user

Deactivate user

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let userId = "userId_example" // String | ID of user to be deactivated

// Deactivate user
UserAPI.deactivateUser(userId: userId) { (response, error) in
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
 **userId** | **String** | ID of user to be deactivated | 

### Return type

Void (empty response body)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteUser**
```swift
    open class func deleteUser(userId: String, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Delete a user

Deletes a user

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let userId = "userId_example" // String | ID of user

// Delete a user
UserAPI.deleteUser(userId: userId) { (response, error) in
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
 **userId** | **String** | ID of user | 

### Return type

Void (empty response body)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getProfileState**
```swift
    open class func getProfileState(userId: String, completion: @escaping (_ data: Bool?, _ error: Error?) -> Void)
```

Retrieve activation state of user

Retrieves activation state of user

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let userId = "userId_example" // String | ID of user

// Retrieve activation state of user
UserAPI.getProfileState(userId: userId) { (response, error) in
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
 **userId** | **String** | ID of user | 

### Return type

**Bool**

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

Find a user by ID

Returns a single user object

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let userId = "userId_example" // String | ID of user profile

// Find a user by ID
UserAPI.getUserById(userId: userId) { (response, error) in
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

# **getUserProfileById**
```swift
    open class func getUserProfileById(userId: String, completion: @escaping (_ data: UserProfile?, _ error: Error?) -> Void)
```

Find a user profile by ID

Returns a single profile object

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let userId = "userId_example" // String | ID of user profile

// Find a user profile by ID
UserAPI.getUserProfileById(userId: userId) { (response, error) in
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

[**UserProfile**](UserProfile.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateUser**
```swift
    open class func updateUser(userId: String, user: User, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Update an existing user

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let userId = "userId_example" // String | ID of user profile
let user = user(userId: "userId_example", firstName: "firstName_example", lastName: "lastName_example", active: false, dateOfBirth: 123, email: "email_example", heardOfTroovFrom: marketingChannels(), phoneNumber: phoneNumber(countryName: countryName(), countryCode: countryCode(), countryPhoneCode: countryPhoneCode(), localNumber: "localNumber_example"), numCredits: 123, phoneNumberVerification: phoneVerification(verified: false, latestVerificationCode: 123, latestVerificationId: "latestVerificationId_example", lastVerifiedAt: Date(), verificationCodesSentCount: 123, verificationFailedAttemptsCount: 123, verificationCodeSentAt: Date(), verificationExpiresAt: Date()), iOSDeviceToken: "iOSDeviceToken_example", lastLoggedInAt: Date(), lastUpdatedAt: Date(), createdAt: Date(), userProfile: userProfile(age: 123, activityInterests: [troovActivity(category: troovActivityCategory(), name: "name_example", emoji: "emoji_example")], almaMater: ["almaMater_example"], bio: "bio_example", company: "company_example", education: education(), ethnicity: [ethnicity()], firstName: "firstName_example", gender: gender(), height: userProfile_height(length: 123, unit: "unit_example"), interestedIn: [nil], lowResThumbnail: profileMedia(mediaId: "mediaId_example", mediaType: "mediaType_example", rank: 123, size: 123, mediaUrl: "mediaUrl_example", createdAt: Date()), numDatesCompleted: 123, numDatesFlaked: 123, occupation: "occupation_example", profileMedia: [nil], politics: politicalAffiliation(), relationshipInterests: [relationshipInterest()], religion: religion(), verified: false), blockedUsers: [blockUserRequest(blockeDate: Date(), blockedUserId: "blockedUserId_example", blockerUserId: "blockerUserId_example", uid: "uid_example")], registrationStatus: registrationStep(), troovReviews: [troovReview(troovReviewId: "troovReviewId_example", reviewerUserId: "reviewerUserId_example", troovCreatorUserId: "troovCreatorUserId_example", rating: 123, notes: "notes_example", allParticipantsShowedUp: false, participantsMatchedProfileAttributes: false, createdAt: Date(), lastUpdatedAt: Date())], usageStatistics: usageStatistics(troovsCreatedCount: 123, troovsConfirmedCount: 123, troovJoinRequestsCount: 123, troovsViewedCount: 123), isTestUser: false) // User | User object to be updated

// Update an existing user
UserAPI.updateUser(userId: userId, user: user) { (response, error) in
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
 **user** | [**User**](User.md) | User object to be updated | 

### Return type

Void (empty response body)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateUserProfile**
```swift
    open class func updateUserProfile(userId: String, userProfile: UserProfile, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Update an existing user profile

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let userId = "userId_example" // String | ID of user profile
let userProfile = userProfile(age: 123, activityInterests: [troovActivity(category: troovActivityCategory(), name: "name_example", emoji: "emoji_example")], almaMater: ["almaMater_example"], bio: "bio_example", company: "company_example", education: education(), ethnicity: [ethnicity()], firstName: "firstName_example", gender: gender(), height: userProfile_height(length: 123, unit: "unit_example"), interestedIn: [nil], lowResThumbnail: profileMedia(mediaId: "mediaId_example", mediaType: "mediaType_example", rank: 123, size: 123, mediaUrl: "mediaUrl_example", createdAt: Date()), numDatesCompleted: 123, numDatesFlaked: 123, occupation: "occupation_example", profileMedia: [nil], politics: politicalAffiliation(), relationshipInterests: [relationshipInterest()], religion: religion(), verified: false) // UserProfile | User profile object to be updated

// Update an existing user profile
UserAPI.updateUserProfile(userId: userId, userProfile: userProfile) { (response, error) in
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
 **userProfile** | [**UserProfile**](UserProfile.md) | User profile object to be updated | 

### Return type

Void (empty response body)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

