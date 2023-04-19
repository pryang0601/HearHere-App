//
//  ViewController.swift
//  bluetooth
//
//  Created by pryang on 2022/12/4.
//

import UIKit
import Combine
import AVFoundation
import AudioToolbox
class ViewController: UIViewController {
    
    struct SoundData: Codable {
        var sounds: [String: Float]
        var mic: Int
    }
    let timer = Timer.publish(every:0.5,on:.main,in:.common).autoconnect()
    @IBOutlet weak var InfoButton: CustomizedButton!
    @IBOutlet weak var sound1: UILabel!
    @IBOutlet weak var sound2: UILabel!
    @IBOutlet weak var sound3: UILabel!
    @IBOutlet weak var sound4: UILabel!
    @IBOutlet weak var sound5: UILabel!
    @IBOutlet weak var progress1: UIProgressView!
    @IBOutlet weak var progress2: UIProgressView!
    @IBOutlet weak var progress3: UIProgressView!
    @IBOutlet weak var progress4: UIProgressView!
    @IBOutlet weak var progress5: UIProgressView!
    
    @IBOutlet weak var arrow: UIImageView!
    @IBAction func showInformation(_ sender: CustomizedButton) {
        let alertController = UIAlertController(title: "Information", message: "", preferredStyle: UIAlertController.Style.alert)
        let heightcon:NSLayoutConstraint = NSLayoutConstraint(item: alertController.view!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 365)
        alertController.view.addConstraint(heightcon)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        let imageView = UIImageView(frame: CGRect(x:2,y:50,width: 265,height: 265))
        imageView.image=UIImage(named: "InfoImage.jpg")
        alertController.view.addSubview(imageView)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }

    func playAlertSound(multiply: Int) {
        let vibrate = SystemSoundID(kSystemSoundID_Vibrate)
        let repeatTime = 0.1
        AudioServicesPlaySystemSoundWithCompletion(vibrate){
            DispatchQueue.main.asyncAfter(deadline: .now() + repeatTime*Double(multiply)) {
                AudioServicesDisposeSystemSoundID(vibrate)
            }
        }
    }

    @objc func printSound(){
        let url=URL(string: "http://172.20.10.7/sounds.json")!
        var sounds=[String]()
        var possibilites=[Double]()
        var Vibrate = [Int]()
        var mic = Int()
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                if let jsonDict = jsonObject as? [String: Any]  {
                    mic = jsonDict["mic"] as! Int
                    let jsonsounds = jsonDict["sounds"] as! [[String: Any]]
                    for sound in jsonsounds {
                        print(sound)
                        let name = sound["name"] as! String
                        let precision = Double(sound["precision"] as! Substring) ?? 0.0//as! Double
                        let alert = sound["alert"] as! Int
                        // Do something with the parsed data
                        sounds.append(name)
                        possibilites.append(precision)
                        Vibrate.append(alert)
                        print("Name: \(name), Precision: \(precision), Alert: \(alert)")
                    }
                }
            } catch {
                print("Error parsing JSON: \(error)")
            }

            
            let arrLabel:[UILabel]=[self.sound1,self.sound2,self.sound3,self.sound4,self.sound5]
            let arrProgress:[UIProgressView]=[self.progress1,self.progress2,self.progress3,self.progress4,self.progress5]

            DispatchQueue.main.async {
//                print(type(of: sounds[0]))
                if sounds[0] != "Silence"{
                    switch mic {
                    case 1:
                        self.arrow.image=UIImage(named: "leftfront.png")
                    case 2:
                        self.arrow.image=UIImage(named: "rightfront.png")
                    case 3:
                        self.arrow.image=UIImage(named: "right.png")
                    case 4:
                        self.arrow.image=UIImage(named: "rightback.png")
                    case 5:
                        self.arrow.image=UIImage(named: "leftback.png")
                    case 6:
                        self.arrow.image=UIImage(named: "left.png")
                    default: break
                    }

                }
                for l in arrLabel{
                    l.isHidden=false
                }
                for p in arrProgress{
                    p.isHidden=false
                }
                for idx in 0...4{
                    arrLabel[idx].text=sounds[idx]
                    arrProgress[idx].progress=Float(possibilites[idx])
                }
                let threshold=0.03
                for idx in 0...4{
                    if(Double(possibilites[idx])<threshold){
                        arrLabel[idx].isHidden=true
                        arrProgress[idx].isHidden=true
                    }
                    else{
                        if(Vibrate[idx] != 0){
//                            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        //AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) { }
                            switch Vibrate[idx] {
                            case 1:
                                arrProgress[idx].tintColor=UIColor(red: 1, green: 0.87, blue: 0.34, alpha: 1)

                            case 2:
                                arrProgress[idx].tintColor=UIColor(red: 1, green: 0.54, blue: 0.36, alpha: 1)

                            case 3:
                                arrProgress[idx].tintColor=UIColor(red: 1, green: 0.22, blue: 0.38, alpha: 1)
                            default: break
                            }
                            let large=Vibrate.max()
                            switch large{
                            case 1:
                                self.playAlertSound(multiply:1)
                            case 2:
                                self.playAlertSound(multiply:5)
                            case 3:
                                self.playAlertSound(multiply:10)
                            default:
                                break
                            }
                        }
                        else{
                            arrProgress[idx].tintColor=UIColor(red: 0.0, green: 0.82, blue: 0.7, alpha: 1)
                        }
                    }
                }
            }
        }
        task.resume()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(printSound), userInfo: nil, repeats: true)
        
    }
    
}
