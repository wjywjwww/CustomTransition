//
//  ViewController.swift
//  自定义转场
//
//  Created by sks on 17/5/11.
//  Copyright © 2017年 besttone. All rights reserved.
//

import UIKit

class ViewController: UIViewController,JYPresentedControllerDelegate {
   
    var interactivePush : JYInteractiveTransition = JYInteractiveTransition(type: JYInteractiveTransitionType.present, direction: JYInteractiveTransitionGestureDirection.top)
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        interactivePush.presentConifg = { [weak self] in
            self?.presentToTwoVC()
        }
        interactivePush.addPanGenture(for: self)
    }
    @IBAction func sender(_ sender: UIButton) {
        present(TwoVC(), animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func interactiveTransitionForPresent() -> JYInteractiveTransition {
        return interactivePush
    }
    
    func presentToTwoVC(){
        let twoVC = TwoVC()
        twoVC.delegate = self
        present(twoVC, animated: true, completion: nil)
    }
    
}
class OneVC: UIViewController {
    var some : UILabel?
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.white
    }
    
}

protocol JYPresentedControllerDelegate {
    func interactiveTransitionForPresent() -> JYInteractiveTransition
}

class TwoVC: UIViewController,UIViewControllerTransitioningDelegate {
    var interactiveDismiss : JYInteractiveTransition = JYInteractiveTransition(type: JYInteractiveTransitionType.dismiss, direction: JYInteractiveTransitionGestureDirection.bottom)
    var delegate : JYPresentedControllerDelegate!
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.yellow
        self.transitioningDelegate = self
        self.modalPresentationStyle = UIModalPresentationStyle.custom
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0))
        self.view.addSubview(btn)
        btn.addTarget(self, action: #selector(TwoVC.click(sender:)), for: UIControlEvents.touchUpInside)
        interactiveDismiss.addPanGenture(for: self)
    }
    func click(sender : Any){
        dismiss(animated: true, completion: nil)
    }
    //关于presesnt 和 dismiss的动画处理
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return JYPresentOneTransition.transition(withTransiontionType: JYPresentOneTransitionType.dismiss)
    }
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return JYPresentOneTransition.transition(withTransiontionType: JYPresentOneTransitionType.present)
    }
    //关于手势处理的两个代理方法
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveDismiss.interation ? interactiveDismiss : nil
    }
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return delegate != nil ? delegate.interactiveTransitionForPresent() : nil
    }
}




