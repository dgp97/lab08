//
//  SoundViewController.swift
//  SoundBoard
//
//  Created by MAC18 on 7/05/18.
//  Copyright © 2018 MAC18. All rights reserved.
//

import UIKit
import AVFoundation

class SoundViewController: UIViewController {

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var nameTextFiled: UITextField!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var tiempoLab: UILabel!
    
    var audioRecorder:AVAudioRecorder?
    var audioPlayer:AVAudioPlayer?
    var audioURL:URL?
    
    
    
    
    var seconds = 00
    var timer = Timer()
    var isTimerrunning = false
    var audioDuracionFin:TimeInterval?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRecorder()
        playButton.isEnabled = false
        addButton.isEnabled = false
        
    }
    
    
    
        func setupRecorder(){
            do{
            //creando sesion de audio
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try session.overrideOutputAudioPort(.speaker)
            try session.setActive(true)
            
                
            //creando direccion para el archivo de audio
                let basePath:String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) .first!
                let pathComponents = [basePath, "audio.m4a"]
                audioURL = NSURL.fileURL(withPathComponents: pathComponents)!
                
                print("**************+*")
                print(audioURL!)
                print("****************")
                
                
            //crear opciones para el grabador de audio
                var settings:[String:AnyObject] = [:]
                settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC) as AnyObject?
                settings[AVSampleRateKey] = 44100.0 as AnyObject?
                settings[AVNumberOfChannelsKey] = 2 as AnyObject?
                
            // crear el objeto de grabacion de auido
                audioRecorder = try AVAudioRecorder(url: audioURL!, settings: settings)
                audioRecorder!.prepareToRecord()
                
            } catch let error as NSError {
                print(error)
            }

        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func recordTapped(_ sender: Any) {
        if audioRecorder!.isRecording{
            //detener la grabacion
            audioRecorder?.stop()
            //cambiar texto del boton grabar
            recordButton.setTitle("Grabar", for: .normal)
            playButton.isEnabled = true
            addButton.isEnabled = true
            timer.invalidate()

        }else{
            //empepzar a grabar
            audioRecorder?.record()
            //cambiar el texto del boton grabar a detener
            recordButton.setTitle("Detener", for: .normal)
            playButton.isEnabled = false
            runTimmer()

        }
    }

    @IBAction func playTapped(_ sender: Any) {
        do{
            try audioPlayer = AVAudioPlayer(contentsOf: audioURL!)
            audioPlayer!.play()
        }catch {}
    }
    
    
    @IBAction func addTapped(_ sender: Any) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let sound = Sound(context: context)
        sound.name = nameTextFiled.text
        sound.audio = NSData(contentsOf: audioURL!)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        navigationController!.popViewController(animated: true)
    }
    
    func runTimmer () {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector (SoundViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    func updateTimer () {
        seconds += 1
        tiempoLab.text = timeString(time: TimeInterval(seconds))
    }
    
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
