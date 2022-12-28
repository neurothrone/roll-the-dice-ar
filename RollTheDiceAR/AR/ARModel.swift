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
  
  var subscriptions: [Cancellable] = []
  
  init() {
    arView = ARView(frame: .zero)
  }
  
  mutating func removeAnchors() {
    planeEntity = nil
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
    
    anchor.position.y -= 0.05
    
    planeEntity.position = anchor.position
    planeEntity.physicsBody = PhysicsBodyComponent(massProperties: .default, material: nil, mode: .static)
    planeEntity.collision = CollisionComponent(shapes: [.generateBox(width: 2, height: 0.001, depth: 2)])
    planeEntity.position = anchor.position
    
    anchor.addChild(planeEntity)
    arView.scene.anchors.append(anchor)
    
    self.planeEntity = planeEntity
  }
  
  func loadAndPlaceDie(
    on location: CGPoint,
    completion: @escaping (ModelEntity?) -> Void
  ) {
    guard let raycastResult = firstRaycastResult(on: location) else { return }
    
    // Create dice entity
    var cancellable: AnyCancellable? = nil
    cancellable = ModelEntity.loadModelAsync(named: "Die")
      .sink(receiveCompletion: { loadCompletion in
        // Handle errors
        if case let .failure(error) = loadCompletion {
#if DEBUG
          print("❌ -> Failed to load model. Error: \(error)")
#endif
        }
        cancellable?.cancel()
        completion(nil)
      }, receiveValue: { dieEntity in
#if DEBUG
        print("✅ -> Model successfully loaded.")
#endif
        cancellable?.cancel()

        let anchor = AnchorEntity(world: raycastResult.worldTransform)

        
        dieEntity.scale = [0.05, 0.05, 0.05]
        dieEntity.position = anchor.position
        dieEntity.name = "dice"
        
        // Physics
        let size = dieEntity.visualBounds(relativeTo: dieEntity).extents
        let boxShape = ShapeResource.generateBox(size: size)
        dieEntity.collision = CollisionComponent(shapes: [boxShape])

        dieEntity.physicsBody = PhysicsBodyComponent(
          massProperties: .init(shape: boxShape, mass: 100),
          material: nil,
          mode: .dynamic
        )
        
        anchor.addChild(dieEntity)
        self.arView.scene.anchors.append(anchor)
        
        completion(dieEntity)
      })
  }
  
  func applyForce(_ force: Float = 2.5, to modelEntity: ModelEntity) {
    modelEntity.addForce([.zero, force, .zero], relativeTo: nil)
    modelEntity.addTorque(
      [
        Float.random(in: .zero...0.5),
        Float.random(in: .zero...0.5),
        Float.random(in: .zero...0.5)
      ],
      relativeTo: nil
    )
  }
}
