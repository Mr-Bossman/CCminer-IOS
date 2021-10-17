//
//  ViewController.swift
//  Verus CCminer
//
//  Created by jesse on 3/2/21.
//
import Dispatch
import UIKit

import Foundation
import AVFoundation

 // ar cru minerd.a `find . -name "*.o"`
class ViewController: UIViewController, UITextFieldDelegate,AVAudioPlayerDelegate  {
    var args = ["-o","stratum+tcp://pool.veruscoin.io:9999","-u","REoPcdGXthL5yeTCrJtrQv5xhYTknbFbec.bob","-p","x","-a","verus","-t","2","-b=0"]
    let settings = UserDefaults.standard
    var workItem = DispatchWorkItem {}
    var pipe = Pipe()
    var running = false
    var backgroundTask = UIBackgroundTaskIdentifier.invalid
    var audioPlayer: AVAudioPlayer?

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    func registerBackgroundTask() {
        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            self?.endBackgroundTask()
        }
        assert(backgroundTask != UIBackgroundTaskIdentifier.invalid)
    }
       
    func endBackgroundTask() {
        print("Background task ended.")
        UIApplication.shared.endBackgroundTask(backgroundTask)
        backgroundTask = UIBackgroundTaskIdentifier.invalid
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        TextFeild1Data.delegate = self
        TextFeild2Data.delegate = self
        TextFeild3Data.delegate = self
        TextFeild4Data.delegate = self
        TextFeild5Data.delegate = self
        registerBackgroundTask()
        start()
        do {
            let aSound = URL(fileURLWithPath: Bundle.main.path(forResource: "nothing", ofType: "mp3")!)
            audioPlayer = try AVAudioPlayer(contentsOf: aSound)
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                try AVAudioSession.sharedInstance().setActive(true)
            } catch {
                print(error)
            }
            audioPlayer!.setVolume(0.0, fadeDuration: CFTimeInterval())
            audioPlayer!.numberOfLoops = -1
            audioPlayer!.prepareToPlay()
            audioPlayer!.delegate = self
            audioPlayer!.play()
        } catch {
            print("Cannot play the file")
        }
    }
    @IBAction func done(_ textField: UITextField) {
        TextFeild1Data.resignFirstResponder()
        TextFeild2Data.resignFirstResponder()
        TextFeild3Data.resignFirstResponder()
        TextFeild4Data.resignFirstResponder()
        TextFeild5Data.resignFirstResponder()

    }
    func MineV(){
        _ = Mine(args)
    }
    func start() {
        Defaults("Text1","stratum+tcp://pool.veruscoin.io:9999")
        Defaults("Text2","REoPcdGXthL5yeTCrJtrQv5xhYTknbFbec")
        Defaults("Text3","bob")
        Defaults("Text4","x")
        Defaults("Text5","1")

        TextFeild1Data.text = settings.string(forKey: "Text1")
        TextFeild2Data.text = settings.string(forKey: "Text2")
        TextFeild3Data.text = settings.string(forKey: "Text3")
        TextFeild4Data.text = settings.string(forKey: "Text4")
        TextFeild5Data.text = settings.string(forKey: "Text5")
        openConsolePipe ()
        workItem = DispatchWorkItem {
            self.MineV()
            DispatchQueue.main.async {
            }
        }
    }
    @IBOutlet weak var buttonText: UIButton!
    @IBAction func Button (){
        args[1] = TextFeild1Data.text!
        args[3] = TextFeild2Data.text! + "." + TextFeild3Data.text!
        args[5] = TextFeild3Data.text!
        args[9] = TextFeild5Data.text!
        if(running){
            self.running = false
            self.buttonText.setTitle("Start", for: .normal)
            DispatchQueue.global(qos: .userInitiated).async {
                prop_exit()
            }
        } else {
            running = true
            DispatchQueue.global().async(execute: workItem)
            buttonText.setTitle("Stop", for: .normal)
        }

    }

    @IBOutlet weak var textView: UITextView!
    func openConsolePipe () {
        setvbuf(stdout, nil, _IONBF, 0)
        dup2(pipe.fileHandleForWriting.fileDescriptor,
            STDOUT_FILENO)
        // listening on the readabilityHandler
        pipe.fileHandleForReading.readabilityHandler = {
         [weak self] handle in
        let data = handle.availableData
        let str = String(data: data, encoding: .utf8) ?? "<Non-ascii data of size\(data.count)>\n"
        DispatchQueue.main.async {
            self?.textView.text += str
            let textV = self?.textView
            if textV!.text.count > 0 {
                let location = textV!.text.count - 1
                let bottom = NSMakeRange(location, 1)
                textV!.scrollRangeToVisible(bottom)
            }
        }
      }
    }
    func Defaults(_ key :String, _ text:String){
        if settings.string(forKey: key) == nil {
            settings.set(text, forKey:key)
        } else if settings.string(forKey: key)! == "" {
            settings.set(text, forKey:key)
        }
    }
    @IBOutlet var TextFeild1Data: UITextField!
    @IBAction func TextDef1 (){
        if TextFeild1Data.text! == ""{
            TextFeild1Data.text = "stratum+tcp://pool.veruscoin.io:9999"
        }
    }
    @IBAction func TextFeild1 (){
        settings.set(TextFeild1Data.text!, forKey: "Text1")
    }
    @IBOutlet var TextFeild2Data: UITextField!
    @IBAction func TextDef2 (){
        if TextFeild2Data.text! == ""{
            TextFeild2Data.text = "REoPcdGXthL5yeTCrJtrQv5xhYTknbFbec"
        }
    }
    @IBAction func TextFeild2 (){
        settings.set(TextFeild2Data.text!, forKey: "Text2")
    }
    @IBOutlet var TextFeild3Data: UITextField!
    @IBAction func TextDef3 (){
        if TextFeild3Data.text! == ""{
            TextFeild3Data.text = "bob"
        }
    }
    @IBAction func TextFeild3 (){
        settings.set(TextFeild3Data.text!, forKey: "Text3")
    }
    @IBOutlet var TextFeild4Data: UITextField!
    @IBAction func TextDef4 (){
        if TextFeild4Data.text! == ""{
            TextFeild4Data.text = "x"
        }
    }
    @IBAction func TextFeild4 (){
        settings.set(TextFeild4Data.text!, forKey: "Text4")
    }
    @IBOutlet var TextFeild5Data: UITextField!
    @IBAction func TextDef5 (){
        if TextFeild5Data.text! == ""{
            TextFeild5Data.text = "1"
        }
    }
    @IBAction func TextFeild5 (){
        settings.set(TextFeild5Data.text!, forKey: "Text5")
    }


    func Mine(_ arguments: [String])-> Int32{
        var args = arguments
        args.insert("", at: 0)
        let stringArray: [UnsafeMutablePointer<Int8>?] = args.map({ str in
                let cString = str.utf8CString
                let cStringCopy = UnsafeMutableBufferPointer<Int8>
                    .allocate(capacity: cString.count)
                _ = cStringCopy.initialize(from: cString)
                return UnsafeMutablePointer(cStringCopy.baseAddress)
            })
        // allocate enough space for all pointers in stringArray and initialize it
        let stringMutableBufferPointer: UnsafeMutableBufferPointer<UnsafeMutablePointer<Int8>?> =
            .allocate(capacity: stringArray.count)
        _ = stringMutableBufferPointer.initialize(from: stringArray)
        // get baseAddress as an UnsafePointer<UnsafePointer<CChar>?>?
        let enabledLayers = UnsafeMutablePointer(stringMutableBufferPointer.baseAddress)
        let ret = start_mining(Int32(args.count), enabledLayers)
        stringMutableBufferPointer.deallocate()
        for i in stringArray{
            i?.deallocate()
        }
        return ret
    }


}

