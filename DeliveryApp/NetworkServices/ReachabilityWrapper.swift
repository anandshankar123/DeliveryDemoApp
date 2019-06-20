//
//  ReachabilityWrapper.swift
//  DeliveryApp
//
//  Created by Kanika on 19/06/19.
//  Copyright © 2019 Kanika. All rights reserved.
//

import Foundation
import Reachability
class ReachabilityWrapper: NSObject {
   static func checkForInternet() -> Bool {
        return Reachability.init()?.isReachable ?? false
    }
}
