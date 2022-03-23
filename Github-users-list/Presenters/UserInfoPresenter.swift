//
//  UserInfoPresenter.swift
//  Github-users-list
//
//  Created by Egor Solovev on 23.03.2022.
//

import Foundation
import UIKit
import Moya

protocol UserInfoPresenterDelegate {
    var count: Int { get }
    
    func setViewDelegate(userInfoViewDelegate: UserInfoViewDelegate?)
    func setUpUserName(with value: String)
    func getObject(at index: Int) -> (String, String)
    func getAvatar() -> UIImage?
    func fetchData()
}

class UserInfoPresenter {
    
    weak private var userInfoViewDelegate : UserInfoViewDelegate?
    private var userName: String?
    private var userDetaildedData: [(String, String)] = []
    private let provider = MoyaProvider<UsersApi>()
    private var avatar: UIImage? = nil
    
    private func fetchImage(for url: String) {
        provider.request(.getAvatar(url: URL(string: url)!), completion: { result in
            switch result {
            case .success(let response):
                self.avatar = UIImage(data: response.data)
                DispatchQueue.main.async {
                    self.userInfoViewDelegate?.reloadTable()
                }
            case .failure(let error):
                print(error)
                return
            }
            
        })
    }
}

extension UserInfoPresenter: UserInfoPresenterDelegate {
    var count: Int {
        return userDetaildedData.count
    }
    
    func setViewDelegate(userInfoViewDelegate: UserInfoViewDelegate?) {
        self.userInfoViewDelegate = userInfoViewDelegate
    }
    func setUpUserName(with value: String) {
        userName = value
    }
    func getObject(at index: Int) -> (String, String) {
        return userDetaildedData[index]
    }
    func getAvatar() -> UIImage? {
        return avatar
    }
    func fetchData() {
        guard let userName = userName else {
            return
        }
        provider.request(.getUser(userName: userName)) { result in
            switch result {
            case .success(let response):
                guard let userInfo = try? JSONDecoder().decode(UserDetailed.self, from: response.data) else {
                    return
                }
                self.userDetaildedData = [("Name:",userInfo.login),
                                          ("Email:",userInfo.email ?? "not specified"),
                                          ("Organization:",userInfo.company ?? "not specified"),
                                          ("Following:",String(userInfo.following)),
                                          ("Followers:",String(userInfo.followers))]

                DispatchQueue.main.async {
                    self.userInfoViewDelegate?.reloadTable()
                }
                self.fetchImage(for: userInfo.avatar_url)
            case .failure(let error):
                print(error)
            }
        }
    }
}
