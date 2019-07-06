//
//  VRecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Hanan Almarzougi on 3/22/19.
//  Copyright © 2019 Hanan Almarzougi. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController : UIViewController , AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!
    
    @IBOutlet weak var recordingLable: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordButton.isEnabled = false
    
    }
    
    @IBAction func recordAudio(_ sender: Any) {
        
        setRecordingState(true)
        stopRecordButton.isEnabled = true
        recordButton.isEnabled = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self as AVAudioRecorderDelegate
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        setRecordingState(false)
        stopRecordButton.isEnabled = false
        recordButton.isEnabled = true
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        

    }
    
    func setRecordingState(_ isRecording: Bool) {
            recordingLable.text = isRecording ? "Recording in Progress" : "Tap to Record"
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag : Bool){
        
        if flag {
            
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
            
        }else{
            
            let alertController = UIAlertController(title: "Attention", message: "Recoding was not successful, please try again!", preferredStyle: .alert)
    
            let defaultAction =  UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let playSoundsVC = segue.destination as! PlaySoundsViewController
        
        let recordedAudioURL = sender as! URL
        playSoundsVC.recordedAudioURL = recordedAudioURL
    }
    
}

