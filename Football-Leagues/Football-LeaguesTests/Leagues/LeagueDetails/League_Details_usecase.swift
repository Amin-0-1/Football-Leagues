//
//  League_Details.swift
//  Football-LeaguesTests
//
//  Created by Amin on 22/10/2023.
//

import XCTest
import Combine

@testable import Football_Leagues
final class League_Details_usecase: XCTestCase {
    var cancellables:Set<AnyCancellable>
    override func setUpWithError() throws {
        cancellables = []
    }

    override func tearDownWithError() throws {
    }

    func test_Should_Success_Fetch_Local_Leagues() throws {
        // MARK: - Given
        let expectation = expectation(description: "wait for a callback")
        let fakeRepo = FakeLeagueDetailsRepo(localShouldFail: false)
        let sut = LeagueDetailsUsecase(leageDetailsRepo: fakeRepo)
        
        // MARK: - When
        sut.fetchTeams(withData: "").sink { completion in
            switch completion{
                case .finished: expectation.fulfill()
                case .failure(let error):
                    XCTFail(error.localizedDescription)
            }
            
        } receiveValue: { model in
            XCTAssertTrue(fakeRepo.isSuccessLocalVisited)
            XCTAssertEqual(model.count, fakeRepo.checkTeamCount)
        }.store(in: &self.cancellables)
        
        
        waitForExpectations(timeout: 2)
    }
    
    
    func test_Should_Success_Fetch_Remote_Teams() throws {
        // MARK: - Given
        let expectation = expectation(description: "wait for a callback")
        let fakeRepo = FakeLeagueDetailsRepo(remoteShouldFail: false)
        let connectivity = FakeConnectivity(connected: true)
        let sut = LeagueDetailsUsecase(leageDetailsRepo: fakeRepo, connectivity: connectivity)
        
        // MARK: - When
        sut.fetchTeams(withData: "").sink { completion in
            switch completion{
                case .finished: expectation.fulfill()
                case .failure(let error):
                    XCTFail(error.localizedDescription)
            }
        } receiveValue: { model in
            XCTAssertTrue(fakeRepo.isSuccessRemoteVisited)
            XCTAssertEqual(model.count, fakeRepo.checkTeamCount)
        }.store(in: &self.cancellables)
        
        
        waitForExpectations(timeout: 2)
    }
    
    func test_Should_Fail_Fetch_Remote_Teams() throws {
        // MARK: - Given
        let expectation = expectation(description: "wait for a callback")
        // either shouldFailRemote or connected is equal to
        let fakeRepo = FakeLeagueDetailsRepo(remoteShouldFail: false)
        let fakeConnectivity = FakeConnectivity(connected: false)
        let sut = LeagueDetailsUsecase(leageDetailsRepo: fakeRepo, connectivity: fakeConnectivity)
        
        // MARK: - When
        sut.fetchTeams(withData: "").sink { completion in
            switch completion{
                case .finished: expectation.fulfill()
                case .failure(let error):
                    XCTFail(error.localizedDescription)
            }
        } receiveValue: { model in
            XCTAssertFalse(fakeRepo.isSuccessRemoteVisited)
        }.store(in: &self.cancellables)
        
        
        waitForExpectations(timeout: 2)
    }
    
    
    
    func test_should_fail_fetch_Local_Teams_But_Success_Remote() throws{
        // MARK: - Given
        let expectation = expectation(description: "wait for a callback")
        let fakeRepo = FakeLeagueDetailsRepo(localShouldFail: true, remoteShouldFail: false)
        let connectivity = FakeConnectivity(connected: true)
        let sut = LeagueDetailsUsecase(leageDetailsRepo: fakeRepo, connectivity: connectivity)
        
        // MARK: - When
        sut.fetchTeams(withData: "PL").sink { completion in
            switch completion{
                case .finished: expectation.fulfill()
                case .failure(let error):
                    XCTFail(error.localizedDescription)
            }
        } receiveValue: { model in
            // MARK: - Then
            XCTAssertTrue(fakeRepo.isSuccessRemoteVisited)
            XCTAssertFalse(fakeRepo.isSuccessLocalVisited)
            XCTAssertEqual(model.count, fakeRepo.checkTeamCount)
        }.store(in: &self.cancellables)
        
        
        waitForExpectations(timeout: 2)
    }
    
    func test_Should_Success_Save_Team()throws{
        // MARK: - Given
        let expectation = expectation(description: "wait for a callback")
        let fakeRepo = FakeLeagueDetailsRepo(localShouldFail: false, remoteShouldFail: false)
        let connectivity = FakeConnectivity(connected: true)
        let sut = LeagueDetailsUsecase(leageDetailsRepo: fakeRepo, connectivity: connectivity)
        
        // note that saving after remote fetch succeeded in usecase
        sut.fetchTeams(withData: "").sink { completion in
            switch completion{
                case .finished: expectation.fulfill()
                case .failure(let erro):
                    XCTFail(erro.localizedDescription)
            }
        } receiveValue: { model in
            // MARK: - Then
            XCTAssertTrue(fakeRepo.isSuccessRemoteVisited)
            XCTAssertTrue(fakeRepo.isSuccessSaveVisted)
            XCTAssertTrue(fakeRepo.isSuccessSaveVisted)
        }.store(in: &cancellables)
        
        waitForExpectations(timeout: 2)
    }
    
    func test_Should_Fail_Save_Team() throws{
        // MARK: - Given
        let expectation = expectation(description: "wait for a callback")
        let fakeRepo = FakeLeagueDetailsRepo(remoteShouldFail: false)
        let connectivity = FakeConnectivity(connected: false)
        let sut = LeagueDetailsUsecase(leageDetailsRepo: fakeRepo, connectivity: connectivity)
        
        // note that saving after remote fetch succeeded in usecase
        sut.fetchTeams(withData: "" ).sink { completion in
            switch completion{
                case .finished:
                    expectation.fulfill()
                case .failure(let erro):
                    XCTFail(erro.localizedDescription)
            }
        } receiveValue: { model in
            // MARK: - Then
            XCTAssertFalse(fakeRepo.isSuccessRemoteVisited)
            XCTAssertFalse(fakeRepo.isSuccessSaveVisted)
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
