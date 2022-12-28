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
      ZStack(alignment: .bottom) {
        ARViewContainer(arViewModel: arViewModel)
          .edgesIgnoringSafeArea(.all)
          .onTapGesture(coordinateSpace: .global) { location in
            arViewModel.interact(on: location)
          }
        
        VStack {
          Text(arViewModel.message)
          
          Spacer()
          
          HStack {
            Spacer()
            
            Button("Place Plane", action: { arViewModel.placementMode = .plane })
              .tint(arViewModel.placementMode == .plane ? .green : .blue)
            
            Spacer()
            
            Button("Place Die", action: { arViewModel.placementMode = .die })
              .tint(arViewModel.placementMode == .die ? .green : .blue)
            
            Spacer()
          }
          .buttonStyle(.borderedProminent)
          .controlSize(.large)
          .padding()
          .background(
            Rectangle()
              .fill(.ultraThinMaterial)
              .edgesIgnoringSafeArea(.bottom)
        )
        }
      }
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button(role: .destructive, action: arViewModel.resetScene) {
            Image(systemName: "arrow.counterclockwise.circle.fill")
              .tint(.red)
          }
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
