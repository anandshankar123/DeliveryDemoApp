//
//  LoaderActivity.swift
//  AssignmentNagarro
//
//  Created by Kanika on 15/06/19.
//  Copyright © 2019 Kanika. All rights reserved.
//

import Foundation
import NVActivityIndicatorView
class LoaderActivity {
    static let shared = LoaderActivity()
    func show() {
        let activityData = ActivityData(size: CGSize(width: 50, height:
            50), message: nil, messageFont: nil, type: .ballRotateChase, color: UIColor(red: 0.400, green: 0.733, blue:
                0.267, alpha: 1.00), padding: nil, displayTimeThreshold: nil, minimumDisplayTime:
            nil, backgroundColor: nil, textColor: nil)
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
    }
    func show(withText: String) {
        let activityData = ActivityData(size: CGSize(width: 50, height:
            50), message: withText, messageFont: UIFont.systemFont(ofSize:
                13), type: .ballRotateChase, color: UIColor(red: 0.400, green:
                    0.733, blue: 0.267, alpha: 1.00), padding: nil, displayTimeThreshold: nil, minimumDisplayTime:
            nil, backgroundColor: nil, textColor: UIColor.white)
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
    }
    func stop() {
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
    }
}
