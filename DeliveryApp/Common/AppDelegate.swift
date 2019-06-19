import UIKit
import CoreData
import GoogleMaps
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
   func application(_ application: UIApplication,didFinishLaunchingWithOptions
        launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        GMSServices.provideAPIKey(AppKeys.googleApiKey)
        window = UIWindow()
        window?.makeKeyAndVisible()
        let rootCtrl = DeliveryListTblVC()
        window?.rootViewController = UINavigationController(rootViewController: rootCtrl)
        return true
    }
}
