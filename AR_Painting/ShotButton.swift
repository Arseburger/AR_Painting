//
//  ShotButton.swift
//  AR_Painting
//
//  Created by Александр Королёв on 23.04.2020.
//  Copyright © 2020 Александр Королёв. All rights reserved.
//

import UIKit

class ShotButton: UIButton {

  func configureButton() {
    
    let circleLayer = CAShapeLayer()
    let circle = UIBezierPath()
    circle.addArc(withCenter: CGPoint(x: 0, y: 0), radius: 0, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
    
  }
  
  
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
