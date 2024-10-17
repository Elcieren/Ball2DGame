//
//  GameScene.swift
//  Project11
//
//  Created by Eren Elçi on 16.10.2024.
//

import SpriteKit


class GameScene: SKScene , SKPhysicsContactDelegate {
    var box: SKSpriteNode!
    
    
    var ScoreLabel: SKLabelNode!
    
    var score = 0 {
        didSet {
            ScoreLabel.text = "Score \(score)"
        }
    }
    
    var editLabel: SKLabelNode!
    
    var editingMode: Bool = false {
        didSet {
            if editingMode {
                editLabel.text = "Done"
            } else {
                editLabel.text = "Edit"
            }
        }
    }
    
    override func didMove(to view: SKView) {
        
       
        
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        
        //Bu, sahnenin etrafında görünmez sınırlar oluşturur
        physicsBody = SKPhysicsBody(edgeLoopFrom:  frame)
        // burada carpisma olayini aktiflestirdik
        physicsWorld.contactDelegate = self
        
        ScoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        ScoreLabel.fontSize = 32
        ScoreLabel.text = "Score: 0"
        ScoreLabel.horizontalAlignmentMode = .right
        ScoreLabel.position = CGPoint(x:980, y: 700)
        addChild(ScoreLabel)
        
        
        editLabel = SKLabelNode(fontNamed: "Chalkduster")
        editLabel.text = "Edit"
        editLabel.position = CGPoint(x: 80, y: 700)
        addChild(editLabel)
        
        
        makeBouncer(at: CGPoint(x: 0, y: 0))
        makeBouncer(at: CGPoint(x: 256, y: 0))
        makeBouncer(at: CGPoint(x: 512, y: 0))
        makeBouncer(at: CGPoint(x: 768, y: 0))
        makeBouncer(at: CGPoint(x: 1024, y: 0))
        
        makeSlot(at: CGPoint(x: 128, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 384, y: 0), isGood: false)
        makeSlot(at: CGPoint(x: 640, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 896, y: 0), isGood: false)

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        if location.y < self.size.height / 2 {
                return // Eğer dokunma ekranın alt yarısında ise hiçbir şey yapma
            }
        let object = nodes(at: location)
        
        if object.contains(editLabel) {
            editingMode.toggle()
        } else {
            
            if editingMode {
                let size = CGSize(width: Int.random(in: 16...128), height: 16)
                box = SKSpriteNode(color: UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1), size: size)
                box.zRotation = CGFloat.random(in: 0...3)
                box.position = location

                box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
                box.physicsBody?.isDynamic = false

                addChild(box)
            } else {
                let balls = ["ballRed" , "ballBlue" ,"ballCyan" , "ballGreen", "ballGrey", "ballPurple", "ballYellow"]
                let random = Int.random(in: 0...6)
                
                let ball = SKSpriteNode(imageNamed: balls[random])
                ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
                //Bu özellik, fizik cisminin başka bir nesneden sıçradığında ne kadar enerji kaybettiğini belirlemek için kullanılır
                ball.physicsBody?.restitution = 0.6
                ball.physicsBody?.contactTestBitMask = ball.physicsBody!.collisionBitMask ?? 00
                ball.position = location
                ball.name = "ball"
                addChild(ball)
            }
            
        }
        
        
        
        
        
        
        
    }
    
    func makeBouncer(at position: CGPoint){
        //görüntü veya karakteri temsil eden nesne oluşturur
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        // nesnesinin ekranda (sahne üzerinde) konumunu belirler.
        bouncer.position = position
        bouncer.name = "bouncer"
        // nesnesine fiziksel bir beden (physics body) ekler, böylece fizik motoruyla etkileşime girebilir
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius:  bouncer.size.width / 2)
        // nesnesinin dinamik (hareket eden) olup olmadığını belirler.
        bouncer.physicsBody?.isDynamic = false
        //nesnesini mevcut sahneye ekler.
        addChild(bouncer)
    }
    
    func makeSlot(at position: CGPoint , isGood: Bool) {
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode
        
        if isGood {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            slotBase.name = "good"
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name = "bad"
        }
        slotBase.position = position
        slotGlow.position = position
        
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody?.isDynamic = false
        
        addChild(slotBase)
        addChild(slotGlow)
        
        let spin = SKAction.rotate(byAngle: .pi, duration: 10)
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)
    }
    
    func collection(between ball: SKNode , object: SKNode){
        if object.name == "good" {
            destroy(ball: ball)
            score += 1
            ScoreLabel.text = "Score:\(score)"
        } else if object.name == "bad" {
            destroy(ball: ball)
            score -= 1
            ScoreLabel.text = "Score:\(score)"
        }
    }
    
    func destroy(ball: SKNode) {
        if let fireParticles = SKEmitterNode(fileNamed: "FireParticles") {
            fireParticles.position = ball.position
            addChild(fireParticles)
        }

        ball.removeFromParent()
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        if nodeA.name == "ball" {
            collection(between: nodeA, object: nodeB)
        } else if nodeB.name  == "ball" {
            collection(between: nodeB, object: nodeA)
        }
    }
    
}
