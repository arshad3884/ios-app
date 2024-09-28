# TroovMatchRequest

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**status** | **String** | Status of the match request:  * CONFIRMED   | The creator of the troov has approved the request  * DECLINED    | The creator of the troov has declined this request  * PENDING     | The requester is still pending a reply from the troov creator  * CANCELLED   | The requester has cancelled this troov request  * EXPIRED     | This troov request has expired  | [optional] [default to .pending]
**requester** | [**UserProfileWithUserId**](UserProfileWithUserId.md) |  | [optional] 
**requestedAt** | **Date** |  | [optional] 
**expiresAt** | **Date** |  | [optional] 
**statusUpdatedAt** | **Date** | the last time at which the status was updated | [optional] 
**lastStatus** | **String** | the prior status | [optional] 
**openingChatMessage** | **String** | store the first message here for easy accessibility to the frontend | [optional] 
**chatSessionId** | **String** | the id of the chat session associated with this troov match request | [optional] 
**troovId** | **String** | the troov to which this request belongs | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


