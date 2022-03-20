//
//  UsersService.swift
//  Github-users-list
//
//  Created by Egor Solovev on 20.03.2022.
//

import Foundation

class UsersService {
    var isInProgress = false
    
    func fetchUsersData(pagination: Bool, completion: @escaping (Result<[User], Error>) -> Void) {
        self.isInProgress = true
        DispatchQueue.global().asyncAfter(deadline: .now() + 2, execute: {
            let originalUsersData = [User(name: "sadsd"),
                                     User(name: "ssss"),
                                     User(name: "sagjs"),
                                     User(name: "sa2423423s"),
                                     User(name: "🧿🔪🧲🧲🔪🧿🔪"),
                                     User(name: "ssss"),
                                     User(name: "sagjs"),
                                     User(name: "sa2423423s"),
                                     User(name: "sa2423423s"),
                                     User(name: "🧿🔪🧲🧲🔪🧿🔪"),
                                     User(name: "ssss"),
                                     User(name: "sagjs"),
                                     User(name: "sa2423423s"),
                                     User(name: "sa2423423s"),
                                     User(name: "🧿🔪🧲🧲🔪🧿🔪"),
                                     User(name: "ssss"),
                                     User(name: "sagjs"),
                                     User(name: "sa2423423s"),
                                     User(name: "🧿🔪🧲🧲🔪🧿🔪")]
            let newUsersData = [User(name: "🧪🧪🧪🧪🧪🧪🧪🧪🧪"),
                                User(name: "🎀🎀🎀🎀🎀🎀🎀🎀🎀"),
                                User(name: "🧲🧲🧲🧲🧲🧲🧲🧲")]
            completion(.success(pagination ? newUsersData : originalUsersData))
            self.isInProgress = false
        })
    }
}
