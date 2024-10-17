## Pinball Slot Adventure Oyun ici Video
![Ekran-Kaydı-2024-10-18-00 54 47](https://github.com/user-attachments/assets/a15a9304-1a02-4c42-8b9e-e244dab1e767
<details>
    <summary><h2>Uygulma Amacı</h2></summary>
  Projenin amacı, ekrandaki çeşitli nesnelerle etkileşime giren topların oluşturulduğu bir fizik tabanlı oyun ortamı yaratmak
  </details> 


  <details>
    <summary><h2>Sınıf Tanımı ve Temel Değişkenler</h2></summary>
    GameScene sınıfı bir oyun sahnesini tanımlar. SKScene, SpriteKit sahneleri için kullanılan bir sınıftır, fiziksel etkileşimleri işlemek için ise SKPhysicsContactDelegate protokolü kullanılır.
    box, sahneye eklenen kutu objesidir.
    ScoreLabel, skoru ekranda görüntüler ve score değişkeni her güncellendiğinde etiketin metni değişir.
    editingMode, düzenleme modunu belirler. Bu mod aktifken "Done", pasifken "Edit" olarak görüntülenir.

    
    ```
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
    }



    ```
  </details> 




<details>
    <summary><h2>Sahnenin Ayarları ve Arka Plan</h2></summary>
    didMove metodu, sahneye geçildiğinde çalışır.
     Bir arka plan görüntüsü eklenir ve SKPhysicsBody(edgeLoopFrom:) ile görünmez sınırlar oluşturulur, böylece topların sahneden dışarı çıkması engellenir.
     Skor ve düzenleme etiketleri (ScoreLabel ve editLabel) sahneye eklenir.
     makeBouncer ve makeSlot fonksiyonları, sahneye çarpan nesneleri ve slotları yerleştirir.

    
    ```
    override func didMove(to view: SKView) {
    let background = SKSpriteNode(imageNamed: "background")
    background.position = CGPoint(x: 512, y: 384)
    background.blendMode = .replace
    background.zPosition = -1
    addChild(background)

    physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
    physicsWorld.contactDelegate = self

    ScoreLabel = SKLabelNode(fontNamed: "Chalkduster")
    ScoreLabel.fontSize = 32
    ScoreLabel.text = "Score: 0"
    ScoreLabel.horizontalAlignmentMode = .right
    ScoreLabel.position = CGPoint(x: 980, y: 700)
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





    ```
  </details>
  <details>
    <summary><h2>Dokunma İşlemi - touchesBegan</h2></summary>
    touchesBegan, ekrana dokunulduğunda çalışır.
    Eğer dokunulan yer düzenleme etiketi (editLabel) ise düzenleme modu açılır veya kapatılır.
    Düzenleme modu açıksa, dokunulan yere rastgele bir kutu eklenir. Normal moddaysa, rastgele renkte bir top eklenir. Toplar fizik motoruna uygun olarak davranır.

    
    ```
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }
    let location = touch.location(in: self)
    if location.y < self.size.height / 2 {
        return
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
            let balls = ["ballRed", "ballBlue", "ballCyan", "ballGreen", "ballGrey", "ballPurple", "ballYellow"]
            let random = Int.random(in: 0...6)
            let ball = SKSpriteNode(imageNamed: balls[random])
            ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
            ball.physicsBody?.restitution = 0.6
            ball.physicsBody?.contactTestBitMask = ball.physicsBody!.collisionBitMask
            ball.position = location
            ball.name = "ball"
            addChild(ball)
        }
    }
    }




    ```
  </details> 
  <details>
    <summary><h2>Çarpan Nesneler - makeBouncer</h2></summary>
    makeBouncer metodu, ekrandaki belirli noktalara sabit çarpan nesneleri ekler. Bu nesneler toplarla çarpıştığında fiziksel olarak tepki verir.

    
    ```
    func makeBouncer(at position: CGPoint){
    let bouncer = SKSpriteNode(imageNamed: "bouncer")
    bouncer.position = position
    bouncer.name = "bouncer"
    bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2)
    bouncer.physicsBody?.isDynamic = false
    addChild(bouncer)
    }





    ```
  </details>
  <details>
    <summary><h2>Slotlar - makeSlot</h2></summary>
    makeSlot, ekrana iyi veya kötü slotları ekler. Toplar bu slotlara düştüğünde, slota göre skor artar veya azalır.
     Slotlar isGood parametresine göre "iyi" veya "kötü" olarak tanımlanır ve slotların ışığı sürekli döner.


    
    ```
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





    ```
  </details>
  <details>
    <summary><h2>Topların Çarpışması - didBegin</h2></summary>
    didBegin, topların diğer nesnelerle çarpıştığı anı algılar. Eğer çarpışan nesnelerden biri "ball" ise, topların slotlara düşüp düşmediği kontrol edilir ve skor ona göre güncellenir.

    
    ```
    func didBegin(_ contact: SKPhysicsContact) {
    guard let nodeA = contact.bodyA.node else { return }
    guard let nodeB = contact.bodyB.node else { return }
    if nodeA.name == "ball" {
        collection(between: nodeA, object: nodeB)
    } else if nodeB.name == "ball" {
        collection(between: nodeB, object: nodeA)
    }
    }





    ```

  
  
  
<details>
    <summary><h2>Uygulama Görselleri </h2></summary>
    
    
 <table style="width: 100%;">
    <tr>
        <td style="text-align: center; width: 16.67%;">
            <h4 style="font-size: 14px;">Görüntü İşleme Sonuçları 1 </h4>
            <img src="https://github.com/user-attachments/assets/73986ac5-77da-4362-8407-7161c69c01a4" style="width: 100%; height: auto;">
        </td>
      <td style="text-align: center; width: 16.67%;">
            <h4 style="font-size: 14px;">Görüntü İşleme Sonuçları 1 </h4>
            <img src="https://github.com/user-attachments/assets/7fdbf852-9056-4fb3-ae19-fe19a3b2881b" style="width: 100%; height: auto;">
        </td>
      <td style="text-align: center; width: 16.67%;">
            <h4 style="font-size: 14px;">Görüntü İşleme Sonuçları 1 </h4>
            <img src="https://github.com/user-attachments/assets/13457fe0-04ab-474b-9358-ef4a8549f317" style="width: 100%; height: auto;">
        </td>
    </tr>
</table>
  </details> 
