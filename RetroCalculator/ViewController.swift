//
//  AppDelegate.swift
//  RetroCalculator
//
//  Created by Mehmet Anıl Kul on 21.07.2017.
//  Copyright © 2017 Mehmet Anıl Kul. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    @IBOutlet weak var outputLbl: UILabel!
    @IBOutlet weak var clearBtn: UIButton!
    @IBOutlet weak var soundBtn: UIButton!
    
    var soundState: Int! = 0
    var btnSound: AVAudioPlayer!
    
    // Set Operation Enums
    enum Operation: String {
        case Divide = "/"
        case Multiply = "*"
        case Subtract = "-"
        case Add = "+"
        case Empty = "Empty"
    }
    
    // Toogle Music
    @IBAction func soundBtnPressed(_ sender: Any) {
        soundBtn.isSelected = !soundBtn.isSelected //
        if soundBtn.isSelected == true {
            soundState = 1
        } else {
            soundState = 0
        }
    }
    
    var currentOperation = Operation.Empty
    var runningNumber = ""
    var leftValStr = ""
    var rightValStr = ""
    var result = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Sound file path
        let path = Bundle.main.path(forResource: "btn", ofType: "wav")
        
        // yukaridaki yolu URL'ye donusturuyoruz.
        let soundURL = URL(fileURLWithPath: path!)
        
        do {
            //tanimladigimiz URL kullanilarak audio stream yapilacak
            try btnSound = AVAudioPlayer(contentsOf: soundURL)
            //calmaya hazirla
            btnSound.prepareToPlay()
        } catch let err as NSError {
            //stream yapilamazsa error ver
            print(err.debugDescription)
        }
        
        outputLbl.text = "0"
        
    }
    
    // Play Sound
    func playSound() {
        if btnSound.isPlaying {
            btnSound.stop()
        }
        // butona basildiginda cal
        if soundState == 1 {
        btnSound.play()
        }
    }
    
    
    @IBAction func numberPressed(sender: UIButton) {
        playSound()
        // str olarak tanimlamamizin nedeni sayilarin bastikca yan yana eklenecek olmasi
        // sender.tag ise SB'daki tusun tag degeri.
        runningNumber += "\(sender.tag)"
        outputLbl.text = runningNumber
    }
    
    @IBAction func onDividePressed(sender: AnyObject) {
        processOperation(operation: .Divide)
    }
    
    @IBAction func onMultiplyPressed(sender: AnyObject) {
        processOperation(operation: .Multiply)
    }
    
    @IBAction func onSubtractPressed(sender: AnyObject) {
        processOperation(operation: .Subtract)
    }
    
    @IBAction func onAddPressed(sender: AnyObject) {
        processOperation(operation: .Add)
    }
    
    @IBAction func onEqualPressed(sender: AnyObject) {
        processOperation(operation: currentOperation)
    }
    
    
    // Operation
    func processOperation(operation: Operation) {
        playSound()
        
        if currentOperation != Operation.Empty {

            // Burada operator tusunun ardindan numara tuslarindan birine basildiginin check'i yapilmaktadir.
            if runningNumber != "" {
                rightValStr = runningNumber // right hand side degerimiz girilen deger
                runningNumber = "" //running numberi resetle
                
                if currentOperation == Operation.Multiply {
                    result = "\(Double(leftValStr)! * Double(rightValStr)!)"
                } else if currentOperation == Operation.Divide {
                    result = "\(Double(leftValStr)! / Double(rightValStr)!)"
                } else if currentOperation == Operation.Subtract {
                    result = "\(Double(leftValStr)! - Double(rightValStr)!)"
                } else if currentOperation == Operation.Add {
                    result = "\(Double(leftValStr)! + Double(rightValStr)!)"
                }
                
                leftValStr = result
                outputLbl.text = result
            }
            
            // Bir deger girildikten sonra artik surekli bir left value olacagindan currentOperation'in bos olmadigindan emin olmak icin enum oldugunu belirtiyoruz ki asagidaki else kismina bir daha gecmesin.
            currentOperation = operation
        } else {
            //Ilk defa bir isleme basildiginda
            leftValStr = runningNumber
            runningNumber = ""
            currentOperation = operation
        }
    }
    
    
    // Clear
    @IBAction func clearBtnPressed(_ sender: Any) {
        currentOperation = Operation.Empty
        runningNumber = ""
        leftValStr = ""
        rightValStr = ""
        result = ""
        outputLbl.text = "0"
    }
}

