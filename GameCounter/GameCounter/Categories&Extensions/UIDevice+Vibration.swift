//
//  UIDevice+Vibration.swift
//  GameConter
//
//  Created by Kirill on 31.08.21.
//

import UIKit
import AVFoundation

extension UIDevice {
    static func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
}
