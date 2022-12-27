//
//  ARView+Extensions.swift
//  RollTheDiceAR
//
//  Created by Zaid Neurothrone on 2022-12-27.
//

import ARKit
import RealityKit

extension ARView {
  func addCoachingOverlay() {
    let overlay = ARCoachingOverlayView()
    overlay.session = self.session
    overlay.goal = .horizontalPlane
    overlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    self.addSubview(overlay)
  }
}
