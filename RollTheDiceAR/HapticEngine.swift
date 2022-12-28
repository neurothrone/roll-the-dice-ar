//
//  HapticEngine.swift
//  RollTheDiceAR
//
//  Created by Zaid Neurothrone on 2022-12-28.
//

import SwiftUI

enum Haptic {
  case impact,
       selectionChanged,
       notificationChanged
}

struct HapticEngine {
  private let impactGenerator = UIImpactFeedbackGenerator()
  private let selectionGenerator = UISelectionFeedbackGenerator()
  private let notificationGenerator = UINotificationFeedbackGenerator()
  
  func play(
    haptic: Haptic,
    intensity: CGFloat = 1,
    notificationType: UINotificationFeedbackGenerator.FeedbackType? = nil
  ) {
    switch haptic {
    case .impact:
      impactGenerator.impactOccurred(intensity: intensity)
    case .selectionChanged:
      selectionGenerator.selectionChanged()
    case .notificationChanged:
      notificationGenerator.notificationOccurred(notificationType ?? .warning)
    }
  }
}
