//
//  ViewController.swift
//  BullsEye
//
//  Created by Denis Malyavin on 12.05.2022.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var slider: UISlider!
    @IBOutlet var targetLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var roundLabel: UILabel!
    
    var _targetValue = 0
    var _currentValue = 0
    var _score = 0
    var _round = 1
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ViewController.lockOrientation(.portrait)
        // Or to rotate and lock
        // AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Don't forget to reset when view is being removed
        AppUtility.lockOrientation(.all)
    }
    
    
    override func viewDidLoad() {
        
        let thumbImageNormal = UIImage(named: "SliderThumb-Normal")!
        slider.setThumbImage(thumbImageNormal, for: .normal)
        
        let thumbImageHighlighted = UIImage(
            named: "SliderThumb-Highlighted")!
        slider.setThumbImage(thumbImageHighlighted, for: .highlighted)
        
        let insets = UIEdgeInsets(
            top: 0,
            left: 14,
            bottom: 0,
            right: 14)
        
        let trackLeftImage = UIImage(named: "SliderTrackLeft")!
        let trackLeftResizable = trackLeftImage.resizableImage(
            withCapInsets: insets)
        slider.setMinimumTrackImage(trackLeftResizable, for: .normal)
        
        let trackRightImage = UIImage(named: "SliderTrackRight")!
        let trackRightResizable = trackRightImage.resizableImage(
            withCapInsets: insets)
        slider.setMaximumTrackImage(trackRightResizable, for: .normal)
        
        super.viewDidLoad()
        startNewGame()
        
    }
    
    func startNewRound() {
        _targetValue = Int.random(in: 1...100)
        _currentValue = 50
        slider.value = Float(_currentValue)
        updateLabels()
    }
    
    @IBAction func startNewGame() {
        _score = 0
        _round = 1
        startNewRound()
        
        let transition = CATransition()
        transition.type = CATransitionType.fade
        transition.duration = 1
        transition.timingFunction = CAMediaTimingFunction(
            name: CAMediaTimingFunctionName.easeOut)
        view.layer.add(transition, forKey: nil)
    }
    
    func updateLabels() {
        targetLabel.text = String(_targetValue)
        scoreLabel.text = String(_score)
        roundLabel.text = String(_round)
    }
    
    @IBAction func showAlert() {
        let difference = abs(_targetValue - _currentValue)
        var points = 100 - difference
        
        _round += 1
        
        let title: String
        if difference == 0 {
            title = "Идеально!"
            points += 100
        } else if difference < 5 {
            title = "Вы были очень близко!"
        } else if difference < 10 {
            title = "Хороший результат!"
            if difference == 1 {
                points += 50
            }
        } else {
            title = "Далековато..."
        }
        
        _score += points
        
        let message = "Вам начислены очки: +\(points)"
        
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(
            title: "Хорошо",
            style: .default) { _ in
                self.startNewRound()
            }
        
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func sliderMoved(_ slider: UISlider) {
        _currentValue = lroundf(slider.value)
    }
    
}

