//
//  ViewController.swift
//  Project6
//
//  Created by Monica Ong on 11/5/15.
//  Copyright © 2015 Monica Ong. All rights reserved.
//bullets = use timer = update y coordinates every second or smtg, kk
//UIPushBehavior -> does not accelerate, just constant velocity, like gravity

import UIKit

class ViewController: UIViewController, UICollisionBehaviorDelegate {
    
    var time: Double = 1.0
    var level: Int = 0
    @IBOutlet weak var levelLabel: UILabel!
    
    @IBOutlet weak var spaceshipView: UIImageView!
    var asteriodTimer: NSTimer!
    
    var animator: UIDynamicAnimator!
    var gravity: UIGravityBehavior = UIGravityBehavior()
    var collision: UICollisionBehavior = UICollisionBehavior()
    var oppGravity: UIPushBehavior = UIPushBehavior()
    
    @IBOutlet weak var scoreLabel: UILabel!
    var score: Int = 0
    
    @IBOutlet weak var gameOverView: UIView!
    @IBOutlet weak var finalScoreLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
        gameOverView.alpha = 0
        finalScoreLabel.text = "Score: \(score)"
        
        //set the level
        if level == 0 { //easy
            gravity.magnitude = 0.5
            time = 1.0
            levelLabel.text = "Level: Easy"
        }
        if level == 1 { //medium
            gravity.magnitude = 0.7
            time = 0.7
            levelLabel.text = "Level: Medium"
        }
        if level == 2{ //hard
            gravity.magnitude = 1
            time = 0.5
            levelLabel.text = "Level: Hard"
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        //set up spaceship
        spaceshipView.tag = 1
        
        //set up asteriods
        asteriodTimer = NSTimer.scheduledTimerWithTimeInterval(time, target: self, selector: Selector("spawnAsteriods"), userInfo: nil, repeats: true)
        
        //set up animator
        animator = UIDynamicAnimator(referenceView: view)
        
        //set up gravity
        animator.addBehavior(gravity)
        
        //set up collision
        collision.translatesReferenceBoundsIntoBoundary = true
        collision.collisionDelegate = self
        animator.addBehavior(collision)
        
        //set up spaceship behaviors
        collision.addItem(spaceshipView)
        
        //set up gravity for bullets
        animator.addBehavior(oppGravity)
        oppGravity.pushDirection = CGVector(dx: 0, dy: -1.0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func spawnAsteriods(){
        let image = UIImage(named: "Asteriod.png")
        let imageView = UIImageView(image: image!)
        imageView.tag = 2
        imageView.frame = CGRect(x: CGFloat(arc4random_uniform(UInt32(UIScreen.mainScreen().bounds.width-80))), y: 20, width: 80, height: 80)
        view.addSubview(imageView)
        gravity.addItem(imageView)
        collision.addItem(imageView)
    }
    
    @IBAction func tapSpaceship(sender: UITapGestureRecognizer) {
        let imageName = "Bullet.png"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        imageView.tag = 3
        imageView.userInteractionEnabled = true
        imageView.frame = CGRect(x: spaceshipView.center.x, y: spaceshipView.center.y - spaceshipView.frame.height, width: 50, height: 50)
        view.addSubview(imageView)
        oppGravity.addItem(imageView)
        collision.addItem(imageView)
    }
    
    @IBAction func panSpaceship(sender: UIPanGestureRecognizer) {
        let spaceshipView = sender.view!
        let trans = sender.translationInView(view)
        spaceshipView.center = CGPoint(x: spaceshipView.center.x + trans.x, y: spaceshipView.center.y + trans.y)
        sender.setTranslation(CGPointZero, inView: view)
        animator.updateItemUsingCurrentState(spaceshipView)
    }
    
    //Behavior when views collide with each other
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item1: UIDynamicItem, withItem item2: UIDynamicItem, atPoint p: CGPoint) {
        let imageView1 = item1 as! UIImageView
        let imageView2 = item2 as! UIImageView
        
        //remove asteriod if bullet (3) hits asteriod (2)
        if(imageView1.tag == 2 && imageView2.tag == 3){
            imageView1.removeFromSuperview() //asteriod
            imageView2.removeFromSuperview() //bulllet
            
            //remove asteriod
            gravity.removeItem(imageView1)
            collision.removeItem(imageView1)
            
            //remove bullet
            oppGravity.removeItem(imageView2)
            collision.removeItem(imageView2)
            
            score = score + 1;
            scoreLabel.text = "Score: \(score)"
        }
        
        if(imageView1.tag == 3 && imageView2.tag == 2){
            imageView1.removeFromSuperview() //bullet
            imageView2.removeFromSuperview() //asteriod
            
            //remove asteriod
            gravity.removeItem(imageView2)
            collision.removeItem(imageView2)
            
            //remove bullet
            oppGravity.removeItem(imageView1)
            collision.removeItem(imageView1)
            
            score = score + 1;
            scoreLabel.text = "Score: \(score)"
        }
        
        //game over if spaceship (1) hit asteriod (2)
        if(imageView1.tag == 1 && imageView2.tag == 2) || (imageView2.tag == 1 && imageView1.tag == 2){
            //remove spaceship
            if imageView1.tag == 1 {
                imageView1.removeFromSuperview()
                collision.removeItem(imageView1)
            }
            if imageView2.tag == 1 {
                imageView2.removeFromSuperview()
                collision.removeItem(imageView2)
            }
            
            for imageView in view.subviews{
                if imageView.tag == 3{
                    imageView.removeFromSuperview()
                }
            }
            
            scoreLabel.hidden = true
            levelLabel.hidden = true
            finalScoreLabel.text = "Score: \(score)"
            UIView.animateWithDuration(1.5, delay: 0, options: .CurveEaseInOut, animations:{self.gameOverView.alpha = 1.0}, completion: nil)
            scoreLabel.alpha = 1.0
            
        }
    }
    
    //Behavior when view collide with boundary
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, atPoint p: CGPoint) {
        let imageView = item as! UIImageView
        
        //if asteriod hit boundary, remove it
        if(imageView.tag == 2){
            imageView.removeFromSuperview()
            gravity.removeItem(imageView)
            collision.removeItem(imageView)
            score = score + 1;
            scoreLabel.text = "Score: \(score)"
        }
        
        //if bullet hit boundary, remove it
        if(imageView.tag == 3){
            imageView.removeFromSuperview()
            oppGravity.removeItem(imageView)
            collision.removeItem(imageView)
        }
        
    }
    
}

