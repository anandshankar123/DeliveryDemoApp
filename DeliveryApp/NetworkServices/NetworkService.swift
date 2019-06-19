// swiftlint:disable comma colon
//  NetworkService.swift
//  Assignment
//
//  Created by Kanika on 13/06/19.
//  Copyright © 2019 Kanika. All rights reserved.
//

import UIKit
class NetworkService: NSObject {
    static let shared = NetworkService()
    func retiveURLForDeliveryData(offset: Int,limit: Int) -> String {
        return AppConstants.baseUrl + AppConstants.endPoint + "offset=\(offset)&limit=\(limit)" }
    func fetchDeliveryList(_ offset: Int,_ limit: Int,completion: @escaping ([DeliveryModel]?,Error?) -> Void) {
        let urlString = retiveURLForDeliveryData(offset: offset, limit: limit)
        print("urlString : \(urlString)")
        //note : if there is no internet we have to show data from local
        if !(Reachability.init()?.isReachable ?? true) {
//            CoreDataHelper.sharedManager.fetchDeliveryData(saveUrl: urlString) { (deliveryData,dataAvailable) in
//                if deliveryData != nil  && dataAvailable {
//                    completion(deliveryData,nil)
//                } else {
//                    completion([],nil)
//                }
//            }
            return
        }
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, _, err) in
            if let err = err {
                completion(nil, err)
                return
            }
            // check response
            guard let data = data else { return }
            do {
                if let stringObj = String.init(data: data, encoding: String.Encoding.utf8) {
                 // CoreDataHelper.sharedManager.checkAndSaveData(saveUrl: urlString, dataToSave: stringObj)
                }
                let delivery = try JSONDecoder().decode([DeliveryModel].self, from: data)
                DispatchQueue.main.async {
                    print("delivery object is : \(delivery)")
                    completion(delivery, nil)
                }
            } catch let jsonErr {
               // print("Failed to decode:", jsonErr)
                let error = NSError(domain:"",code:401,userInfo:
                    [NSLocalizedDescriptionKey: jsonErr.localizedDescription])
                completion(nil,error)
            }
        }.resume()
    }
}
