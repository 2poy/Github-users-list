//
//  User.swift
//  Github-users-list
//
//  Created by Egor Solovev on 20.03.2022.
//

import UIKit

struct User {
    let login: String
    let id: Int
    let avatar_url: String
}

extension User: Decodable { }


struct UserDataForCell {
    var user: User
    var avatar: UIImage?
    
    init(user: User) {
        self.user = user
        self.avatar = nil
    }
}
