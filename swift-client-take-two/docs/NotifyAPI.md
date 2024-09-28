# NotifyAPI

All URIs are relative to *https://localhost/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getNotificationsForUserSince**](NotifyAPI.md#getnotificationsforusersince) | **GET** /notify/notifications/{userId}/since/{createdTime} | Get notifications since a given time
[**longPollChatSessions**](NotifyAPI.md#longpollchatsessions) | **GET** /notify/notifications/chatSessions/{userId}/longPolling | Long poll for chat session updates
[**longPollNotifications**](NotifyAPI.md#longpollnotifications) | **GET** /notify/notifications/{userId}/longPolling | Long poll for notifications
[**longPollTroovMatchRequests**](NotifyAPI.md#longpolltroovmatchrequests) | **GET** /notify/notifications/troovMatchRequests/{userId}/longPolling | Long poll for troov match requests


# **getNotificationsForUserSince**
```swift
    open class func getNotificationsForUserSince(userId: String, createdTime: Date, completion: @escaping (_ data: [Notification]?, _ error: Error?) -> Void)
```

Get notifications since a given time

Returns any notifications related to the user since the given time

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let userId = "userId_example" // String | ID of user notifications of interest
let createdTime = Date() // Date | Time to get notifications since

// Get notifications since a given time
NotifyAPI.getNotificationsForUserSince(userId: userId, createdTime: createdTime) { (response, error) in
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
 **userId** | **String** | ID of user notifications of interest | 
 **createdTime** | **Date** | Time to get notifications since | 

### Return type

[**[Notification]**](Notification.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **longPollChatSessions**
```swift
    open class func longPollChatSessions(userId: String, completion: @escaping (_ data: [ChatSession]?, _ error: Error?) -> Void)
```

Long poll for chat session updates

Returns any chat session updates related to the user

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let userId = "userId_example" // String | ID of user chat sessions of interest

// Long poll for chat session updates
NotifyAPI.longPollChatSessions(userId: userId) { (response, error) in
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
 **userId** | **String** | ID of user chat sessions of interest | 

### Return type

[**[ChatSession]**](ChatSession.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **longPollNotifications**
```swift
    open class func longPollNotifications(userId: String, completion: @escaping (_ data: [Notification]?, _ error: Error?) -> Void)
```

Long poll for notifications

Returns any notifications related to the user

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let userId = "userId_example" // String | ID of user notifications of interest

// Long poll for notifications
NotifyAPI.longPollNotifications(userId: userId) { (response, error) in
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
 **userId** | **String** | ID of user notifications of interest | 

### Return type

[**[Notification]**](Notification.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **longPollTroovMatchRequests**
```swift
    open class func longPollTroovMatchRequests(userId: String, completion: @escaping (_ data: Troov?, _ error: Error?) -> Void)
```

Long poll for troov match requests

Returns any troov match requests related to the user

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let userId = "userId_example" // String | ID of user chat sessions of interest

// Long poll for troov match requests
NotifyAPI.longPollTroovMatchRequests(userId: userId) { (response, error) in
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
 **userId** | **String** | ID of user chat sessions of interest | 

### Return type

[**Troov**](Troov.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

