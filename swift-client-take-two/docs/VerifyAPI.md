# VerifyAPI

All URIs are relative to *https://localhost/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**verifySmsCodeForUser**](VerifyAPI.md#verifysmscodeforuser) | **POST** /verify/verifySmsCodeForUser/{userId} | Verify user profile
[**verifyUserProfile**](VerifyAPI.md#verifyuserprofile) | **POST** /verify/sendSmsCodeForUser/{userId} | Verify user profile


# **verifySmsCodeForUser**
```swift
    open class func verifySmsCodeForUser(userId: String, verifySmsCodeForUserRequest: VerifySmsCodeForUserRequest? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Verify user profile

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let userId = "userId_example" // String | ID of user to be verified
let verifySmsCodeForUserRequest = verifySmsCodeForUser_request(userSubmittedCode: 123) // VerifySmsCodeForUserRequest | New user to be created (optional)

// Verify user profile
VerifyAPI.verifySmsCodeForUser(userId: userId, verifySmsCodeForUserRequest: verifySmsCodeForUserRequest) { (response, error) in
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
 **userId** | **String** | ID of user to be verified | 
 **verifySmsCodeForUserRequest** | [**VerifySmsCodeForUserRequest**](VerifySmsCodeForUserRequest.md) | New user to be created | [optional] 

### Return type

Void (empty response body)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **verifyUserProfile**
```swift
    open class func verifyUserProfile(userId: String, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Verify user profile

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let userId = "userId_example" // String | ID of user to be verified

// Verify user profile
VerifyAPI.verifyUserProfile(userId: userId) { (response, error) in
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
 **userId** | **String** | ID of user to be verified | 

### Return type

Void (empty response body)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

