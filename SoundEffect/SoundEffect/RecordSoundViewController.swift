//
//  ViewController.swift
//  SoundEffect
//
//  Created by Pomme on 9/23/16.
//  Copyright © 2016 Yuanjie Xie. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecorButton: UIButton!

    var audioRecorder:AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        stopRecorButton.isEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // record audio button clicked
    @IBAction func recordAudioBtn(_ sender: AnyObject) {
        print("Record Audio button pressed.\n")
        recordLabel.text = "Record in progress"
        
        stopRecorButton.isEnabled = true
        recordButton.isEnabled = false
        
        // Grabs the document directory and store it as a string in the dirPath constant
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURL(withPathComponents: pathArray)
        print(filePath)
        
        // Grab the AVAudioSession and set up the category to play and record
        // iOS API and grab a singleton, usually a function called shared instance.
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        
        // set view controller self as delegate to the a.v.audio recorder
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
        
        
        
    }
    
    @IBAction func stropRecordBtn(_ sender: AnyObject) {
        print("Stop recording button pressed.\n")
        recordLabel.text = "Record stopped\nTap to Record"
        
        stopRecorButton.isEnabled = false
        recordButton.isEnabled = true
        
        // stop audio to recordButton
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear called")
    }
    
    
    // delegation of AVAudioRecorderDelegate
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
        
        
        
        print("AVAudioRecorder finished recording")
        if (flag) {
            self.performSegue(withIdentifier: "stopRecordingSegue", sender: audioRecorder.url)
            print("Saving of recording succeeded")
        }
        else {
            print("Saving of recording failed")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "stopRecordingSegue") {
            let playSoundVC = segue.destination as! PlaySoundViewController
            let recordedAudioURL = sender as! URL
            playSoundVC.recordedAudioURL = recordedAudioURL
        }
    }
}

