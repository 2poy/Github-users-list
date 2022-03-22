//
//  ListViewController.swift
//  Github-users-list
//
//  Created by Egor Solovev on 20.03.2022.
//

import UIKit

protocol ListViewDelegate: AnyObject {
    func reloadTable()
    func stopSpinner()
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


}
extension ListViewController: ListViewDelegate {
    func reloadTable() {
        tableView.reloadData()
    }
    func stopSpinner() {
        tableView.tableFooterView = nil
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
