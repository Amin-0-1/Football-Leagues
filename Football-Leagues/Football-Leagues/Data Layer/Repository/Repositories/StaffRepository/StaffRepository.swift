//
//  StaffRepository.swift
//  Football-Leagues
//
//  Created by Amin on 22/11/2023.
//

import Foundation
import Combine

protocol StaffRepositoryInterface {
    func fetchLocalStaff(localEndpoint: LocalEndPoint) -> Future<StaffDataModel, Error>
    func fetchRemoteStaff(remoteEndPoint: EndPoint) -> Future<StaffDataModel, Error>
    func saveStaff(model: StaffDataModel, localEndPoint: LocalEndPoint) -> Future<StaffDataModel, Error>
}
struct StaffRepository: StaffRepositoryInterface {
    var appRepository: RepositoryInterface
    
    init(appRepository: RepositoryInterface = AppRepository()) {
        self.appRepository = appRepository
    }
    func fetchLocalStaff(localEndpoint: LocalEndPoint) -> Future<StaffDataModel, Error> {
        return appRepository.fetch(localEndPoint: localEndpoint)
    }
    
    func fetchRemoteStaff(remoteEndPoint: EndPoint) -> Future<StaffDataModel, Error> {
        return appRepository.fetch(remoteEndPoint: remoteEndPoint)
    }
    
    func saveStaff(model: StaffDataModel, localEndPoint: LocalEndPoint) -> Future<StaffDataModel, Error> {
        return appRepository.save(data: model, localEndPoint: localEndPoint)
    }
}
