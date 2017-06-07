//
//  JYPresentOneTransition.swift
//  自定义转场
//
//  Created by sks on 17/5/11.
//  Copyright © 2017年 besttone. All rights reserved.
//

import UIKit
enum JYPresentOneTransitionType : NSInteger {
    case present = 0
    case dismiss = 1
}
class JYPresentOneTransition: NSObject,UIViewControllerAnimatedTransitioning {
    var transitionType : JYPresentOneTransitionType = JYPresentOneTransitionType.present
    
    override init(){
        super.init()
    }
    
     convenience init(withType : JYPresentOneTransitionType){
        self.init()
        transitionType = withType
    }
    
    class func transition(withTransiontionType : JYPresentOneTransitionType) -> JYPresentOneTransition{
         return JYPresentOneTransition(withType: withTransiontionType)
    }
    
    // UIViewControllerAnimatedTransitioning的两个代理 处理动画事件
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch transitionType {
        case JYPresentOneTransitionType.dismiss:
            self.dismissAnimation(transitionContext: transitionContext)
            break
        case JYPresentOneTransitionType.present:
            self.presentAnimation(transitionContext: transitionContext)
            break
        }
    }
    
    func presentAnimation(transitionContext : UIViewControllerContextTransitioning){
        //首先取出两个VC
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) ?? UIViewController()
        let formVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        //截图动画
        let tempView = formVC!.view.snapshotView(afterScreenUpdates: false)
        tempView?.frame = formVC!.view.frame 
        //隐藏 Form VC
        formVC?.view.isHidden = true
        let containView = transitionContext.containerView
        containView.addSubview(tempView!)
        containView.addSubview(toVC.view)
        toVC.view.frame = CGRect(x: 0, y: containView.frame.height, width: containView.frame.width, height: 400)
        //开始动画
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 0.55, initialSpringVelocity: 1.0/0.55, options: UIViewAnimationOptions.layoutSubviews, animations: {
            //先让toVC向上移动
            toVC.view.transform = CGAffineTransform(translationX: 0, y: -200)
//            tempView?.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        }) { (finished) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            if transitionContext.transitionWasCancelled{
                formVC?.view.isHidden = false
                tempView?.removeFromSuperview()
            }
        }
     }
    func dismissAnimation(transitionContext : UIViewControllerContextTransitioning){
        let formVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) ?? UIViewController()
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) ?? UIViewController()
        let tempView = transitionContext.containerView.subviews[0]
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: { 
            formVC.view.transform = CGAffineTransform.identity
            tempView.transform = CGAffineTransform.identity
        }) { (finished) in
            if transitionContext.transitionWasCancelled{
                transitionContext.completeTransition(false)
            }else{
                transitionContext.completeTransition(true)
                toVC.view.isHidden = false
                tempView.removeFromSuperview()
            }
        }
    }
}














