import Foundation
import CoreLocation
typealias CompletionClosure = (() -> Void)
typealias NoConnectivityClosure = ((_ msg: String?) -> Void)
typealias LoadMoreCompletionClosure = ((_ show: Bool) -> Void)
typealias ErrorClosure = ((_ error: Error?) -> Void)

protocol DeliveryListModelProtocol {
    var errorHandler: ErrorClosure? { get set }
    var noConnectivityHandler: NoConnectivityClosure? { get set }
    var loadMoreCompletionHandler: LoadMoreCompletionClosure? { get set }
    var reloadListDataHandler: CompletionClosure? { get set }
    func apiCallForPullDownToRefresh()
    func loadMoreApiCallInProgress(indexPath: IndexPath)
    func numberOfRows() -> Int
    func getDeliveryModel(index: IndexPath) -> DeliveryModel
    func getListData()
    func setShowLoader(show: Bool)
    func getShowLoader() -> Bool
    func setApiState(apiStatus: ApiState)
    func getApiState() -> ApiState
    func getDeliveryDescription(index: IndexPath) -> String
    func getImageUrl(index: IndexPath) -> String
    func getLocation(index: IndexPath) -> CLLocationCoordinate2D
}
