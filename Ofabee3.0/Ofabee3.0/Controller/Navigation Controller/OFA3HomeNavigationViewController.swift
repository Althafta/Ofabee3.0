//
//  OFA3HomeNavigationViewController.swift
//  TestApp
//
//  Created by Enfin on 26/06/19.
//  Copyright © 2019 Administrator. All rights reserved.
//

import UIKit
import BubbleTransition

class OFA3HomeNavigationViewController: UINavigationController, UIViewControllerTransitioningDelegate {

    let transition = BubbleTransition()
    let interactiveTransition = BubbleInteractiveTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        interactiveTransition.interactionThreshold = 0.5
        interactiveTransition.swipeDirection = .up
        NotificationCenter.default.addObserver(self, selector: #selector(self.toggleLeftMenu), name: NSNotification.Name.init("LeftSideClick"), object: nil)
    }
    
    @objc func toggleLeftMenu(){
        //        panel?.openLeft(animated: true)
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "BubbleTVC") as! OFA3LeftSideBubbleTableViewController 
        controller.transitioningDelegate = self
        controller.modalPresentationStyle = .custom
        controller.interactiveTransition = interactiveTransition
        present(controller, animated: true, completion: nil)
        interactiveTransition.attach(to: controller)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? OFA3LeftSideBubbleTableViewController {
            controller.transitioningDelegate = self
            controller.modalPresentationStyle = .custom
            controller.interactiveTransition = interactiveTransition
            interactiveTransition.attach(to: controller)
        }
    }
    
    // MARK: UIViewControllerTransitioningDelegate
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = CGPoint.zero
        transition.bubbleColor = UIColor.clear//transitionButton.backgroundColor!
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = CGPoint.zero
        transition.bubbleColor = UIColor.clear//transitionButton.backgroundColor!
        return transition
    }
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransition
    }
}
