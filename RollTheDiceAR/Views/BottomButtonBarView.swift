//
//  BottomButtonBarView.swift
//  RollTheDiceAR
//
//  Created by Zaid Neurothrone on 2022-12-28.
//

import SwiftUI

struct BottomButtonBarView: View {
  @ObservedObject var arViewModel: ARViewModel
  
  var body: some View {
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

struct BottomButtonBarView_Previews: PreviewProvider {
  static var previews: some View {
    BottomButtonBarView(arViewModel: .init())
  }
}
