//
//  ViewController.swift
//  Pi2
//
//  Created by Masaki Horimoto on 2016/02/20.
//  Copyright © 2016年 Masaki Horimoto. All rights reserved.
//

import UIKit
import SpriteKit

class ViewController: UIViewController {
    
    @IBOutlet weak var sceneView: SKView!
  
    var scene : GameScene?
    var level = 0
    
    override func viewWillAppear(animated: Bool) {
        
        scene = GameScene(size: sceneView.bounds.size, level: level)
        sceneView.presentScene(scene)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        sceneView.showsFPS = true // FPS表示
        sceneView.showsNodeCount = true //画面内要素数表示
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func pressButtonNextScene(sender: AnyObject) {
        
        //print("\(NSStringFromClass(self.classForCoder)).\(__FUNCTION__) is called!")
        
        level++
        scene = GameScene(size: sceneView.bounds.size, level: level)
        let transition : SKTransition = SKTransition.pushWithDirection(SKTransitionDirection.Left, duration: 1.0)
        sceneView.presentScene(scene!, transition: transition)
        
    }
    
    @IBAction func pressButton1(sender: AnyObject) {
        
        //print("\(NSStringFromClass(self.classForCoder)).\(__FUNCTION__) is called!")

        guard let _scene = scene else {
            fatalError("error")
        }
        
        _scene.outputPressButtonLog(1)
        
    }
    
    @IBAction func pressButton2(sender: AnyObject) {
        
        //print("\(NSStringFromClass(self.classForCoder)).\(__FUNCTION__) is called!")

        guard let _scene = scene else {
            fatalError("error")
        }
        
        _scene.outputPressButtonLog(2)
        
    }


}

