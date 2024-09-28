# User

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**userId** | **String** | represents a unique identifier for all users in the application | 
**firstName** | **String** |  | [optional] 
**lastName** | **String** |  | [optional] 
**active** | **Bool** | indicates if the user&#39;s account is active | [optional] 
**dateOfBirth** | **OpenAPIDateWithoutTime** |  | [optional] 
**email** | **String** |  | [optional] 
**heardOfTroovFrom** | [**MarketingChannels**](MarketingChannels.md) |  | [optional] 
**phoneNumber** | [**PhoneNumber**](PhoneNumber.md) |  | [optional] 
**numCredits** | **Int64** | users can use app credits for access to enhanced features | [optional] 
**phoneNumberVerification** | [**PhoneVerification**](PhoneVerification.md) |  | [optional] 
**iOSDeviceToken** | **String** | user iOS device 32 char token found under didRegisterForRemoteNotificationsWithDeviceToken (but larger on simulator) | [optional] 
**lastLoggedInAt** | **Date** |  | [optional] 
**lastUpdatedAt** | **Date** |  | [optional] 
**createdAt** | **Date** |  | [optional] 
**userProfile** | [**UserProfile**](UserProfile.md) |  | [optional] 
**blockedUsers** | [BlockUserRequest] | all the users which this user has blocked | [optional] 
**registrationStatus** | [**RegistrationStep**](RegistrationStep.md) |  | [optional] 
**troovReviews** | [TroovReview] | all the reviews for the user | [optional] 
**usageStatistics** | [**UsageStatistics**](UsageStatistics.md) |  | [optional] 
**isTestUser** | **Bool** |  | [optional] [default to false]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


