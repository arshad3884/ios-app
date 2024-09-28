# Troov

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**troovId** | **String** |  | [optional] 
**createdBy** | [**UserProfileWithUserId**](UserProfileWithUserId.md) |  | [optional] 
**status** | [**TroovStatus**](TroovStatus.md) |  | [optional] 
**locationDetails** | [**LocationIndicator**](LocationIndicator.md) |  | [optional] 
**troovCoreDetails** | [**TroovCoreDetails**](TroovCoreDetails.md) |  | [optional] 
**matchRequests** | [TroovMatchRequest] | a list of all the match requests | [optional] 
**matchRequestsCount** | **Int** |  | [optional] 
**confirmedMatchRequest** | [**TroovMatchRequest**](TroovMatchRequest.md) |  | [optional] 
**indexedFields** | [**TroovIndexedFields**](TroovIndexedFields.md) |  | [optional] 
**createdAt** | **Date** |  | [optional] 
**lastUpdatedAt** | **Date** |  | [optional] 
**participantReviews** | [TroovReview] | a list of all the reviews for the participants of the troov  | [optional] 
**viewedBy** | **[String]** | a list of all the user ids which have viewed this troov  | [optional] 
**distinctViewsCount** | **Int** |  | [optional] 
**suitabilityScore** | **Float** | The suitability score of the troov from 0 to 1 where 0 is the worst and 1 is the best  | [optional] 
**activitySubLabels** | [TroovActivity] | a list of all the activity sub labels associated with the troov  | [optional] 
**activityCategories** | [TroovActivityCategory] | a list of all the activity categories associated with the troov  | [optional] 
**isTestTroov** | **Bool** |  | [optional] [default to false]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


