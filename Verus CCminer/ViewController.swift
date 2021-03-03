//
//  ViewController.swift
//  Verus CCminer
//
//  Created by jesse on 3/2/21.
//
import UIKit
class ViewController: UIViewController {
    var args = ["-o","stratum+tcp://pool.veruscoin.io:9999","-u","REoPcdGXthL5yeTCrJtrQv5xhYTknbFbec.bob","-p","x","-a","verus","-t","1"]
    let settings = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan
        TextFeild1Data.text = settings.string(forKey: "Text1")
        TextFeild2Data.text = settings.string(forKey: "Text2")
        TextFeild3Data.text = settings.string(forKey: "Text3")
        TextFeild4Data.text = settings.string(forKey: "Text4")
    }
    @IBAction func Button (){
        //TextFeild1Data.text
        Mine(args)
    }
    @IBOutlet var TextFeild1Data: UITextField!
    @IBAction func TextFeild1 (){
        settings.set(TextFeild1Data.text, forKey: "Text1")
    }
    @IBOutlet var TextFeild2Data: UITextField!
    @IBAction func TextFeild2 (){
        settings.set(TextFeild2Data.text, forKey: "Text2")
    }
    @IBOutlet var TextFeild3Data: UITextField!
    @IBAction func TextFeild3 (){
        settings.set(TextFeild3Data.text, forKey: "Text3")
    }
    @IBOutlet var TextFeild4Data: UITextField!
    @IBAction func TextFeild4 (){
        settings.set(TextFeild4Data.text, forKey: "Text4")
    }
    @IBOutlet var TextFeild5Data: UITextField!
    @IBAction func TextFeild5 (){
        settings.set(TextFeild5Data.text, forKey: "Text5")
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

