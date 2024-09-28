# ChatSession

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  | [optional] 
**status** | **String** | Status of the match request:  * OPENING_REQUEST  | User has issued a request to join a troov but the troov creator has not yet responded  * ACTIVE           | Active chat between the participants  * NON_ACTIVE       | Non active chat between the participants  * BLOCKED          | One of the chat participants has blocked the other  | [optional] [default to .active]
**troovId** | **String** | the id of the troov this chat session is associated with | [optional] 
**troovCreatorUserId** | **String** | the user id of the troov creator | [optional] 
**participantUserIds** | **[String]** | a list of all the chat session participants user ids | [optional] 
**participantProfiles** | [UserProfileWithUserId] | a list of all the chat session participants profiles | [optional] 
**messages** | [Chat] | a list of all the chats in this chat session | [optional] 
**createdAt** | **Date** |  | [optional] 
**lastUpdatedAt** | **Date** |  | [optional] 
**mostRecentChatUserId** | **String** | the user id of the user who sent the most recent chat | [optional] 
**lastViewedBy** | [ChatSessionLastViewedByInner] | an array of user ids and when they last viewed the chat session | [optional] 
**isAdminChatSession** | **Bool** | whether this is an admin chat | [optional] [default to false]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


