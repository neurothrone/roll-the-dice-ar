//
//  ContentView.swift
//  RollTheDiceAR
//
//  Created by Zaid Neurothrone on 2022-12-27.
//

import SwiftUI

struct ContentView: View {
  @StateObject private var arViewModel: ARViewModel = .init()
  
  var body: some View {
    NavigationStack {
      ZStack(alignment: .top) {
        ARViewContainer(arViewModel: arViewModel)
          .edgesIgnoringSafeArea(.all)
          .onTapGesture(coordinateSpace: .global) { location in
            arViewModel.interact(on: location)
          }
        
        if arViewModel.showControls {
          ControlView()
            .environmentObject(arViewModel)
        }
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
