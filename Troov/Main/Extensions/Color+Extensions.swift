//
//  Color+Extensions.swift
//  mango
//
//  Created by Leo on 06.01.22.
//  Copyright © 2022 Levon Arakelyan. All rights reserved.
//

import SwiftUI

extension UIColor {
    static let primaryTroov = UIColor(red: 60/255,
                                      green: 74/255,
                                      blue: 216/255,
                                      alpha: 1)
}

extension Color {
    static var primaryTroovColor: Color {
        if let hex = UserDefaults.standard.string(forKey: "primary.color") {
            return Color(hex: hex)
        } else {
            return Color(hex: "3C4AD8")
        }
    }
    static let primaryTroovLightGray = Color(red: 247/255,
                                             green: 247/255,
                                             blue: 247/255)
    static let primaryTroovDarkColor = Color(UIColor(red: 178/255,
                                                     green: 86/255,
                                                     blue: 97/255,
                                                     alpha: 1))
    static let primaryTroovGradientColor = Color(UIColor(red: 200/255,
                                                         green: 115/255,
                                                         blue: 121/255,
                                                         alpha: 1))
    static let primaryTroovLightColor = Color(UIColor(red: 247/255,
                                                      green: 249/255,
                                                      blue: 255/255,
                                                      alpha: 1))
    static let primaryBlack = Color(UIColor(red: 51/255,
                                            green: 51/255,
                                            blue: 51/255,
                                            alpha: 1))
    static let primaryGray6 = Color(UIColor(red: 248/255,
                                            green: 249/255,
                                            blue: 255/255,
                                            alpha: 1))
    static let primaryNavigationBarBlackColor = Color(UIColor(red: 33/255,
                                                              green: 33/255,
                                                              blue: 33/255,
                                                              alpha: 1))
    static let primaryNavigationBarButtonBlackColor = Color(UIColor(red: 18/255,
                                                                    green: 18/255,
                                                                    blue: 18/255,
                                                                    alpha: 1))
    static let primaryTextFieldGray = Color(UIColor(red: 249/255,
                                                    green: 249/255,
                                                    blue: 249/255,
                                                    alpha: 1))
    
    static let primaryDarkGray = Color(UIColor(red: 117/255,
                                               green: 117/255,
                                               blue: 117/255,
                                               alpha: 1))
    static let primaryBorder = Color(UIColor(red: 17/255,
                                             green: 45/255,
                                             blue: 106/255,
                                             alpha: 0.3))
    static let tableViewBackground = Color(UIColor(red: 245/255,
                                                   green: 249/255,
                                                   blue: 254/255,
                                                   alpha: 1))

    static let primaryTroovRed = Color.rgba(255, 25, 25, 1)

    static let primaryTroovGreen = Color(UIColor(red: 49/255,
                                                 green: 160/255,
                                                 blue: 109/255,
                                                 alpha: 1))
    static let primaryConfirm = Color(UIColor(red: 0.898,
                                              green: 0.898,
                                              blue: 0.898,
                                              alpha: 1))
    static let primaryTroovChatGreen = Color(UIColor(red: 94/255,
                                                     green: 202/255,
                                                     blue: 4/255,
                                                     alpha: 1))
    static let primaryTroovChatOrange = Color.orange
    static let primaryTroovChatGray = Color.gray
    static let primaryLighterGray = Color(UIColor(red: 129/255,
                                                  green: 129/255,
                                                  blue: 129/255,
                                                  alpha: 1))
    static let primaryGrayBorder = Color(UIColor(red: 238/255,
                                                 green: 238/255,
                                                 blue: 238/255,
                                                 alpha: 1))
    static let primaryGray170 = Color(UIColor(red: 170/255,
                                              green: 170/255,
                                              blue: 170/255,
                                              alpha: 1))
    struct TRV {
        static let introButton = Color(red: 94.0/255.0,
                                       green: 176.0/255.0,
                                       blue: 187.0/255.0)
        static let linkedin = Color(red: 14.0/255.0,
                                    green: 118.0/255.0,
                                    blue: 168.0/255.0)
        static let facebook = Color(red: 64.0/255.0,
                                    green: 90.0/255.0,
                                    blue: 147.0/255.0)
        static let email = Color(red: 230.0/255.0,
                                 green: 246.0/255.0,
                                 blue: 246.0/255.0)
        static let gmail = Color(red: 80.0/255.0,
                                 green: 135.0/255.0,
                                 blue: 237.0/255.0)
        static let liknedin = Color(hex: "0e76a8")
        static let primary = Color(red: 17.0/255.0,
                                   green: 45.0/255.0,
                                   blue: 106.0/255.0)
    }
    
    static let primary243 = Color(red: 243/255,
                                  green: 243/255,
                                  blue: 243/255)
    static let primary93175187 = Color(red: 93/255,
                                       green: 175/255,
                                       blue: 187/255)
}

extension UIFont {
    static func poppins700(size: CGFloat) -> UIFont {
        return UIFont(name: "Poppins-Bold", size: size)!
    }

    static func poppins600(size: CGFloat) -> UIFont {
        return UIFont(name: "Poppins-SemiBold", size: size)!
    }

    static func poppins500(size: CGFloat) -> UIFont {
        return UIFont(name: "Poppins-Medium", size: size)!
    }

    static func poppins400(size: CGFloat) -> UIFont {
        return UIFont(name: "Poppins-Regular", size: size)!
    }

    static func poppins600Italic(size: CGFloat) -> UIFont {
        return UIFont(name: "Poppins-SemiBoldItalic", size: size)!
    }
    
    static func lato400(size: CGFloat) -> UIFont {
        return UIFont(name: "Lato-Regular", size: size)!
    }
}

extension Color {
    init(hex: UInt,
         alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: alpha
        )
    }
}

extension Color {
    init(hex: String) {
        var str = hex
        if str.hasPrefix("#") {
            str.removeFirst()
        }
        if str.count == 3 {
            str = String(repeating: str[str.startIndex], count: 2)
            + String(repeating: str[str.index(str.startIndex, offsetBy: 1)], count: 2)
            + String(repeating: str[str.index(str.startIndex, offsetBy: 2)], count: 2)
        } else if !str.count.isMultiple(of: 2) || str.count > 8 {
            self.init(.sRGB, red: 0, green: 0, blue: 0, opacity: 0)
        }
        let scanner = Scanner(string: str)
        var color: UInt64 = 0
        scanner.scanHexInt64(&color)
        if str.count == 2 {
            let gray = Double(Int(color) & 0xFF) / 255
            self.init(.sRGB, red: gray, green: gray, blue: gray, opacity: 1)
        } else if str.count == 4 {
            let gray = Double(Int(color >> 8) & 0x00FF) / 255
            let alpha = Double(Int(color) & 0x00FF) / 255
            self.init(.sRGB, red: gray, green: gray, blue: gray, opacity: alpha)
        } else if str.count == 6 {
            let red = Double(Int(color >> 16) & 0x0000FF) / 255
            let green = Double(Int(color >> 8) & 0x0000FF) / 255
            let blue = Double(Int(color) & 0x0000FF) / 255
            self.init(.sRGB, red: red, green: green, blue: blue, opacity: 1)
        } else if str.count == 8 {
            let red = Double(Int(color >> 24) & 0x000000FF) / 255
            let green = Double(Int(color >> 16) & 0x000000FF) / 255
            let blue = Double(Int(color >> 8) & 0x000000FF) / 255
            let alpha = Double(Int(color) & 0x000000FF) / 255
            self.init(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
        } else {
            self.init(.sRGB, red: 0, green: 0, blue: 0, opacity: 0)
        }
    }

    static func rgba(_ red: CGFloat,
                     _ green: CGFloat,
                     _ blue: CGFloat,
                     _ opacity: CGFloat = 1) -> Color {
        Color(red: red/255.0,
              green: green/255.0,
              blue: blue/255.0)
        .opacity(opacity)
    }
}

extension Color {
    static let primaryLightGray = Color(hex: "FAFAFB")//rgba(242, 242, 242, 1)//Color.rgba(250, 250, 251, 1)
    static let textGray = Color.rgba(167, 175, 184, 1)
    static let primaryLightBlue = Color.rgba(244, 245, 255, 1)
    static let sliderBlue = Color.rgba(17, 45, 106, 1)
    static let overlayGray = Color.rgba(224, 224, 224, 1)
    static let textDarkGray = Color.rgba(22, 24, 22, 0.65)
    static let brightGreen = Color.rgba(33, 238, 0, 1)
    static let overlayLightGray = Color.rgba(0, 0, 0, 0.1)
    

    static let textFieldForeground = Color.rgba(42, 42, 42, 1)
}
