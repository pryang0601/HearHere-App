//
//  Sound.swift
//  bluetooth
//
//  Created by pryang on 2022/12/19.
//

import UIKit

@IBDesignable class CustomizedButton: UIButton{
    @IBInspectable var cornerRadius: CGFloat = 0.0{
        didSet{
            self.layer.cornerRadius=self.frame.height/2
            layer.masksToBounds=true
            layer.cornerCurve = .continuous
            layer.contents="jiji"
        }
    }
    
    
}
// class CustomizedButton
