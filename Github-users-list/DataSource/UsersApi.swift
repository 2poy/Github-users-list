//
//  UsersApi.swift
//  Github-users-list
//
//  Created by Egor Solovev on 21.03.2022.
//

import Foundation
import Moya

enum UsersApi {
    case getUser(userName: String)
    case getUsers(since: Int?, perPage: Int?)
    case getAvatar(url: URL)
}
extension UsersApi: TargetType {
    var baseURL: URL {
        switch self {
        case .getUser(_), .getUsers(_, _):
            return URL(string: "https://api.github.com")!
        case .getAvatar(let url):
            return url
        }
        
    }
    
    var path: String {
        switch self {
        case .getUser(let username):
            return "/users/\(username)"
        case .getUsers(_, _):
            return "/users"
        case .getAvatar(_):
            return ""
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        switch self {
        case .getUser(_), .getAvatar(_):
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
