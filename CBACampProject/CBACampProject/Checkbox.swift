//
//  Checkbox.swift
//  CBACampProject
//
//  Created by JUDY on 2019. 5. 27..
//  Copyright © 2019년 mac. All rights reserved.
//

import UIKit

class Checkbox: UIButton{
    let CheckBoxImage = UIImage(named : "환언포스터.jpeg") as! UIImage
    let unCheckBoxImage = UIImage(named : "환언포스터.jpeg") as! UIImage
    
    var isChecked: Bool = false {
        didSet{
            if isChecked == true{
                self.setImage(CheckBoxImage, for: .normal)
            } else{
                self.setImage(unCheckBoxImage, for: .normal)
            }
        }
    }
    
    override func awakeFromNib(){
        //self.addTarget(self, action: "buttonClicked:", forControlEvent: UIControlEvents.touchUpInside)
        self.isChecked = false
    }
    
    func buttonClicked(sender:UIButton){
        if(sender == self){
            //if()
        }
    }
}
