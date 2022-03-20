//
//  ListPresenter.swift
//  Github-users-list
//
//  Created by Egor Solovev on 20.03.2022.
//

import Foundation

protocol ListPresenterDelegate {
    var count: Int { get }
    var isInProgress: Bool { get }
    
    func getObject(at index: Int) -> User?
    func fetchData()
    func fetchAdditionalData()
    func setViewDelegate(listViewDelegate: ListViewDelegate?)
}

class ListPresenter {
    private let usersService: UsersService
    private var data: [User]?
    
    weak private var listViewDelegate : ListViewDelegate?
    
    init(usersService: UsersService){
        self.usersService = usersService
    }
}

extension ListPresenter: ListPresenterDelegate {
    var count: Int {
        return data?.count ?? 0
    }
    var isInProgress: Bool {
        return usersService.isInProgress
    }
    
    func getObject(at index: Int) -> User? {
        guard let object = data?[index] else {
            return nil
        }
        return object
    }
    func fetchData() {
        guard !usersService.isInProgress else {
            return
        }
        usersService.fetchUsersData(pagination: false, completion: { result in
            switch result {
            case .success(let data):
                self.data = data
                DispatchQueue.main.async {
                    self.listViewDelegate?.reloadTable()
                }
            case .failure(let error):
                print()
            }
        })
    }
    func fetchAdditionalData() {
        guard !usersService.isInProgress else {
            return
        }
        usersService.fetchUsersData(pagination: true, completion: { result in
            DispatchQueue.main.async {
                self.listViewDelegate?.stopSpinner()
            }
            switch result {
            case .success(let data):
                self.data?.append(contentsOf: data)
                DispatchQueue.main.async {
                    self.listViewDelegate?.reloadTable()
                }
            case .failure(let error):
                print()
            }
        })
    }
    func setViewDelegate(listViewDelegate: ListViewDelegate?) {
        self.listViewDelegate = listViewDelegate
    }
}
