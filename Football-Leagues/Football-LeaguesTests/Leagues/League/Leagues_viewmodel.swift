//
//  Leagues_viewmodel.swift
//  Football-LeaguesTests
//
//  Created by Amin on 23/10/2023.
//

import XCTest
import Combine
@testable import Football_Leagues
final class Leagues_viewmodel: XCTestCase {
    
    var expectation:XCTestExpectation!
    var cancellables:Set<AnyCancellable> = []
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        expectation = .init(description: "wait for expected int value")
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
    }

    func testShould_Display_LeaguesData() throws {
        // MARK: - Given
        let fakeUsecase = FakeLeaguesUsecase(shouldFail: false)
        let fakeCoordinator = FakeLeaguesCoordinator()
        let sutViewModel = LeaguesViewModel(usecase: fakeUsecase, coordinator: fakeCoordinator)
        // MARK: - When
        sutViewModel.onScreenAppeared.send(true)
        
        // MARK: - Then
        sutViewModel.leagues.sink { completion in
            XCTFail()
        } receiveValue: { data in
            XCTAssertEqual(data.count, fakeUsecase.leagueCount)
            self.expectation.fulfill()
        }.store(in: &cancellables)

        wait(for: [expectation],timeout: 3)
    }
    
    func testShould_Fail_FetchData() throws{
        // MARK: - Given
        let fakeUsecase = FakeLeaguesUsecase(shouldFail: true)
        let fakeCoordinator = FakeLeaguesCoordinator()
        let sut = LeaguesViewModel(usecase: fakeUsecase, coordinator: fakeCoordinator)
        // MARK: - When
        sut.onScreenAppeared.send(true)

        // MARK: - Then
        sut.showError.sink { error in
            self.expectation.fulfill()
        }.store(in: &cancellables)

        sut.leagues.sink { completion in
            XCTFail()
        } receiveValue: { model in
            print(model)

        }.store(in: &cancellables)


        wait(for: [expectation], timeout: 3)
    }
    
    func testShould_Success_NavigateToLeagueDetails(){
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
