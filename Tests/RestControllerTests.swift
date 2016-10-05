//
//  RestEssentialsTests.swift
//  RestEssentialsTests
//
//  Created by Sean Kosanovich on 7/30/15.
//  Copyright © 2016 Sean Kosanovich. All rights reserved.
//

import XCTest
@testable import RestEssentials

class RestControllerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGET() {
        let expectation = self.expectation(description: "GET JSON network call")

        guard let rest = RestController.create(urlString: "http://httpbin.org/get") else {
            XCTFail("Bad URL")
            return
        }

        rest.get { result, httpResponse in
            do {
                let json = try result.value()
                print(json)
                XCTAssert(json["url"]?.string == "http://httpbin.org/get")

                expectation.fulfill()
            } catch {
                XCTFail("Error performing GET: \(error)")
            }
        }
        
        waitForExpectations(timeout: 5) { (error) -> Void in
            if let _ = error {
                XCTFail("Test timeout reached")
            }
        }
    }
    
    func testPOST() {
        let expectation = self.expectation(description: "POST JSON network call")

        guard let rest = RestController.create(urlString: "http://httpbin.org") else {
            XCTFail("Bad URL")
            return
        }

        rest.post(relativePath: "post", json: JSON(dict: ["key1": "value1", "key2": 2, "key3": 4.5, "key4": true])) { result, httpResponse in
            do {
                let json = try result.value()
                print(json)
                XCTAssert(json["url"]?.string == "http://httpbin.org/post")
                XCTAssert(json["json"]?["key1"]?.string == "value1")
                XCTAssert(json["json"]?["key2"]?.int == 2)
                XCTAssert(json["json"]?["key3"]?.double == 4.5)
                XCTAssert(json["json"]?["key4"]?.bool == true)

                expectation.fulfill()
            } catch {
                XCTFail("Error performing POST: \(error)")
            }
        }

        waitForExpectations(timeout: 5) { (error) -> Void in
            if let _ = error {
                XCTFail("Test timeout reached")
            }
        }
    }

    func testPUT() {
        let expectation = self.expectation(description: "PUT JSON network call")

        guard let rest = RestController.create(urlString: "http://httpbin.org") else {
            XCTFail("Bad URL")
            return
        }

        rest.put(relativePath: "put", json: JSON(dict: ["key1": "value1", "key2": 2, "key3": 4.5, "key4": true])) { result, httpResponse in
            do {
                let json = try result.value()
                print(json)
                XCTAssert(json["url"]?.string == "http://httpbin.org/put")

                expectation.fulfill()
            } catch {
                XCTFail("Error performing PUT: \(error)")
            }
        }

        waitForExpectations(timeout: 5) { (error) -> Void in
            if let _ = error {
                XCTFail("Test timeout reached")
            }
        }
    }

    func testGetImage() {
        let expectation = self.expectation(description: "GET Image network call")

        guard let rest = RestController.create(urlString: "https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png") else {
            XCTFail("Bad URL")
            return
        }

        rest.get(responseHandler: ImageResponseHandler()) { result, httpResponse in
            do {
                let img = try result.value()
                XCTAssert(img is UIImage)

                expectation.fulfill()
            } catch {
                XCTFail("Error performing GET: \(error)")
            }
        }

        waitForExpectations(timeout: 5) { (error) -> Void in
            if let _ = error {
                XCTFail("Test timeout reached")
            }
        }
    }

    func testVoidResponse() {
        let expectation = self.expectation(description: "GET Void network call")

        guard let rest = RestController.create(urlString: "https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png") else {
            XCTFail("Bad URL")
            return
        }

        rest.get(responseHandler: VoidResponseHandler()) { _, httpResponse in
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5) { (error) -> Void in
            if let _ = error {
                XCTFail("Test timeout reached")
            }
        }
    }

    func testDataResponse() {
        let expectation = self.expectation(description: "GET Data network call")

        guard let rest = RestController.create(urlString: "https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png") else {
            XCTFail("Bad URL")
            return
        }

        rest.get(responseHandler: DataResponseHandler()) { result, httpResponse in
            do {
                let data = try result.value()
                XCTAssert(data is Data)

                expectation.fulfill()
            } catch {
                XCTFail("Error performing GET: \(error)")
            }
        }

        waitForExpectations(timeout: 5) { (error) -> Void in
            if let _ = error {
                XCTFail("Test timeout reached")
            }
        }
    }

}
