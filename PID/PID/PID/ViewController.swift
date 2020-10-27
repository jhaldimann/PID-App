//
//  ViewController.swift
//  PID
//
//  Created by Julian Haldimann on 23.10.20.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    var motionManager = CMMotionManager()
    var timer: Timer!
    var v = 0.0
    var a = 0.0
    var p = 0.0
    var s = 0.0
    
    var kp = 0.3
    var ki = 0.003
    var kd = 0.0
    
    var max = 30.0
    var min = -30.0
    
    var i = 0.0
    var t0 = 0.0
    var e0 = 0.0
    
    @IBOutlet var powerslider: UISlider!
    @IBOutlet var x: UILabel!
    @IBOutlet var y: UILabel!
    @IBOutlet var z: UILabel!
    @IBOutlet var destSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        motionManager.startAccelerometerUpdates()
        motionManager.startGyroUpdates()
        motionManager.startMagnetometerUpdates()
        motionManager.startDeviceMotionUpdates()
        destSlider.value = 20
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(ViewController.update), userInfo: nil, repeats: true)
    }
    
    @objc func update() {
        if let accelerometerData = motionManager.accelerometerData {
            var a = accelerometerData.acceleration.y * 9.81
            let t = 0.1
            
            print()
            
            if s < 0.0 {
                v = 0
                s = 0
            } else if s > 100.0 {
                v = 0
                s = 100.0
            }
            
            //a = bangbang(val: a)
            
            a = pid(r: Double(destSlider.value), x: s, t: 1.0) + a
            
            a = a - v * 0.1
            
            v = a * t + v
            s = v * t + s
            

            print(destSlider.value)
            print("Position: \(s)")
            print("Acceleration: \(a)")
            
            powerslider.value = Float(s)
        }
    }
    
    func bangbang(val: Double) -> Double {
        var a = val
        if destSlider.value > (Float(s) + 10) && destSlider.value > Float(s) {
            a += 8
        } else if destSlider.value < (Float(s) - 10) && destSlider.value < (Float(s)) {
            a -= 8
        }
        
        return a
    }
    
    func pid (r: Double, x: Double, t: Double) -> Double {
        let e1 = r - x
        i = i + e1
        
        if i > max {
            i = max
        } else if i < min {
            i = min
        }
        
        let de = (e1 - e0)
        e0 = e1
        
        let u = (kp * e1) + (ki * i) + (kd * de)
        
        return u
    }
}




