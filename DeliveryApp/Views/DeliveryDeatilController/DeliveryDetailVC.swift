//
//  DeliveryDetailVC.swift
//  AssignmentNagarro
//
//  Created by Kanika on 14/06/19.
//  Copyright © 2019 Kanika. All rights reserved.
//

import UIKit
import GoogleMaps
class DeliveryDetailVC: UIViewController {
    var detailView: DetailView!
    var deliveryDetailViewModel: DeliveryDetailViewModel!
    override func loadView() {
        detailView  = DetailView(frame: UIScreen.main.bounds, model: deliveryDetailViewModel)
        detailView.backgroundColor = .white
        view = detailView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = ConstantMessage.detailHeaderText
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in 
            self?.detailView.showMarker()
        }
    }
}
