# HealthcheckAPI

All URIs are relative to *https://localhost/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**healthCheck**](HealthcheckAPI.md#healthcheck) | **GET** /healthcheck | Healthcheck


# **healthCheck**
```swift
    open class func healthCheck(completion: @escaping (_ data: HealthStatusResponse?, _ error: Error?) -> Void)
```

Healthcheck

Healthcheck endpoint

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient


// Healthcheck
HealthcheckAPI.healthCheck() { (response, error) in
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

[**HealthStatusResponse**](HealthStatusResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

