//
//  Movie_Sample_AlperTests.swift
//  Movie-Sample-AlperTests
//
//  Created by Alper Tufan on 7.07.2021.
//

import XCTest
@testable import Movie_Sample_Alper

class Movie_Sample_AlperTests: XCTestCase {

    var sut: URLSession!

    override func setUpWithError() throws {
        try super.setUpWithError()
          sut = URLSession(configuration: .default)
        
    }

    override func tearDownWithError() throws {
        sut = nil
         try super.tearDownWithError()
    }
    
    func testValidApiCallGetsHTTPStatusCode200() throws {
      // given
      let urlString =
        "https://api.themoviedb.org/3/movie/popular?language=en-US&api_key=fd2b04342048fa2d5f728561866ad52a&page=1"
      let url = URL(string: urlString)!
      let promise = expectation(description: "Status code: 200")
      let dataTask = sut.dataTask(with: url) { _, response, error in
        if let error = error {
          XCTFail("Error: \(error.localizedDescription)")
          return
        } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
          if statusCode == 200 {
            promise.fulfill()
          } else {
            XCTFail("Status code: \(statusCode)")
          }
        }
      }
      dataTask.resume()
      wait(for: [promise], timeout: 5)
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
