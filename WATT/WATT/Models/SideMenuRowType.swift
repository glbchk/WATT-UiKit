//
//  SideMenuRowType.swift
//  WATT
//
//  Created by Stas Boiko on 29.02.2024.
//

import UIKit

enum SideMenuRowType {
    case profile, bookings, myChargings, myCars, listYourCharger, paymentMethod, inviteFriends, help, feedback, signOut
    
    var title: String {
        switch self {
        case .profile:
            "Profile"
        case .bookings:
            "Bookings"
        case .myChargings:
            "My chargings"
        case .myCars:
            "My cars"
        case .listYourCharger:
            "List your charger"
        case .paymentMethod:
            "Payment method"
        case .inviteFriends:
            "Invite friends"
        case .help:
            "Help"
        case .feedback:
            "Feedback"
        case .signOut:
            "Sign out"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .profile:
            Asset.Icons.account
        case .bookings:
            Asset.Icons.SideMenu.bookings
        case .myChargings:
            Asset.Icons.SideMenu.myChargings
        case .myCars:
            Asset.Icons.car
        case .listYourCharger:
            Asset.Icons.evStation
        case .paymentMethod:
            Asset.Icons.card
        case .inviteFriends:
            Asset.Icons.SideMenu.inviteFriends
        case .help:
            Asset.Icons.SideMenu.help
        case .feedback:
            Asset.Icons.SideMenu.feedback
        case .signOut:
            Asset.Icons.SideMenu.signOut
        }
    }
}
