//
//  UsersApi.swift
//  Github-users-list
//
//  Created by Egor Solovev on 21.03.2022.
//

import Foundation
import Moya

enum UsersApi {
    case getUser(id: Int)
    case getUsers(since: Int?, perPage: Int?)
}
extension UsersApi: TargetType {
    var baseURL: URL {
        URL(string: "https://api.github.com")!
    }
    
    var path: String {
        switch self {
        case .getUser(let id):
            return "/users"
        case .getUsers(_, _):
            return "/users"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getUser(_), .getUsers(_, _):
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getUser(_):
            return .requestPlain
        case .getUsers(let since, let perPage):
            switch (since, perPage) {
            case (.none, .none):
                return .requestPlain
            case (.some(let safeSince), .none):
                return .requestParameters(parameters: ["since": safeSince], encoding: URLEncoding.queryString)
            case (.none, .some(let safePerPage)):
                return .requestParameters(parameters: ["perPage": safePerPage], encoding: URLEncoding.queryString)
            case (.some(let safeSince), .some(let safePerPage)):
                return .requestParameters(parameters: ["since": safeSince, "perPage": safePerPage], encoding: URLEncoding.queryString)
            }
        }
    }
    
    var headers: [String : String]? {
        return ["accept": "application/vnd.github.v3+json"]
    }
}
