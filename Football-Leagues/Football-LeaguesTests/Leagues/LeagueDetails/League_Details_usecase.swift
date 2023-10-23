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
    
    var cancellables:Set<AnyCancellable>!
    override func setUpWithError() throws {
        cancellables = []
    }

    override func tearDownWithError() throws {
    }

    func testShouldSuccess_FetchLeagueDetails() throws {
        // MARK: - Given
        let shouldFaile = false
        let fakeRepo = FakeLeagueDetailsRepo(shouldFail: shouldFaile)
        let sut = LeagueDetailsUsecase(leageDetailsRepo: fakeRepo)
        let code = "PL"
        // MARK: - When
        sut.fetchTeams(withData: code).sink { completion in
            switch completion{
                case .finished: break
                case .failure(let error):
                    XCTFail(error.localizedDescription)
            }
        } receiveValue: { model in
            // MARK: - Then
            XCTAssertEqual(model.count, fakeRepo.checkTeamCount)
        }.store(in: &cancellables)
    }
    
    func testShould_FaileFeatch_LeagueDetails()throws{
        // MARK: - Given
        let shouldFaile = true
        let fakeRepo = FakeLeagueDetailsRepo(shouldFail: shouldFaile)
        let sut = LeagueDetailsUsecase(leageDetailsRepo: fakeRepo)
        let code = "PL"
        // MARK: - When
        sut.fetchTeams(withData: code).sink { completion in
            switch completion{
                case .finished: break
                case .failure(let error):
                    XCTAssertEqual(error.localizedDescription, fakeRepo.error)
            }
        } receiveValue: { model in
            // MARK: - Then
            XCTFail()
        }.store(in: &cancellables)
    }
    
    func testShouldSave()throws{
        // MARK: - Given
        let shouldFailed = false
        let fakeRepo = FakeLeaguesRepository(shouldFailed: shouldFailed)
        let sut = LeaguesUsecase(leaguesRepo: fakeRepo)
        // MARK: - When
        
        sut.fetchLeagues().sink { completion in
            switch completion{
                case .finished: break
                case .failure(let erro):
                    XCTFail(erro.localizedDescription)
            }
        } receiveValue: { model in
            // MARK: - Then
            XCTAssertTrue(fakeRepo.isSaveVisited)
        }.store(in: &cancellables)
    }
    
    func test_ShouldFail_SaveLeague() throws{
        // MARK: - Given
        let shouldFailed = true
        let fakeRepo = FakeLeaguesRepository(shouldFailed: shouldFailed)
        let sut = LeaguesUsecase(leaguesRepo: fakeRepo)

        
        sut.fetchLeagues().sink { completion in
            // MARK: - Then
            XCTAssertFalse(fakeRepo.isSaveVisited)
        } receiveValue: { model in
            XCTFail()
        }.store(in: &cancellables)
    }


}
