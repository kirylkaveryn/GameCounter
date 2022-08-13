//
//  RSTimer.swift
//  GameConter
//
//  Created by Kirill on 28.08.21.
//

import UIKit

enum TimerState {
    case play
    case pause
}

class RSTimer: UIView {
    
    var timer: Timer?
    var currentTime: Date?
    var timerState: TimerState?
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "mm:ss"
        return formatter
    }()
    
    let timerStateControl: UIButton = {
        let button = UIButton()
        button.contentMode = .scaleAspectFit
        button.tintColor = .rsLabelWhite
        button.isEnabled = true
        return button
    }()
    
    let timerLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.font = UIFont.rsExtraBold28
        label.textAlignment = .center
        label.text = "00:00"
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        self.isUserInteractionEnabled = true
        self.addSubview(timerLabel)
        self.addSubview(timerStateControl)
        self.timer = Timer()
        
        timerStateControl.addTarget(self, action: #selector(timerControlButtonPressed), for: .touchUpInside)
        
        if !rsDefaults.bool(forKey: rsDefaultsNotFirstLaunch) {
            currentTime = Date(timeIntervalSinceReferenceDate: 0)
        } else {
            guard let timeFromDefaults = rsDefaults.string(forKey: rsDefaultsTime) else {return}
            currentTime = formatter.date(from: timeFromDefaults)
            setTimerState(state: .play)
            startTimer()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateTimeDefaults), name: UIApplication.willResignActiveNotification, object: nil)

        activateConstraints()
    }
    
    func activateConstraints() {
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        timerStateControl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            timerLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            timerLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            timerStateControl.centerYAnchor.constraint(equalTo: centerYAnchor),
            timerStateControl.centerXAnchor.constraint(equalTo: timerLabel.trailingAnchor, constant: 20),
            timerStateControl.heightAnchor.constraint(equalToConstant: 20),
            timerStateControl.widthAnchor.constraint(equalToConstant: 20),
        ])
    }
    
    func setTimerState(state: TimerState) {
        switch state {
        case .play:
            timerState = .play
            timerStateControl.setImage(UIImage(named: "icon_Pause"), for: .normal)
            timerLabel.textColor = .rsLabelWhite
        case .pause:
            timerState = .pause
            timerStateControl.setImage(UIImage(named: "icon_Play"), for: .normal)
            timerLabel.textColor = .rsBackgroundCollection
        }
    }
    
    @objc func updateLabel() {
        currentTime! += 0.1
        timerLabel.text = formatter.string(from: currentTime!)
    }
    
    func startTimer() {
        setTimerState(state: .play)
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateLabel), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: .common)
    }
    
    func stopTimer() {
        setTimerState(state: .pause)
        if timer != nil {
            timer!.invalidate()
        }
        timer = nil
    }
    
    func restartTimer() {
        stopTimer()
        currentTime = Date(timeIntervalSinceReferenceDate: 0)
        startTimer()
    }
    
    @objc func updateTimeDefaults() {
        let stringFromDate = DateFormatter()
        stringFromDate.dateFormat = "mm:ss"
        rsDefaults.setValue(stringFromDate.string(from: currentTime!), forKey: rsDefaultsTime)
    }
    
    @objc func timerControlButtonPressed() {
        if timerState == .pause {
            startTimer()
        } else {
            stopTimer()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
