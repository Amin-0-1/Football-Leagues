//
//  TeamDetails_Usecase.swift
//  Football-LeaguesTests
//
//  Created by Amin on 23/10/2023.
//

import XCTest
import Combine
@testable import Football_Leagues

final class TeamDetails_Usecase: XCTestCase {

    var cancellables:Set<AnyCancellable> = []
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testShouldSuccess_FetchTeamDetails() throws {
        // MARK: - Given
        let exp = expectation(description: "wait for a callback")
        let shouldFaile = false
        let fakeRepo = FakeTeamDetailsRepo(shouldFail: shouldFaile)
        let sut = TeamUsecase(repo: fakeRepo)
        let dummy = 54
        // MARK: - When
        sut.fetchGames(withTeamID: dummy).sink { completion in
            switch completion{
                case .finished: break
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                    exp.fulfill()
            }
        } receiveValue: { model in
            // MARK: - Then
            XCTAssertNotNil(model)
            exp.fulfill()
        }.store(in: &cancellables)
        
        waitForExpectations(timeout: 2)
    }
    
    func testShould_FaileFeatch_TeamDetails()throws{
        // MARK: - Given
        let exp = expectation(description: "wait for a callback")
        let shouldFaile = true
        let fakeRepo = FakeTeamDetailsRepo(shouldFail: shouldFaile)
        let connectivity = FakeConnectivity(connected: false)
        let sut = TeamUsecase(repo: fakeRepo,connectivity: connectivity)
        let code = 44
        // MARK: - When
        sut.fetchGames(withTeamID: code).sink { completion in
            switch completion{
                case .finished: break
                case .failure:
                    exp.fulfill()
            }
        } receiveValue: { model in
            // MARK: - Then
            XCTFail()
            exp.fulfill()
        }.store(in: &cancellables)
        waitForExpectations(timeout: 2)
    }
    
    func testShould_SaveTeam()throws{
        // MARK: - Given
        let exp = expectation(description: "wait for a callback")
        let shouldFailed = false
        let fakeRepo = FakeTeamDetailsRepo(shouldFail: shouldFailed)
        let connectivity = FakeConnectivity(connected: true)
        let sut = TeamUsecase(repo: fakeRepo,connectivity: connectivity)
        let dummy = 32
        // MARK: - When
        sut.fetchGames(withTeamID: dummy).sink { completion in
            switch completion{
                case .finished: break
                case .failure(let erro):
                    XCTFail(erro.localizedDescription)
                    exp.fulfill()
            }
        } receiveValue: { model in
            // MARK: - Then
            XCTAssertTrue(fakeRepo.isVisited)
            exp.fulfill()
        }.store(in: &cancellables)
        waitForExpectations(timeout: 2)
    }
    
    func test_ShouldFail_SaveTeam() throws{
        // MARK: - Given
        let exp = expectation(description: "wait for a callback")
        let shouldFailed = true
        let fakeRepo = FakeTeamDetailsRepo(shouldFail: shouldFailed)
        let connectivity = FakeConnectivity(connected: false)
        let sut = TeamUsecase(repo: fakeRepo,connectivity: connectivity)
        let dummy = 20
        // MARK: - When
        sut.fetchGames(withTeamID: dummy).sink { completion in
            // MARK: - Then
            XCTAssertFalse(fakeRepo.isVisited)
            exp.fulfill()
        } receiveValue: { model in
            XCTFail()
            exp.fulfill()
        }.store(in: &cancellables)
        waitForExpectations(timeout: 2)
    }
    


    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
