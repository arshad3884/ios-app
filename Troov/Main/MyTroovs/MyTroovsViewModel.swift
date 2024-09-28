//
//  MyTroovsViewModel.swift
//  mango
//
//  Created by Leo on 09.04.21.
//  Copyright © 2021 Dustin Godevais. All rights reserved.
//

import SwiftUI

@Observable class MyTroovsViewModel {
    let service = TTroovService()
    
    private(set) var confirmPicks: [PickSection] = []
    private(set) var currentMyPick: Troov?
    private(set) var currentTroovMatchRequest: TroovMatchRequest?
    private(set) var myPicks: [PickSection] = []
    private(set) var theirPicks: [PickSection] = []

    var addEvent: Bool = false
    var showMyPicksWarning = false
    var showConfirmPicksWarning = false

    private(set) var hasUpdatesAtIndices: [MyTroovsView.Taper]?
    
    var confirmedTroovs: [Troov] {
        confirmPicks.flatMap({$0.troovs})
    }
    
    var myTroovs: [Troov] {
        myPicks.flatMap({$0.troovs})
    }
    
    var theirTroovs: [Troov] {
        theirPicks.flatMap({$0.troovs})
    }

    var userId: String {
        service.userId ?? ""
    }
    
    var getCurrentPick: Troov? {
        currentMyPick
    }
    
    @MainActor func setCurrentMyPick(_ pick: Troov) {
        self.currentMyPick = pick
    }

    @MainActor func select(match: TroovMatchRequest) {
        self.currentTroovMatchRequest = match
    }
    
    /// Confirm Picks
    func deleteConfirmPick(pick: Troov) {
        guard let troovId = pick.troovId else { return }
        guard let userId = service.userId else { return }

        for sectionIndex in confirmPicks.indices {
            if let index = confirmPicks[sectionIndex].troovs.firstIndex(where: {$0.troovId == pick.troovId}) {
                confirmPicks[sectionIndex].troovs.remove(at: index)
                if confirmPicks[sectionIndex].troovs.count == 0 {
                    confirmPicks.remove(at: sectionIndex)
                }
                break
            }
        }
    
        cancelTroov(troovId: troovId, userId: userId)
    }
    /// Your Picks
    
    func cancelMyTroov() {
        guard let troovId = currentMyPick?.troovId else { return }
        guard let userId = service.userId else { return }

        for sectionIndex in myPicks.indices {
            if let index = myPicks[sectionIndex].troovs.firstIndex(where: {$0.troovId == troovId}) {
                myPicks[sectionIndex].troovs.remove(at: index)
                if myPicks[sectionIndex].troovs.count == 0 {
                    myPicks.remove(at: sectionIndex)
                }
                break
            }
        }
        
        cancelTroov(troovId: troovId, userId: userId)
    }
    
    /// Your Picks
    
    func deleteTheir(pick: Troov) {
        guard let troovId = pick.troovId else { return }
        guard let userId = service.userId else { return }
        for sectionIndex in theirPicks.indices {
            if let index = theirPicks[sectionIndex].troovs.firstIndex(where: {$0.troovId == troovId}) {
                theirPicks[sectionIndex].troovs.remove(at: index)
                if theirPicks[sectionIndex].troovs.count == 0 {
                    theirPicks.remove(at: sectionIndex)
                }
                break
            }
        }
        cancelJoinRequest(troovId: troovId, userId: userId)
    }
    
    /**
     Reject Match
     */
    @MainActor func declineMatch() {
        guard let match = currentTroovMatchRequest else { return }
        guard let troovId = match.troovId else { return }
        guard let userId = match.requester?.userId else { return }
        declineJoinRequest(troovId: troovId, userId: userId)
        removeMatchFromList(match)
    }

   @MainActor func removeMatchFromList(_ match: TroovMatchRequest) {
        if let index = myPicks.firstIndex(where: {$0.troovs.contains(where: {$0.matchRequests?.contains(where: {$0.requester?.userId == match.requester?.userId}) == true})}) {
            if let section = myPicks[index].troovs.firstIndex(where: {$0.matchRequests?.contains(where: {$0.requester?.userId == match.requester?.userId}) == true}) {
                if let requesterIndex = myPicks[index].troovs[section].matchRequests?.firstIndex(where: {$0.requester?.userId == match.requester?.userId}) {
                    withAnimation {
                        myPicks[index].troovs[section].matchRequests?.remove(at: requesterIndex)
                    }
                }
            }
        }

        if let index = currentMyPick?.matchRequests?.firstIndex(where: {$0.requester?.userId == match.requester?.userId}) {
            withAnimation {
                currentMyPick?.matchRequests?.remove(at: index)
            }
        }
    }
    
    private func cancelJoinRequest(troovId: String, userId: String) {
        Task {
            switch await service.cancelJoinRequest(troovId: troovId,
                                                   userId: userId) {
            case .success(let response):
                debugPrint("cancel join request response: ", response)
            case .failure(let error):
                debugPrint("cancel join request error: ", String(describing: error))
            }
        }
    }
    
    private func declineJoinRequest(troovId: String, userId: String) {
        Task {
            switch await service.declineJoinRequest(troovId: troovId,
                                                   userId: userId) {
            case .success(let response):
                debugPrint("decline join request response: ", response)
            case .failure(let error):
                debugPrint("decline join request error: ", String(describing: error))
            }
        }
    }
    

    private func cancelTroov(troovId: String, userId: String) {
        Task {
            switch await service.cancelTroov(troovId: troovId,
                                             userId: userId) {
            case .success(let response):
                debugPrint("cancel join request response: ", response)
            case .failure(let error):
                debugPrint("cancel join request error: ", String(describing: error))
            }
        }
    
    }
    
    func confirmCurrentMatchRequest() async {
        guard let match = currentTroovMatchRequest else { return }
        guard let troovId = match.troovId else { return }
        guard let userId = match.requester?.userId else { return }

        if case .success(let success) = await service.confirm(troovId: troovId,
                                                              userId: userId) {
            debugPrint("success: ", success.message)
        }
    
       await removeMatchFromList(match)
    }
    
    // MARK: - Fetch Troovs
    
    func fetchTroovs() async {
        await fetchConfirmedTroovs()
        await fetchOwnTroovs()
        await fetchTheirTroovs()
    }

    func fetchOwnTroovs() async {
        if case .success(let pending) = await service.open() {
            await generate(myPicks: pending)
        }
    }
    
    func fetchTheirTroovs() async {
        if case .success(let allMatches) = await service.allMatchRequests() {
            await generate(theirPicks: allMatches)
        }
    }
    
    func fetchConfirmedTroovs() async {
        if case .success(let troovs) = await service.confirmed() {
            await generate(confirmed: troovs)
        }
    }
    
    @MainActor private func generate(confirmed troovs: [Troov]) async {
        let initialCount = confirmPicks.map({$0.troovs}).count
        let newPicks: [PickSection] = groupTroovsByCreatedAtDay(troovs: troovs,
                                                                type: .confirmed)
        await MainActor.run {
            withAnimation {
                confirmPicks = newPicks
            }
            let finalCount = confirmPicks.map({$0.troovs}).count
            if finalCount > 0 && initialCount != finalCount {
                notify(.confirmed)
            }
        }
    }

    @MainActor private func generate(myPicks troovs: [Troov]) {
        
        let initialCount = myPicks.map({$0.troovs}).count
        
        let newPicks: [PickSection] = groupTroovsByCreatedAtDay(troovs: troovs,
                                                                type: .my)
        withAnimation {
            myPicks = newPicks
        }
        
        let finalCount = myPicks.map({$0.troovs}).count
        if finalCount > 0 && initialCount != finalCount {
            notify(.my)
        }
    }
    
    
    @MainActor private func generate(theirPicks troovs: [Troov]) {
        let initialCount = theirPicks.map({$0.troovs}).count
        let newPicks: [PickSection] = groupTroovsByCreatedAtDay(troovs: troovs,
                                                                type: .their)
        withAnimation {
            theirPicks = newPicks
        }
        let finalCount = theirPicks.map({$0.troovs}).count
        if finalCount > 0 && initialCount != finalCount {
            notify(.their)
        }
    }

    @MainActor private func notify(_ type: MyTroovsView.Taper) {
        if let hasUpdatesAtIndices = hasUpdatesAtIndices {
            if !hasUpdatesAtIndices.contains(type) {
                self.hasUpdatesAtIndices?.append(type)
            }
        } else {
            hasUpdatesAtIndices = [type]
        }
    }

    @MainActor func resetNotify(_ type: MyTroovsView.Taper) {
        if let hasUpdatesAtIndices = hasUpdatesAtIndices {
            if let index = hasUpdatesAtIndices.firstIndex(of: type) {
                self.hasUpdatesAtIndices?.remove(at: index)
            }
        }
    }
    
    private func receivedAllMatches(_ matches: [Troov]) {
        Task { await fetchTroovs() }
    }
}

fileprivate extension MyTroovsViewModel {
    private func groupTroovsByCreatedAtDay(troovs: [Troov], type: MyTroovsView.Taper) -> [PickSection] {
        let calendar = Calendar.current
        
        // Group Troov instances by the day
        let groups = Dictionary(grouping: troovs) { (troov) -> DateComponents in
            let date = troov.troovCoreDetails?.startTime ?? Date()
            return calendar.dateComponents([.year, .month, .day], from: date)
        }
        
        // Create a PickSection for each group
        var sections = groups.map { (_, troovs) -> PickSection in
            PickSection(type: type,
                        troovs: troovs)
        }
        
        // Sort sections in descending order by the most recent createdAt date within each section
        sections.sort { (section1, section2) -> Bool in
            if let startTime1 = section1.troovs.first?.startTime,
               let startTime2 = section2.troovs.first?.startTime {
                return startTime1 < startTime2
            }
            return false
        }
        
        return sections
    }
}
