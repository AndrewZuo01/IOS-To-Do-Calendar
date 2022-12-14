//
//  SettingVariables.swift
//  AndrewZuo_FinalProject
//
//  Created by andrew on 2021/8/4.
//

import Foundation
import UIKit
class SettingVariales : UIViewController{
    @IBOutlet weak var focus: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func changeFocusMode(_ sender: Any) {
        if(Variable.shared.focusMode){
            Variable.shared.focusMode = false
            focus.setTitle("Click to change Focus mode. Current: Off", for: .normal)
            if(Variable.shared.FocusOnce){
                let alert = UIAlertController(title: "Focus Mode Off!", message: "Now focus mode is off. You will not get coin from deleting events.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                Variable.shared.FocusOnce = false
            }
        }
        else{
            Variable.shared.focusMode = true
            focus.setTitle("Click to change Focus mode. Current: On", for: .normal)
        }
         
    }
    @IBAction func ClearEvery(_ sender: Any) {
        Variable.shared.clear = 1
    }
    @IBAction func ClearPets(_ sender: Any) {
        Variable.shared.clear = 2
    }
    @IBAction func ClearFurnitures(_ sender: Any) {
        Variable.shared.clear = 3
    }
    @IBAction func deleteMode(_ sender: Any) {
        Variable.shared.Mode = 2
    }
    @IBAction func addMode(_ sender: Any) {
        Variable.shared.Mode = 0
    }
    @IBAction func moveMode(_ sender: Any) {
        Variable.shared.Mode = 1
    }
}
            
