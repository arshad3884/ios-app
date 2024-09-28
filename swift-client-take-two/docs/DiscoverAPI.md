# DiscoverAPI

All URIs are relative to *https://localhost/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**discoverTagsActiveGet**](DiscoverAPI.md#discovertagsactiveget) | **GET** /discover/tags/active | Get all active tags
[**discoverTagsMostPopularNGet**](DiscoverAPI.md#discovertagsmostpopularnget) | **GET** /discover/tags/mostPopular/{n} | Get the most popular n tags
[**discoverTroovsByTagName**](DiscoverAPI.md#discovertroovsbytagname) | **GET** /discover/troovs/byTag/{tagName} | Find all troovs relevant to a given tag
[**discoverTroovsByUserId**](DiscoverAPI.md#discovertroovsbyuserid) | **POST** /discover/troovs/{userId} | Find recommended troovs for a given user
[**discoverTroovsSearchSearchTermsGet**](DiscoverAPI.md#discovertroovssearchsearchtermsget) | **GET** /discover/troovs/search/{searchTerms} | Get all troovs matching the search terms
[**getActivitySuggestions**](DiscoverAPI.md#getactivitysuggestions) | **GET** /discover/activitySuggestions/{userId} | Get activity suggestions


# **discoverTagsActiveGet**
```swift
    open class func discoverTagsActiveGet(completion: @escaping (_ data: [Troov]?, _ error: Error?) -> Void)
```

Get all active tags

Returns all tags which have active troovs

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient


// Get all active tags
DiscoverAPI.discoverTagsActiveGet() { (response, error) in
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

[**[Troov]**](Troov.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **discoverTagsMostPopularNGet**
```swift
    open class func discoverTagsMostPopularNGet(n: Double, completion: @escaping (_ data: [Troov]?, _ error: Error?) -> Void)
```

Get the most popular n tags

Returns the most popular n tags

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let n = 987 // Double | return this number of tags

// Get the most popular n tags
DiscoverAPI.discoverTagsMostPopularNGet(n: n) { (response, error) in
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
 **n** | **Double** | return this number of tags | 

### Return type

[**[Troov]**](Troov.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **discoverTroovsByTagName**
```swift
    open class func discoverTroovsByTagName(tagName: String, completion: @escaping (_ data: [Troov]?, _ error: Error?) -> Void)
```

Find all troovs relevant to a given tag

Returns an array of troovs

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let tagName = "tagName_example" // String | Get recommended troovs for this tagName

// Find all troovs relevant to a given tag
DiscoverAPI.discoverTroovsByTagName(tagName: tagName) { (response, error) in
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
 **tagName** | **String** | Get recommended troovs for this tagName | 

### Return type

[**[Troov]**](Troov.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **discoverTroovsByUserId**
```swift
    open class func discoverTroovsByUserId(userId: String, discoverFilterSettings: DiscoverFilterSettings, completion: @escaping (_ data: DiscoverTroovsResponse?, _ error: Error?) -> Void)
```

Find recommended troovs for a given user

Returns an array of troovs

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let userId = "userId_example" // String | Get recommended troovs for this userId
let discoverFilterSettings = discoverFilterSettings(troovFilters: troovCoreDetailFilterAttributes(originCoordinates: coordinates(latitude: 123, longitude: 123), maximumDistance: troovCoreDetailFilterAttributes_maximumDistance(length: 123, unit: "unit_example"), daysOfWeek: [dayOfWeek()], dateStartTimings: [timeOfDay()], expenseRatings: [expenseRating()], relationshipInterests: [relationshipInterest()], startTimeRange: Date(), endTimeRange: Date(), filterTimezone: "filterTimezone_example"), profileFilters: profileFilterAttributes(minAge: 123, maxAge: 123, educationHistory: [education()], ethnicity: [ethnicity()], gender: [gender()], minHeight: profileFilterAttributes_minHeight(length: 123, unit: "unit_example"), maxHeight: nil, politics: [politicalAffiliation()], religion: [religion()], verified: false), initialPageLimit: 123, perPageLimit: 123, nextPageToken: "nextPageToken_example", paginationOrder: paginationOrder(), limit: 123, testingMode: false) // DiscoverFilterSettings | Filter to be applied on the discover query

// Find recommended troovs for a given user
DiscoverAPI.discoverTroovsByUserId(userId: userId, discoverFilterSettings: discoverFilterSettings) { (response, error) in
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
 **userId** | **String** | Get recommended troovs for this userId | 
 **discoverFilterSettings** | [**DiscoverFilterSettings**](DiscoverFilterSettings.md) | Filter to be applied on the discover query | 

### Return type

[**DiscoverTroovsResponse**](DiscoverTroovsResponse.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **discoverTroovsSearchSearchTermsGet**
```swift
    open class func discoverTroovsSearchSearchTermsGet(searchTerms: String, limit: Int? = nil, includeTestTroovs: Bool? = nil, queryLatitude: Double? = nil, queryLongitude: Double? = nil, queryRadius: Double? = nil, sortBy: PaginationOrder? = nil, limit2: Int? = nil, completion: @escaping (_ data: [Troov]?, _ error: Error?) -> Void)
```

Get all troovs matching the search terms

Returns all troovs matching the search terms

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let searchTerms = "searchTerms_example" // String | Get recommended troovs for these search terms
let limit = 987 // Int | The max numbers of troovs to return per request (optional)
let includeTestTroovs = true // Bool | Include test troovs in the search results (optional)
let queryLatitude = 987 // Double | The latitude of the user (optional)
let queryLongitude = 987 // Double | The longitude of the user (optional)
let queryRadius = 987 // Double | The radius of the search in km (optional)
let sortBy = paginationOrder() // PaginationOrder | The field to sort by (optional)
let limit2 = 987 // Int | The max numbers of troovs to return per request (optional) (default to 50)

// Get all troovs matching the search terms
DiscoverAPI.discoverTroovsSearchSearchTermsGet(searchTerms: searchTerms, limit: limit, includeTestTroovs: includeTestTroovs, queryLatitude: queryLatitude, queryLongitude: queryLongitude, queryRadius: queryRadius, sortBy: sortBy, limit2: limit2) { (response, error) in
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
 **searchTerms** | **String** | Get recommended troovs for these search terms | 
 **limit** | **Int** | The max numbers of troovs to return per request | [optional] 
 **includeTestTroovs** | **Bool** | Include test troovs in the search results | [optional] 
 **queryLatitude** | **Double** | The latitude of the user | [optional] 
 **queryLongitude** | **Double** | The longitude of the user | [optional] 
 **queryRadius** | **Double** | The radius of the search in km | [optional] 
 **sortBy** | [**PaginationOrder**](.md) | The field to sort by | [optional] 
 **limit2** | **Int** | The max numbers of troovs to return per request | [optional] [default to 50]

### Return type

[**[Troov]**](Troov.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getActivitySuggestions**
```swift
    open class func getActivitySuggestions(userId: String, coordinates: Coordinates, completion: @escaping (_ data: [ActivitySuggestion]?, _ error: Error?) -> Void)
```

Get activity suggestions

Returns an array of activity suggestions

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let userId = "userId_example" // String | Get activity suggestions for this userId
let coordinates = coordinates(latitude: 123, longitude: 123) // Coordinates | Location of the user

// Get activity suggestions
DiscoverAPI.getActivitySuggestions(userId: userId, coordinates: coordinates) { (response, error) in
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
 **userId** | **String** | Get activity suggestions for this userId | 
 **coordinates** | [**Coordinates**](Coordinates.md) | Location of the user | 

### Return type

[**[ActivitySuggestion]**](ActivitySuggestion.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

