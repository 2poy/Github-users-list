//
//  ListViewController.swift
//  Github-users-list
//
//  Created by Egor Solovev on 20.03.2022.
//

import UIKit

protocol ListViewDelegate: AnyObject {
    func fetchCompleted(withErrorMessage message: String?)
}

class ListViewController: UIViewController {

    
    private let listPresenter: ListPresenterDelegate = ListPresenter()
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
        listPresenter.setViewDelegate(listViewDelegate: self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        listPresenter.fetchData()
    }
    
    private func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        return footerView
    }
    
    private func showAlert(withErrorMessage erorr: String) {
        let alert = UIAlertController(title: "Something went wrong 🥲", message: erorr, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}
extension ListViewController: ListViewDelegate {
    func fetchCompleted(withErrorMessage message: String?) {
        tableView.tableFooterView = nil
        guard let message = message else {
            tableView.reloadData()
            return
        }
        showAlert(withErrorMessage: message)
    }
}
extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listPresenter.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCellType", for:  indexPath)
        guard let userCell = cell as? UserCell else {
            return cell
        }
        guard let userData = listPresenter.getObject(at: indexPath.row) else {
            return cell
        }
        userCell.topLabel?.text = userData.user.login
        userCell.botLabel?.text = String(userData.user.id)
        userCell.avatar?.image = userData.avatar
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userInfoViewController = UserInfoViewController()
        guard let userId = listPresenter.getObject(at: indexPath.row)?.user.login else {
            showAlert(withErrorMessage: "Can't get user id")
            return
        }
        userInfoViewController.setUpPresenter(with: userId)
        self.present(userInfoViewController, animated: true, completion: nil)
    }
}
extension ListViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (tableView.contentSize.height - 100 - scrollView.frame.size.height) {
            guard !listPresenter.isInProgress else {
                return
            }
            self.tableView.tableFooterView = createSpinnerFooter()
            listPresenter.fetchData()
        }
    }
}
extension ListViewController: UITableViewDelegate { }
