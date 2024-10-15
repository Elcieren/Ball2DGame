//
//  GameScene.swift
//  Project11
//
//  Created by Eren Elçi on 16.10.2024.
//

import SpriteKit


class GameScene: SKScene {
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        
        //Bu, sahnenin etrafında görünmez sınırlar oluşturur
        physicsBody = SKPhysicsBody(edgeLoopFrom:  frame)
        
        makeBouncer(at: CGPoint(x: 0, y: 0))
        makeBouncer(at: CGPoint(x: 256, y: 0))
        makeBouncer(at: CGPoint(x: 512, y: 0))
        makeBouncer(at: CGPoint(x: 768, y: 0))
        makeBouncer(at: CGPoint(x: 1024, y: 0))
       

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let ball = SKSpriteNode(imageNamed: "ballRed")
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
        ball.physicsBody?.restitution = 0.6
        ball.position = location
        addChild(ball)
    }
    
    func makeBouncer(at position: CGPoint){
        //görüntü veya karakteri temsil eden nesne oluşturur
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        // nesnesinin ekranda (sahne üzerinde) konumunu belirler.
        bouncer.position = position
        // nesnesine fiziksel bir beden (physics body) ekler, böylece fizik motoruyla etkileşime girebilir
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius:  bouncer.size.width / 2)
        // nesnesinin dinamik (hareket eden) olup olmadığını belirler.
        bouncer.physicsBody?.isDynamic = false
        //nesnesini mevcut sahneye ekler.
        addChild(bouncer)
    }
    
    
}
