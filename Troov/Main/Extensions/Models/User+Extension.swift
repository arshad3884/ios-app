//
//  User+Extension.swift
//  Troov
//
//  Created by Leo on 28.03.23.
//

import Foundation
import CoreLocation

extension User {
    /**
     TODO: - enhance this code Leo
     */
    static private var location: CLLocation?
    
    /**
     TODO: - enhance this code Leo
     */
    static var storedLocation: CLLocation? {
        if let location = location {
            return location
        } else if let latitude = UserDefaults.standard.value(forKey: "t.user.latitude") as? CLLocationDegrees,
                  let longitude = UserDefaults.standard.value(forKey: "t.user.longitude") as? CLLocationDegrees {
            let newLocation = CLLocation(latitude: latitude,
                                         longitude: longitude)
            setUserLocation(newLocation)
            return newLocation
        } else {
            return nil
        }
    }

    /**
     TODO: - enhance this code Leo
     */
    static func setUserLocation(_ newLocation: CLLocation?) {
        UserDefaults.standard.setValue(newLocation?.coordinate.latitude, forKey: "t.user.latitude")
        UserDefaults.standard.setValue(newLocation?.coordinate.longitude, forKey: "t.user.longitude")
        Self.location = newLocation
    }

    /**
     Optional init user account
     */
    init?() {
        guard let authOUserInfo = TAuth0.shared.userInfo else { return nil }
        userId = authOUserInfo.sub
        email = authOUserInfo.email
        phoneNumberVerification = .init(verified: false)
        registrationStatus = .firstStep
        assignNotificationTokenLocally()
    }

    static var preview: User! {
        return User(userId: UUID().uuidString,
                    firstName: "RandomFirstName",
                    lastName: "RandomLastName",
                    active: Bool.random(),
                    dateOfBirth: OpenAPIDateWithoutTime.init(wrappedDate: .now),
                    email: "random@example.com",
                    heardOfTroovFrom: MarketingChannels.allCases.randomElement(),
                    phoneNumber: .init(),
                    numCredits: Int64.random(in: 0...100),
                    phoneNumberVerification: PhoneVerification(verified: true),
                    lastLoggedInAt: Date(),
                    lastUpdatedAt: Date(),
                    userProfile: UserProfile(),
                    blockedUsers: [BlockUserRequest](),
                    isTestUser: Bool.random()
        )
    }

    mutating func assignNotificationTokenLocally() {
        if let token = TKeychain.getStringValue(key: TKeychainItems.deviceNotificationToken.rawValue),
               !token.isClean,
               iOSDeviceToken != token {
               iOSDeviceToken = token
               debugPrint("=====>>> User account initial setup deviceNotificationToken: ", token)
        }
    }
}
