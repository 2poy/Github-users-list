//
//  ListPresenter.swift
//  Github-users-list
//
//  Created by Egor Solovev on 20.03.2022.
//

import Foundation
import Moya

protocol ListPresenterDelegate {
    var count: Int { get }
    var isInProgress: Bool { get }
    
    func getObject(at index: Int) -> UserDataForCell?
    func fetchData()
    func setViewDelegate(listViewDelegate: ListViewDelegate?)
}

class ListPresenter {
    private var isRequestInProgress: Bool = false
    private var usersData: [UserDataForCell] = []
    private let provider = MoyaProvider<UsersApi>()
    private var maxId: Int?
    
    weak private var listViewDelegate : ListViewDelegate?
}

extension ListPresenter: ListPresenterDelegate {
    var count: Int {
        return usersData.count
    }
    var isInProgress: Bool {
        return isRequestInProgress
    }
    
    func getObject(at index: Int) -> UserDataForCell? {
        return usersData[index]
    }
    
    func fetchData() {
        guard !isRequestInProgress else {
            return
        }
        isRequestInProgress = true
        provider.request(.getUsers(since: maxId, perPage: 30)) { result in
            self.isRequestInProgress = false
            DispatchQueue.main.async {
                self.listViewDelegate?.stopSpinner()
            }
            switch result {
            case .success(let response):
                let newUsers = try! JSONDecoder().decode([User].self, from: response.data)
                self.maxId = newUsers.last?.id ?? self.maxId
                let newUserData = newUsers.map{ UserDataForCell(user: $0) }
                let oldUserDataCount = self.usersData.count
                self.usersData.append(contentsOf: newUserData)
                for (index, value) in newUsers.enumerated() {
                    self.provider.request(.getAvatar(url: URL(string: value.avatar_url)!), completion: { result in
                        switch result {
                        case .success(let response):
                            self.usersData[index + oldUserDataCount].avatar = UIImage(data: response.data)
                            DispatchQueue.main.async {
                                self.listViewDelegate?.reloadTable()
                            }
                            print()
                        case .failure(let error):
                            print()
                        }
                        
                    })
                }

            case .failure(let error):
                print()
            }
        }
    }
    func setViewDelegate(listViewDelegate: ListViewDelegate?) {
        self.listViewDelegate = listViewDelegate
    }
}
