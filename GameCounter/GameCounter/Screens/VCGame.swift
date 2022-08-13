//
//  VCGame.swift
//  GameConter
//
//  Created by Kirill on 27.08.21.
//

import UIKit

class VCGame: RSBasicVC, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    lazy var gameCounterVC = VCGameCounter()
    lazy var resultsVC = VCResults()
    
    var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    
    let navigationButtonLeft = RSNavigationButton(title: "New Game")
    let navigationButtonRight = RSNavigationButton(title: "Result")
    let diceButton = RSDiceButton()
    var diceView: UIImageView?
    let pointButtonBig = RSCirclePointButton(title: "+1", size: .big)
    let pointButtonSmall1 = RSCirclePointButton(title: "-10", size: .small)
    let pointButtonSmall2 = RSCirclePointButton(title: "-5", size: .small)
    let pointButtonSmall3 = RSCirclePointButton(title: "-1", size: .small)
    let pointButtonSmall4 = RSCirclePointButton(title: "+5", size: .small)
    let pointButtonSmall5 = RSCirclePointButton(title: "+10", size: .small)
    let pointButtonsStack = UIStackView()
    let pointButtonPressDelay: TimeInterval = 1.0
    var pointButtonPressTimer: Timer? = nil
    let timerLabel = RSTimer()
    let playerCollection = RSPlayerCollectionView()
    let bottomIndexCollection = RSBottomIndexCollectionView()
    let undoButton = UIButton()
    var playerLabelLeft = RSPlayerArrowButton(playerStyle: .stopLeft)
    var playerLabelRight = RSPlayerArrowButton(playerStyle: .playRight)
    
    // this var stores current player index
    var indexOfMajorCell: Int = {
        // check if app loads first time and set a default/ last session value
        if !rsDefaults.bool(forKey: rsDefaultsNotFirstLaunch) {
            return 0
        } else {
            let index = rsDefaults.integer(forKey: rsDefaultsCurrentPlayer)
            return index
        }
    }() {
        // reload data and Defaults every time index updated
        didSet {
            bottomIndexCollection.indexOfMajorCell = indexOfMajorCell
            bottomIndexCollection.reloadData()
            rsDefaults.setValue(indexOfMajorCell, forKey: rsDefaultsCurrentPlayer)
        }
    }

    let cellWidth: CGFloat = 255
    
    let blureEffectView: UIVisualEffectView = {
        let blureEffect = UIBlurEffect(style: .dark)
        let blureView = UIVisualEffectView(effect: blureEffect)
        return blureView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reinstateBackgroundTask), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        addChild(gameCounterVC)
        addChild(resultsVC)

        setupTitleLabel(withTitle: "Game")
        
        gameCounterVC.reloadData = { [weak self] in
            guard let self = self else {
                return
            }
            self.contentData = FillingData.data
            self.playerCollection.reloadData()
            self.playerCollection.contentOffset.x = 0
            self.bottomIndexCollection.reloadData()
            self.timerLabel.restartTimer()
        }
        
        setupNavigationItems()
        setupDiceButton()
        setupPointsButtons()
        setupPlayerLabels()
        setupCollectionView()
        setupTimer()
        setupUndoButton()
        
        // check for first time launch
        if !rsDefaults.bool(forKey: rsDefaultsNotFirstLaunch) {
            deactivateUndoAndResultButtons()
            view.addSubview(gameCounterVC.view)
        } else {
            if GameProgress.data.count != 0 {
                activateUndoAndResultButtons()
            } else {
                deactivateUndoAndResultButtons()
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(deactivateUndoAndResultButtons), name: gameProgressIsEmpty, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(activateUndoAndResultButtons), name: gameProgressIsNotEmpty, object: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // roll to lact active player
        if rsDefaults.bool(forKey: rsDefaultsNotFirstLaunch) {
            playerCollection.scrollToItem(at: IndexPath(row: indexOfMajorCell, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    
    func setupNavigationItems() {
        view.addSubview(navigationButtonLeft)
        view.addSubview(navigationButtonRight)

        navigationButtonLeft.activateConstraints(position: .left)
        navigationButtonRight.activateConstraints(position: .rignt)
        
        navigationButtonLeft.addTarget(self, action: #selector(newGameButtonPressed), for: .touchUpInside)
        navigationButtonRight.addTarget(self, action: #selector(resultButtonPressed), for: .touchUpInside)
    }
    
    func setupDiceButton() {
        diceButton.addTarget(self, action: #selector(diceButtonPressed), for: .touchUpInside)
    
        blureEffectView.frame = UIScreen.main.bounds
        
        let blureEffectViewGesture = UITapGestureRecognizer()
        blureEffectViewGesture.addTarget(self, action: #selector(removeDiceRollView))
        blureEffectView.addGestureRecognizer(blureEffectViewGesture)
        
        view.addSubview(diceButton)
        NSLayoutConstraint.activate([
            diceButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            diceButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
        ])
    }
    
    func setupPointsButtons() {
        pointButtonsStack.addArrangedSubview(pointButtonSmall1)
        pointButtonsStack.addArrangedSubview(pointButtonSmall2)
        pointButtonsStack.addArrangedSubview(pointButtonSmall3)
        pointButtonsStack.addArrangedSubview(pointButtonSmall4)
        pointButtonsStack.addArrangedSubview(pointButtonSmall5)

        pointButtonsStack.distribution = .equalSpacing
        pointButtonsStack.alignment = .center
        pointButtonsStack.spacing = 15
        
        pointButtonSmall1.addTarget(self, action: #selector(pointButtonPressed), for: .touchUpInside)
        pointButtonSmall2.addTarget(self, action: #selector(pointButtonPressed), for: .touchUpInside)
        pointButtonSmall3.addTarget(self, action: #selector(pointButtonPressed), for: .touchUpInside)
        pointButtonSmall4.addTarget(self, action: #selector(pointButtonPressed), for: .touchUpInside)
        pointButtonSmall5.addTarget(self, action: #selector(pointButtonPressed), for: .touchUpInside)
        pointButtonBig.addTarget(self, action: #selector(pointButtonPressed), for: .touchUpInside)
        
        view.addSubview(pointButtonsStack)
        view.addSubview(pointButtonBig)
        
        pointButtonsStack.translatesAutoresizingMaskIntoConstraints = false
        pointButtonBig.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pointButtonsStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            pointButtonsStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            pointButtonsStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -74),
            pointButtonsStack.heightAnchor.constraint(equalToConstant:55),
            pointButtonBig.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            pointButtonBig.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -196),
        ])
    }
    
    func setupPlayerLabels() {
        playerLabelLeft.addTarget(self, action: #selector(playerLeftPress), for: .touchUpInside)
        playerLabelRight.addTarget(self, action: #selector(playerRightPress), for: .touchUpInside)
        
        view.addSubview(playerLabelLeft)
        view.addSubview(playerLabelRight)
        
        NSLayoutConstraint.activate([
            playerLabelLeft.rightAnchor.constraint(equalTo: pointButtonBig.leftAnchor, constant: -65),
            playerLabelLeft.centerYAnchor.constraint(equalTo: pointButtonBig.centerYAnchor),
            playerLabelRight.leftAnchor.constraint(equalTo: pointButtonBig.rightAnchor, constant: 65),
            playerLabelRight.centerYAnchor.constraint(equalTo: pointButtonBig.centerYAnchor),
        ])
    }
    
    func setupTimer() {
        view.addSubview(timerLabel)

        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            timerLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 20),
            timerLabel.bottomAnchor.constraint(equalTo: playerCollection.topAnchor, constant: -40),
            timerLabel.heightAnchor.constraint(equalToConstant: 40),
            timerLabel.widthAnchor.constraint(equalToConstant: 115),
        ])
    }

    func setupCollectionView() {
        playerCollection.dataSource = self
        playerCollection.delegate = self
        playerCollection.isScrollEnabled = true
        
        playerCollection.register(RSPlayerCollectionViewCell.self, forCellWithReuseIdentifier: RSPlayerCollectionViewCell.reuseID)

        view.addSubview(playerCollection)
        view.addSubview(bottomIndexCollection)
        
        playerCollection.translatesAutoresizingMaskIntoConstraints = false
        bottomIndexCollection.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            playerCollection.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 112),
            playerCollection.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            playerCollection.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            playerCollection.bottomAnchor.constraint(equalTo: pointButtonBig.topAnchor, constant: -28),
            
            bottomIndexCollection.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            bottomIndexCollection.heightAnchor.constraint(equalToConstant: 24),
            bottomIndexCollection.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 100),
            bottomIndexCollection.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -100),
            bottomIndexCollection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
        ])
    }
    
    func setupUndoButton() {
        undoButton.setImage(UIImage(named: "icon_Undo"), for: .normal)
        undoButton.addTarget(self, action: #selector(undoButtonPressed), for: .touchUpInside)
        
        view.addSubview(undoButton)
        undoButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            undoButton.heightAnchor.constraint(equalToConstant: 20),
            undoButton.widthAnchor.constraint(equalToConstant: 15),
            undoButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            undoButton.centerYAnchor.constraint(equalTo: bottomIndexCollection.centerYAnchor)
        ])
    }
    
    // MARK: - Actions for buttons
    @objc func undoButtonPressed() {
        guard GameProgress.data.count != 0 else {return}
        
        let indexOfLastPlayer = FillingData.data.firstIndex { player in
            player.name == GameProgress.data.last?.name
        }!
        playerCollection.scrollToItem(at: IndexPath(row: indexOfLastPlayer, section: 0), at: .centeredHorizontally, animated: true)
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { [self] _ in
            FillingData.data[indexOfLastPlayer].point -= GameProgress.data.last!.point
            GameProgress.data.removeLast()
            playerCollection.reloadItems(at: [IndexPath(item: indexOfLastPlayer, section: 0)])
        }
    }
    
    @objc func activateUndoAndResultButtons() {
        undoButton.isEnabled = true
        navigationButtonRight.isEnabled = true
    
    }
    @objc func deactivateUndoAndResultButtons() {
        undoButton.isEnabled = false
        navigationButtonRight.isEnabled = false
    }
    
    @objc func newGameButtonPressed() {
        gameCounterVC.contentData = FillingData.data
        gameCounterVC.playersTableView.reloadData()
        view.addSubview(gameCounterVC.view)
    }
    
    @objc func resultButtonPressed() {
        guard GameProgress.data.count != 0 else { return }
        timerLabel.stopTimer()
        resultsVC.reloadData()
        view.addSubview(resultsVC.view)
    }
    
    @objc func diceButtonPressed() {
        view.addSubview(blureEffectView)
        guard let dice = RSDiceView.randomElement() else { return }
        diceView = dice
        diceView?.center = view.center
        view.addSubview(diceView!)
        UIDevice.vibrate()
        startDiceAnimation()
    }
    
    // dice Animation
    func startDiceAnimation() {
        UIView.animateKeyframes(withDuration: 0.3, delay: 0, options: .calculationModeLinear) {
            UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.4) {
                self.diceView?.transform = CGAffineTransform(rotationAngle: -0.05)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.4) {
                self.diceView?.transform = CGAffineTransform(rotationAngle: 0.05)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.8, relativeDuration: 0.2) {
                self.diceView?.transform = CGAffineTransform(rotationAngle: 0)
            }
        } completion: { _ in }
    }
    
    @objc func removeDiceRollView() {
        diceView?.removeFromSuperview()
        blureEffectView.removeFromSuperview()
    }
    
    @objc func playerRightPress() {
        // swipe to first cell and update current index
        if indexOfMajorCell == FillingData.data.count - 1 {
            playerCollection.scrollToItem(at: IndexPath(row: 0, section: 0), at: .centeredHorizontally, animated: true)
        }
        // swipe to next cell right and update current index
        else {
            playerCollection.scrollToItem(at: IndexPath(row: indexOfMajorCell + 1, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    
    @objc func playerLeftPress() {
        // swipe to last cell
        if indexOfMajorCell == 0 {
            playerCollection.scrollToItem(at: IndexPath(row: FillingData.data.count - 1, section: 0), at: .centeredHorizontally, animated: true)
        }
        // swipe to next cell left
        else {
            playerCollection.scrollToItem(at: IndexPath(row: indexOfMajorCell - 1, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    
    func changePlayArrow(index: Int) {
        if index == 0 {
            playerLabelLeft.setStyle(style: .stopLeft)
            playerLabelRight.setStyle(style: .playRight)
        }
        else if index == FillingData.data.count - 1 {
            playerLabelLeft.setStyle(style: .playLeft)
            playerLabelRight.setStyle(style: .stopRight)
        }
        else {
            playerLabelLeft.setStyle(style: .playLeft)
            playerLabelRight.setStyle(style: .playRight)
        }
    }
    
    // MARK: Background task for Timer
    func registerBackgroundTask() {
        backgroundTask = UIApplication.shared.beginBackgroundTask(expirationHandler: { [weak self] in
            self?.endBackgroundTask()
        })
        assert(backgroundTask != .invalid)
    }
    
    func endBackgroundTask() {
        UIApplication.shared.endBackgroundTask(backgroundTask)
        backgroundTask = .invalid
    }
    
    @objc func reinstateBackgroundTask() {
        if timerLabel.timerState != .pause && backgroundTask == .invalid {
            registerBackgroundTask()
        }
    }

    // MARK: Point buttons actions
    @objc func pointButtonPressed(sender: UIButton) {
        guard let titleLabel = sender.titleLabel else { return }
        guard let point = Int(titleLabel.text!) else { return }
        
        // Add data
        FillingData.data[indexOfMajorCell].point += point
        
        // Add data to gameprogress Array
        GameProgress.data.append(DataItem(name: FillingData.data[indexOfMajorCell].name, point: point))
        playerCollection.reloadItems(at: [IndexPath(row: indexOfMajorCell, section: 0)])
        
        if timerLabel.timerState == .pause {
            timerLabel.startTimer()
        }
        
        if pointButtonPressTimer != nil {
            pointButtonPressTimer?.invalidate()
            pointButtonPressTimer = nil
            startPointButtonDelayTimer()
        } else {
            startPointButtonDelayTimer()
        }
    }
    
    func startPointButtonDelayTimer() {
        pointButtonPressTimer = Timer.scheduledTimer(withTimeInterval: pointButtonPressDelay, repeats: false) { [weak self] timer in
            self?.pointButtonPressTimer!.invalidate()
            self?.pointButtonPressTimer = nil
            self?.registerBackgroundTask()
            self?.playerRightPress()
        }
    }
}
