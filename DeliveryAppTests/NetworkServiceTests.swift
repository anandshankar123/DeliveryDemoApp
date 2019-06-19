//
//  NetworkServiceTests.swift
//  NagarroChallengeTests
//
//  Created by Kanika on 17/06/19.
//  Copyright © 2019 Kanika. All rights reserved.
//

import XCTest
@testable import DeliveryApp
import Mockingjay
class NetworkServiceTests: XCTestCase {
    static let testUrlStr = "https://mock-api-mobile.dev.lalamove.com/deliveries?offset=0&limit=20"
    let networkCall = NetworkService.shared

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testRetiveStringURLForDeliverData() {
        let urlStr = AppConstants.baseUrl + AppConstants.endPoint + "offset=0&limit=20"
        let responseStr = networkCall.retiveURLForDeliveryData(offset: 0,limit: 20)
        XCTAssert(urlStr == responseStr, "URL must be equals to \(NetworkServiceTests.testUrlStr)")
    }
    func testRetiveStringURLForDeliverDataShouldFail() {
        let urlStr = AppConstants.baseUrl + AppConstants.endPoint + "offset=0&limit=20"
        let responseStr = networkCall.retiveURLForDeliveryData(offset: 0,limit: 30)
        XCTAssert(urlStr != responseStr, "URL must be not equals to \(NetworkServiceTests.testUrlStr)")
    }
    func testFetchDeliveryData() {
        guard let requestUrl = URL(string: NetworkServiceTests.testUrlStr) else { return }
        let path = Bundle(for: type(of: self)).path(forResource: "DeliveryData", ofType: "json")!
        let data = NSData(contentsOfFile: path)!
        self.stub(uri(NetworkServiceTests.testUrlStr), jsonData(data as Data))
        let promise = expectation(description: "Simple Request")
        URLSession.shared.dataTask(with: requestUrl) { (data, response
            , error) in
            guard let data = data else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
                if let result = json as? [[String : Any]], result.count > 0{
                    let fistObject = result[0]
                    XCTAssertTrue(fistObject["id"] as? Int == 0)
                    XCTAssertTrue(fistObject["description"] as? String == "Deliver documents to Andrio")
                    promise.fulfill()
                }
            } catch let err {
                print("Err", err)
            }
            }.resume()
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testFetchDeliveryDataForUnexpectedData() {
        guard let requestUrl = URL(string: NetworkServiceTests.testUrlStr) else { return }
        let path = Bundle(for: type(of: self)).path(forResource: "UnexpectedResponse", ofType: "json")!
        let data = NSData(contentsOfFile: path)!
        self.stub(uri(NetworkServiceTests.testUrlStr), jsonData(data as Data))
        let promise = expectation(description: "Unexpected Request")
        URLSession.shared.dataTask(with: requestUrl) { (data, response
            , error) in
            guard let data = data else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
                if let result = json as? [[String : Any]], result.count > 0{
                    let fistObject = result[0]
                    XCTAssertTrue(fistObject["id"] as? Int != 0)
                    promise.fulfill()
                }
            } catch let err {
                print("Err", err)
            }
            }.resume()
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testDataForEmptyData() {
        guard let requestUrl = URL(string: NetworkServiceTests.testUrlStr) else { return }
        let emptyList = [[String : Any]]()
        let emptyData : Data = NSKeyedArchiver.archivedData(withRootObject: emptyList)
        self.stub(uri(NetworkServiceTests.testUrlStr), jsonData(emptyData as Data))
        let promise = expectation(description: "Empty Data")
        URLSession.shared.dataTask(with: requestUrl) { (data, response
            , error) in
            guard let data = data else { return }
            do{
                if let result = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [[String : Any]] {
                    XCTAssertTrue(result.count == 0)
                    promise.fulfill()
                }
            }catch{
                print("Unable to successfully convert NSData to NSDictionary")
            }
            }.resume()
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testGetDeliveryWhenResponseErrorReturnsError() {
        guard let requestUrl = URL(string: "https://mock-api-mobile.dev.lalamove.com/deliveries?offset") else { return }
        let localError = NSError(domain: "No data was found", code: 1, userInfo: nil)
        let errorData : Data = NSKeyedArchiver.archivedData(withRootObject: localError)
        self.stub(uri("https://mock-api-mobile.dev.lalamove.com/deliveries?offset"), jsonData(errorData as Data))
        let promise = expectation(description: "Error")
        URLSession.shared.dataTask(with: requestUrl) { (data, response
            , error) in
            guard let data = data else { return }
            do{
                if let result = try NSKeyedUnarchiver.unarchiveObject(with: data) as? NSError {
                    XCTAssertTrue(result.domain == "No data was found")
                    XCTAssertTrue(result.code == 1)
                    promise.fulfill()
                }
            }catch{
                print("Unable to successfully convert NSData to NSDictionary")
            }
            }.resume()
        waitForExpectations(timeout: 5, handler: nil)
    }
}
