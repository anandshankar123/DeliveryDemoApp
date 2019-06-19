import Foundation
import UIKit
class DeliveryViewModel {
    var apiStatus: ApiState?
    static let limit: Int = 20
    var offset: Int? = 0
    var showLoader: Bool = false
    var moreDataToLoad: Bool = true
    init() {
        self.offset = 0
    }
    ///closure use for notifi
    var reloadList = {() -> Void in }
    var errorMessage = {(error: Error?) -> Void in }
    ///Array of List Model class
    var arrayOfDelivery: [DeliveryModel] = [] {
        ///Reload data when data set
        didSet {
            reloadList()
        }
    }
    
    
    
///get data from api
    func getListData() {
        apiStatus = .apiInProgress
        if showLoader {
            LoaderActivity.shared.show()
        }
        NetworkService.shared.fetchDeliveryList(offset!,DeliveryViewModel.limit) { [weak self] (deliveryDataArray,error) in
            LoaderActivity.shared.stop()
            self?.showLoader = false
            if error != nil {
                self?.apiStatus = .apiFailed
                self?.errorMessage(error)
            } else {
                self?.apiStatus = .apiSuccess
                if self?.offset! == 0 {
                    self?.arrayOfDelivery.removeAll()
                    self?.arrayOfDelivery = deliveryDataArray ?? []
                } else {
                    self?.isMoreDataAvailable(data: deliveryDataArray ?? [])
                    self?.arrayOfDelivery.append(contentsOf: deliveryDataArray ?? [])
                }
                self?.offset = (self?.arrayOfDelivery.count ?? 0)
            }
        }
    }
//this is to check load more data or not
private func isMoreDataAvailable(data: [DeliveryModel]) {
        if data.count < 20 {
            self.moreDataToLoad = false
        } else {
           self.moreDataToLoad = true
        }
    }
}
extension UIActivityIndicatorView {
    convenience init(activityIndicatorStyle: UIActivityIndicatorView.Style,
                     color: UIColor,placeInTheCenterOf parentView: UIView) {
        self.init(style: activityIndicatorStyle)
        center = parentView.center
        self.color = color
        parentView.addSubview(self)
    }
}
