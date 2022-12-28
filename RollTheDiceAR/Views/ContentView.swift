//
//  ContentView.swift
//  RollTheDiceAR
//
//  Created by Zaid Neurothrone on 2022-12-27.
//

import SwiftUI

extension Float {
  func formatted(to digits: Int = 1) -> String {
    String(format: "%.\(digits)f", self)
  }
}

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
          controls
        }
      }
    }
  }
  
  private var controls: some View {
    VStack {
      ZStack {
        Text(arViewModel.message)
          .font(.title3)
          .frame(maxWidth: .infinity, alignment: .center)
          .padding()
          .background(
            Rectangle()
              .fill(.ultraThinMaterial)
              .edgesIgnoringSafeArea(.top)
          )
        
        HStack {
          Spacer()
          Button(role: .destructive, action: arViewModel.resetScene) {
            Image(systemName: AppMain.SystemImage.resetScene)
              .foregroundColor(.red)
              .imageScale(.large)
          }
          .padding(.trailing)
        }
      }
      
      Spacer()
      
      Stepper(
        "Force: \(arViewModel.force.formatted(to: 1))",
        value: $arViewModel.force,
        in: 1...5,
        step: 0.5
      )
      .padding(.horizontal)
      
      BottomButtonBarView()
        .environmentObject(arViewModel)
    }
  }
  
  private var toolbarItems: some ToolbarContent {
    ToolbarItem(placement: .navigationBarTrailing) {
      Button(role: .destructive, action: arViewModel.resetScene) {
        Image(systemName: AppMain.SystemImage.resetScene)
          .tint(.red)
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
