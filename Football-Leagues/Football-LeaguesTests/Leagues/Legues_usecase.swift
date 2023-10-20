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
                case .failure(_):
                    XCTFail()
                case .finished:
                    break
            }
        } receiveValue: { model in
            // MARK: - Then
            XCTAssertEqual(model.competitions.count,fakeRepo.competitionCounts)
        }.store(in: &cancellables)
    }
    
    func testFailedFetchLeagues() throws{
        // MARK: - Given
        let shouldFailed = true
        let fakeRepo = FakeLeaguesRepository(shouldFailed: shouldFailed)
        let sut = LeaguesUsecase(leaguesRepo: fakeRepo)
//        sut = LeaguesUsecase(leaguesRepo: fakeRepo)
        
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
    
    func testSuccessSave()throws{
        // MARK: - Given
        let shouldFailed = true
        let fakeRepo = FakeLeaguesRepository(shouldFailed: shouldFailed)
        sut = LeaguesUsecase(leaguesRepo: fakeRepo)
        // MARK: - When
        // based on the buisness logic so that the save functionality is automatically invoked while fetching
        // keep in mind that the view model has no responsibilty to invoke save itself too
        // so we we will check weather it gets visited or not after completion of fetching local data
        
        sut.fetchLeagues().sink { completion in
            switch completion{
                case .failure(let error):
                    print(error)
                case .finished: // gets called after .failure
            // MARK: - Then
                XCTAssertTrue(fakeRepo.isSaveVisited)
            }
            
        } receiveValue: { model in}.store(in: &cancellables)
    }

//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
