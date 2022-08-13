//
//  VCGameCounter.swift
//  GameConter
//
//  Created by Kirill on 25.08.21.
//

import UIKit

class VCGameCounter: RSBasicVC, UITableViewDelegate, UITableViewDataSource {

    let addPlayerVC = VCAddPlayer()
    let playersTableView = RSPlayerTableView(frame: .zero)
    let navigationButtonLeft = RSNavigationButton(title: "Cancel")
    let starGameButton = RSStartGameButton()
    
    var reloadData: (() -> ())?
    
    override var contentData: [DataItem] {
        didSet {
            if contentData.count == 0 {
                starGameButton.isEnabled = false
            } else {
                starGameButton.isEnabled = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChild(addPlayerVC)
        
        setupTitleLabel(withTitle: "Game Counter")
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupNavigationItems()
    }
    
    func setupNavigationItems() {
        if rsDefaults.bool(forKey: rsDefaultsNotFirstLaunch) && !view.subviews.contains(navigationButtonLeft) {
            view.addSubview(navigationButtonLeft)
            navigationButtonLeft.activateConstraints(position: .left)
            navigationButtonLeft.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        }
    }
    
    func setupTableView() {
        playersTableView.dataSource = self
        playersTableView.delegate = self
        playersTableView.setEditing(true, animated: true)
        playersTableView.sectionFooterHeight = 59
        playersTableView.sectionHeaderHeight = 43

        playersTableView.register(RSPlayerTableViewCell.self, forCellReuseIdentifier: RSPlayerTableViewCell.reuseID)
        playersTableView.register(RSPlayerTableViewFooter.self, forHeaderFooterViewReuseIdentifier: RSPlayerTableViewFooter.reuseID)
        playersTableView.register(RSPlayerTableViewHeader.self, forHeaderFooterViewReuseIdentifier: RSPlayerTableViewHeader.reuseID)
        
        starGameButton.addTarget(self, action: #selector(stargGameButtonPressed), for: .touchUpInside)

        view.addSubview(playersTableView)
        view.addSubview(starGameButton)
        
        activateTableViewConstraints()
        starGameButton.activateConstraints()
    }
    
// MARK: Actions for buttons
    @objc func stargGameButtonPressed() {
        for (i, _) in contentData.enumerated() {
            contentData[i].point = 0
        }
        FillingData.data = contentData
        GameProgress.data.removeAll()
        
        reloadData?()
        
        view.removeFromSuperview()
        
        rsDefaults.set(true, forKey: rsDefaultsNotFirstLaunch)
    }
    
    @objc func cancelButtonPressed() {
        contentData = FillingData.data
        addPlayerVC.contentData = FillingData.data
        view.removeFromSuperview()
        playersTableView.reloadData()
    }
    
    @objc func addButtonPress() {
        addPlayerVC.contentData = contentData
        view.addSubview(addPlayerVC.view)
    }
    
//MARK: Views constriants
    func activateTableViewConstraints() {
        playersTableView.translatesAutoresizingMaskIntoConstraints = false
        playersTableView.removeConstraints(playersTableView.constraints)
        NSLayoutConstraint.activate([
            playersTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            playersTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            playersTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 112),
            playersTableView.bottomAnchor.constraint(equalTo: starGameButton.topAnchor, constant: -50)
        ])
    }
    
//MARK: Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contentData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RSPlayerTableViewCell.reuseID, for: indexPath) as! RSPlayerTableViewCell
        cell.textLabel?.text = contentData[indexPath.row].name
        cell.configureCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: RSPlayerTableViewHeader.reuseID) as! RSPlayerTableViewHeader
        header.configureContent(withTitle: "Players")
        return header
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            contentData.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.none)
            activateTableViewConstraints()
        case .none:
            break
        case .insert:
            break
        @unknown default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == contentData.count {
            return false
        }
        else {
            return true
        }
    }
    
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let cell = contentData[sourceIndexPath.row]
        contentData.remove(at: sourceIndexPath.row)
        contentData.insert(cell, at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let customCell = cell as? RSPlayerTableViewCell else { return }
        customCell.reorderControl?.tint(color: .rsLabelWhite)
        customCell.addDeleteButton()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: RSPlayerTableViewFooter.reuseID) as! RSPlayerTableViewFooter
        footer.configureContent()
        footer.button.addTarget(self, action: #selector(addButtonPress), for: .touchUpInside)
        return footer
    }

}


