//
//  DeliveryViewModelTest.swift
//  NagarroChallengeTests
//
//  Created by Kanika on 17/06/19.
//  Copyright © 2019 Kanika. All rights reserved.
//

import XCTest
@testable import NagarroChallenge
class DeliveryViewModelTest: XCTestCase {
    var viewModel = DeliveryViewModel()
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    func testCreateDeliveryViewModel() {
        // Given
        let deliveryModelList = StubGenerator().stubDeliveryList()
        DeliveryViewModel.init().arrayOfDelivery = deliveryModelList
        let expect = XCTestExpectation(description: "reload closure triggered")
        viewModel.reloadList = { () in
            expect.fulfill()
        }
        viewModel.getListData()
        XCTAssertEqual(viewModel.arrayOfDelivery.count, deliveryModelList.count)
        wait(for: [expect], timeout: 2.0)
    }
}

class StubGenerator {
    func stubDeliveryList() -> [DeliveryModel] {
        var deliveryList = [DeliveryModel]()
        guard let path = Bundle.main.path(forResource: "DeliveryData", ofType: "json") else {
            return deliveryList
        }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            return deliveryList
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        guard let list = try? decoder.decode([DeliveryModel].self, from: data) else {
            return deliveryList
        }
        deliveryList = list
        return deliveryList
    }
}
