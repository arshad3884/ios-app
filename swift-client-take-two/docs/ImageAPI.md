# ImageAPI

All URIs are relative to *https://localhost/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**cleanUploadProfilePhotos**](ImageAPI.md#cleanuploadprofilephotos) | **POST** /image/cleanUpload/profilePhotos/{userId} | Remove existing profile photos and upload new ones
[**deleteAllProfilePhotos**](ImageAPI.md#deleteallprofilephotos) | **DELETE** /image/delete/profilePhotos/{userId} | Delete all of this users profile photos
[**deleteProfilePhoto**](ImageAPI.md#deleteprofilephoto) | **DELETE** /image/delete/{userId}/{imageKey}/{rank} | Delete profile photo by url
[**getLowResProfilePhotoDownloadUrl**](ImageAPI.md#getlowresprofilephotodownloadurl) | **GET** /image/downloadUrl/lowRes/{userId}/{imageKey} | Get low resolution image download url
[**getLowResProfilePhotosDownloadUrls**](ImageAPI.md#getlowresprofilephotosdownloadurls) | **GET** /image/downloadUrl/lowRes/profilePhotos/{userId} | Get low resolution profile photos download urls
[**getLowResProfileThumbnailDownloadUrl**](ImageAPI.md#getlowresprofilethumbnaildownloadurl) | **GET** /image/downloadUrl/lowRes/profileThumbnail/{userId} | Get low resolution profile thumbnail download url
[**getProfilePhotoDownloadUrl**](ImageAPI.md#getprofilephotodownloadurl) | **GET** /image/downloadUrl/{userId}/{imageKey} | Get image download url
[**getProfilePhotosDownloadUrls**](ImageAPI.md#getprofilephotosdownloadurls) | **GET** /image/downloadUrl/profilePhotos/{userId} | Get profile photos download urls
[**uploadProfilePhoto**](ImageAPI.md#uploadprofilephoto) | **POST** /image/upload/profilePhoto/{userId} | Save profile photo
[**uploadProfilePhotos**](ImageAPI.md#uploadprofilephotos) | **POST** /image/upload/profilePhotos/{userId} | Save profile photos


# **cleanUploadProfilePhotos**
```swift
    open class func cleanUploadProfilePhotos(userId: String, profilePhotos: [URL]? = nil, profilePhotosRanks: [ProfilePhotosRanks_cleanUploadProfilePhotos]? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Remove existing profile photos and upload new ones

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let userId = "userId_example" // String | The User Id
let profilePhotos = [URL(string: "https://example.com")!] // [URL] |  (optional)
let profilePhotosRanks = ["inner_example"] // Set<String> |  (optional) (default to ._0)

// Remove existing profile photos and upload new ones
ImageAPI.cleanUploadProfilePhotos(userId: userId, profilePhotos: profilePhotos, profilePhotosRanks: profilePhotosRanks) { (response, error) in
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
 **profilePhotos** | [**[URL]**](URL.md) |  | [optional] 
 **profilePhotosRanks** | [**Set&lt;String&gt;**](String.md) |  | [optional] [default to ._0]

### Return type

Void (empty response body)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: multipart/form-data
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteAllProfilePhotos**
```swift
    open class func deleteAllProfilePhotos(userId: String, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Delete all of this users profile photos

Delete profile photos

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let userId = "userId_example" // String | The User Id

// Delete all of this users profile photos
ImageAPI.deleteAllProfilePhotos(userId: userId) { (response, error) in
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

# **deleteProfilePhoto**
```swift
    open class func deleteProfilePhoto(userId: String, imageKey: String, rank: Int, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Delete profile photo by url

Delete profile photo

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let userId = "userId_example" // String | The User Id
let imageKey = "imageKey_example" // String | Key of profile photo to be deleted
let rank = 987 // Int | the rank of the profile photo to be deleted

// Delete profile photo by url
ImageAPI.deleteProfilePhoto(userId: userId, imageKey: imageKey, rank: rank) { (response, error) in
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
 **imageKey** | **String** | Key of profile photo to be deleted | 
 **rank** | **Int** | the rank of the profile photo to be deleted | 

### Return type

Void (empty response body)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getLowResProfilePhotoDownloadUrl**
```swift
    open class func getLowResProfilePhotoDownloadUrl(userId: String, imageKey: String, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Get low resolution image download url

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let userId = "userId_example" // String | The User Id
let imageKey = "imageKey_example" // String | The Image Key

// Get low resolution image download url
ImageAPI.getLowResProfilePhotoDownloadUrl(userId: userId, imageKey: imageKey) { (response, error) in
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
 **imageKey** | **String** | The Image Key | 

### Return type

Void (empty response body)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getLowResProfilePhotosDownloadUrls**
```swift
    open class func getLowResProfilePhotosDownloadUrls(userId: String, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Get low resolution profile photos download urls

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let userId = "userId_example" // String | The User Id

// Get low resolution profile photos download urls
ImageAPI.getLowResProfilePhotosDownloadUrls(userId: userId) { (response, error) in
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

# **getLowResProfileThumbnailDownloadUrl**
```swift
    open class func getLowResProfileThumbnailDownloadUrl(userId: String, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Get low resolution profile thumbnail download url

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let userId = "userId_example" // String | The User Id

// Get low resolution profile thumbnail download url
ImageAPI.getLowResProfileThumbnailDownloadUrl(userId: userId) { (response, error) in
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

# **getProfilePhotoDownloadUrl**
```swift
    open class func getProfilePhotoDownloadUrl(userId: String, imageKey: String, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Get image download url

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let userId = "userId_example" // String | The User Id
let imageKey = "imageKey_example" // String | The Image Key

// Get image download url
ImageAPI.getProfilePhotoDownloadUrl(userId: userId, imageKey: imageKey) { (response, error) in
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
 **imageKey** | **String** | The Image Key | 

### Return type

Void (empty response body)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getProfilePhotosDownloadUrls**
```swift
    open class func getProfilePhotosDownloadUrls(userId: String, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Get profile photos download urls

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let userId = "userId_example" // String | The User Id

// Get profile photos download urls
ImageAPI.getProfilePhotosDownloadUrls(userId: userId) { (response, error) in
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

# **uploadProfilePhoto**
```swift
    open class func uploadProfilePhoto(userId: String, profilePhoto: URL? = nil, profilePhotoRank: ProfilePhotoRank_uploadProfilePhoto? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Save profile photo

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let userId = "userId_example" // String | The User Id
let profilePhoto = URL(string: "https://example.com")! // URL |  (optional)
let profilePhotoRank = "profilePhotoRank_example" // String |  (optional) (default to ._0)

// Save profile photo
ImageAPI.uploadProfilePhoto(userId: userId, profilePhoto: profilePhoto, profilePhotoRank: profilePhotoRank) { (response, error) in
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

# **uploadProfilePhotos**
```swift
    open class func uploadProfilePhotos(userId: String, profilePhotos: [URL]? = nil, profilePhotosRanks: [ProfilePhotosRanks_uploadProfilePhotos]? = nil, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Save profile photos

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let userId = "userId_example" // String | The User Id
let profilePhotos = [URL(string: "https://example.com")!] // [URL] |  (optional)
let profilePhotosRanks = ["inner_example"] // Set<String> |  (optional) (default to ._0)

// Save profile photos
ImageAPI.uploadProfilePhotos(userId: userId, profilePhotos: profilePhotos, profilePhotosRanks: profilePhotosRanks) { (response, error) in
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
 **profilePhotos** | [**[URL]**](URL.md) |  | [optional] 
 **profilePhotosRanks** | [**Set&lt;String&gt;**](String.md) |  | [optional] [default to ._0]

### Return type

Void (empty response body)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: multipart/form-data
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

