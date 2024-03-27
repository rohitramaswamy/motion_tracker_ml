//
//  ViewController.swift
//  gyroscope
//
//  Created by Rohit Ramaswamy on 6/11/23.
//

import UIKit
import CoreMotion
import Foundation


class ViewController: UIViewController {

    @IBOutlet weak var gyrox: UILabel!
    @IBOutlet weak var gyroy: UILabel!
    @IBOutlet weak var gyroz: UILabel!
    @IBOutlet weak var accelx: UILabel!
    @IBOutlet weak var accely: UILabel!
    @IBOutlet weak var accelz: UILabel!
    var trackingButtonChecked = false
    
    var csvString = " "
    
    
    
    @IBOutlet weak var toggleButton: UIButton!
    
    var motion = CMMotionManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        toggleButton.setTitle("Start Tracking", for: .normal)
        

        
        // Do any additional setup after loading the view.
    }
    @IBAction func toggleButton(_ sender: Any) {
        if trackingButtonChecked == false {
            trackingButtonChecked = true
            startTracking()
            toggleButton.setTitle("Stop Tracking", for: .normal)

            
        }
        else{
            trackingButtonChecked = false
            stopTracking()
            toggleButton.setTitle("Start Tracking", for: .normal)

            
            
        }
        
    }
    func startTracking(){
        MyGyro()
        MyAccel()
        csvString += "%, "
        
    }
    func stopTracking(){
        motion.stopGyroUpdates()
        motion.stopAccelerometerUpdates()
        
        uploadData(fileContents: csvString)

        
        
        
    }
    func MyGyro(){
        motion.gyroUpdateInterval = 0.01
        motion.startGyroUpdates(to: OperationQueue.current!){(data, error) in
            if let trueData = data{
                self.gyrox.text = "\(trueData.rotationRate.x)"
                self.gyroy.text = "\(trueData.rotationRate.y)"
                self.gyroz.text = "\(trueData.rotationRate.z)"
                
                self.csvString.append("gyrox \(trueData.rotationRate.x), gyroy \(trueData.rotationRate.y), gyroz \(trueData.rotationRate.z), ")

               
            }
           
        
        }
    }
    func MyAccel(){
        motion.accelerometerUpdateInterval = 0.01
        motion.startAccelerometerUpdates(to: OperationQueue.current!){(data, error) in
            if let trueData = data{
                self.accelx.text = "\(trueData.acceleration.x)"
                self.accely.text = "\(trueData.acceleration.y)"
                self.accelz.text = "\(trueData.acceleration.z)"
                
                self.csvString.append("acclx \(trueData.acceleration.x), accly \(trueData.acceleration.y), acclz \(trueData.acceleration.z), " )
                
            }
        }
    }
    func uploadData(fileContents: String) {
            // Prepare the URL and request
            let url = URL(string: "http://192.168.1.25:6000/upload")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            // Convert the file contents to JSON data
            let json: [String: Any] = ["fileContents": fileContents]
            let jsonData = try? JSONSerialization.data(withJSONObject: json)
           
            // Create a URLSession data task to send the request
            let task = URLSession.shared.uploadTask(with: request, from: jsonData) { data, response, error in
                if let error = error {
                    print("Error: \(error)")
                } else {
                    print("Success!")
                }
            }
            task.resume()
        }


}

