//
//  URLSessionProviderTests.swift
//  Movie-Sample-AlperTests
//
//  Created by Alper Tufan on 26.12.2021.
//

import XCTest
@testable import Movie_Sample_Alper

class URLSessionProviderTests: XCTestCase {

    var sut: URLSessionProvider!
    
    override func setUp() {
        sut = URLSessionProvider()
    }

    override func tearDown() {
        sut = nil
    }

    func testRequestSuccess() {
        // Given
        let expectation = self.expectation(description: "Request Data Success")

        // When
        sut.request(type: MovieListBaseModel.self, service: MovieService.list(pageNumber: 1)) { response in
            switch response {
            
        // Then
            case let .success(movieBaseModel):
                XCTAssertNotNil(movieBaseModel)
            case let .failure(error):
                XCTAssertNil(error)
            }
            expectation.fulfill()
        }
        self.wait(for: [expectation], timeout: 5)

    }

    func testRequestFailure() {
        // Given
        let expectation = self.expectation(description: "Request Data Failure")

        // When
        sut.request(type: MovieListBaseModel.self, service: MovieService.list(pageNumber: -1)) { response in
            switch response {
        // Then
            case let .success(movieBaseModel):
                XCTAssertNil(movieBaseModel)
            case let .failure(error):
                XCTAssertNotNil(error)
            }
            expectation.fulfill()
        }
        self.wait(for: [expectation], timeout: 5)

    }
}
