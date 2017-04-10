//
//  HBEmitterButton.swift
//  HBPraiseAnimation
//
//  Created by apple on 2017/4/9.
//  Copyright © 2017年 apple. All rights reserved.
//

import UIKit

extension UIImage{
    func clips() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let path = UIBezierPath(ovalIn: CGRect.init(x: 0, y: 0, width: size.width, height: size.height))
        path.addClip()
        draw(in: CGRect.init(x: 0, y: 0, width: size.width, height: size.height))
        let clipsImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return clipsImage
    }
}

class HBEmitterButton: UIButton {
    
    var blingImage: UIImage?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    fileprivate func setup(){
        
        addTarget(self, action: #selector(HBEmitterButton.buttonClick), for: .touchUpInside)
        
    }
    // TODO: - Events
    @objc fileprivate func buttonClick(){
        let blingImage = self.blingImage?.clips() ?? (imageView?.image?.clips() ?? #imageLiteral(resourceName: "paopao0"))
        let blingImageView = UIImageView(image: blingImage)
        blingImageView.bounds = CGRect(x: 0, y: 0, width: 15, height: 15)
        blingImageView.center = CGPoint.init(x: bounds.width/2, y: 0)
        addSubview(blingImageView)
        
        let upDuration = 0.2
        UIView.animate(withDuration: upDuration, delay: 0, options: .curveLinear, animations: {
            blingImageView.center = CGPoint.init(x: self.bounds.width/2 + CGFloat(arc4random_uniform(80))-40, y: self.bounds.size.height/2 - 120)
            
        }) { (_) in
            UIView.animate(withDuration: upDuration, delay: 0, options: .curveLinear, animations: {
                
                blingImageView.transform = CGAffineTransform(scaleX: 2, y: 2)
                //插入发光动画
                self.blingBling(view: blingImageView)
            }, completion: { (_) in
               blingImageView.removeFromSuperview()
                self.bubbleAnimation(start: CGPoint.init(x: blingImageView.center.x, y: blingImageView.center.y), isAuto: false)
            })
        }
        
    }
    
    fileprivate func startAutoAnimatiing(){
        self.bubbleAnimation(start: CGPoint(x: bounds.width/2, y: 0), isAuto: true)
    }
    // MARK: - Animations
    
    /// blingbling 发光动画
    ///
    /// - Parameter view: 发光的view
    fileprivate func blingBling(view: UIView){
        let anim = CABasicAnimation(keyPath: "strokeStart")
        anim.fromValue = 0.5
        anim.toValue = 1
        anim.beginTime = CACurrentMediaTime()
        anim.repeatCount = 1
        anim.duration = 0.2
        anim.fillMode = kCAFillModeForwards
        anim.isRemovedOnCompletion = true
        
        let count = 12
        for i in 0..<count {
            let path = CGMutablePath()
            /*
             x1=x+s·cosθ
             y1=y+s·sinθ
             */
            path.move(to: CGPoint(x: view.bounds.midX, y: view.bounds.midY))
            path.addLine(to: CGPoint(x: Double(view.bounds.width/2)+20*cos(2*M_PI*Double(i)/Double(count)), y: Double(view.bounds.width/2)+20*sin(2*M_PI*Double(i)/Double(count))))
            
            let trackLayer = CAShapeLayer()
            trackLayer.strokeColor = UIColor.orange.cgColor
            trackLayer.lineWidth = 1
            trackLayer.path = path
            trackLayer.fillColor = UIColor.clear.cgColor
            trackLayer.strokeStart = 1
            view.layer.addSublayer(trackLayer)
            trackLayer.add(anim, forKey: nil)
        }
    }
    /// 上升动画
    ///
    /// - Parameters:
    ///   - start: 起点
    ///   - isAuto:
    fileprivate func bubbleAnimation(start: CGPoint,isAuto: Bool){
        let path = UIBezierPath()
        path.move(to: start)
        let endPointX: CGFloat = bounds.width/2+CGFloat(arc4random_uniform(80))-40
        let endPointY: CGFloat = -400
        let endPoint = CGPoint(x: endPointX, y: endPointY)
        if isAuto {
            path.addCurve(to: endPoint, controlPoint1: CGPoint.init(x: CGFloat(arc4random_uniform(80))-40, y: endPointY/3.0), controlPoint2: CGPoint.init(x: 0, y: endPointY*2/3.0))
        }else{
            path.addCurve(to: endPoint, controlPoint1: CGPoint.init(x: start.x, y: endPointY/3.0), controlPoint2: CGPoint.init(x: 0, y: endPointY*2/3.0))
        }
        
        let bubble = UIImageView(image: UIImage(named: "paopao\(arc4random_uniform(3))"))
        bubble.bounds = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        if isAuto {
            bubble.bounds = CGRect(x: 0, y: 0, width: 5, height: 5)
            UIView.animate(withDuration: 0.1, animations: {
                bubble.transform = CGAffineTransform(scaleX: 6, y: 6)
            }, completion: { (_) in
                
            })
        }
        
        let anim = CAKeyframeAnimation(keyPath: "position")
        anim.path = path.cgPath
        anim.duration = 2
        anim.repeatCount = 1
        anim.timingFunctions = [CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)]
        anim.isRemovedOnCompletion = true
        bubble.layer.add(anim, forKey: nil)
        layer.addSublayer(bubble.layer)
        
        UIView.animate(withDuration: 1, delay: 1, options: .curveLinear, animations: {
            bubble.alpha = 0
        }) { (finished) in
            if finished {
            bubble.removeFromSuperview()
            }
        }
    }
}

// MARK: - Public
extension HBEmitterButton{
    func emit(count: uint) {
        if count<=0 {
            return
        }
        var bubbleCount = count
        let interval = Double(arc4random_uniform(3)+1)/15
        
        Timer.scheduledTimer(withTimeInterval: TimeInterval(interval), repeats: true){
        (timer) in
            self.startAutoAnimatiing()
        bubbleCount = bubbleCount - 1
            if bubbleCount == 0 {
            timer.invalidate()
            }
            
        }
        
        
    }



}





















