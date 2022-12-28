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
            .font(.title3)
          
          Spacer()
          
          BottomButtonBarView(arViewModel: arViewModel)
        }
      }
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button(role: .destructive, action: arViewModel.resetScene) {
            Image(systemName: AppMain.SystemImage.resetScene)
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
