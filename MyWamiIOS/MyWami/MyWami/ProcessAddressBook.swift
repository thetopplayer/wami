//
//  ProcessAddressBook.swift
//  MyWami
//
//  Created by Robert Lanter on 5/9/15.
//  Copyright (c) 2015 Robert Lanter. All rights reserved.
//

import MessageUI
import AddressBook

class ProcessAddressBook: UIViewController {

    var adbk : ABAddressBook?
    var authDone: Bool = false
    var replaceContact = false
    var error: Unmanaged<CFErrorRef>? = nil
    
    var firstName = ""
    var lastName = ""
    var email = ""
    var telephone = ""
    var streetAddress = ""
    var city = ""
    var state = ""
    var zipcode = ""
    var country = ""
    var person: AnyObject!
    
    func initialize() {
        let adbk: ABAddressBook = ABAddressBookCreateWithOptions(nil, nil).takeRetainedValue()
    }

    func getAuthorization() -> Bool {
        if !self.authDone {
            self.authDone = true
            let status = ABAddressBookGetAuthorizationStatus()
            
            switch status {
            case .Denied, .Restricted:
                return false
            case .Authorized, .NotDetermined:
                var err : Unmanaged<CFError>? = nil
                var adbk : ABAddressBook? = ABAddressBookCreateWithOptions(nil, &err).takeRetainedValue()
                if adbk == nil {
                    return false
                }
                ABAddressBookRequestAccessWithCompletion(adbk) {
                    (granted:Bool, err:CFError!) in
                    if granted {
                        self.adbk = adbk
                    }
                    else {
                        
                    }
                }
                return true
            }
        }
        return true
    }
    
    func checkForExist(firstName: String, lastName: String) -> Int {
        self.firstName = firstName
        self.lastName = lastName
        
        var targetContact = ((self.firstName + " " + self.lastName).uppercaseString).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
 
        let addressBook: ABAddressBook? = adbk
        if addressBook == nil {
            return 2
        }
        let allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook)
        if allPeople == nil {
            return 2
        }
        if let allPeopleArray = allPeople.takeRetainedValue() as NSArray? {
            let people = allPeopleArray as [ABRecord]
            
            for person in people {
                if let a = ABRecordCopyCompositeName(person) {
                    let b = a.takeRetainedValue()
                    var name = ((String(ABRecordCopyCompositeName(person).takeRetainedValue())).uppercaseString).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                    if name == targetContact {
                        self.person = person
                        return 0
                    }
                }
            }
        }

        return 1
        
//        let people = ABAddressBookCopyArrayOfAllPeople(adbk).takeRetainedValue() as NSArray as [ABRecord]
        
        //****
//        for person in people {
//            if let a = ABRecordCopyCompositeName(person) {
//                let b = a.takeRetainedValue()
//                var name = ((String(ABRecordCopyCompositeName(person).takeRetainedValue())).uppercaseString).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
//                println(name)
////                                  if name == "ROBBIE LANTER" {
////                                      ABAddressBookRemoveRecord(adbk, person, nil)
////                                  }
////                                  ABAddressBookSave(adbk, &error)
//            }
//        }
        //***
    }
    
    func addToContactListAction(firstName: String, lastName: String, telephone: String, email: String,
        streetAddress: String, city: String, state: String, zipcode: String, country: String, replaceContact: Bool) {
    
        self.replaceContact = replaceContact
        self.firstName = firstName
        self.lastName = lastName
        self.telephone = telephone
        self.email = email
        self.streetAddress = streetAddress
        self.city = city
        self.state = state
        self.zipcode = zipcode
        self.country = country
        
        if self.replaceContact {
            ABAddressBookRemoveRecord(self.adbk, self.person, nil)
            ABAddressBookSave(self.adbk, &self.error)
        }

        var newContact:ABRecordRef! = ABPersonCreate().takeRetainedValue()
        var success:Bool = false
        
        if self.firstName != "" {
            success = ABRecordSetValue(newContact, kABPersonFirstNameProperty, self.firstName, &error)
        }
        if self.lastName != "" {
            success = ABRecordSetValue(newContact, kABPersonLastNameProperty, self.lastName, &error)
         }
        if self.telephone != "" {
            var phoneNumbers: ABMutableMultiValueRef = createMultiStringRef()
            var phone = ((self.telephone as String).stringByReplacingOccurrencesOfString(" ", withString: "") as NSString)
            ABMultiValueAddValueAndLabel(phoneNumbers, phone, kABPersonPhoneMainLabel, nil)
            success = ABRecordSetValue(newContact, kABPersonPhoneProperty, phoneNumbers, &error)
         }
        if self.email != "" {
            var multiEmail: ABMutableMultiValueRef = createMultiStringRef()
            var email = ((self.email as String).stringByReplacingOccurrencesOfString(" ", withString: "") as NSString)
            ABMultiValueAddValueAndLabel(multiEmail, email, kABHomeLabel, nil)
            success = ABRecordSetValue(newContact, kABPersonEmailProperty, multiEmail, &error)
        }
        var multiAddress: ABMutableMultiValueRef = createMultiStringRef()
        if self.streetAddress != "" {
            var addressDictionary:NSDictionary = NSDictionary(dictionary: [kABPersonAddressStreetKey : self.streetAddress])
            if self.city != "" {
                addressDictionary = NSMutableDictionary(dictionary: [kABPersonAddressCityKey : self.city])
            }
            if self.state != "" {
                addressDictionary = NSMutableDictionary(dictionary: [kABPersonAddressStateKey : self.state])
            }
            if self.zipcode != "" {
                addressDictionary = NSMutableDictionary(dictionary: [kABPersonAddressZIPKey : self.zipcode])
            }
            if self.country != "" {
                addressDictionary = NSMutableDictionary(dictionary: [kABPersonAddressCountryKey : self.country])
            }
            ABMultiValueAddValueAndLabel(multiAddress, addressDictionary, kABHomeLabel, nil)
            success = ABRecordSetValue(newContact, kABPersonAddressProperty, multiAddress, &error)
        }
        
        success = ABAddressBookAddRecord(self.adbk, newContact, &error)
        success = ABAddressBookSave(self.adbk, &error)
     }
    func createMultiStringRef() -> ABMutableMultiValueRef {
        let propertyType: NSNumber = kABMultiStringPropertyType
        return Unmanaged.fromOpaque(ABMultiValueCreateMutable(propertyType.unsignedIntValue).toOpaque()).takeUnretainedValue() as NSObject as ABMultiValueRef
    }
}