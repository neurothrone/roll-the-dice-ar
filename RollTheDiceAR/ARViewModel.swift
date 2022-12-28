//
//  ARViewModel.swift
//  RollTheDiceAR
//
//  Created by Zaid Neurothrone on 2022-12-28.
//

import ARKit
import Combine
import RealityKit
import SwiftUI

enum PlacementMode {
  case plane,
       die
}

extension PlacementMode: Identifiable {
  var id: Self { self }
}

final class ARViewModel: UIViewController, ObservableObject, ARSessionDelegate {
  @Published private var model: ARModel = .init()
  @Published var message: String = "Message"
  @Published var placementMode: PlacementMode = .plane
  
  var arView: ARView {
    model.arView
  }
  
  func clearButtonPressed() {
    resetScene()
  }
  
  func setUp() {
    initARView()
    initGestures()
    
#if DEBUG
//    arView.debugOptions = [
//      .showFeaturePoints,
//      .showAnchorOrigins,
//      .showAnchorGeometry,
//      .showPhysics
//    ]
#endif
  }
}

// MARK: - Helper Functions
extension ARViewModel {
  func sendMessage(_ message: String) {
    DispatchQueue.main.async {
      self.message = message
    }
  }
}

// MARK: - AR View Functions
extension ARViewModel {
  func initARView() {
    arView.session.delegate = self
    arView.automaticallyConfigureSession = false
    
    let arConfiguration = ARWorldTrackingConfiguration()
    arConfiguration.planeDetection = [.horizontal]
    arConfiguration.environmentTexturing = .automatic
    
    arView.addCoachingOverlay()
    
#if DEBUG
//    arView.debugOptions = [.showFeaturePoints, .showAnchorOrigins, .showAnchorGeometry]
#endif
    
    arView.session.run(arConfiguration)
  }
  
  func resetScene() {
    model.removeAnchors()
    sendMessage("Resetted!")
  }
  
  func interact(on location: CGPoint) {
    if placementMode == .plane {
      placePlane(on: location)
      return
    }
    
    // If tapped on existing entity that is a die
    if let hitEntity = arView.entity(at: location),
       let existingDiceEntity = hitEntity as? ModelEntity,
       existingDiceEntity.name == "dice" {
      
      model.applyForcesToModelEntity(existingDiceEntity)
      sendMessage("Applied forces to Die")
      
      return
    }
    
    model.loadAndPlaceDie(on: location)
    sendMessage("Placed Die")
  }
  
  // Place a plane if one does not exist
  func placePlane(on location: CGPoint) {
    guard model.planeEntity == nil else {
      sendMessage("A plane already exists")
      return
    }
    
    model.placePlane(on: location)
  }
}

// MARK: - Gesture Functions
extension ARViewModel {
  func initGestures() {
//    let tap = UITapGestureRecognizer(
//      target: self,
//      action: #selector(handleTap)
//    )
//
//    arView.addGestureRecognizer(tap)
  }
  
//  @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
//    let tapLocation = recognizer.location(in: view)
//  }
  
}
