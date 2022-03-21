//
//  User.swift
//  Github-users-list
//
//  Created by Egor Solovev on 20.03.2022.
//

struct User {
    let login: String
    let id: Int
    let avatar_url: String
}

extension User: Decodable { }
