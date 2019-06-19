//
//  DeliveryDetailViewModel.swift
//  DeliveryApp
//
//  Created by Kanika on 18/06/19.
//  Copyright © 2019 Kanika. All rights reserved.
//

import Foundation
class DeliveryDetailViewModel: NSObject {
    var selectedDelivery: DeliveryModel
    init(selectedDelivery: DeliveryModel) {
        self.selectedDelivery = selectedDelivery
        super.init()
    }
    func getLatitude() -> Double {
        return selectedDelivery.location?.lat ?? 0
    }
    func getLongitude() -> Double {
        return selectedDelivery.location?.lng ?? 0
    }
    func getAddress() -> String {
        return selectedDelivery.location?.address ?? ""
    }
    func getDeliveryIdAddress() -> Int {
        return selectedDelivery.deliveryId ?? -1
    }
    func getImageUrl() -> String {
        return selectedDelivery.imageURL ?? ""
    }
    func getDeliveryText() -> String {
        guard let desc = selectedDelivery.deliveryDescription, let address = selectedDelivery.location?.address else {
            return ""
        }
        return String(format: "%@ at %@", desc, address)
    }
}
