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
    
    //MARK: AR Config & Session
    let session = arView.session
    let config = ARWorldTrackingConfiguration()
    config.planeDetection = [.horizontal]
    session.run(config)
    
    //MARK: ARCoachingOverlayView
    arView.addCoachingOverlay()
    
    return arView
  }
  
  func updateUIView(_ uiView: ARView, context: Context) {}
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
