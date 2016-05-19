//
//  ViewController.swift
//  TabBarTesting
//
//  Created by Jose Roberto Abreu on 5/19/16.
//  Copyright © 2016 Media Revolution. All rights reserved.
//

import UIKit

//MARK: TYPE CELL

enum TypeCell:String{
    case Type1TextField = "cellType1"
    case Type2TextField = "cellType2"
    case Type3Button = "cellType3"
}

protocol SampleModel{
    var typeCell:TypeCell {get}
}

//MARK: MODEL

struct TypeCellTextField1 : SampleModel{
    var value:String
    var typeCell:TypeCell{
        return .Type1TextField
    }
}

struct TypeCellTextField2 : SampleModel {
    var value:String
    var typeCell:TypeCell{
        return .Type2TextField
    }
}

class TypeCellButton3 : SampleModel {
    var enable:Bool
    var typeCell:TypeCell{
        return .Type3Button
    }
    
    init(enable:Bool){
        self.enable = enable
    }
}

//MARK: CONTROLLER DEFINITION

class ViewController: UIViewController {
    
    @IBOutlet weak var tblSample: UITableView!
    var sampleData:[SampleModel] = [TypeCellTextField1(value: ""),TypeCellTextField2(value: ""),TypeCellButton3(enable: false)]
}

//MARK: TABLEVIEW DATASOURCE

extension ViewController : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sampleData.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 73.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let sampleModel = self.sampleData[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier(sampleModel.typeCell.rawValue, forIndexPath: indexPath)
        
        switch sampleModel{
        case let object as TypeCellTextField1:
            let cellTmp = cell as! FirstTypeTableViewCell
            cellTmp.txtSample.text = object.value
            cellTmp.txtSample.tag = indexPath.row
            cellTmp.txtSample.addTarget(self, action: "textFieldDidChanged:", forControlEvents: UIControlEvents.EditingChanged)
            return cellTmp
            
        case let object as TypeCellTextField2:
            let cellTmp = cell as! SecondTypeTableViewCell
            cellTmp.txtSample.text = object.value
            cellTmp.txtSample.addTarget(self, action: "textFieldDidChanged:", forControlEvents: UIControlEvents.EditingChanged)
            cellTmp.txtSample.tag = indexPath.row
            return cellTmp
            
        case let object as TypeCellButton3:
            let cellTmp = cell as! ThirdTypeTableViewCell
            cellTmp.btnSample.enabled = object.enable
            
            if object.enable{
                cellTmp.btnSample.backgroundColor = UIColor.blueColor()
            }else{
                cellTmp.btnSample.backgroundColor = UIColor.grayColor()
            }
            
            return cellTmp
            
        default:
            print("No type::")
        }
        
        return UITableViewCell()
    }
  
    //MARK: TEXTFIELD ACTION
    
    func textFieldDidChanged(textField:UITextField){
        print(textField.text!)
        let tag = textField.tag
        let sampleModel = self.sampleData[tag]
        
        switch sampleModel{
        case _ as TypeCellTextField1:
            self.sampleData[tag] = TypeCellTextField1(value: textField.text!)
        case _ as TypeCellTextField2:
            self.sampleData[tag] = TypeCellTextField2(value: textField.text!)
        default:
            print("Unknow")
        }
        
        refreshData()
    }
    
    func refreshData(){
        var isValid = true
        for sample in sampleData where sample is TypeCellTextField1 || sample is TypeCellTextField2{
            switch sample{
            case let sample as TypeCellTextField1:
                print("From Sample Value : \(sample.value)")
                if sample.value.isEmpty{
                    isValid = false
                    break
                }
            case let sample as TypeCellTextField2:
                if sample.value.isEmpty{
                    isValid = false
                    break
                }
            default:
                isValid = false
            }
        }
        
        self.sampleData.forEach { (sample:SampleModel) -> () in
            if let sample = sample as? TypeCellButton3{
                sample.enable = isValid
            }
        }

        self.tblSample.reloadRowsAtIndexPaths([NSIndexPath(forRow: sampleData.count - 1, inSection: 0)], withRowAnimation: UITableViewRowAnimation.None)
        
        
    }
    

}
