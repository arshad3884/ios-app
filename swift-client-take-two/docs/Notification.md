# Notification

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  | [optional] 
**userId** | **String** |  | [optional] 
**message** | **String** |  | [optional] 
**apiUrlUpdatePaths** | **[String]** |  | [optional] 
**type** | [**NotificationType**](NotificationType.md) |  | [optional] 
**importanceRating** | **Int** | lower numbers are more important | [optional] [default to 2]
**createdAt** | **Date** |  | [optional] 
**status** | **String** | Status of the notification:  * READ      | The user has read the notification  * UNREAD    | The user has not read the notification  * CANCELLED | The notification has been cancelled  | [optional] [default to .cancelled]
**statusUpdatedAt** | **Date** | the last time at which the status was updated | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


