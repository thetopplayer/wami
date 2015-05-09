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
    var cancelAddContact = false
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
    
    func initialize() {
        let adbk: ABAddressBook = ABAddressBookCreateWithOptions(nil, nil).takeRetainedValue()
    }
    
    func cancelContactAction(alertController: UIAlertAction!) {
        self.cancelAddContact = true
    }
    func replaceContactAction(alertController: UIAlertAction!) {
       self.replaceContact = true
    }
    func addContactAction(alertController: UIAlertAction!) {
        
    }

    func getAuthorization() -> Bool {
        if !self.authDone {
            self.authDone = true
            let status = ABAddressBookGetAuthorizationStatus()
            
            switch status {
            case .Denied, .Restricted:
                println("no access")
            case .Authorized, .NotDetermined:
                var err : Unmanaged<CFError>? = nil
                var adbk : ABAddressBook? = ABAddressBookCreateWithOptions(nil, &err).takeRetainedValue()
                if adbk == nil {
                    println(err)
                }
                ABAddressBookRequestAccessWithCompletion(adbk) {
                    (granted:Bool, err:CFError!) in
                    if granted {
                        self.adbk = adbk
                    }
                    else {
                        println(err)
                    }
                }
            }
        }
        return self.authDone
    }
    
    func checkForExist(firstName: String, lastName: String) {
        self.firstName = firstName
        self.lastName = lastName
        
        var targetContact = ((self.firstName + " " + self.lastName).uppercaseString).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        let people = ABAddressBookCopyArrayOfAllPeople(adbk).takeRetainedValue() as NSArray as [ABRecord]
        for person in people {
            if let a = ABRecordCopyCompositeName(person) {
                let b = a.takeRetainedValue()
                var name = ((String(ABRecordCopyCompositeName(person).takeRetainedValue())).uppercaseString).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                println(name)
                if name == targetContact {
                    var alertController = UIAlertController(title: "Alert!", message: "Contact Already Exists In Address Book", preferredStyle: .Alert)
                    alertController.addAction(UIAlertAction(title: "Add", style: UIAlertActionStyle.Default, handler: addContactAction))
                    alertController.addAction(UIAlertAction(title: "Replace", style: UIAlertActionStyle.Default, handler: replaceContactAction))
                    alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: cancelContactAction))
                    dispatch_async(dispatch_get_main_queue()) {
                        self.presentViewController(alertController, animated: true, completion: nil)
                    }
                }
                //                if name == "JOHN SMITH" {
                //                    ABAddressBookRemoveRecord(adbk, person, nil)
                //                }
                //                ABAddressBookSave(adbk, &error)
            }
        }
    }
    
    func addToContactListAction(firstName: String, lastName: String, telephone: String, email: String,
        streetAddress: String, city: String, state: String, zipcode: String, country: String) {
        
        if self.cancelAddContact {
            self.firstName = firstName
            self.lastName = lastName
            self.telephone = telephone
            self.email = email
            self.streetAddress = streetAddress
            self.city = city
            self.state = state
            self.zipcode = zipcode
            self.country = country
            
            if replaceContact {
                ABAddressBookRemoveRecord(adbk, self.firstName + " " + self.lastName, nil)
                ABAddressBookSave(adbk, &error)
            }

            var newContact:ABRecordRef! = ABPersonCreate().takeRetainedValue()
            var success:Bool = false
            
            if self.firstName != "" {
                success = ABRecordSetValue(newContact, kABPersonFirstNameProperty, self.firstName, &error)
                //              println("first=\(success)")
            }
            if self.lastName != "" {
                success = ABRecordSetValue(newContact, kABPersonLastNameProperty, self.lastName, &error)
                //              println("last=\(success)")
            }
            if self.telephone != "" {
                var phoneNumbers: ABMutableMultiValueRef = createMultiStringRef()
                var phone = ((self.telephone as String).stringByReplacingOccurrencesOfString(" ", withString: "") as NSString)
                ABMultiValueAddValueAndLabel(phoneNumbers, phone, kABPersonPhoneMainLabel, nil)
                success = ABRecordSetValue(newContact, kABPersonPhoneProperty, phoneNumbers, &error)
                //              println("phone=\(success)")
            }
            if self.email != "" {
                var multiEmail: ABMutableMultiValueRef = createMultiStringRef()
                var email = ((self.email as String).stringByReplacingOccurrencesOfString(" ", withString: "") as NSString)
                ABMultiValueAddValueAndLabel(multiEmail, email, kABHomeLabel, nil)
                success = ABRecordSetValue(newContact, kABPersonEmailProperty, multiEmail, &error)
                //              println("email=\(success)")
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
                //              println("address=\(success)")
            }
            
            success = ABAddressBookAddRecord(adbk, newContact, &error)
            //          println("add=\(success)")
            success = ABAddressBookSave(adbk, &error)
            //          println("save=\(success)")
            self.cancelAddContact = false
        }
    }
    func createMultiStringRef() -> ABMutableMultiValueRef {
        let propertyType: NSNumber = kABMultiStringPropertyType
        return Unmanaged.fromOpaque(ABMultiValueCreateMutable(propertyType.unsignedIntValue).toOpaque()).takeUnretainedValue() as NSObject as ABMultiValueRef
    }
}