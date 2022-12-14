//
//  HouseController.swift
//  AndrewZuo_FinalProject
//
//  Created by andrew on 2021/7/28.
//

import Foundation
import UIKit
import SpriteKit
import SwiftUI



// A sample SwiftUI creating a GameScene and sizing it
// at 300x400 points

class HouseController : UIViewController,UICollectionViewDataSource, UICollectionViewDelegate{
    var theImageCache:[UIImage] = []
    var backgroundImage: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var CurrentMode: UILabel!
    @IBOutlet weak var coinImage: UIImageView!
    @IBOutlet weak var SkV: SKView!
    @IBOutlet weak var coins: UILabel!
    @IBOutlet weak var Hint1: BlinkLabel!
    @IBOutlet weak var Hint2: BlinkLabel!
    var scene: SKScene {
        let scene = GameScene()
        scene.size = CGSize(width: 300, height: 300)
        scene.scaleMode = .resizeFill
        scene.backgroundColor = UIColor(patternImage: UIImage(named: "background3")!)
        return scene
        
    }
    //https://www.hackingwithswift.com/quick-start/swiftui/how-to-integrate-spritekit-using-spriteview
    override func viewDidLoad() {
        super.viewDidLoad()
        coinImage.image = UIImage(named: "coin")!
        
        SkV.presentScene(scene)
        coins.text = String(Variable.shared.money)
        let cellSize = UIScreen.main.bounds.width / 5
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        layout.itemSize = CGSize(width: cellSize, height: cellSize)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        collectionView.collectionViewLayout = layout
        theImageCache = []
        cacheImage(isEmpty: true)
        self.backgroundImage = UIImageView(image: UIImage(named: "purecolor"))
        self.backgroundImage.contentMode = .scaleAspectFill
        self.view.insertSubview(self.backgroundImage, at: 0)
        
        setupCollectionView()
        //https://stackoverflow.com/questions/52467679/set-uiimageview-as-background-swift-4/52467745
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.backgroundImage.frame = self.view.bounds
    }
    override func viewDidAppear(_ animated: Bool) {
        cacheImage(isEmpty: true)
        collectionView.reloadData()
        
        Hint1.colours = [.red,.clear]
        Hint1.speed = 1.0
        Hint1.startBlinking()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 4) {
            self.Hint1.stopBlinking()
        }
        Hint2.colours = [.red,.clear]
        Hint2.speed = 1.0
        Hint2.startBlinking()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 4) {
            self.Hint2.stopBlinking()
        }
        
        if(Int(coins.text ?? "0") != Variable.shared.money){
            coins.text = String(Variable.shared.money)
        }
        if(Variable.shared.clear == 1){
            
            Variable.shared.scene.enumerateChildNodes(withName: "pets") {
                    node, stop in
                node.run(SKAction.removeFromParent())
             }
            Variable.shared.scene.enumerateChildNodes(withName: "furnitures") {
                    node, stop in
                node.run(SKAction.removeFromParent())
             }
        }
        if(Variable.shared.clear == 2){
            Variable.shared.scene.enumerateChildNodes(withName: "pets") {
                    node, stop in
                node.run(SKAction.removeFromParent())
             }
        }
        if(Variable.shared.clear == 3){
            Variable.shared.scene.enumerateChildNodes(withName: "furnitures") {
                    node, stop in
                node.run(SKAction.removeFromParent())
             }
        }
        if(Variable.shared.Mode == 2){
            CurrentMode.text = "Current Mode: Delete"
        }
        if(Variable.shared.Mode == 1){
            CurrentMode.text = "Current Mode: Move"
        }
        if(Variable.shared.Mode == 0){
            CurrentMode.text = "Current Mode: Add"
        }
        
    }
    var body: some View {
        SpriteView(scene: scene)
            .frame(width: 300, height: 300)
            .ignoresSafeArea()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(Int(coins.text ?? "0") != Variable.shared.money){
            coins.text = String(Variable.shared.money)
            }
        }
    func setupCollectionView(){
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return theImageCache.count;
    }
    func cacheImage(isEmpty: Bool){
        theImageCache = []
        if(isEmpty == true){
            let theImagea = UIImage(named: "bird")!
            theImageCache.append(theImagea)
            let theImageb = UIImage(named: "cat")!
            theImageCache.append(theImageb)
            let theImagec = UIImage(named: "dog")!
            theImageCache.append(theImagec)
            let theImaged = UIImage(named: "fish")!
            theImageCache.append(theImaged)
            let theImagee = UIImage(named: "bunny")!
            theImageCache.append(theImagee)
            let theImage1 = UIImage(named: "1")!
            theImageCache.append(theImage1)
            let theImage2 = UIImage(named: "2")!
            theImageCache.append(theImage2)
            let theImage3 = UIImage(named: "3")!
            theImageCache.append(theImage3)
            let theImage4 = UIImage(named: "4")!
            theImageCache.append(theImage4)
            let theImage5 = UIImage(named: "5")!
            theImageCache.append(theImage5)
            let theImage6 = UIImage(named: "6")!
            theImageCache.append(theImage6)
            let theImage7 = UIImage(named: "7")!
            theImageCache.append(theImage7)
            let theImage8 = UIImage(named: "8")!
            theImageCache.append(theImage8)
            let theImage9 = UIImage(named: "9")!
            theImageCache.append(theImage9)
            let theImage10 = UIImage(named: "10")!
            theImageCache.append(theImage10)
        }
        print(theImageCache.count)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FurnitureCell", for: indexPath) as! FurnitureCell
        
        if(theImageCache.count == 0){
            cell.image.image = nil
        }
        
        cell.image.image = theImageCache[indexPath.row]
        
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let i = theImageCache[indexPath.section * 3 + indexPath.row]
        if(indexPath.section * 3 + indexPath.row < 5){
            Variable.shared.category = 0
        }
        else{
            Variable.shared.category = 1
        }
        Variable.shared.currentImage = i;
    }
    
}

