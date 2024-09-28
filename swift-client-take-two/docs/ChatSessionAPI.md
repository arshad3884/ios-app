# ChatSessionAPI

All URIs are relative to *https://localhost/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**addChatToChatSession**](ChatSessionAPI.md#addchattochatsession) | **POST** /chatSession/{chatSessionId}/addChat | add a chat to a chat session
[**createChatSession**](ChatSessionAPI.md#createchatsession) | **POST** /chatSession/create | Create a new chatSession
[**deleteAllChatSessionsForUser**](ChatSessionAPI.md#deleteallchatsessionsforuser) | **DELETE** /chatSession/deleteAllChatSessionsForUser/{userId} | Deletes all chat sessions associate with the user id
[**deleteChatSession**](ChatSessionAPI.md#deletechatsession) | **DELETE** /chatSession/delete/{chatSessionId} | Delete a chatSession
[**getActiveChatSessionsWithUser**](ChatSessionAPI.md#getactivechatsessionswithuser) | **GET** /chatSession/active/{userId} | Get all active chat sessions for user
[**getAllChatSessionsWithUser**](ChatSessionAPI.md#getallchatsessionswithuser) | **GET** /chatSession/all/{userId} | Get all chat sessions for user
[**getChatSessionById**](ChatSessionAPI.md#getchatsessionbyid) | **GET** /chatSession/{chatSessionId} | Find a chatSession by ID
[**updateLatestViewedTime**](ChatSessionAPI.md#updatelatestviewedtime) | **PUT** /chatSession/{chatSessionId}/viewedBy/{userId} | update the latest chat view time for this user


# **addChatToChatSession**
```swift
    open class func addChatToChatSession(chatSessionId: String, chat: Chat, completion: @escaping (_ data: [Chat]?, _ error: Error?) -> Void)
```

add a chat to a chat session

Returns all chats for a given user

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let chatSessionId = "chatSessionId_example" // String | ID of the chat session
let chat = chat(id: "id_example", createdAt: Date(), createdByUserId: "createdByUserId_example", createdByFirstName: "createdByFirstName_example", messageContent: "messageContent_example", likedByUserIds: ["likedByUserIds_example"]) // Chat | New chat message to be added

// add a chat to a chat session
ChatSessionAPI.addChatToChatSession(chatSessionId: chatSessionId, chat: chat) { (response, error) in
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
 **chatSessionId** | **String** | ID of the chat session | 
 **chat** | [**Chat**](Chat.md) | New chat message to be added | 

### Return type

[**[Chat]**](Chat.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createChatSession**
```swift
    open class func createChatSession(chatSession: ChatSession, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Create a new chatSession

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let chatSession = chatSession(id: "id_example", status: "status_example", troovId: "troovId_example", troovCreatorUserId: "troovCreatorUserId_example", participantUserIds: ["participantUserIds_example"], participantProfiles: [userProfileWithUserId(age: 123, activityInterests: [troovActivity(category: troovActivityCategory(), name: "name_example", emoji: "emoji_example")], almaMater: ["almaMater_example"], bio: "bio_example", company: "company_example", education: education(), ethnicity: [ethnicity()], firstName: "firstName_example", gender: gender(), height: userProfile_height(length: 123, unit: "unit_example"), interestedIn: [nil], lowResThumbnail: profileMedia(mediaId: "mediaId_example", mediaType: "mediaType_example", rank: 123, size: 123, mediaUrl: "mediaUrl_example", createdAt: Date()), numDatesCompleted: 123, numDatesFlaked: 123, occupation: "occupation_example", profileMedia: [nil], politics: politicalAffiliation(), relationshipInterests: [relationshipInterest()], religion: religion(), verified: false, userId: "userId_example")], messages: [chat(id: "id_example", createdAt: Date(), createdByUserId: "createdByUserId_example", createdByFirstName: "createdByFirstName_example", messageContent: "messageContent_example", likedByUserIds: ["likedByUserIds_example"])], createdAt: Date(), lastUpdatedAt: Date(), mostRecentChatUserId: "mostRecentChatUserId_example", lastViewedBy: [chatSession_lastViewedBy_inner(userId: "userId_example", lastViewedAt: Date())], isAdminChatSession: false) // ChatSession | New chatSession to be created

// Create a new chatSession
ChatSessionAPI.createChatSession(chatSession: chatSession) { (response, error) in
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
 **chatSession** | [**ChatSession**](ChatSession.md) | New chatSession to be created | 

### Return type

Void (empty response body)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteAllChatSessionsForUser**
```swift
    open class func deleteAllChatSessionsForUser(userId: String, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Deletes all chat sessions associate with the user id

Deletes all chat sessions associate with the user id

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let userId = "userId_example" // String | ID of user

// Deletes all chat sessions associate with the user id
ChatSessionAPI.deleteAllChatSessionsForUser(userId: userId) { (response, error) in
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

# **deleteChatSession**
```swift
    open class func deleteChatSession(chatSessionId: String, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Delete a chatSession

Deletes a chatSession

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let chatSessionId = "chatSessionId_example" // String | ID of chatSession

// Delete a chatSession
ChatSessionAPI.deleteChatSession(chatSessionId: chatSessionId) { (response, error) in
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
 **chatSessionId** | **String** | ID of chatSession | 

### Return type

Void (empty response body)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getActiveChatSessionsWithUser**
```swift
    open class func getActiveChatSessionsWithUser(userId: String, completion: @escaping (_ data: [ChatSession]?, _ error: Error?) -> Void)
```

Get all active chat sessions for user

Returns an array of a users chatSession

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let userId = "userId_example" // String | userId for which to get active chats

// Get all active chat sessions for user
ChatSessionAPI.getActiveChatSessionsWithUser(userId: userId) { (response, error) in
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
 **userId** | **String** | userId for which to get active chats | 

### Return type

[**[ChatSession]**](ChatSession.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getAllChatSessionsWithUser**
```swift
    open class func getAllChatSessionsWithUser(userId: String, completion: @escaping (_ data: [ChatSession]?, _ error: Error?) -> Void)
```

Get all chat sessions for user

Returns an array of a users chatSession

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let userId = "userId_example" // String | userId for which to get active chats

// Get all chat sessions for user
ChatSessionAPI.getAllChatSessionsWithUser(userId: userId) { (response, error) in
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
 **userId** | **String** | userId for which to get active chats | 

### Return type

[**[ChatSession]**](ChatSession.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getChatSessionById**
```swift
    open class func getChatSessionById(chatSessionId: String, completion: @escaping (_ data: ChatSession?, _ error: Error?) -> Void)
```

Find a chatSession by ID

Returns a single chatSession

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let chatSessionId = "chatSessionId_example" // String | ID of chatSession

// Find a chatSession by ID
ChatSessionAPI.getChatSessionById(chatSessionId: chatSessionId) { (response, error) in
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
 **chatSessionId** | **String** | ID of chatSession | 

### Return type

[**ChatSession**](ChatSession.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateLatestViewedTime**
```swift
    open class func updateLatestViewedTime(chatSessionId: String, userId: String, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

update the latest chat view time for this user

update the latest chat view time for this user

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let chatSessionId = "chatSessionId_example" // String | ID of chatSession
let userId = "userId_example" // String | userId for which to get active chats

// update the latest chat view time for this user
ChatSessionAPI.updateLatestViewedTime(chatSessionId: chatSessionId, userId: userId) { (response, error) in
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
 **chatSessionId** | **String** | ID of chatSession | 
 **userId** | **String** | userId for which to get active chats | 

### Return type

Void (empty response body)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

