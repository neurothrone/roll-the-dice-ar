//
//  ARModel.swift
//  RollTheDiceAR
//
//  Created by Zaid Neurothrone on 2022-12-28.
//

import ARKit
import Combine
import RealityKit

struct ARModel {
  private(set) var arView: ARView
  private(set) var planeEntity: ModelEntity?
  
  init() {
    arView = ARView(frame: .zero)
  }
  
  func removeAnchors() {
    arView.scene.anchors.removeAll()
  }
  
  func firstRaycastResult(on location: CGPoint) -> ARRaycastResult? {
    let raycastResults = arView.raycast(
      from: location,
      allowing: .estimatedPlane,
      alignment: .horizontal
    )
    
    return raycastResults.first
  }
  
  mutating func placePlane(on location: CGPoint) {
    guard let raycastResult = firstRaycastResult(on: location) else { return }
    
    let anchor = AnchorEntity(world: raycastResult.worldTransform)
    
    let planeMesh = MeshResource.generatePlane(width: 2, depth: 2)
    let material = SimpleMaterial(color: .init(white: 1.0, alpha: 0.1), isMetallic: false)
    let planeEntity = ModelEntity(mesh: planeMesh, materials: [material])
    planeEntity.position = anchor.position
    planeEntity.physicsBody = PhysicsBodyComponent(massProperties: .default, material: nil, mode: .static)
    planeEntity.collision = CollisionComponent(shapes: [.generateBox(width: 2, height: 0.001, depth: 2)])
    planeEntity.position = anchor.position
    
    anchor.addChild(planeEntity)
    arView.scene.anchors.append(anchor)
    
    self.planeEntity = planeEntity
  }
  
  func loadAndPlaceDie(on location: CGPoint) {
    guard let raycastResult = firstRaycastResult(on: location) else { return }
    
    // Create dice entity
    var cancellable: AnyCancellable? = nil
    cancellable = ModelEntity.loadModelAsync(named: "Dice")
      .sink(receiveCompletion: { loadCompletion in
        // Handle errors
        if case let .failure(error) = loadCompletion {
          print("❌ -> Failed to load model. Error: \(error)")
        }
        cancellable?.cancel()
      }, receiveValue: { diceEntity in
        print("✅ -> Model successfully loaded.")
        cancellable?.cancel()

        let anchor = AnchorEntity(world: raycastResult.worldTransform)

        
        diceEntity.scale = [0.1, 0.1, 0.1]
        diceEntity.position = anchor.position
        diceEntity.name = "dice"
        
        // Physics
        let size = diceEntity.visualBounds(relativeTo: diceEntity).extents
        let boxShape = ShapeResource.generateBox(size: size)
        diceEntity.collision = CollisionComponent(shapes: [boxShape])

        diceEntity.physicsBody = PhysicsBodyComponent(
          massProperties: .init(shape: boxShape, mass: 50),
          material: nil,
          mode: .dynamic
        )
        
        anchor.addChild(diceEntity)
        self.arView.scene.anchors.append(anchor)
      })
  }
  
  func applyForcesToModelEntity(_ modelEntity: ModelEntity) {
    modelEntity.addForce([.zero, 5, .zero], relativeTo: nil)
    modelEntity.addTorque(
      [
        Float.random(in: .zero...0.4),
        Float.random(in: .zero...0.4),
        Float.random(in: .zero...0.4)
      ],
      relativeTo: nil
    )
  }
}
