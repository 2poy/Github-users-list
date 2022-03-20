//
//  UsersService.swift
//  Github-users-list
//
//  Created by Egor Solovev on 20.03.2022.
//

class UsersService {
    
    func getUsersList(callBack:([User]?) -> Void) {
        let users = [User(name: "sadsd"),
                     User(name: "ssss"),
                     User(name: "sagjs"),
                     User(name: "sa2423423s"),
                     User(name: "🔪🔪🔪🔪🔪")]
            callBack(users)

    }
}
