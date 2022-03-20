//
//  ListPresenter.swift
//  Github-users-list
//
//  Created by Egor Solovev on 20.03.2022.
//

class ListPresenter {
    private let usersService: UsersService
    weak private var listViewDelegate : ListViewDelegate?
    
    init(usersService: UsersService){
        self.usersService = usersService
    }
    
    func setViewDelegate(listViewDelegate: ListViewDelegate?){
        self.listViewDelegate = listViewDelegate
    }
    
}
