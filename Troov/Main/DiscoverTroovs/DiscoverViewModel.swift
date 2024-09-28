//
//  DiscoverViewModel.swift
//  mango
//
//  Created by Leo on 18.06.21.
//  Copyright © 2021 Dustin Godevais. All rights reserved.
//

import SwiftUI
import CoreLocation

@Observable class DiscoverViewModel {
    private let service = TSearchService()
    private let troovService = TTroovService()
    private(set) var extendedTroovs: [ExtendedTroov] = []

    private var removedTroovIds: [String] {
        if let ids = UserDefaults.standard.stringArray(forKey: "t.removed.troov.ids") {
            return ids
        } else {
            return []
        }
    }

    private var filterLocation: CLLocation?
    
    var troovs: [Troov] {
        extendedTroovs.map({$0.element2})
    }

    var userId: String? {
        troovService.userId
    }
    
    var sortedByCoordinatesTroovs: [Troov] {
        if let filterLocation = filterLocation {
            return extendedTroovs.sorted { (item1, item2) -> Bool in
                if let distance1 = item1.element2.cllocation?.distance(from: filterLocation),
                   let distance2 = item2.element2.cllocation?.distance(from: filterLocation) {
                    
                    return distance1 < distance2
                }
                return false
            }.map({$0.element2})
        } else if let location = User.storedLocation {
            return extendedTroovs.sorted { (item1, item2) -> Bool in
                if let distance1 = item1.element2.cllocation?.distance(from: location),
                   let distance2 = item2.element2.cllocation?.distance(from: location) {
                    
                    return distance1 < distance2
                }
                return false
            }.map({$0.element2})
        } 
        else {
            return troovs
        }
    }

    var offeredTroovsForConfirmedTroovTab: [ExtendedTroov] {
        extendedTroovs.suffix(2)
    }

    private(set) var currentTroov: Troov?
    private(set) var numTroovsFound: Int?
    private var nextPageToken: String?

    var search: Bool = false
    var searchText: String = ""
    var currentTroovIndex: Int?
    var isBig = false
    var activeFiltersCount: Int = 0
    
    var setNilCurrentTroovId = false

    var troovsAreLoading = true
    
    private(set) var updateCurrentTroovsOnMap = false
    private(set) var positionCamera = false

    func setCurrentTroov(_ troov: Troov?, refreshMap: Bool = false) {
        self.currentTroov = troov
        if refreshMap { 
            self.updateCurrentTroovsOnMap.toggle()
        }
    }
    
    /**
     Fetch troovs
     */
    private var task: Task<(), Never>?

    func tryToFetchTroovs(search: Bool = false,
                          troovId: String? = nil,
                          setCurrentTroov: Bool = false,
                          paginationOrder: PaginationOrder? = nil,
                          positionCamera: Bool = true,
                          refresh: Bool = true) {
        var canFetchTroovs = false
        if let troovId = troovId {
            if nextPageToken != nil,
               !extendedTroovs.isEmpty,
                troovId == extendedTroovs[extendedTroovs.count - 3].troovId {
                canFetchTroovs = true
            }
        } else {
            canFetchTroovs = true
        }
        
        guard canFetchTroovs else { return }
        task?.cancel()
        task = Task.detached { [weak self] in
            guard let self = self, !Task.isCancelled else { return}
    
            await self.fetchTroovs(search: search,
                                   setCurrentTroov: setCurrentTroov,
                                   paginationOrder: paginationOrder,
                                   positionCamera: positionCamera,
                                   refresh: refresh)
        }
    }

    private func fetchTroovs(search: Bool = false,
                             setCurrentTroov: Bool = false,
                             paginationOrder: PaginationOrder? = nil,
                             positionCamera: Bool,
                             refresh: Bool = true) async {

        await MainActor.run {
            troovsAreLoading = true
        }
        
        guard let filters = await SearchFilters.shared.fetchSettings()?.element2 else {
            await MainActor.run {
                troovsAreLoading = false
            }
            return
        }
        
        if let originCoordinates = filters.troovFilters.originCoordinates,
        let latitude = originCoordinates.latitude,
        let longitude = originCoordinates.longitude {
            await MainActor.run {
                self.filterLocation = .init(latitude: latitude,
                                            longitude: longitude)
            }
        } else if self.filterLocation != nil {
            await MainActor.run {
                self.filterLocation = nil
            }
        }

        await MainActor.run {
            self.activeFiltersCount = filters.activeFiltersCount
            if positionCamera {
                self.positionCamera.toggle()
            }
        }
        
        /**
         TODO: - this is hardcoded
         Return and fix iot
         */
        if refresh {
            nextPageToken = nil
            await MainActor.run {
                numTroovsFound = nil
            }
        }
        
        var filtersHardcoded = filters
        filtersHardcoded.initialPageLimit = 25
        filtersHardcoded.perPageLimit = 10
        filtersHardcoded.limit = 100
        filtersHardcoded.paginationOrder = paginationOrder ?? filters.paginationOrder
        filtersHardcoded.nextPageToken = nextPageToken
        switch await troovService.recommended(by: filtersHardcoded) {
        case .success(let troovsResponse):
                /**
                 TODO: - enhance this part too
                 */
            if let base = troovsResponse.base {
                self.nextPageToken = base.nextPageToken

                let removedTroovIds = self.removedTroovIds
                /**
                 Filter out removed troovs
                 */
                let troovs = base.troovs.filter({ troov in
                    return !removedTroovIds.contains(where: {$0 == troov.id})
                })
                                
                let mappedTroovs = troovs.compactMap({ ExtendedTroov(troov: $0,
                                                                     isExpanded: !isBig,
                                                                     isOwn: $0.createdBy?.userId == troovService.userId) })
                await MainActor.run {
                    if numTroovsFound == nil {
                        numTroovsFound = mappedTroovs.count
                    }
                }
                await updateTroovFromServer(mappedTroovs,
                                            search: search,
                                            setCurrentTroov: setCurrentTroov,
                                            refresh: refresh)
                
            } else {
                self.nextPageToken = nil
            }
        case .failure(let error):
            self.nextPageToken = nil
            debugPrint(String(describing: error))
        }
    
        await MainActor.run {
            troovsAreLoading = false
        }
    }
    
    private func updateTroovFromServer(_ troovs: [ExtendedTroov],
                                       search: Bool = false,
                                       setCurrentTroov: Bool = false,
                                       refresh: Bool = true) async {
        if refresh || search || self.extendedTroovs.count == 0 {
            await MainActor.run {
                setNilCurrentTroovId.toggle()
            }
            await assignNewTroovs(troovs)
        } else if troovs.count == 0 {
            await assignNewTroovs([])
        } else {
            for troov in troovs {
                if let index = self.extendedTroovs.firstIndex(where: {$0.troovId == troov.troovId}) {
                    await MainActor.run {
                        var troov = troov
                        let isExpanded = self.extendedTroovs[index].isExpanded
                        troov.isExpanded = isExpanded
                        withAnimation {
                            self.extendedTroovs[index] = troov
                        }
                    }
                } else {
                    await MainActor.run {
                        self.extendedTroovs.append(troov)
                    }
                }
            }
        
            /**
             Clean up
             */
            if search {
                await MainActor.run {
                    for index in self.extendedTroovs.indices {
                        if index < self.extendedTroovs.count {
                            let troovId = self.extendedTroovs[index].troovId
                            if !troovs.contains(where: {$0.troovId == troovId}) {
                                self.extendedTroovs.remove(at: index)
                            }
                        }
                    }
                }
            }
        }

        if setCurrentTroov,
            let firstTroov = extendedTroovs.first {
            await MainActor.run {
                self.setCurrentTroov(firstTroov.element2, refreshMap: true)
            }
        }
    }

    private func assignNewTroovs(_ troovs: [ExtendedTroov]) async {
        await MainActor.run {
            self.extendedTroovs = troovs
        }
    }
    
    /**
     Remove a troov
     */
    @MainActor func remove(troov: Troov,
                           storeId: Bool) {
        
        if let troovId = troov.troovId,
           let index = extendedTroovs.firstIndex(where: {$0.troovId == troovId}) {
            /*
             TODO: - enhance this in the future
             */
            if storeId {
                var ids = removedTroovIds
                if !ids.contains(troovId) {
                    ids.append(troovId)
                    UserDefaults.standard.set(ids, forKey: "t.removed.troov.ids")
                }
            }
        
            extendedTroovs.remove(at: index)
            numTroovsFound = extendedTroovs.count
        }
    }

    func epxandTroov(id: String?) {
        if let index = extendedTroovs.firstIndex(where: {$0.element2.id == id}) {
            extendedTroovs[index].isExpanded.toggle()
        }
        
        let allCollapsed = extendedTroovs.filter({$0.isExpanded}).count == 0
        let allExpanded = extendedTroovs.filter({!$0.isExpanded}).count == 0
        
        if !isBig && allCollapsed {
            isBig = true
        } else if isBig && allExpanded {
            isBig = false
        }
    }

     func expandAllTroovs(_ expand: Bool) {
        for index in extendedTroovs.indices where extendedTroovs[index].isExpanded != expand {
            Task {
                await MainActor.run {
                    withAnimation {
                        extendedTroovs[index].isExpanded = expand
                    }
                }
            }
        }
    }

   private func searchTroovs(_ troovs: [Troov]) async {
        let isBig = isBig
        let mappedTroovs = troovs.compactMap({ ExtendedTroov(troov: $0,
                                                             isExpanded: !isBig,
                                                             isOwn: $0.createdBy?.userId == userId) })
        await updateTroovFromServer(mappedTroovs, search: true)
    }
    
    func searchByTerm(term: String) async {
        guard let filters = await SearchFilters.shared.fetchSettings()?.element2,
              let latitude = filters.troovFilters.originCoordinates?.latitude,
              let longitude = filters.troovFilters.originCoordinates?.longitude,
              let radius = filters.troovFilters.maximumDistance?.length else { return }
        let result = await service.searchByTerm(term: term,
                                                latitude: latitude,
                                                longitude: longitude,
                                                radius: radius)
        switch result {
        case .success(let response):
            /**
             Filter out removed troovs
             */
            let removedTroovIds = self.removedTroovIds
            var results: [Troov] = []
            for item in response {
                if let troov = item.base,
                   !removedTroovIds.contains(where: {$0 == troov.id}) {
                    results.append(troov)
                }
            }
            await searchTroovs(results)
        case .failure(_):
            await searchTroovs([])
        }
    }
}
