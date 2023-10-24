//
//  Football_LeaguesTests.swift
//  Football-LeaguesTests
//
//  Created by Amin on 20/10/2023.
//

import XCTest

import Combine
@testable import Football_Leagues
final class Legues_usecase: XCTestCase {
    var cancellables:Set<AnyCancellable> = []
    
    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
    }

    func test_Should_Success_Fetch_Local_Leagues() throws {
        // MARK: - Given
        let exp = expectation(description: "wait for response")
        let fakeRepo = FakeLeaguesRepository(shouldFailLocal: false)
        let sut = LeaguesUsecase(leaguesRepo: fakeRepo)

        // MARK: - When
        sut.fetchLeagues().sink { completion in
            switch completion{
                case .finished: break
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                    exp.fulfill()
            }

        } receiveValue: { model in
            XCTAssertTrue(fakeRepo.isLocalSuccessVisited)
            XCTAssertEqual(model.count, fakeRepo.modelCount)
            exp.fulfill()
            
        }.store(in: &self.cancellables)


        waitForExpectations(timeout: 2)
    }


    func test_Should_Success_Fetch_Remote_Leagues() throws {
        // MARK: - Given
        let exp = expectation(description: "wait for response")
        let fakeRepo = FakeLeaguesRepository(shouldFailRemote: false)
        let connectivity = FakeConnectivity(connected: true)
        let sut = LeaguesUsecase(leaguesRepo: fakeRepo,connectivity: connectivity)

        // MARK: - When
        sut.fetchLeagues().sink { completion in
            switch completion{
                case .finished: break
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                    exp.fulfill()
            }
        } receiveValue: { model in
            XCTAssertTrue(fakeRepo.isRemoteSuccessVisited)
            XCTAssertEqual(model.count, fakeRepo.modelCount)
            exp.fulfill()
        }.store(in: &self.cancellables)


        waitForExpectations(timeout: 2)
    }



    func test_Should_Fail_Fetch_Local_Leagues_WithInternet() throws {
        // MARK: - Given
        let exp = expectation(description: "wait for response")
        let fakeRepo = FakeLeaguesRepository(shouldFailLocal: true)
        let connectivity = FakeConnectivity(connected: true)
        let sut = LeaguesUsecase(leaguesRepo: fakeRepo,connectivity: connectivity)

        // MARK: - When
        sut.fetchLeagues().sink { completion in
            switch completion{
                case .finished: break
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                    exp.fulfill()
            }
        } receiveValue: {  model in
            XCTAssertFalse(fakeRepo.isLocalSuccessVisited)
            exp.fulfill()
        }.store(in: &self.cancellables)


        waitForExpectations(timeout: 2)
    }
    
    func test_Should_Fail_Fetch_Local_Leagues_WithoutInternet() throws {
        // MARK: - Given
        let exp = expectation(description: "wait for response")
        let fakeRepo = FakeLeaguesRepository(shouldFailLocal: true)
        let connectivity = FakeConnectivity(connected: false)
        let sut = LeaguesUsecase(leaguesRepo: fakeRepo,connectivity: connectivity)
        
        // MARK: - When
        sut.fetchLeagues().sink { completion in
            switch completion{
                case .finished: break
                case .failure(_):
                    XCTAssertTrue(true)
                    exp.fulfill()
            }
        } receiveValue: {  model in
            XCTFail()
            exp.fulfill()
        }.store(in: &self.cancellables)
        waitForExpectations(timeout: 2)
    }


    func test_Should_Fail_Fetch_Remote_Leagues() throws {
        // MARK: - Given
        let exp = expectation(description: "wait for response")
        // either shouldFailRemote or connected is equal to
        let fakeRepo = FakeLeaguesRepository(shouldFailRemote: false)
        let fakeConnectivity = FakeConnectivity(connected: false)
        let sut = LeaguesUsecase(leaguesRepo: fakeRepo,connectivity: fakeConnectivity)

        // MARK: - When
        sut.fetchLeagues().sink { completion in
            switch completion{
                case .finished: break
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                    exp.fulfill()
            }
        } receiveValue: { model in
            XCTAssertTrue(!fakeRepo.isRemoteSuccessVisited)
            exp.fulfill()
        }.store(in: &self.cancellables)


        waitForExpectations(timeout: 2)
    }



    func test_should_fail_fetch_Local_Leagues_But_Success_Remote() throws{
        // MARK: - Given
        let exp = expectation(description: "wait for response")
        let fakeRepo = FakeLeaguesRepository(shouldFailLocal: true,shouldFailRemote: false)
        let connectivity = FakeConnectivity(connected: true)
        let sut = LeaguesUsecase(leaguesRepo: fakeRepo,connectivity: connectivity)

        // MARK: - When
        sut.fetchLeagues().sink { completion in
            switch completion{
                case .finished: break
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                    exp.fulfill()
            }
        } receiveValue: { model in
            // MARK: - Then
            XCTAssertTrue(fakeRepo.isRemoteSuccessVisited)
            XCTAssertFalse(fakeRepo.isLocalSuccessVisited)
            XCTAssertEqual(model.count, fakeRepo.modelCount)
            exp.fulfill()
        }.store(in: &self.cancellables)


        waitForExpectations(timeout: 2)
    }

    func test_Should_Success_Save_League()throws{
        // MARK: - Given
        let exp = expectation(description: "wait for response")
        let fakeRepo = FakeLeaguesRepository(shouldFailRemote: false,shouldFailSave: false)
        let connectivity = FakeConnectivity(connected: true)
        let sut = LeaguesUsecase(leaguesRepo: fakeRepo,connectivity: connectivity)

        // note that saving after remote fetch succeeded in usecase
        sut.fetchLeagues().sink { completion in
            switch completion{
                case .finished: break
                case .failure(let erro):
                    XCTFail(erro.localizedDescription)
                    exp.fulfill()
            }
        } receiveValue: { model in
            // MARK: - Then
            XCTAssertTrue(fakeRepo.isRemoteSuccessVisited)
            XCTAssertTrue(fakeRepo.isSavedVisited)
            XCTAssertTrue(fakeRepo.isSavedVisited)
            exp.fulfill()
        }.store(in: &cancellables)

        waitForExpectations(timeout: 2)
    }

    func test_Should_Fail_Save_League() throws{
        // MARK: - Given
        let exp = expectation(description: "wait for response")
        let fakeRepo = FakeLeaguesRepository(shouldFailRemote: false)
        let connectivity = FakeConnectivity(connected: false)
        let sut = LeaguesUsecase(leaguesRepo: fakeRepo,connectivity: connectivity)

        // note that saving after remote fetch succeeded in usecase
        sut.fetchLeagues().sink { completion in
            switch completion{
                case .finished: break
                case .failure(let erro):
                    XCTFail(erro.localizedDescription)
                    exp.fulfill()
            }
        } receiveValue: { model in
            // MARK: - Then
            XCTAssertFalse(fakeRepo.isRemoteSuccessVisited)
            XCTAssertFalse(fakeRepo.isSavedVisited)
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
