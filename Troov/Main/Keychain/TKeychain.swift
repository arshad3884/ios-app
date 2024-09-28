//
//  TKeychain.swift
//  mango
//
//  Created by Leo on 28.03.22.
//  Copyright © 2022 Levon Arakelyan. All rights reserved.
//

import Foundation

public enum TKeychainItems: String {
    /* TODO: - Leo
     * Should be changed in the future
     */
    case accessGroup = "group.com.troov-company.Troov"//"group.troov"
    case launched = "first.launch"
    case deviceNotificationToken = "device_notification_token"
//    case supportUserId = "google-oauth2|107547404901007509928"
}

extension TKeychainItems {
    var raw: String {
        return self.rawValue
    }

    var storedUDStringValue: String? {
        UserDefaults.standard.string(forKey: raw)
    }

    var storedUDBoolValue: Bool {
        UserDefaults.standard.bool(forKey: raw)
    }

    func removeFromUD() {
        UserDefaults.standard.removeObject(forKey: raw)
    }

    func setUD(value: String) {
        UserDefaults.standard.set(value, forKey: raw)
    }

    func setBoolUD(value: Bool) {
        UserDefaults.standard.set(value, forKey: raw)
    }
    
    
}

 public class TKeychain: NSObject {
     public class func getValue(key: String) -> Data? {
        let appAccessGroup = TKeychainItems.accessGroup.rawValue
            let queryLoad: [String: AnyObject] = [
              kSecClass as String: kSecClassGenericPassword,
              kSecAttrAccount as String: key as AnyObject,
              kSecReturnData as String: kCFBooleanTrue,
              kSecMatchLimit as String: kSecMatchLimitOne,
              kSecAttrAccessGroup as String: appAccessGroup as AnyObject
            ]

            var result: AnyObject?

            let resultCodeLoad = withUnsafeMutablePointer(to: &result) {
              SecItemCopyMatching(queryLoad as CFDictionary, UnsafeMutablePointer($0))
            }

            if resultCodeLoad == noErr {
              if let result = result as? Data {
                return result
              }
            }
        print("Error getting value from keychain: \(resultCodeLoad)")
        return nil
    }

     public class func getStringValue(key: String) -> String? {
        if let value = TKeychain.getValue(key: key),
             let strValue = NSString(data: value,
                                     encoding: String.Encoding.utf8.rawValue) as String? {
               return strValue
        }
        return nil
    }

     public class func add(key: AnyObject,
                           valueData: Data) -> OSStatus {
        let appAccessGroup = TKeychainItems.accessGroup.rawValue
            let queryAdd: [String: AnyObject] = [
              kSecClass as String: kSecClassGenericPassword,
              kSecAttrAccount as String: key as AnyObject,
              kSecValueData as String: valueData as AnyObject,
              kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked,
              kSecAttrAccessGroup as String: appAccessGroup as AnyObject
            ]

            let resultCode = SecItemAdd(queryAdd as CFDictionary, nil)

            return resultCode
    }

     public class func add(key: AnyObject,
                           value: String) -> OSStatus {
        guard let valueData = value.data(using: String.Encoding.utf8) else {
             print("Could not covert string to data in TKeychain: \(value)")
              return -1
        }

        return TKeychain.add(key: key,
                              valueData: valueData)
    }

     public class func update(key:AnyObject,valueData:Data) -> OSStatus {
        let appAccessGroup = TKeychainItems.accessGroup.rawValue
            let query: [String: AnyObject] = [
              kSecClass as String: kSecClassGenericPassword,
              kSecAttrAccount as String:  key as AnyObject,
              kSecAttrAccessGroup as String: appAccessGroup as AnyObject
            ]

            let attributes: [String: AnyObject] = [
                     kSecValueData as String: valueData as AnyObject
            ]

            let resultCode = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)

            if resultCode != noErr {
               print("Error updating from Keychain: \(resultCode)")
            }

            return resultCode
    }

     public class func update(key:AnyObject,value:String) -> OSStatus {
        guard let valueData = value.data(using: String.Encoding.utf8) else {
            print("Could not convert string to data in TKeychain: \(value)")
              return -1
        }

        return TKeychain.update(key: key,
                                 valueData: valueData)
    }

     public class func addOrUpdate(key: AnyObject,
                                   valueData: Data) -> OSStatus {
        var status = TKeychain.add(key: key,
                                    valueData: valueData)

        if status == errSecDuplicateItem {
            //Already exists try and update
            status = TKeychain.update(key: key,
                                       valueData:valueData)
        }

        return status
    }


    @discardableResult  public class func addOrUpdate(key: AnyObject,
                                                      value: String) -> OSStatus {
        guard let valueData = value.data(using: String.Encoding.utf8) else {
            print("Could not convert string to data in TKeychain: \(value)")
              return -1
        }

        return addOrUpdate(key: key,
                           valueData: valueData)
    }
    
  @discardableResult public class func addOrUpdate(key: AnyObject,
                                                   dictionary: NSDictionary) -> OSStatus {
        do {
             let valueData = try NSKeyedArchiver.archivedData(withRootObject: dictionary, requiringSecureCoding: false)
             return addOrUpdate(key: key,
                                valueData: valueData)
         } catch let error as NSError {
             print("Unable to archive dictionary: \(error)")
             return OSStatus()
         }
    }

   @discardableResult public class func addOrUpdate(key: AnyObject,
                                                    array: NSArray) -> OSStatus {
        do {
            let valueData = try NSKeyedArchiver.archivedData(withRootObject: array, requiringSecureCoding: false)
            return addOrUpdate(key: key,
                               valueData: valueData)
        } catch let error as NSError {
            print("Unable to archive array: \(error)")
            return OSStatus()
        }
    }

    @discardableResult public class func delete(key: AnyObject) -> OSStatus {
        let appAccessGroup = TKeychainItems.accessGroup.rawValue
            let queryDelete: [String: AnyObject] = [
              kSecClass as String: kSecClassGenericPassword,
              kSecAttrAccount as String: key as AnyObject,
              kSecAttrAccessGroup as String: appAccessGroup as AnyObject
            ]

            let resultCodeDelete = SecItemDelete(queryDelete as CFDictionary)

            if resultCodeDelete != noErr {
                print("Error deleting from Keychain: \(resultCodeDelete)")
            }
            return resultCodeDelete
    }

     public class func getAllKeyChainGenericPasswordItems() -> [String:String] {
         let query: [String: AnyObject] = [
             kSecClass as String : kSecClassGenericPassword,
             kSecReturnData as String  : kCFBooleanTrue,
             kSecReturnAttributes as String : kCFBooleanTrue,
             kSecReturnRef as String : kCFBooleanTrue,
             kSecMatchLimit as String: kSecMatchLimitAll
         ]

         var result: AnyObject?
                     
         let lastResultCode = withUnsafeMutablePointer(to: &result) {
             SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
         }

         var values = [String: String]()
         if lastResultCode == noErr {
             let array = result as? Array<Dictionary<String, Any>>
                         
             for item in array! {
                 if let key = item[kSecAttrAccount as String] as? String,
                    let value = item[kSecValueData as String] as? Data {
                      
                     values["key"] = key
                     values["password"] = String(data: value,
                                                encoding: .utf8)
                  }
              }
         }

         return values
     }
}
