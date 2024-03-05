//
//  Icons.swift
//  WATT
//
//  Created by Stas Boiko on 02.02.2024.
//

import UIKit

extension Asset {
    public enum Icons {
        
        static let account = UIImage(named: "account.circle")
        static let car = UIImage(named: "car")
        static let evStation = UIImage(named: "ev.station")
        static let card = UIImage(named: "card")
        static let magnifyingglass = UIImage(systemName: "magnifyingglass")
        static let xmark = UIImage(named: "xmark")
        static let filters = UIImage(named: "filters")
        static let location = UIImage(named: "location")
        
        static let cash = UIImage(systemName: "banknote")
        static let unknown = UIImage(systemName: "exclamationmark.circle")
        
        public enum Navigation {
            static let chevronRight = UIImage(systemName: "chevron.right")
            static let chevronLeft = UIImage(systemName: "chevron.left")
        }
        
        public enum SideMenu {
            static let menu = UIImage(named: "menu")
            static let userPhoto = UIImage(named: "user.photo")
            static let bookings = UIImage(named: "today")
            static let myChargings = UIImage(named: "bolt")
            static let inviteFriends = UIImage(named: "paperplane")
            static let help = UIImage(named: "support")
            static let feedback = UIImage(named: "feedback")
            static let signOut = UIImage(named: "logout")
        }
        
        public enum BankCards {
            static let americanExpress = UIImage(named: "ic.ae")
            static let chase = UIImage(named: "ic.chase")
            static let discover = UIImage(named: "ic.discover")
            static let mastercard = UIImage(named: "ic.mastercard")
            static let visa = UIImage(named: "ic.visa")
            static let unknown = UIImage(systemName: "dollarsign.circle.fill")
        }
        
        public enum Menu {
            static let menu = UIImage(systemName: "line.3.horizontal")
            static let filter = UIImage(systemName: "slider.horizontal.3")
            static let locationFound = UIImage(named: "location.found")
            static let search = UIImage(systemName: "magnifyingglass")
        }
        
        public enum Cells {
            public enum PaymentMethodCell {
                static let radioMarkInactive = UIImage(systemName: "circle")
                static let radioMarkActive = UIImage(systemName: "circle.inset.filled")
            }
            public enum CollectioViewnCell {
//                static let discover = UIImage(named: "ic_discover")
//                static let mastercard = UIImage(named: "ic_mastercard")
//                static let visa = UIImage(named: "ic_visa")
            }
        }
    }
}
