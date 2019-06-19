import Foundation
import UIKit
extension UIColor {
    static let mainTextBlue = UIColor.rgb(red: 7, green: 71, blue: 89)
    static let highlightColor = UIColor.rgb(red: 50, green: 199, blue: 242)
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}
