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
    
    func getObject(at index: Int) -> User?
    func fetchData()
    func setViewDelegate(listViewDelegate: ListViewDelegate?)
}

class ListPresenter {
    private var isRequestInProgress: Bool = false
    private var users: [User]?
    private let provider = MoyaProvider<UsersApi>()
    private var maxId: Int?
    
    weak private var listViewDelegate : ListViewDelegate?
}

extension ListPresenter: ListPresenterDelegate {
    var count: Int {
        return users?.count ?? 0
    }
    var isInProgress: Bool {
        return isRequestInProgress
    }
    
    func getObject(at index: Int) -> User? {
        guard let object = users?[index] else {
            return nil
        }
        return object
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
                if self.users == nil {
                    self.users = newUsers
                } else {
                    self.users?.append(contentsOf: newUsers)
                }
                DispatchQueue.main.async {
                    self.listViewDelegate?.reloadTable()
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
