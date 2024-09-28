//
//  TEventGenerator.swift
//  TEventGenerator
//
//  Created by Leo on 14.09.21.
//  Copyright © 2021 Levon Arakelyan. All rights reserved.
//

import SwiftUI
import EventKitUI

struct TEventGenerator: UIViewControllerRepresentable {
    private let eventStore = EKEventStore()
    typealias UIViewControllerType = EKEventEditViewController
    
    @Binding var isShowing: Bool
    var troov: Troov?
    let theEvent: EKEvent

    init(isShowing: Binding<Bool>,
         troov: Troov?) {
        eventStore.requestWriteOnlyAccessToEvents { _, _ in }
        self.troov = troov
        self.theEvent = EKEvent(eventStore: eventStore)
        _isShowing = isShowing
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<TEventGenerator>)
    -> EKEventEditViewController {
        let controller = EKEventEditViewController()
        controller.event = theEvent
        controller.event?.location = troov?.locationName
        controller.event?.title = troov?.title
        
        if let startTime = troov?.troovCoreDetails?.startTime,
           let endTime = startTime.addHoursToDate(hours: 2) {
            controller.event?.startDate = startTime
            controller.event?.endDate = endTime
        }

        controller.event?.notes = troov?.troovCoreDetails?.details
        controller.eventStore = eventStore
        controller.editViewDelegate = context.coordinator
        controller.navigationBar.tintColor = .primaryTroov
        return controller
    }

    func updateUIViewController(_ uiViewController: TEventGenerator.UIViewControllerType,
                                context: UIViewControllerRepresentableContext<TEventGenerator>) {
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(isShowing: $isShowing)
    }

    class Coordinator: NSObject,
                       UINavigationControllerDelegate,
                       EKEventEditViewDelegate {
        @Binding var isVisible: Bool

        init(isShowing: Binding<Bool>) {
            _isVisible = isShowing
        }

        func eventEditViewController(_ controller: EKEventEditViewController,
                                     didCompleteWith action: EKEventEditViewAction) {
            switch action {
            case .canceled:
                isVisible = false
            case .saved:
                if let event = controller.event {
                    do {
                        try controller.eventStore.save(event,
                                                       span: .thisEvent,
                                                       commit: true)
                    } catch {
                        print("Event couldn't be created")
                    }
                }

                isVisible = false
            case .deleted:
                isVisible = false
            @unknown default:
                isVisible = false
            }
        }
    }
}
