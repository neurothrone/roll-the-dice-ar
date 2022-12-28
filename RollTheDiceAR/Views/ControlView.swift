//
//  ControlView.swift
//  RollTheDiceAR
//
//  Created by Zaid Neurothrone on 2022-12-28.
//

import SwiftUI

struct ControlView: View {
  @EnvironmentObject var arViewModel: ARViewModel
  
  var body: some View {
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
}

extension Float {
  func formatted(to digits: Int = 1) -> String {
    String(format: "%.\(digits)f", self)
  }
}

struct ControlView_Previews: PreviewProvider {
  static var previews: some View {
    ControlView()
      .environmentObject(ARViewModel())
  }
}
