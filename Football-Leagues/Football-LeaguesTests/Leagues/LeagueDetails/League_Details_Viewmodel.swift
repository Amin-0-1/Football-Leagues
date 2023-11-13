//
//  League_Details_Viewmodel.swift
//  Football-LeaguesTests
//
//  Created by Amin on 24/10/2023.
//

import XCTest
import Combine
@testable import Football_Leagues
final class League_Details_Viewmodel: XCTestCase {

    var cancellables: Set<AnyCancellable> = []

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func test_should_display_Teams() throws {
        // MARK: - Given
        let exp = expectation(description: "wait for a callback")
        let fakeCoordinator = FakeLeagueDetailsCoordinator()
        let fakeUsecase = FakeLeagueDetailUsecase(shouldFetch: true)
        let dummy = "PL"
        let sut = LeagueDetailsViewModel(
            params: .init(
                coordinator: fakeCoordinator,
                code: dummy,
                usecase: fakeUsecase
            )
        )
        // MARK: - When
        sut.onScreenAppeared.send(true)

        sut.teams.sink { completion in
            switch completion {
                case .finished:
                    exp.fulfill()
                case .failure:
                    XCTFail("failed")
            }
        } receiveValue: { model in
            XCTAssertEqual(model.models.count, fakeUsecase.teamCount)
            XCTAssertTrue(fakeUsecase.isFetchedSucess)
            exp.fulfill()
        }.store(in: &cancellables)

        // MARK: - Then
        waitForExpectations(timeout: 2)
    }
    
    func test_Should_Fail_FetchData() throws {
        // MARK: - Given
        let exp = expectation(description: "wait for a callback")
        let fakeUsecase = FakeLeagueDetailUsecase(shouldFetch: false)
        let dummy = "PL"
        let fakeCoordinator = FakeLeagueDetailsCoordinator()
        let sut = LeagueDetailsViewModel(
            params: .init(
                coordinator: fakeCoordinator,
                code: dummy,
                usecase: fakeUsecase
            )
        )
        
        sut.showError.sink { error in
            // MARK: - Then
            XCTAssertEqual(error, fakeUsecase.error)
            exp.fulfill()
        }.store(in: &self.cancellables)
        
        // MARK: - When
        sut.onScreenAppeared.send(true)
        
        waitForExpectations(timeout: 2)
    }
    
    func test_navigateTo_WebView()throws {
        // MARK: - Givent
        let exp = expectation(description: "wait for a callback")
        let fakeUsecase = FakeLeagueDetailUsecase(shouldFetch: true)
        let dummy = "PL"
        let fakeCoordinator = FakeLeagueDetailsCoordinator {
            // MARK: - then
            exp.fulfill()
        }
        let sut = LeagueDetailsViewModel(
            params: .init(
                coordinator: fakeCoordinator,
                code: dummy,
                usecase: fakeUsecase
            )
        )
        
        // MARK: - When
        fakeUsecase.fetchTeams(withData: dummy).sink { completion in
            switch completion {
                case .finished: break
                case .failure:
                    XCTFail("failed")
            }
        } receiveValue: { model in
            let mapped = fakeUsecase.prepareForFakePublish(model: model)
            sut.publishableTeams.send(mapped)
        }.store(in: &cancellables)
        sut.onTappingCell.send(2)
        
        waitForExpectations(timeout: 2)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
