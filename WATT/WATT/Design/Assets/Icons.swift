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
        static let card = UIImage(systemName: "creditcard")
        static let magnifyingglass = UIImage(systemName: "magnifyingglass")
        static let xmark = UIImage(named: "xmark")
        static let filters = UIImage(named: "filters")
        static let location = UIImage(named: "location")
        
        public enum Navigation {
            static let chevronRight = UIImage(systemName: "chevron.right")
            static let chevronLeft = UIImage(systemName: "chevron.left")
        }
        
        public enum SideMenu {
            static let menu = UIImage(named: "menu")
        }
    }
}
