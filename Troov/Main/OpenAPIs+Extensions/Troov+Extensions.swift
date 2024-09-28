//
//  Troov+Extensions.swift
//  Troov
//
//  Created by Levon Arakelyan on 01.07.23.
//

import Foundation
import MapKit

extension Troov {
    init() {
        self.createdBy = .init(userId: UUID().uuidString)
    }
    
    static var preview: Troov {
        return .init(createdBy: .init(age: 25,
                                      almaMater: ["Harvard Business School"],
                                      company: "British American Tobacco",
                                      education: .associates,
                                      ethnicity: [.middleEastern],
                                      firstName: "Ellen",
                                      gender: .female,
                                      height: .init(length: 6,
                                                    unit: ._in),
                                      interestedIn: [.female,
                                                     .male,
                                                     .nonBinary],
                                      occupation: "Manager",
                                      profileMedia: [.init(mediaId: "t.jessica",
                                                           mediaUrl: "t.jessica"),
                                                     .init(mediaId: "t.jessica.1",
                                                           mediaUrl: "t.jessica"),
                                                     .init(mediaId: "t.jessica",
                                                           mediaUrl: "t.jessica"),
                                                     .init(mediaId: "t.jessica.2",
                                                           mediaUrl: "t.jessica"),
                                                     .init(mediaId: "t.jessica.3",
                                                           mediaUrl: "t.jessica")], politics: .liberal,
                                      religion: .christian,
                                      userId: UUID().uuidString),
                     locationDetails: .init(location: .init(name: "Central Park",
                                                            coordinates: .init(latitude: 24,
                                                                               longitude: -100))),
                     troovCoreDetails: .init(title: "Let’s watch Openheimmer in IMAX together!",
                                             details: "Hey there! How about we plan a fantastic evening together? I've got a great idea – let's catch the latest blockbuster movie, 'Openheimmer,' in stunning IMAX format! 🎬🍿",
                                             startTime: .now,
                                             expenseRating: .dollarDollarDollar,
                                             tags: ["Stand Up", "Friends", "Social", "Adventure", "Family Oriented"]))
    }
}

extension Troov {
    var thumbnail: TServerImage {
        serverImages?.first ?? .preview
    }
    
    var serverImages: [TServerImage]? {
        if let createdBy = createdBy {
            return createdBy.profileMedia?.map {
                return $0.serverImage(by: createdBy.userId)
            }
        }
        
        return nil
    }

    var confirmedTroovServerImages: [TServerImage]? {
        if let request = confirmedMatchRequest,
           let requester = request.requester,
           requester.userId != ProfileViewModel.shared.user?.userId  {
            return requester.profileMedia?.map {
                return $0.serverImage(by: requester.userId)
            }
        } else if let createdBy = createdBy {
            return createdBy.profileMedia?.map {
                return $0.serverImage(by: createdBy.userId)
            }
        }
        
        return nil
    }

    var startTime: Date? {
        troovCoreDetails?.startTime
    }
    
    var dateString: String {
        startTime?.getLongDayFromDate ?? ""
    }
    
    var timeString: String {
        startTime?.getHourFromDate ?? ""
    }
    
    var dayString: String {
        startTime?.getDayFromDate ?? ""
    }
    
    var getDayFromDateWithSuffixString: String {
        startTime?.getDayFromDateWithSuffix ?? ""
    }
    
    var weekString: String {
        startTime?.getWeek ?? ""
    }
    
    var getShortWeek: String {
        startTime?.getShortWeek ?? ""
    }    
    
    var isToday: Bool {
        startTime?.isDateInToday ?? false
    }
    
    var weekDayMonth: String {
        "\(isToday ? "Today, " : "")\(weekString) \(dayString) \(monthString.prefix(3))"
    }
    
    var monthString: String {
        startTime?.getMonth ?? ""
    }
    
    var fullMonthString: String {
        startTime?.getFullMonth ?? ""
    }
    
    var firstName: String {
        createdBy?.firstName ?? ""
    }
    
    var confirmedTroovFirstName: String {
        if let request = confirmedMatchRequest,
           let requester = request.requester,
           requester.userId != ProfileViewModel.shared.user?.userId  {
            return requester.firstName ?? ""
        } else if let createdBy = createdBy {
            return createdBy.firstName ?? ""
        }
        return ""
    }
    
    var age: String {
        if let age = createdBy?.age {
            return "\(age)"
        }
        return ""
    }
    
    var height: String {
        if let length = createdBy?.height?.length {
            return "\(ProfileFilterAttributesMinHeight.heightString(of: Double(length)))"
        }
        return ""
    }
    
    var education: String {
        createdBy?.education?.rawValue ?? ""
    }
    
    var occupation: String {
        /// for now only the first item
        createdBy?.occupation ?? ""
    }
    
    var locationName: String {
        locationDetails?.location?.name ?? ""
    }
    
    var title: String {
        troovCoreDetails?.title ?? ""
    }
    
    var deatils: String {
        troovCoreDetails?.details ?? ""
    }
    
    var location: Location? {
        locationDetails?.location
    }
    
    
    var coordinates: Coordinates {
        location?.coordinates ?? .init()
    }
    
    var firstImage: TServerImage? {
        serverImages?.first
    }
    
    var secondImage: TServerImage? {
        if let images = serverImages,
           images.count > 1 {
            return images[1]
        }
        return nil
    }
    
    var thridImage: TServerImage? {
        if let images = serverImages,
           images.count > 2 {
            return images[2]
        }
        return nil
    }
    
    var forthImage: TServerImage? {
        if let images = serverImages,
           images.count > 3 {
            return images[3]
        }
        return nil
    }
    
    var fiftImage: TServerImage? {
        if let images = serverImages,
           images.count > 4 {
            return images[4]
        }
        return nil
    }

    var hiddenCoordinate2D: CLLocationCoordinate2D {
        locationDetails?.queryableLocation?.coordinate2D ?? .init()
    }

    var coordinate2D: CLLocationCoordinate2D {
        locationDetails?.location?.coordinate2D ?? .init()
    }
    
    var coordinate2DHiddenAndVisible: CLLocationCoordinate2D {
        if !locationIsHidden {
            return coordinate2D
        } else {
            return hiddenCoordinate2D
        }
    }
    
    var cllocation: CLLocation? {
        if !locationIsHidden {
            return locationDetails?.location?.cllocation
        } else {
            return locationDetails?.queryableLocation?.cllocation
        }
    }

    var locationIsHidden: Bool {
        locationDetails?.hidden == true
    }
}

/*
 For interested in
 */
extension Troov {
    
    var pendingMatchRequests: [TroovMatchRequest]? {
        if let matchRequests = matchRequests {
            return matchRequests.filter({$0.status == .pending})
        }
        return nil
    }
    
    var interestedText: String {
        if let interestedCount = pendingMatchRequests?.count, interestedCount > 0 {
            return "\(interestedCount) \(interestedCount > 1 ? "people" : "person") interested"
        }
        return "Waiting on someone to troov"
    }
    
    var interestedInImages: [TServerImage] {
        var imagesArray: [TServerImage] = []
        if let matchRequests = pendingMatchRequests {
            for request in matchRequests {
                if let requester = request.requester,
                   let first = requester.images.first  {
                    imagesArray.append(first)
                }
            }
        }
        return imagesArray
    }
    
    var isOwn: Bool {
        if let userId = ProfileViewModel.shared.user?.userId {
            return self.createdBy?.userId == userId
        } else {
            return false
        }
    }

    func timeLeftIsCritical(userId: String?) -> (String, Bool) {
        if let matchRequest = matchRequests?.first(where: {$0.requester?.userId == userId}),
           let expiresAt = matchRequest.expiresAt {
            return expiresAt.timeLeftIsCritical
        } else {
            return ("Expired", true)
        }
    }
    
    func expiresInIsCritical(userId: String?) -> (String, Bool) {
        if let matchRequest = matchRequests?.first(where: {$0.requester?.userId == userId}),
           let expiresAt = matchRequest.expiresAt {
            return expiresAt.expiresInIsCritical
        } else {
            return ("Your request expired", true)
        }
    }
    
}

extension Troov: Identifiable {
    public var id: String {
        troovId ?? UUID().uuidString
    }
}
