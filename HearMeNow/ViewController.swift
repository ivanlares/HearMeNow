//
//  ViewController.swift
//  HearMeNow
//
//  Created by ivan lares on 5/3/15.
//  Copyright (c) 2015 Ivan Lares. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate {
  
  var hasRecording = false
  var soundPlayer: AVAudioPlayer?
  var soundRecorder: AVAudioRecorder?
  var session: AVAudioSession?
  var soundPath: String?
  
  @IBOutlet weak var recordButton: UIButton!
  @IBOutlet weak var playButton: UIButton!
  @IBAction func recordPressed(sender: AnyObject) {
    
    
    // !!!!!!Testing!!!!!!!!

    
    // CHANGES ON MASTER


    // TESTING ON TESTING BRANCH 

    
    if(soundRecorder?.recording == true){
      soundRecorder?.stop()
      recordButton.setTitle("Record", forState: UIControlState.Normal)
      hasRecording = true
    } else {
      session?.requestRecordPermission(){
        granted in
        if (granted == true){
          self.soundRecorder?.record()
          self.recordButton.setTitle("Stop", forState: UIControlState.Normal)
        } else {
          print("Unable to record")
        }
      }
    }
  }
  
  @IBAction func playPressed(sender: AnyObject) {
    if (soundPlayer?.playing == true){
      soundPlayer?.pause()
      playButton.setTitle("Play", forState: UIControlState.Normal)
    } else if (hasRecording == true){
      let url = NSURL(fileURLWithPath: soundPath!)
      do {
        soundPlayer = try AVAudioPlayer(contentsOfURL: url)
        soundPlayer?.delegate = self
        soundPlayer?.enableRate = true
        soundPlayer?.rate = 1.0
        soundPlayer?.play()
      } catch let error as NSError {
        print(error.localizedDescription)
        soundPlayer = nil
      }
      playButton.setTitle("Pause", forState: UIControlState.Normal)
      hasRecording = false
    } else if (soundPlayer != nil){
      soundPlayer?.play()
      playButton.setTitle("Pause", forState: UIControlState.Normal)
    }
  }
  
  func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
    recordButton.setTitle("Record", forState: UIControlState.Normal)
  }
  
  func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
    playButton.setTitle("Play", forState: UIControlState.Normal)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    soundPath = "\(NSTemporaryDirectory())hearmenow.wav"
    let url = NSURL(fileURLWithPath:soundPath!)
    session = AVAudioSession.sharedInstance()
    do {
      try session?.setActive(true)
      try session?.setCategory(AVAudioSessionCategoryPlayAndRecord)
    } catch let error as NSError {
      print(error.localizedDescription)
    }
    do {
      try session?.setCategory(AVAudioSessionCategoryPlayAndRecord)
    } catch let error as NSError {
      print(error.localizedDescription)
    }
    do {
      let dictionary = [String:AnyObject]()
      soundRecorder = try AVAudioRecorder(URL: url, settings: dictionary)
    } catch let error as NSError {
      print(error.localizedDescription)
      soundRecorder = nil
    }
    soundRecorder?.delegate = self
    soundRecorder?.prepareToRecord()
  }
  
}

