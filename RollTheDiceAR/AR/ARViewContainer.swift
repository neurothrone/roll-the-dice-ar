//
//  ARViewContainer.swift
//  RollTheDiceAR
//
//  Created by Zaid Neurothrone on 2022-12-28.
//

import RealityKit
import SwiftUI

struct ARViewContainer: UIViewRepresentable {
  var arViewModel: ARViewModel
  
  func makeUIView(context: Context) -> ARView {
    arViewModel.setUp()
    return arViewModel.arView
  }
  
  func updateUIView(_ uiView: ARView, context: Context) {}
}
