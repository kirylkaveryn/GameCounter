//
//  VCResults.swift
//  GameConter
//
//  Created by Kirill on 28.08.21.
//

import UIKit

class VCResults: RSBasicVC, UITableViewDelegate, UITableViewDataSource {
    
    let navigationButtonLeft = RSNavigationButton(title: "New Game")
    let navigationButtonRight = RSNavigationButton(title: "Resume")
    let scrollView = UIScrollView()
    let playersGameProgressTable = RSPlayerTableView(frame: .zero)
    let playersRankingTable = RSPlayerTableView(frame: .zero)
    
    var rankPosition = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
        setupTitleLabel(withTitle: "Results")
        setupNavigationItems()
        setupPlayersRankingTable()
        if GameProgress.data.count != 0 {
            setupPlayersGameProgressTable()
        }
        print("viewDidLoad")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        rankPosition = 1
        playersRankingTableConstraintsActivate()
        playersGameProgressTableConstraintsActivate()
    }
    

    override func setupTitleLabel(withTitle title: String) {
        titleLabel.text = title
        scrollView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addLabelConstraints()
    }

    override func addLabelConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
        ])
    }

    func setupNavigationItems() {
        view.addSubview(navigationButtonLeft)
        view.addSubview(navigationButtonRight)
        navigationButtonLeft.activateConstraints(position: .left)
        navigationButtonRight.activateConstraints(position: .rignt)
        
        navigationButtonLeft.addTarget(self, action: #selector(navigationButtonLeftPressed), for: .touchUpInside)
        navigationButtonRight.addTarget(self, action: #selector(navigationButtonRightPressed), for: .touchUpInside)
    }
    
    func setupScrollView() {
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = true
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.frameLayoutGuide.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.frameLayoutGuide.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.frameLayoutGuide.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 46),
            scrollView.frameLayoutGuide.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            scrollView.contentLayoutGuide.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor),
            scrollView.contentLayoutGuide.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor),
            scrollView.contentLayoutGuide.topAnchor.constraint(equalTo: scrollView.frameLayoutGuide.topAnchor),
        ])
    }
    
    func setupPlayersRankingTable() {
        playersRankingTable.dataSource = self
        playersRankingTable.delegate = self
        playersRankingTable.allowsSelection = false
        playersRankingTable.isScrollEnabled = false
        playersRankingTable.separatorStyle = .none
        playersRankingTable.rowHeight = 55
        playersRankingTable.sectionHeaderHeight = 0
        playersRankingTable.register(RSPlayerRankingCell.self, forCellReuseIdentifier: RSPlayerRankingCell.reuseID)

        scrollView.addSubview(playersRankingTable)
        
        playersRankingTable.translatesAutoresizingMaskIntoConstraints = false
        playersRankingTableConstraintsActivate()
    }
    
    func playersRankingTableConstraintsActivate() {
        playersRankingTable.removeConstraints(playersRankingTable.constraints)
        NSLayoutConstraint.activate([
            playersRankingTable.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 20),
            playersRankingTable.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -20),
            playersRankingTable.topAnchor.constraint(equalTo: titleLabel.bottomAnchor ,constant: 18),
            playersRankingTable.heightAnchor.constraint(equalToConstant: playersRankingTable.rowHeight * CGFloat(FillingData.data.count)),
        ])
    }
    
    func setupPlayersGameProgressTable() {
        playersGameProgressTable.dataSource = self
        playersGameProgressTable.delegate = self
        playersGameProgressTable.allowsSelection = false
        playersGameProgressTable.isScrollEnabled = false
        playersGameProgressTable.rowHeight = 46
        playersGameProgressTable.sectionHeaderHeight = 43
        playersGameProgressTable.backgroundColor = .blue
        
        playersGameProgressTable.register(RSPlayerTableViewCell.self, forCellReuseIdentifier: RSPlayerTableViewCell.reuseID)
        playersGameProgressTable.register(RSPlayerTableViewHeader.self, forHeaderFooterViewReuseIdentifier: RSPlayerTableViewHeader.reuseID)

        scrollView.addSubview(playersGameProgressTable)
        
        playersGameProgressTable.translatesAutoresizingMaskIntoConstraints = false
        playersGameProgressTableConstraintsActivate()
    }
    
    func playersGameProgressTableConstraintsActivate() {
        playersGameProgressTable.removeConstraints(playersGameProgressTable.constraints)
        NSLayoutConstraint.activate([
            playersGameProgressTable.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            playersGameProgressTable.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            playersGameProgressTable.topAnchor.constraint(equalTo: playersRankingTable.bottomAnchor, constant: 25),
            playersGameProgressTable.heightAnchor.constraint(equalToConstant:
                                                                playersGameProgressTable.rowHeight * CGFloat(GameProgress.data.count) + playersGameProgressTable.sectionHeaderHeight),
            scrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: playersGameProgressTable.bottomAnchor),
        ])
    }

    func reloadData() {
        playersRankingTable.reloadData()
        playersGameProgressTable.reloadData()
    }

    // MARK: Actions for buttons
    @objc func navigationButtonLeftPressed() {
        guard let paretVC = parent as? VCGame else { return }
        paretVC.newGameButtonPressed()
        view.removeFromSuperview()
    }
    
    @objc func navigationButtonRightPressed() {
        guard let paretVC = parent as? VCGame else { return }
        paretVC.timerLabel.startTimer()
        view.removeFromSuperview()
    }
    
    //MARK: Table view data source
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            switch tableView {
            case playersRankingTable:
                return FillingData.data.count
            case playersGameProgressTable:
                return GameProgress.data.count
            default:
                return .zero
            }
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            switch tableView {
            case playersRankingTable:
                let cell = tableView.dequeueReusableCell(withIdentifier: RSPlayerRankingCell.reuseID, for: indexPath) as! RSPlayerRankingCell
                let sortedData = FillingData.data.sorted { item1, item2 in
                    item1.point > item2.point
                }
                if indexPath.item == 0 {
                    cell.rankPosition.text = "#" + String(rankPosition)
                }
                else if sortedData[indexPath.item].point == sortedData[indexPath.item - 1].point {
                    cell.rankPosition.text = "#" + String(rankPosition)
                }
                else {
                    rankPosition += 1
                    cell.rankPosition.text = "#" + String(rankPosition)
                }
                
                cell.textLabel?.text = sortedData[indexPath.row].name
                cell.accessoryImage.text = String(sortedData[indexPath.row].point)
                
                cell.configureCell()
                return cell
                
            case playersGameProgressTable:
                let cell = tableView.dequeueReusableCell(withIdentifier: RSPlayerTableViewCell.reuseID, for: indexPath) as! RSPlayerTableViewCell
                cell.textLabel?.text = GameProgress.data[GameProgress.data.count - 1 - indexPath.row].name
                cell.setProgressScore(point: GameProgress.data[GameProgress.data.count - 1 - indexPath.row].point)
                cell.configureCell()
                return cell
            default:
                return UITableViewCell()
            }
        }
        
        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            switch tableView {
            case playersRankingTable:
                return nil
            case playersGameProgressTable:
                let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: RSPlayerTableViewHeader.reuseID) as! RSPlayerTableViewHeader
                header.configureContent(withTitle: "Turns")
                return header
            default:
                return nil
            }
        }
    
}
