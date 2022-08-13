//
//  Data.swift
//  GameConter
//
//  Created by Kirill on 26.08.21.
//

import UIKit

public var rsDefaults = UserDefaults.standard
public let rsDefaultsNotFirstLaunch = "rsDefaultsNotFirstLaunch"
public let rsDefaultsPlayersData = "rsDefaultsPlayersData"
public let rsDefaultsGameProgressData = "rsDefaultsGameProgressData"
public let rsDefaultsTime = "rsDefaultsTime"
public let rsDefaultsCurrentPlayer = "rsDefaultsCurrentPlayer"

public let gameProgressIsEmpty = Notification.Name("gameProgressIsEmpty")
public let gameProgressIsNotEmpty = Notification.Name("gameProgressIsNotEmpty")

struct DataItem {
    let name: String
    var point: Int
}

// players data
struct FillingData {
    static var data: [DataItem] = {
        if !rsDefaults.bool(forKey: rsDefaultsNotFirstLaunch) {
            let data: [DataItem] = [
            DataItem(name: "Harold", point: 0),
            DataItem(name: "Bob", point: 0)]
            return data
        }
        else {
            return loadDataFromDefaultsAsArray(defaultsKey: rsDefaultsPlayersData)
        }

    }() {
        didSet {
            loadDataToDefaultsAsArray(data: data, defaultsKey: rsDefaultsPlayersData)
        }
    }
}

// game progress data
struct GameProgress {
    static var data: [DataItem] = {
        if !rsDefaults.bool(forKey: rsDefaultsNotFirstLaunch) {
            let data: [DataItem] = []
            return data
        }
        else {
            let data = loadDataFromDefaultsAsArray(defaultsKey: rsDefaultsGameProgressData)
            return data
        }

    }() {
        didSet {
            loadDataToDefaultsAsArray(data: data, defaultsKey: rsDefaultsGameProgressData)
            postNotificationToUndoAndResultButtons()
        }
    }
}

func postNotificationToUndoAndResultButtons() {
    if GameProgress.data.count == 0 {
        NotificationCenter.default.post(name: gameProgressIsEmpty, object: nil)
    } else {
        NotificationCenter.default.post(name: gameProgressIsNotEmpty, object: nil)
    }
}

func loadDataToDefaultsAsArray(data: [DataItem], defaultsKey: String) {
    var dataArray: [[Any?]] = [[]]
    for i in 0..<data.count {
        dataArray.append([data[i].name, data[i].point])
    }
    rsDefaults.set(dataArray, forKey: defaultsKey)
}

func loadDataFromDefaultsAsArray(defaultsKey: String) -> [DataItem] {
    guard rsDefaults.array(forKey: defaultsKey) != nil else { return [] }
    var data: [DataItem] = []
    let defaultArray = rsDefaults.array(forKey: defaultsKey) as! [[Any?]]
    for item in defaultArray {
        if !item.isEmpty {
            data.append(DataItem(name: item[0] as! String, point: item[1] as! Int))
        }
    }
    return data
}
