//
//  Football_LeaguesTests.swift
//  Football-LeaguesTests
//
//  Created by Amin on 20/10/2023.
//

import XCTest
@testable import Football_Leagues
import Combine

final class Legues_usecase: XCTestCase {
    var sut:LeaguesUsecaseProtocol!
    var cancellables:Set<AnyCancellable> = []
    
    override func setUpWithError() throws {
        let fakeRepo = FakeLeaguesRepository(shouldFailed: true)
        sut = LeaguesUsecase(leaguesRepo: fakeRepo)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSuccessFeatchLeagues() throws {
        // MARK: - Given
        let shouldFailed = false
        let fakeRepo = FakeLeaguesRepository(shouldFailed: shouldFailed)
        sut = LeaguesUsecase(leaguesRepo: fakeRepo)
        
        // MARK: - When
        sut.fetchLeagues().sink { completion in
            switch completion{
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                case .finished:
                    break
            }
        } receiveValue: { model in
            // MARK: - Then
            XCTAssertEqual(model.competitions.count,fakeRepo.competitionCounts)
        }.store(in: &cancellables)
    }
    
    func test_shouldfail_fetchLeagues() throws{
        // MARK: - Given
        let shouldFailed = true
        let fakeRepo = FakeLeaguesRepository(shouldFailed: shouldFailed)
        let sut = LeaguesUsecase(leaguesRepo: fakeRepo)
        
        // MARK: - When
        sut.fetchLeagues().sink { completion in
            switch completion{
                case .failure(let error):
                    // MARK: - Then
                    XCTAssertEqual(error.localizedDescription, fakeRepo.error)
                case .finished:
                    break
            }
        } receiveValue: { model in
            XCTFail()
        }.store(in: &cancellables)
    }
    
    func testShouldSave()throws{
        // MARK: - Given
        let shouldFailed = false
        let fakeRepo = FakeLeaguesRepository(shouldFailed: shouldFailed)
        sut = LeaguesUsecase(leaguesRepo: fakeRepo)
        // MARK: - When
        // based on the buisness logic so that the save functionality is automatically invoked while fetching
        // keep in mind that the view model has no responsibilty to invoke save itself too
        // so we we will check weather it gets visited or not after completion of fetching local data if it fetched successfully then it will save
        
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
        sut = LeaguesUsecase(leaguesRepo: fakeRepo)
        // MARK: - When
        // like the above test funtion
        // so here we will assert that save function is not saved if data not fetched

        sut.fetchLeagues().sink { completion in
            // MARK: - Then
            XCTAssertFalse(fakeRepo.isSaveVisited)
        } receiveValue: { model in
            XCTFail()
        }.store(in: &cancellables)
    }
}
