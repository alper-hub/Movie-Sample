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
        sut.request(type: MovieListBaseModel.self, service: MovieService.list(pageNumber: -1)) { response in
            switch response {
            case let .success(movieBaseModel):
                XCTAssertNotNil(movieBaseModel)
            case let .failure(error):
                XCTAssertNil(error)
            }
        }
    }
}
