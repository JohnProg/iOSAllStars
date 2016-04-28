//
//  BarView.swift
//  SuperBars
//
//  Created by Raul Rashuaman on 4/11/16.
//  Copyright © 2016 Raul Rashuaman. All rights reserved.
//

import UIKit
import SnapKit

class BarView: UIView {
    var maxValue : UInt = 1
    var items : Array<BarElement>?
    var colors : Array<CGColor> = [UIColor.orangeColor().CGColor, UIColor.blueColor().CGColor, UIColor.redColor().CGColor]
    var viewOffset : CGFloat = 10
    var viewsHeight : CGFloat = 30
    var fontSize = UIFont.systemFontOfSize(12)
    
    func showBars() {
        guard let safeItems = items else {
            return
        }
        
        var y : CGFloat = viewsHeight / 2
        for item in safeItems {
            
            let itemView = itemBarView(item)
            itemView.frame = CGRect(x: bounds.origin.x + viewOffset, y: bounds.origin.y + y, width: bounds.width - (bounds.origin.x + viewOffset) * 2, height: bounds.height)
            addSubview(itemView)
            
            y += viewsHeight
        }
    }
    
    private func itemBarView(item : BarElement) -> UIView {
        let containerView = UIView(frame : CGRect(x: bounds.origin.x, y: bounds.origin.y, width:frame.width , height: viewsHeight) )
        let labelView = UILabel()
        labelView.text = String(format: "%@: %d", item.title!, item.value)
        labelView.font = fontSize
        containerView.addSubview(labelView)
        
        //labelView.frame = CGRect(x: containerView.frame.origin.x, y: containerView.frame.origin.y, width: 30 , height: 10)
        labelView.frame = CGRect(x: containerView.frame.origin.x, y: containerView.frame.origin.y, width: containerView.frame.width , height: 20)
        
        let barView = Bar()
        barView.offset = CGFloat(self.viewOffset)
        barView.colors = self.colors
        barView.value = item.value
        barView.maxValue = self.maxValue
        
        //        barView.frame = CGRect(x: labelView.bounds.origin.x + labelView.bounds.width + viewOffset / 2, y: containerView.bounds.height / 2.0 - containerView.bounds.origin.y - 2, width: bounds.width - labelView.bounds.origin.x - labelView.bounds.width - viewOffset * 2 , height: 2)
        
        barView.frame = CGRect(x: labelView.bounds.origin.x, y: labelView.bounds.origin.y + 10, width: containerView.frame.width , height: 2)
        
        containerView.addSubview(barView)
        
        return containerView
    }
}

class Bar : UIView {
    var value : UInt = 0
    var maxValue : UInt = 1
    var animationDuration : Double = 0.5
    var offset : CGFloat = 10
    var colors : Array<CGColor> = Array<CGColor>()
    
    override func layoutSubviews() {
        var subFrame = self.frame
        subFrame.size.width = (CGFloat(self.value) / CGFloat(self.maxValue)) * self.frame.width - offset * 2
        
        let gradient:CAGradientLayer = self.gradient(subFrame)
        layer.insertSublayer(gradient, atIndex: 0)
        self.animations(layer)
    }
    
    func gradient(frame:CGRect) -> CAGradientLayer {
        let layer = CAGradientLayer()
        layer.frame = frame
        layer.startPoint = CGPointMake(0,0.5)
        layer.endPoint = CGPointMake(1,0.5)
        
        if colors.count > 0 {
            layer.colors = colors
        }
        
        return layer
    }
    
    func animations(layer : CALayer) {
        layer.anchorPoint = CGPointMake(0, 1.0);
        let widthAnim = CABasicAnimation(keyPath: "transform.scale.x")
        widthAnim.fromValue = 0
        widthAnim.toValue = 1
        widthAnim.fillMode = kCAFillModeBoth
        widthAnim.duration = animationDuration
        layer.addAnimation(widthAnim, forKey: "transform.scale.x")
        
        // update layer's frame
        var frame = layer.frame
        frame.origin.x = self.bounds.origin.x
        frame.size.width = self.bounds.width - offset
        layer.frame = frame
    }
}

class BarElement {
    var title : String?
    var value : UInt = 0
    init (title: String?, value : UInt) {
        self.title = title
        self.value = value
    }
}
