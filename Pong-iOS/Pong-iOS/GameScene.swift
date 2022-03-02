//
//  GameScene.swift
//  Pong-iOS
//
//  Created by Daniel Kwolek on 2/28/22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    private var leftPaddle : SKShapeNode?
    private var rightPaddle : SKShapeNode?
    
    override func didMove(to view: SKView) {
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        self.leftPaddle = self.childNode(withName: "//leftPaddle") as? SKShapeNode
        if let leftPaddle = self.leftPaddle {
            leftPaddle.fillColor = UIColor.blue
            leftPaddle.physicsBody = SKPhysicsBody.init(rectangleOf: leftPaddle.frame.size)
            leftPaddle.physicsBody?.affectedByGravity = false
            leftPaddle.physicsBody?.allowsRotation = false
            leftPaddle.physicsBody?.isDynamic = false
        }
        
        self.rightPaddle = self.childNode(withName: "//rightPaddle") as? SKShapeNode
        if let rightPaddle = rightPaddle {
            rightPaddle.fillColor = UIColor.red
            rightPaddle.physicsBody = SKPhysicsBody.init(rectangleOf: rightPaddle.frame.size)
            rightPaddle.physicsBody?.affectedByGravity = false
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
    }
    
    func spawnBall() {
        let node = SKShapeNode(circleOfRadius: 20)
        self.addChild(node)
        node.physicsBody = SKPhysicsBody(circleOfRadius: 20)
        node.physicsBody?.affectedByGravity = false
        node.physicsBody?.applyForce(CGVector.init(dx: 50, dy: 800))
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
        self.leftPaddle?.position.x = pos.x
        spawnBall()
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
        self.leftPaddle?.position.x = pos.x
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
