//
//  PasswordCell.swift
//  PasswordKeeper
//
//  Created by Tyler Rockwood on 3/6/16.
//  Copyright © 2016 Rose-Hulman. All rights reserved.
//

import UIKit
import FoldingCell
import Material


class PasswordCell: FoldingCell {
    
    var cornerRadius: CGFloat = 8
    
    typealias ButtonHandler = (Password) -> Void
    
    var editPasswordHandler: ButtonHandler?
    var deletePasswordHandler: ButtonHandler?
    
    @IBOutlet var lockImageViews: [UIImageView]!
    @IBOutlet weak var themeColorView: UIView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet var serviceLabels: [UILabel]!
    
    @IBOutlet weak var buttonContainer: UIView!
    @IBOutlet weak var editButton: FlatButton!
    @IBOutlet weak var deleteButton: FlatButton!
    
    var password : Password?
    
    @IBAction func onEditPassword(sender: AnyObject) {
        editPasswordHandler?(password!)
    }
    
    @IBAction func onDeletePassword(sender: AnyObject) {
        deletePasswordHandler?(password!)
    }
    
    
    override func awakeFromNib() {
        for view in [foregroundView, containerView] {
            view.layer.cornerRadius = cornerRadius
            view.layer.masksToBounds = true
        }
        
        for serviceName in serviceLabels {
            serviceName.font = RobotoFont.boldWithSize(24)
        }
        
        let randomColor = ["cyan", "red", "green", "orange", "pink", "purple"].sample()
        
        var themeColor : UIColor = MaterialColor.grey.lighten3
        switch (randomColor) {
            case "cyan": themeColor = MaterialColor.cyan.lighten3
            case "red": themeColor = MaterialColor.red.lighten3
            case "green": themeColor = MaterialColor.green.lighten3
            case "orange": themeColor = MaterialColor.orange.lighten3
            case "pink": themeColor = MaterialColor.pink.lighten3
            case "purple": themeColor = MaterialColor.purple.lighten3
            default: break
        }
        backViewColor = themeColor
        
        switch (randomColor) {
            case "cyan": themeColor = MaterialColor.cyan.base
            case "red": themeColor = MaterialColor.red.base
            case "green": themeColor = MaterialColor.green.base
            case "orange": themeColor = MaterialColor.orange.base
            case "pink": themeColor = MaterialColor.pink.base
            case "purple": themeColor = MaterialColor.purple.base
            default: break
        }
        themeColorView.backgroundColor = themeColor
        for imageView in lockImageViews {
            imageView.image = UIImage(named: "ic_lock_\(randomColor)")
        }
        editButton.setTitle("Edit", forState: .Normal)
        deleteButton.setTitle("Delete", forState: .Normal)
        buttonContainer.tr_addUpperBorder()
        super.awakeFromNib()
    }
    
    func bindPassword(password : Password) {
        self.password = password
        for serviceName in serviceLabels {
            serviceName.text = password.service
        }
        self.usernameLabel.text = password.username
        self.passwordLabel.text = password.password
    }
    
    override func animationDuration(itemIndex:NSInteger, type:AnimationType)-> NSTimeInterval {
        let durations = [0.26, 0.2, 0.2, 0.2, 0.2]
        return durations[itemIndex]
    }
    
}

extension UIView {
    func tr_addUpperBorder() {
        let upperBorder = CALayer(layer: layer)
        upperBorder.backgroundColor = MaterialColor.grey.lighten4.CGColor
        upperBorder.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), 1.0)
        layer.addSublayer(upperBorder)
    }
}

extension Array {
    func sample() -> Element {
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}