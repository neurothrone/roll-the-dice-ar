//
//  AudioManager.swift
//  RollTheDiceAR
//
//  Created by Zaid Neurothrone on 2022-12-28.
//

import Combine
import Foundation
import RealityKit

final class AudioManager {
  var tapSound: AudioFileResource? = nil
  var diceSound: AudioFileResource? = nil
  
  func loadAudio() {
    loadAsync(named: "ui-click-43196.mp3") { tapSound in
      self.tapSound = tapSound
    }
    
    loadAsync(named: "dice-sound-40081.mp3") { diceSound in
      self.diceSound = diceSound
    }
  }
  
  private func playAudioSync(
    named audioFilePath: String,
    for modelEntity: ModelEntity
  ) {
    do {
      let resource = try AudioFileResource.load(
        named: audioFilePath,
        in: nil,
        inputMode: .spatial,
        loadingStrategy: .preload,
        shouldLoop: false
      )

//      let audioController = modelEntity.prepareAudio(resource)
//      audioController.play()

      // To play right away
      _ = modelEntity.playAudio(resource)
    } catch {
      print("❌ -> Failed to play audio. Error: \(error.localizedDescription)")
    }
  }
  
  func playAudioAsync(
    named audioFilePath: String,
    for modelEntity: ModelEntity
  ) {
    var cancellable: AnyCancellable? = nil
    cancellable = AudioFileResource.loadAsync(
      named: audioFilePath,
      in: nil,
      inputMode: .spatial,
      loadingStrategy: .preload,
      shouldLoop: false
    )
    .sink(receiveCompletion: { loadCompletion in
      // Handle errors
      if case let .failure(error) = loadCompletion {
#if DEBUG
        print("❌ -> Failed to load model. Error: \(error)")
#endif
      }
      cancellable?.cancel()
    }, receiveValue: { audioResource in
#if DEBUG
        print("✅ -> Audio successfully loaded.")
#endif
        cancellable?.cancel()
      
      _ = modelEntity.playAudio(audioResource)
    })
  }
  
  private func loadAsync(named audioFilePath: String, completion: @escaping (AudioFileResource?) -> Void) {
    var cancellable: AnyCancellable? = nil
    
    cancellable = AudioFileResource.loadAsync(
      named: audioFilePath,
      in: nil,
      inputMode: .spatial,
      loadingStrategy: .preload,
      shouldLoop: false
    )
    .sink(receiveCompletion: { loadCompletion in
      // Handle errors
      if case let .failure(error) = loadCompletion {
#if DEBUG
        print("❌ -> Failed to load model. Error: \(error)")
#endif
      }
      cancellable?.cancel()
      completion(nil)
    }, receiveValue: { audioResource in
#if DEBUG
      print("✅ -> Audio successfully loaded.")
#endif
      cancellable?.cancel()
      
      completion(audioResource)
    })
  }
}
