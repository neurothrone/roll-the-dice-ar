//
//  ContentView.swift
//  RollTheDiceAR
//
//  Created by Zaid Neurothrone on 2022-12-27.
//

import ARKit
import RealityKit
import SwiftUI

struct ContentView: View {
  var body: some View {
    ZStack {
      ARViewContainer()
        .edgesIgnoringSafeArea(.all)
    }
  }
}

struct ARViewContainer: UIViewRepresentable {
  func makeUIView(context: Context) -> ARView {
    let arView = ARView(frame: .zero)
    
    // Set up config and run session
    let session = arView.session
    let config = ARWorldTrackingConfiguration()
    config.planeDetection = [.horizontal]
    session.run(config)
    
    // Set up and add AR Coaching overlay
    let overlay = ARCoachingOverlayView()
    overlay.session = session
    overlay.goal = .horizontalPlane
    overlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    arView.addSubview(overlay)
    
    return arView
  }
  
  func updateUIView(_ uiView: ARView, context: Context) {}
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
