//
//  Alert.swift
//  AssignmentNagarro
//
//  Created by Kanika on 15/06/19.
//  Copyright © 2019 Kanika. All rights reserved.
//

import Foundation
import UIKit

class Alert {
    static let shared: Alert = Alert()
    func show(_ onController: UIViewController, withTitle: String, alert: String) {
        let alertVC = UIAlertController(title: withTitle, message: alert, preferredStyle: UIAlertController.Style.alert)
        alertVC.addAction(UIAlertAction(title: ConstantMessage.alertBtnText, style: .default, handler: nil))
        onController.present(alertVC, animated: true) {
        }
    }
    func show(_ onController: UIViewController, alert: String) {
        self.show(onController, withTitle: ConstantMessage.alertTitle, alert: alert)
    }
}
