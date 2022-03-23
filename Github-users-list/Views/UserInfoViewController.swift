//
//  UserInfoViewController.swift
//  Github-users-list
//
//  Created by Egor Solovev on 23.03.2022.
//

import UIKit

protocol UserInfoViewDelegate: AnyObject {
    func reloadTable()
}

class UserInfoViewController: UIViewController {

    
    private let userInfoPresenter: UserInfoPresenterDelegate = UserInfoPresenter()
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        let nib = UINib(nibName: "UserCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "userCellType")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        userInfoPresenter.fetchData()
    }
    
    func setUpPresenter(with userName: String) {
        userInfoPresenter.setViewDelegate(userInfoViewDelegate: self)
        userInfoPresenter.setUpUserName(with: userName)
    }
    
    
    private func showAlert(withErrorMessage erorr: String) {
        let alert = UIAlertController(title: "Something went wrong 🥲", message: erorr, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}

extension UserInfoViewController: UserInfoViewDelegate {
    func reloadTable() {
        tableView.reloadData()
    }
}

extension UserInfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userInfoPresenter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCellType", for:  indexPath)
        guard let userCell = cell as? UserCell else {
            return cell
        }
        let parameter: String
        let value: String
        (parameter, value) = userInfoPresenter.getObject(at: indexPath.row)
        userCell.topLabel?.text = parameter
        userCell.botLabel?.text = value
        if indexPath.row == 0 {
            userCell.avatar?.image = userInfoPresenter.getAvatar()
        } else {
            userCell.avatar?.image = nil
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 300
        }
        return 70
    }
}

extension UserInfoViewController: UITableViewDelegate { }


