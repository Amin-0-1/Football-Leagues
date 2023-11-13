//
//  FakeConnectivity.swift
//  Football-LeaguesTests
//
//  Created by Amin on 24/10/2023.
//

import Foundation
import Football_Leagues
class FakeConnectivity: ConnectivityProtocol {
    var connected: Bool
    init(connected: Bool) {
        self.connected = connected
    }
    func isConnected(completion: @escaping (Bool) -> Void) {
        completion(connected)
    }
}
