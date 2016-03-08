//
//  GameScene.swift
//  Pi2
//
//  Created by Masaki Horimoto on 2016/02/20.
//  Copyright © 2016年 Masaki Horimoto. All rights reserved.
//

import SpriteKit

private let sceneSize = CGSize(width: 375, height: 344)

class GameScene : SKScene {
    
    private var level: Int       //表示するlevel (本プロパティを基にfistAreaの色と記載内容を変更する)
    private var inputLabelArray: [SKLabelNode] = [SKLabelNode()]    //入力をインプットするLabel配列
    let col = 5     //生成する四角形の列の数
    let row = 2     //生成する四角形の行の数
    
    
    /**
    レベルのカテゴリー
    
    カテゴリーの数値は1の位の値を示す.
    
    backgroundImageNameでレベルによる背景画像名を取得できる.
    */
    private enum LevelCategory : Int {
        
        case Category0
        case Category1
        case Category2
        case Category3
        case Category4
        case Category5
        case Category6
        case Category7
        case Category8
        case Category9
        
        var backgroundImageName : String {
            return ["yellow", "green", "purple"][self.rawValue % 3] + ".png"
        }
    }

    /**
     firstAreaとsecondAreaの表示サイズと座標と背景画像名を定義した列挙型
    */
    private enum displayArea {
        
        case first
        case second
        
        /**
         Sceneのサイズに従いfirstAreaとsecondAreaの表示サイズを返す
         
         - parameter size: Sceneのサイズ
         - returns: .first, .secondの指定に従い適した各Areaにサイズを返す
        */
        func calcSize(size: CGSize) -> CGSize {
            switch self {
            case .first:
                return CGSizeMake(size.width, size.height / 2)
            case .second:
                return CGSizeMake(size.width, size.height / 2)
            }
        }
        
        /**
         引数のSceneのサイズに従いfirstAreaとsecondAreaの表示座標を返す
         
         - parameter size: Sceneのサイズ
         - returns: .first, .secondの指定に従い適した各Areaの表示座標を返す
         */
        func calcPosition(size: CGSize) -> CGPoint {
            
            switch self {
            case .first:
                return CGPointMake(size.width / 2, size.height / 4 * 3)
            case .second:
                return CGPointMake(size.width / 2, size.height / 4)
            }
            
        }

        /**
         引数のlevelに従いfirstAreaとsecondAreaの背景画像名を返す

         - parameter level: 表示中のゲームレベル
         - returns: .first, .secondの指定に従い適した各Areaの背景画像名を返す
        */
        func getBackgroundImageNamed(level: Int) -> String {
            
            switch self {
            case .first:
                guard let level_ = LevelCategory(rawValue: level % 10) else {
                    print("\(__FILE__)(\(__LINE__)):Error! LevelCategory is nothing!")
                    return ""
                }
                return level_.backgroundImageName
            case .second:
                return "blue.png"
            }
            
        }
        
    }
  
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(level: Int) {
        
        self.level = level
        
        super.init(size: sceneSize)
        
    }
    
    override func didMoveToView(view: SKView) {
        
        //print("\(NSStringFromClass(self.classForCoder)).\(__FUNCTION__) is called!")

        //firstViewとsecondViewを作成する
        let firstView = SKSpriteNode()  //first
        let secondView = SKSpriteNode() //second

        //背景画像を適用
        applyBackgroundImage(view: firstView, area: displayArea.first, level: self.level)   //firstView
        applyBackgroundImage(view: secondView, area: displayArea.second, level: self.level) //secondView

        //等間隔に四角形を作成 (5列2行, 計10個)
        let scale = size.width / CGFloat(col)
        let scaleSquare = scale * 0.6
        let squareSize = CGSizeMake(scaleSquare, scaleSquare)
        
        makeTupleArray(col: col, row: row).map({
            displayPointMake(numX: $0.0, numY: $0.1, scale: scale)
        }).forEach({
            createSquare(size: squareSize, point: $0)
        })

        
    }
    
    /**
     2次元タプル生成関数
     
     - parameter col: 列
     - parameter row: 行
     - returns : col, rowに基づき生成した全パータンのタプルを返す
    */
    func makeTupleArray(col col:Int, row:Int) -> [(Int,Int)]{
        return (0...(col * row - 1))
            .map({($0 % col, $0 / col)})
    }

    /**
     背景用画像を適用する
     
     - parameter view: 背景画像を表示するNode (SKSpriteNode型)
     - parameter area: displayAreaを指定する (enum displayArea型)
     - parameter level: 表示するlevelを指定する
    */
    private func applyBackgroundImage(var view view: SKSpriteNode, area: displayArea, level: Int) {
        
        let firstViewTexture = SKTexture.init(imageNamed: area.getBackgroundImageNamed(level))
        view = SKSpriteNode(texture: firstViewTexture)
        view.size = area.calcSize(self.size)
        view.position = area.calcPosition(self.size)
        self.addChild(view)
        
    }
    
    /**
     四角形を表示する. 四角形は入力文字の表示用.
     
     - parameter size: 作成する四角形のサイズ
     - parameter point: 作成する四角形の座標位値
     */
    private func createSquare(size size: CGSize, point: CGPoint) {
        
        inputLabelArray.append(SKLabelNode(text: "a"))  //Label配列にLabelを追加
        inputLabelArray.last!.position = CGPoint(x: 0, y: -inputLabelArray.last!.frame.size.height / 2)     //Labelの位置を指定
        
        let squareBackground = SKSpriteNode(color: UIColor.grayColor(), size: size)    //背景用四角を作成
        squareBackground.position = CGPoint(x:point.x, y:point.y)                      //背景用四角の位置を指定
        
        squareBackground.addChild(inputLabelArray.last!)
        self.addChild(squareBackground)
        
    }
    
    /**
     座標を作成する. 座標は四角形は表示位置.
     
     - parameter numX: 列番号を示す値
     - parameter numY: 行番号を示す値
     - parameter scale: 座標位値を決めるために必要な基準の長さ
     - returns: 生成した座標をreturnする
     */
    func displayPointMake(numX numX: Int, numY: Int, scale: CGFloat) -> CGPoint {
        let numX_ = CGFloat(numX)
        let numY_ = CGFloat(numY)
        return CGPointMake(scale / 2 + scale * numX_, scale / 2 + scale * numY_)
    }
    
    
//    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        
//        //print("\(NSStringFromClass(self.classForCoder)).\(__FUNCTION__) is called!")
//        
//        let scene = GameScene(size: self.size, level: level + 1)
//        let transition : SKTransition = SKTransition.pushWithDirection(SKTransitionDirection.Left, duration: 1.0)
//        self.view!.presentScene(scene, transition: transition)
//        
//        print("\(inputLabelArray.count)")
//        outputPressButtonLog(3)
//        
//    }

    func outputPressButtonLog(num: Int) {
        
        print("pressed button \(num)")
  
        inputLabelArray[num].text = "\(num)"
        
    }

    

}
