# TroovSearchable

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  | [optional] 
**title** | **String** |  | [optional] 
**details** | **String** |  | [optional] 
**placeName** | **String** |  | [optional] [default to ""]
**isHiddenLocation** | **Bool** |  | [optional] 
**activityCategories** | **[String]** |  | [optional] 
**activitySubLabels** | **[String]** |  | [optional] 
**tags** | **[String]** | Users will assign free-form text tags to each date to improve searchability | [optional] 
**startTime** | **Int** | Unix timestamp (since Typesense doesn&#39;t support native datetime) | [optional] 
**coordinates** | **[Double]** | Array of latitude and longitude | [optional] 
**createdByGender** | **String** |  | [optional] 
**relationshipInterests** | **[String]** |  | [optional] 
**isTestTroov** | **Bool** |  | [optional] [default to false]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


