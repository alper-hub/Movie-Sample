//
//  MovieListViewControllerTests.swift
//  Movie-Sample-AlperTests
//
//  Created by Alper Tufan on 14.07.2021.
//

import XCTest
@testable import Movie_Sample_Alper

class MovieListViewControllerTests: XCTestCase {
    var presenter: MovieListPresenterProtocol?
    var sut: MovieListViewController!
    override func setUp() {
        super.setUp()
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyBoard.instantiateViewController(identifier: "MovieListViewController")
        
    }

    func testIsCollectionViewOnScreen() {
        XCTAssertNil(sut.collectionView)
    }
    
    func testForInitialData() {
        XCTAssertEqual(sut.shouldRefresh, false)
        XCTAssertEqual(sut.currentPage, 1)
        XCTAssertEqual(sut.searchResults.count, 0)
        XCTAssertEqual(sut.displayedData.count, 0)

    }
    
    func testViewDidLoad() {
        sut.viewDidLoad()
        XCTAssertNotNil(sut.collectionView)
    }
    
    func testLoadingViewOnScreen() {
        sut.viewDidLoad()
        XCTAssertNotNil(sut.loadView)
    }
    
    func testSUT_ShouldSetCollectionViewDelegate() {
        
        sut.viewDidLoad()
        XCTAssertNotNil(sut.collectionView.delegate)
        
    }
    
    func testSUT_ShouldSetCollectionViewDataSource() {
        sut.viewDidLoad()
        XCTAssertNotNil(sut.collectionView.dataSource)
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
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
