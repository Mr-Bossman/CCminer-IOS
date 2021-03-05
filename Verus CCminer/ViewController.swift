//
//  ViewController.swift
//  Verus CCminer
//
//  Created by jesse on 3/2/21.
//
import Dispatch
import UIKit
class ViewController: UIViewController {
    var args = ["-o","stratum+tcp://pool.veruscoin.io:9999","-u","REoPcdGXthL5yeTCrJtrQv5xhYTknbFbec.bob","-p","x","-a","verus","-t","2"]
    let settings = UserDefaults.standard
    var workItem = DispatchWorkItem {}
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan
        start()
    }
    @objc func MineV(){
        Mine(args)
    }
    func start() {
        workItem = DispatchWorkItem {
            self.MineV()
          DispatchQueue.main.async {
           print("done")
          }
       }
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
        DispatchQueue.global().async(execute: workItem)

    }
    @IBAction func Button (){
        args[1] = TextFeild1Data.text!
        args[3] = TextFeild2Data.text! + "." + TextFeild3Data.text!
        args[5] = TextFeild3Data.text!
        args[9] = TextFeild5Data.text!

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
        return start_mining(Int32(args.count), enabledLayers)
    }


}

