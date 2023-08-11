//
//  ViewController.swift
//  Verus CCminer
//
//  Created by jesse on 3/2/21.
//
import UIKit
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        Mine()
    }
    
    func Mine()-> Int32{
        let args = ["n","-a"]
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

