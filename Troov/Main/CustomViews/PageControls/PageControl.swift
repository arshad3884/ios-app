//
//  PageControl.swift
//  Troov
//
//  Created by Levon Arakelyan on 13.11.23.
//

import SwiftUI

struct PageControl: UIViewRepresentable {
    var pagesCount: Int
    var currentPage: Int
    var onPageChange: (Int) -> ()
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onPageChange: onPageChange)
    }
    
    func makeUIView(context: Context) -> UIPageControl {
        let control = UIPageControl()
        control.numberOfPages = pagesCount
        control.currentPageIndicatorTintColor = .white
        control.pageIndicatorTintColor = UIColor(white: 1, alpha: 0.1)
        /*
         This part seems to have a native iOS bag
         */
        control.addTarget(
            context.coordinator,
            action: #selector(Coordinator.onValueChanged(control:)),
            for: .valueChanged)
        return control
    }
    
    func updateUIView(_ uiView: UIPageControl, context: Context) {
        uiView.currentPage = currentPage
    }
    
    class Coordinator: NSObject {
        var onPageChange: (Int) -> ()
        
        init(onPageChange: @escaping (Int) -> ()) {
            self.onPageChange = onPageChange
        }
        
        @objc func onValueChanged(control: UIPageControl) {
            onPageChange(control.currentPage)
        }
    }
}
