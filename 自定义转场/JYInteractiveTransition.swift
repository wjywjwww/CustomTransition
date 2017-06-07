//
//  JYInteractiveTransition.swift
//  自定义转场
//
//  Created by sks on 17/5/11.
//  Copyright © 2017年 besttone. All rights reserved.
//

import UIKit

typealias GestureConifg = (()->())
enum JYInteractiveTransitionGestureDirection : NSInteger {
    case top = 0
    case left = 1
    case bottom = 2
    case right = 3
}
enum JYInteractiveTransitionType : NSInteger {
    case push = 0
    case pop = 1
    case present = 2
    case dismiss = 3
}
class JYInteractiveTransition: UIPercentDrivenInteractiveTransition {
     //记录是否开始手势，判断pop操作是手势触发还是返回键触发
    var interation:Bool = false
    //触发手势present的时候的config，config中初始化并present需要弹出的控制器
    var presentConifg : GestureConifg?
    //触发手势push的时候的config，config中初始化并push需要弹出的控制器
    var pushConifg : GestureConifg?
    /**手势方向*/
    var direction : JYInteractiveTransitionGestureDirection = JYInteractiveTransitionGestureDirection.top
    /**手势类型*/
    var type : JYInteractiveTransitionType = JYInteractiveTransitionType.push
    
    var vc : UIViewController = UIViewController()
    
    override init() {
        super.init()
    }
    
    convenience init(type : JYInteractiveTransitionType  , direction : JYInteractiveTransitionGestureDirection){
        self.init()
        self.type = type
        self.direction = direction
    }
    
    class func interactiveTransition(type : JYInteractiveTransitionType , direction : JYInteractiveTransitionGestureDirection) ->JYInteractiveTransition{
        return JYInteractiveTransition(type: type, direction: direction)
    }
    
    /** 给传入的控制器添加手势*/
    func addPanGenture(for viewController : UIViewController){
        self.vc = viewController
        let pan = UIPanGestureRecognizer(target: self, action: #selector(JYInteractiveTransition.handleGesture(sender:)))
        viewController.view.addGestureRecognizer(pan)
    }
    func handleGesture(sender : UIPanGestureRecognizer){
        var persent : CGFloat = 0.0
        var maxPresent : CGFloat = 0.0
        switch direction {
        case JYInteractiveTransitionGestureDirection.top:
            let transitionY = -sender.translation(in: sender.view).y
            persent = transitionY / sender.view!.frame.height
            break
        case JYInteractiveTransitionGestureDirection.left:
            let transitionX = -sender.translation(in: sender.view).x
            persent = transitionX / sender.view!.frame.width
            break
        case JYInteractiveTransitionGestureDirection.bottom:
            let transitionY = sender.translation(in: sender.view).y
            persent = transitionY / sender.view!.frame.height
            break
        case JYInteractiveTransitionGestureDirection.right:
            let transitionX = sender.translation(in: sender.view).x
            persent = transitionX / sender.view!.frame.width
            break
        }
        if persent > maxPresent {
            maxPresent = persent
        }
        switch sender.state {
        case UIGestureRecognizerState.began:
            self.interation = true
            self.startGesture()
            break
        case UIGestureRecognizerState.changed:
            self.update(persent)
            break
        case UIGestureRecognizerState.ended:
            self.interation = false
            if maxPresent > 0.2{
                self.finish()
            }else{
                self.cancel()
            }
        default:
            break
        }
    }
    
    func startGesture(){
        switch type {
        case JYInteractiveTransitionType.present:
            if presentConifg != nil{
                presentConifg!()
            }
            break
        case JYInteractiveTransitionType.dismiss:
            vc.dismiss(animated: true, completion: nil)
            break
        case JYInteractiveTransitionType.push:
            if pushConifg != nil{
                pushConifg!()
            }
            break
        case JYInteractiveTransitionType.pop:
            _ = vc.navigationController?.popViewController(animated: true)
            break
        }
    }
}











