//Created by IPH Technologies Pvt. Ltd.

import UIKit
import AVFoundation

class CasinoViewController: UIViewController {
    
    //MARK: IBoutlets
    @IBOutlet weak var backImageView: UIView!
    @IBOutlet weak var casinoImageView: UIImageView!
    @IBOutlet weak var sectorLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    
    
    
    //MARK: Properties
    var audioPlayer: AVAudioPlayer?
    var isAnimating = false
    var spinDegrees = 0.0
    var random = 0.0
    var newAngle = 0.0
    let halfSector = 360.0 / 37.0 / 2.0
    var rotationSpeed: CGFloat = 0.0
    var initialTouchPoint: CGPoint?
    var panBeginTimestamp: CFTimeInterval = 0.0
    let spinAnimationKey = "spinAnimation"
    
     
    let sectors: [Sector] = [Sector(number: 32, color: .red),
                             Sector(number: 15, color: .black),
                             Sector(number: 19, color: .red),
                             Sector(number: 4, color: .black),
                             Sector(number: 21, color: .red),
                             Sector(number: 2, color: .black),
                             Sector(number: 25, color: .red),
                             Sector(number: 17, color: .black),
                             Sector(number: 34, color: .red),
                             Sector(number: 6, color: .black),
                             Sector(number: 27, color: .red),
                             Sector(number: 13, color: .black),
                             Sector(number: 36, color: .red),
                             Sector(number: 11, color: .black),
                             Sector(number: 30, color: .red),
                             Sector(number: 8, color: .black),
                             Sector(number: 23, color: .red),
                             Sector(number: 10, color: .black),
                             Sector(number: 5, color: .red),
                             Sector(number: 24, color: .black),
                             Sector(number: 16, color: .red),
                             Sector(number: 33, color: .black),
                             Sector(number: 1, color: .red),
                             Sector(number: 20, color: .black),
                             Sector(number: 14, color: .red),
                             Sector(number: 31, color: .black),
                             Sector(number: 9, color: .red),
                             Sector(number: 22, color: .black),
                             Sector(number: 18, color: .red),
                             Sector(number: 29, color: .black),
                             Sector(number: 7, color: .red),
                             Sector(number: 28, color: .black),
                             Sector(number: 12, color: .red),
                             Sector(number: 35, color: .black),
                             Sector(number: 3, color: .red),
                             Sector(number: 26, color: .black),
                             Sector(number: 0, color: .green)]
    
    
    //MARK: Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        casinoImageView.addGestureRecognizer(panGesture)
        casinoImageView.isUserInteractionEnabled = true
        
        audioSound()
        
    }
    
    
    //MARK: handlePanGesture
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translation(in: self.view)
        
        isAnimating = true
        
        if translation.x > 0 {
            random = Double.random(in: 1...179)
        } else if translation.x < 0 {
            random = Double.random(in: 181...359)
        }
        
        spinDegrees += random
        print("spinDegree = ", spinDegrees)
        newAngle = getAngle(angle: spinDegrees)
        print("newAngle = ", newAngle)
        
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.playRotationSound()
            self.casinoImageView.transform = CGAffineTransform(rotationAngle: CGFloat(self.spinDegrees.degreesToRadians))
        }) { (_) in
            let sectorText = self.sectorFromAngle(angle: self.newAngle)
            self.sectorLabel.text = sectorText
            let numberLabelText = sectorText.components(separatedBy: "\n").last ?? ""
            self.numberLabel.text = "\(numberLabelText)"
            self.audioPlayer?.currentTime = 8.0
            self.stopRotationSound()
            self.isAnimating = false
        }
    }
    
    
    func getAngle(angle: Double) -> Double {
        
        let rotationTime = calculateRotationTime(duration: 0.1, angle: spinDegrees)
        print("Rotation Time: \(rotationTime) seconds")
        let deg = 360 - angle.truncatingRemainder(dividingBy: 360)
        print("degree = ", deg)
        return deg
        
    }
    
    func sectorFromAngle(angle: Double) -> String {
        
        var i = 0
        var sector: Sector = Sector(number: -1, color: .empty)
        
        while sector == Sector(number: -1, color: .empty) && i < sectors.count {
            let start: Double = halfSector * Double((i*2 + 1)) - halfSector
            let end: Double = halfSector * Double((i*2 + 3))
            
            if angle >= start && angle < end {
                sector = sectors[i]
            }
            i += 1
        }
        return "Sector\n\(sector.number) \(sector.color.rawValue)"
        
    }
    
    //MARK: Sound
    func audioSound() {
        
        guard let soundURL = Bundle.main.url(forResource: "casino", withExtension: "wav") else {
            print("Failed to find sound file")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.prepareToPlay()
        } catch {
            print("Failed to create audio player: \(error)")
        }
        
    }
    
    
    func playRotationSound() {
        
        audioPlayer?.stop()
        audioPlayer?.currentTime = 1.0
        audioPlayer?.play()
        
    }
    
    
    func stopRotationSound() {
        audioPlayer?.stop()
    }
    
    func calculateRotationTime(duration: TimeInterval, angle: CGFloat) -> TimeInterval {
        
        let rotationTime = (duration * abs(angle)) / (2 * .pi)
        return rotationTime
        
    }
}



//MARK: Extension
extension Double {
    var degreesToRadians: Double { return self * .pi / 180 }
}

extension CasinoViewController: CAAnimationDelegate {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            spinDegrees += 360.0
            casinoImageView.transform = CGAffineTransform(rotationAngle: spinDegrees * CGFloat.pi / 180.0)
            
        }
    }
    
}











