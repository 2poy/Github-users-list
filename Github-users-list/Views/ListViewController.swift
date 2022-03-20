//
//  ListViewController.swift
//  Github-users-list
//
//  Created by Egor Solovev on 20.03.2022.
//

import UIKit

protocol ListViewDelegate: NSObjectProtocol {
    func displayList()
}

class ListViewController: UIViewController {
    private let listPresenter = ListPresenter(usersService: UsersService())

    override func viewDidLoad() {
        super.viewDidLoad()
        listPresenter.setViewDelegate(listViewDelegate: self)
        // Do any additional setup after loading the view.
    }


}
extension ListViewController: ListViewDelegate {
    func displayList() {
        
    }
}
