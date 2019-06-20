// swiftlint:disable all
import Foundation
import CoreLocation
import UIKit
class DeliveryViewModel : NSObject, DeliveryListModelProtocol {

    var errorHandler: ErrorClosure?
    var noConnectivityHandler: NoConnectivityClosure?
    var loadMoreCompletionHandler: LoadMoreCompletionClosure?
    var reloadListDataHandler: CompletionClosure?
    var apiStatus: ApiState!
    let limit: Int = 20
    var offset: Int? = 0
    var showLoader: Bool = true
    var moreDataToLoad: Bool = true
    ///Array of List Model class
    private var arrayOfDelivery: [DeliveryModel] = [] {
        //Reload data when data set
        didSet { reloadListDataHandler?() }
    }
    // MARK: Tableview rows
    func numberOfRows() -> Int {
        return arrayOfDelivery.count
    }
    
    func setShowLoader(show: Bool) {
        showLoader = show
    }
    
    func getShowLoader() -> Bool{
        return showLoader
    }
    
    func setApiState(apiStatus : ApiState){
        self.apiStatus = apiStatus
    }
    func getApiState() -> ApiState {
        return apiStatus
    }
    

    func apiCallForPullDownToRefresh() {
        offset = 0
        showLoader = false
        moreDataToLoad = true
        getListData()
    }

    func loadMoreApiCallInProgress(indexPath : IndexPath) {
        if indexPath.row == arrayOfDelivery.count-1 {
            if apiStatus != ApiState.apiInProgress {
                if moreDataToLoad {
                    loadMoreCompletionHandler?(true)
                }else{
                    loadMoreCompletionHandler?(false)
                }
            }
        }
    }
    
    

///get data from api
    func getListData() {
        
        if apiStatus == ApiState.apiInProgress {
            return
        }
        
        if !ReachabilityWrapper.checkForInternet() && CoreDataHelper.sharedManager.checkDataAvailableOrNot(entity:CoreDataEntityName.entityName) {
            noConnectivityHandler?(ConstantMessage.checkConnectivity)
            apiStatus = .apiFailed
            return
        }
        
        apiStatus = .apiInProgress
        if showLoader {
            LoaderActivity.shared.show()
        }
        NetworkService.shared.fetchDeliveryList(offset!,limit) { [weak self] (deliveryDataArray,error) in
            guard let weakSelfRefrence = self else {
                return
            }
            LoaderActivity.shared.stop()
            weakSelfRefrence.showLoader = false
            if error != nil {
                weakSelfRefrence.moreDataToLoad = true
                weakSelfRefrence.apiStatus = .apiFailed
                weakSelfRefrence.errorHandler?(error)
            } else {
                weakSelfRefrence.apiStatus = .apiSuccess
                if weakSelfRefrence.offset! == 0 {
                    weakSelfRefrence.arrayOfDelivery.removeAll()
                    weakSelfRefrence.arrayOfDelivery = deliveryDataArray ?? []
                } else {
                    weakSelfRefrence.isMoreDataAvailable(data: deliveryDataArray ?? [])
                    weakSelfRefrence.arrayOfDelivery.append(contentsOf: deliveryDataArray ?? [])
                }
                weakSelfRefrence.offset = (weakSelfRefrence.arrayOfDelivery.count)
            }
        }
    }

//this is to check load more data or not
    private func isMoreDataAvailable(data: [DeliveryModel]) {
        if data.count > 0 {
            self.moreDataToLoad = true
        } else {
           self.moreDataToLoad = false
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

extension DeliveryViewModel {
    func getDeliveryDescription(index : IndexPath) -> String {
        if arrayOfDelivery.indices.contains(index.row),let description = arrayOfDelivery[index.row].deliveryDescription {
            #warning("please remove indexpath before giving code")
            return "indexpath : \(index.row) and \(description)"
        }
       return ""
    }
    func getImageUrl(index: IndexPath) -> String {
            if arrayOfDelivery.indices.contains(index.row), let imageUrl = arrayOfDelivery[index.row].imageURL {
                return imageUrl
            }
        return ""
    }
    
    func getLocation(index: IndexPath) -> CLLocationCoordinate2D {
        if arrayOfDelivery.indices.contains(index.row), let location = arrayOfDelivery[index.row].location {
            return CLLocationCoordinate2D(latitude: location.lat ?? 0, longitude: location.lng ?? 0)
        }
        return CLLocationCoordinate2D(latitude: 0, longitude: 0)
    }
    
    func getDeliveryModel(index: IndexPath) -> DeliveryModel {
        return arrayOfDelivery[index.row]
    }
}
