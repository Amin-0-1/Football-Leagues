//
//  Leagues_viewmodel.swift
//  Football-LeaguesTests
//
//  Created by Amin on 23/10/2023.
//

import XCTest
import Combine
import Football_Leagues
final class Leagues_viewmodel: XCTestCase {
    
    var cancellables: Set<AnyCancellable> = []
    
    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func test_Should_Display_LeaguesData() throws {
        // MARK: - Given
        let exp = expectation(description: "wait for response")
        let fakeUsecase = FakeLeaguesUsecase(shouldFail: false)
        let fakeCoordinator = FakeLeaguesCoordinator()
        let sutViewModel = LeaguesViewModel(usecase: fakeUsecase, coordinator: fakeCoordinator)
        // MARK: - When
        sutViewModel.onScreenAppeared.send(true)
        
        // MARK: - Then
        sutViewModel.leagues.sink { completion in
            switch completion {
                case .finished: break
                case .failure:
                    XCTFail("failed")
                    exp.fulfill()
            }
        } receiveValue: { data in
            XCTAssertTrue(fakeUsecase.isSuccessVisited)
            XCTAssertEqual(data.count, fakeUsecase.leagueCount)
            exp.fulfill()
        }.store(in: &cancellables)

        waitForExpectations(timeout: 2)
    }
    
    func test_Should_Fail_FetchData() throws {
        // MARK: - Given
        let exp = expectation(description: "wait for response")
        let fakeUsecase = FakeLeaguesUsecase(shouldFail: true)
        let fakeCoordinator = FakeLeaguesCoordinator {
            exp.fulfill()
        }
        let sut = LeaguesViewModel(usecase: fakeUsecase, coordinator: fakeCoordinator)
        
        sut.showError.sink {  error in
            // MARK: - Then
            XCTAssertEqual(error, fakeUsecase.error)
            exp.fulfill()
        }.store(in: &self.cancellables)
        
        // MARK: - When
        sut.onScreenAppeared.send(true)
        
        waitForExpectations(timeout: 2)
    }
    
    func test_Should_Success_NavigateTo_LeagueDetails() {
        // MARK: - Given
        let exp = expectation(description: "wait for response")
        let fakeUsecase = FakeLeaguesUsecase(shouldFail: false)
        let fakeCoordinator = FakeLeaguesCoordinator {
            exp.fulfill()
        }
        let sut = LeaguesViewModel(coordinator: fakeCoordinator)
        
        // MARK: - When
        fakeUsecase.fetchLeagues().sink { completion in
            switch completion {
                case .finished: break
                case .failure:
                    XCTFail("failed")
            }
        } receiveValue: { model in
            let mapped = fakeUsecase.prepareForFakePublish(model: model)
            sut.publishLeague.send(mapped)
        }.store(in: &self.cancellables)
        
        sut.onTappedCell.send(0)
        waitForExpectations(timeout: 2)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
