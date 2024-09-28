//
//  TApperance.swift
//  Troov
//
//  Created by Levon Arakelyan on 09.05.23.
//

import UIKit


class TApperance {
    class func setup() {
        /** Navigation view ste to be white*/
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = UIColor.white
        navBarAppearance.shadowColor = .clear
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
    
        let thumbImage = UIImage(named: "t.slider.thumbnail")
        UISlider.appearance().setThumbImage(thumbImage, for: .normal)
        UISlider.appearance().maximumTrackTintColor = UIColor.init(red: 17/255, green: 45/255, blue: 106/255, alpha: 1.0)
        UISlider.appearance().minimumTrackTintColor = UIColor.init(red: 17/255, green: 45/255, blue: 106/255, alpha: 1.0)
    }
}
