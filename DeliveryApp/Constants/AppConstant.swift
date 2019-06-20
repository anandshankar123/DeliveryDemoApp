import Foundation
import UIKit
struct ScreenSize {
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
}
enum ApiState {
    case apiInProgress
    case apiFailed
    case apiSuccess
}
struct AppConstants {
    static let protocolo: String = "https://"
    static let domain: String = "mock-api-mobile.dev.lalamove.com"
    static let baseUrl: String = AppConstants.protocolo + AppConstants.domain
    static let endPoint: String = "/deliveries?"
}

struct AppKeys {
    static let googleApiKey = "AIzaSyAHEh-gVyTF77mVd8vIWz-hkOwan7uCPns"
}

struct TopBottomPadding {
    @available(iOS 11.0, *)
    static let topPadding: CGFloat = UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0
    @available(iOS 11.0, *)
    static let bottomPadding: CGFloat = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
}
struct ConstantMessage {
    static let apiFailedMessage = "Something went worng."
    static let homeTiltleText = "Things to Deliver"
    static let loadMore = "Load More"
    static let retry = "Retry"
    static let refreshText = "Fetching Delivery Data ..."
    static let detailHeaderText = "Delivery Details"
    static let alertTitle = "Assignment Nagarro"
    static let alertBtnText = "OK"
    static let descriptionNotFound = "Delivery Address or Description not found"
    static let dataNotFound = "Not Found"
    static let checkConnectivity = "Please check your internet connectivity and retry"

}

struct CoreDataEntityName {
    static let entityName = "DeliveryData"
}

class CustomNavigationController: UINavigationController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
class CustomNavigationTitleView: UIView {
   static func setNaviagtionTitleCenter() -> UILabel {
        let label = UILabel()
        label.text = ConstantMessage.homeTiltleText
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.superview?.addConstraint(NSLayoutConstraint(item:
            label,attribute: .centerX,relatedBy: .equal,toItem:
            label.superview,attribute: .centerX,multiplier: 1,constant: 0))
        label.superview?.addConstraint(NSLayoutConstraint(item: label,
        attribute: .width, relatedBy: .equal, toItem: label.superview,
        attribute: .width, multiplier: 1, constant: 0))
        label.superview?.addConstraint(NSLayoutConstraint(item: label,
        attribute: .centerY, relatedBy: .equal, toItem: label.superview,
        attribute: .centerY, multiplier: 1, constant: 0))
        label.superview?.addConstraint(NSLayoutConstraint(item: label,
        attribute: .height, relatedBy: .equal, toItem: label.superview,
        attribute: .height, multiplier: 1, constant: 0))
        return label
    }
}
struct ColorConstant {
   static let tableBackGroundColor = UIColor.rgb(red: 12, green: 47, blue: 57)
   static let activityIndicatorTintColor = UIColor(red: 0.25,green: 0.72,blue: 0.85,alpha: 1.0)
}

struct FontConstant {
    static let headerFont = UIFont.boldSystemFont(ofSize: 18)
    static let titleFont = UIFont.boldSystemFont(ofSize: 16)
    static let textFont = UIFont.systemFont(ofSize: 16)

}
