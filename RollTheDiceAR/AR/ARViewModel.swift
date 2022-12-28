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

enum Message {
  static let placedPlane = "Placed Plane"
  static let placedDie = "Placed Die"
  static let rolledDice = "Rolled the dice"
  static let planeAlreadyExists = "A plane already exists"
  static let resetedScene = "Reseted scene!"
  
}

final class ARViewModel: UIViewController, ObservableObject, ARSessionDelegate {
  @Published private var model: ARModel = .init()
  @Published var message: String = "Welcome"
  @Published var placementMode: PlacementMode = .plane
  
  var arView: ARView {
    model.arView
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
    sendMessage(Message.resetedScene)
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
      sendMessage(Message.rolledDice)
      
      return
    }
    
    model.loadAndPlaceDie(on: location)
    sendMessage(Message.placedDie)
  }
  
  // Places a plane only if one does not exist
  func placePlane(on location: CGPoint) {
    guard model.planeEntity == nil else {
      sendMessage(Message.planeAlreadyExists)
      return
    }
    
    model.placePlane(on: location)
    sendMessage(Message.placedPlane)
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
