import UIKit
import PlaygroundSupport

let view = UIView(frame: .init(x: 0, y: 0, width: 100, height: 100))

let bigCircleLayer = CAShapeLayer()
let bigCircle = UIBezierPath()
bigCircle.addArc(withCenter: CGPoint(x: 50, y: 50), radius: 30, startAngle: 0, endAngle: CGFloat.pi * 2.0, clockwise: true)
bigCircleLayer.fillColor = UIColor.init(red: 0.8, green: 1.0, blue: 1.0, alpha: 1.0).cgColor
bigCircleLayer.lineWidth = 1
bigCircleLayer.path = bigCircle.cgPath
bigCircleLayer.zPosition = 1
view.layer.addSublayer(bigCircleLayer)

let smallCircleLayer = CAShapeLayer()
let smallCircle = UIBezierPath()
smallCircle.addArc(withCenter: CGPoint(x: 50, y: 50), radius: 25, startAngle: 0, endAngle:CGFloat.pi * 2.0, clockwise: true)
smallCircleLayer.fillColor = UIColor.init(red: /*0.0/255.0*/ 0.9, green: 1.0, blue: 1.0, alpha: 1.0).cgColor
smallCircleLayer.lineWidth = 2
smallCircleLayer.path = smallCircle.cgPath
smallCircleLayer.zPosition = 2
view.layer.addSublayer(smallCircleLayer)

PlaygroundPage.current.liveView = view
