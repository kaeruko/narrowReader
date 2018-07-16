//
//  HomeViewController
//  narrowReader
//
//  Created by kaeruko on 2018/07/11.
//  Copyright © 2018年 kaeruko. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift

class SearchModalViewController: narrowBaseViewController, UITextFieldDelegate, UIPickerViewDelegate,UIToolbarDelegate, UIPickerViewDataSource, UITextInputDelegate {

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return SearchPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
print(textField)
        print("textFieldDidBeginEditing:" + textField.text!)
    }
    
    var search_word : String = ""
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // キーボードを隠す
        textField.resignFirstResponder()
        print("textFieldShouldReturn:" + textField.text!)
        self.search_word = textField.text!
        //検索
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("Start" + textField.text!)
        print(textField)
        return true
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        print("textFieldShouldEndEditing:" + textField.text!)
        print(textField)
        return true
    }
    
    // クリアボタンが押された時の処理
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        
        print("Clear" + textField.text!)
        print(textField)
        return true
    }


    func selectionWillChange(_ textInput: UITextInput?) {
    }
    
    func selectionDidChange(_ textInput: UITextInput?) {
    }
    
    func textWillChange(_ textInput: UITextInput?) {
    }
    
    func textDidChange(_ textInput: UITextInput?) {
        
    }
    
    
    lazy var modalWidth : CGFloat = 0
    lazy var modalHeight : CGFloat = 0
    lazy var modalOriginX : CGFloat = 0
    lazy var modalOriginY : CGFloat = 0

    var ntypes: NSArray = ["新着順","ブクマ順","レビュー順","評価順","評価者順","文字数順","新しい順"]
    var nocgenres: NSArray = ["すべて","女性向け", "BL"]
    

    //一段目
    lazy var titleLabel : UILabel = self.createLabel()

    //二段目
    lazy var searchTitleLabel : UILabel = self.createLabel()
    lazy var searchTextField: UITextField = self.createTextField()

    //三段目
    lazy var ignoreTitleLabel : UILabel = self.createLabel()
    lazy var ignoreTextField: UITextField = self.createTextField()

    //四段目
    lazy var titleNameLabel : UILabel = self.createLabel()
    lazy var titleNameSwitch : UISwitch = self.createSwitch()
    
    lazy var plotLabel : UILabel = self.createLabel()
    lazy var plotSwitch : UISwitch = self.createSwitch()
    
    //五段目
    lazy var keywordLabel : UILabel = self.createLabel()
    lazy var keywordSwitch : UISwitch = self.createSwitch()
    
    lazy var autherLabel : UILabel = self.createLabel()
    lazy var autherSwitch : UISwitch = self.createSwitch()

    //六段目
    lazy var genreTextField: UITextField = self.createTextField()
    lazy var ganrePicker: UIPickerView = self.createPicker()
    var myToolBar: UIToolbar!

    //７段目
    lazy var ntypeTitleLabel : UILabel = self.createLabel()
    lazy var ngenreTitleLabel : UILabel = self.createLabel()

    //８段目
    lazy var ntypeValueLabel : UILabel = self.createLabel()
    lazy var ngenreValueLabel : UILabel = self.createLabel()

    lazy var submitButton : UIButton = self.createButton()

    open func createUIView(uiview : UIView) -> UIView{
        uiview.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(uiview)
        return uiview
    }

    open func createLabel() -> UILabel{
        var label = UILabel(frame:CGRect(x: 0, y: 0, width: 0 , height: 0))
        label = self.createUIView(uiview: label) as! UILabel
        label.adjustsFontSizeToFitWidth = true
        return label
    }

    open func createButton() -> UIButton{
        var btn = UIButton(frame:CGRect(x: 0, y: 0, width: 0 , height: 0))
        btn = self.createUIView(uiview: btn) as! UIButton
        return btn
    }

    
    open func createSwitch() -> UISwitch{
        var swt = UISwitch(frame:CGRect(x: 0, y: 0, width: 0 , height: 0))
        swt = self.createUIView(uiview: swt) as! UISwitch
        swt.isOn = false
        return swt
    }

    open func createPicker() -> UIPickerView{
        //PickerView作成
        var picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.showsSelectionIndicator = true
        picker.delegate = self
        picker.dataSource = self
        picker.selectRow(0, inComponent: 0, animated: false);
        return picker
    }

    open func createTextField() -> UITextField{
        var textfield = UITextField(frame: CGRect(x: 0, y: 0, width: self.modalWidth * 0.6, height: 50))
        textfield = self.createUIView(uiview: textfield) as! UITextField
        textfield.backgroundColor = UIColor.white
        textfield.adjustsFontSizeToFitWidth = true
        textfield.delegate = self as! UITextFieldDelegate
        textfield.inputDelegate = self as! UITextInputDelegate
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.returnKeyType = .done
        return textfield
    }

    open func layoutElement(target : UIView, element : UIView, attr: NSLayoutAttribute, constant: CGFloat, mult: CGFloat = 1.0){
        target.addConstraint(Constraint(item:element, attr,    to: target, attr,    constant: constant,  multiplier:mult))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.gray

        let half = (self.modalWidth * 0.5)
        let labelwidth = self.modalWidth * 0.35
        let rightmargin = (half - labelwidth) * 0.5
        var marginatline:CGFloat = 50
        var topmargin = self.modalHeight * 0.05
        //タイトル
        self.titleLabel.text = "小説 検索"
        self.layoutElement(target: self.view, element: self.titleLabel, attr: NSLayoutAttribute.top, constant: topmargin)
        self.layoutElement(target: self.view, element: self.titleLabel, attr: NSLayoutAttribute.centerX, constant: 0)
        //二段目

        //検索ラベル
        self.searchTitleLabel.text = "検索"
        self.layoutElement(target: self.view, element: self.searchTitleLabel, attr: NSLayoutAttribute.top, constant: topmargin + marginatline)
        self.layoutElement(target: self.view, element: self.searchTitleLabel, attr: NSLayoutAttribute.leading, constant: rightmargin)

        //検索フォーム
        self.searchTextField.placeholder = "検索フォーム";
        self.layoutElement(target: self.view, element: self.searchTextField, attr: NSLayoutAttribute.top, constant: topmargin + marginatline)
        self.layoutElement(target: self.view, element: self.searchTextField, attr: NSLayoutAttribute.trailing, constant: self.modalWidth * -0.1)
        self.layoutElement(target: self.view, element: self.searchTextField, attr: NSLayoutAttribute.width, constant: 0, mult: 0.6)
//        self.searchTextField.addTarget(self, action: #selector(self.setText(sender:)), for: UIControlEvents.valueChanged)

        //三段目

        //除外ラベル
        self.ignoreTitleLabel.text = "除外"
        self.layoutElement(target: self.view, element: self.ignoreTitleLabel, attr: NSLayoutAttribute.top, constant: topmargin + (marginatline * 2.0))
        self.layoutElement(target: self.view, element: self.ignoreTitleLabel, attr: NSLayoutAttribute.leading, constant: rightmargin)

        //除外フォーム
        self.ignoreTextField.placeholder = "除外フォーム"
        self.layoutElement(target: self.view, element: self.ignoreTextField, attr: NSLayoutAttribute.top, constant: topmargin + (marginatline * 2.0))
        self.layoutElement(target: self.view, element: self.ignoreTextField, attr: NSLayoutAttribute.trailing, constant: self.modalWidth * -0.1)
        self.layoutElement(target: self.view, element: self.ignoreTextField, attr: NSLayoutAttribute.width, constant: 0, mult: 0.6)

        //四段目
        self.titleNameLabel.text = "作品名"
        self.layoutElement(target: self.view, element: self.titleNameLabel, attr: NSLayoutAttribute.top, constant: topmargin + (marginatline * 3.0)+8)
        self.layoutElement(target: self.view, element: self.titleNameLabel, attr: NSLayoutAttribute.leading, constant: rightmargin)

        self.titleNameSwitch.addTarget(self, action: #selector(self.checkView(sender:)), for: UIControlEvents.valueChanged)
        self.titleNameSwitch.isOn = true
        self.view.addConstraint(Constraint(item:self.titleNameSwitch, .top,    to: self.view, .top,    constant:topmargin + (marginatline * 3.0)))
        self.view.addConstraint(Constraint(item:self.titleNameSwitch, .leading,  to: self.view, .leading,  constant: self.modalWidth * 0.34,   multiplier: 1.0))

        self.plotLabel.text = "あらすじ"
        self.layoutElement(target: self.view, element: self.plotLabel, attr: NSLayoutAttribute.top, constant: topmargin + (marginatline * 3.0)+8)
        self.layoutElement(target: self.view, element: self.plotLabel, attr: NSLayoutAttribute.trailing, constant:  self.modalWidth * -0.28)

        self.plotSwitch.addTarget(self, action: #selector(self.checkView(sender:)), for: UIControlEvents.valueChanged)
        self.layoutElement(target: self.view, element: self.plotSwitch, attr: NSLayoutAttribute.top, constant: topmargin + (marginatline * 3.0))
        self.layoutElement(target: self.view, element: self.plotSwitch, attr: NSLayoutAttribute.trailing, constant:  self.modalWidth * -0.1)

        //五段目
        self.keywordLabel.text = "キーワード"
        self.layoutElement(target: self.view, element: self.keywordLabel, attr: NSLayoutAttribute.top, constant: topmargin + (marginatline * 4.0)+8)
        self.layoutElement(target: self.view, element: self.keywordLabel, attr: NSLayoutAttribute.leading, constant: rightmargin)

        self.keywordSwitch.addTarget(self, action: #selector(self.checkView(sender:)), for: UIControlEvents.valueChanged)
        self.view.addConstraint(Constraint(item:self.keywordSwitch, .top,    to: self.view, .top,    constant:topmargin + (marginatline * 4.0)))
        self.view.addConstraint(Constraint(item:self.keywordSwitch, .leading,  to: self.view, .leading,  constant: self.modalWidth * 0.34,   multiplier: 1.0))

        self.autherLabel.text = "作者名"
        self.layoutElement(target: self.view, element: self.autherLabel, attr: NSLayoutAttribute.top, constant: topmargin + (marginatline * 4.0)+8)
        self.layoutElement(target: self.view, element: self.autherLabel, attr: NSLayoutAttribute.trailing, constant:  self.modalWidth * -0.28)

        self.autherSwitch.addTarget(self, action: #selector(self.checkView(sender:)), for: UIControlEvents.valueChanged)
        self.layoutElement(target: self.view, element: self.autherSwitch, attr: NSLayoutAttribute.top, constant: topmargin + (marginatline * 4.0))
        self.layoutElement(target: self.view, element: self.autherSwitch, attr: NSLayoutAttribute.trailing, constant:  self.modalWidth * -0.1)

        //六段目
        self.genreTextField.placeholder = "並び順、ジャンル"
        self.layoutElement(target: self.view, element: self.genreTextField, attr: NSLayoutAttribute.centerY, constant: modalHeight * 0.13)
        self.layoutElement(target: self.view, element: self.genreTextField, attr: NSLayoutAttribute.centerX, constant: 0)
        self.layoutElement(target: self.view, element: self.genreTextField, attr: NSLayoutAttribute.width, constant:0, mult: 0.7)


        //スロット

        self.ntypeValueLabel.text = "並び順"
        self.layoutElement(target: self.view, element: self.ntypeValueLabel, attr: NSLayoutAttribute.bottom, constant: (topmargin + (marginatline * 2.0)) * -1  )
        self.layoutElement(target: self.view, element: self.ntypeValueLabel, attr: NSLayoutAttribute.leading, constant:modalWidth * 0.2)
        
        self.ngenreValueLabel.text = "ジャンル"
        self.layoutElement(target: self.view, element: self.ngenreValueLabel, attr: NSLayoutAttribute.bottom, constant: (topmargin + (marginatline * 2.0)) * -1  )
        self.layoutElement(target: self.view, element: self.ngenreValueLabel, attr: NSLayoutAttribute.trailing, constant:modalWidth * -0.2)
        
        
        
        self.ntypeTitleLabel.text = ntypes[0] as! String
        self.layoutElement(target: self.view, element: self.ntypeTitleLabel, attr: NSLayoutAttribute.bottom, constant:  (topmargin + (marginatline * 1.2)) * -1  )
        self.layoutElement(target: self.view, element: self.ntypeTitleLabel, attr: NSLayoutAttribute.leading, constant:modalWidth * 0.2)
        
        self.ngenreTitleLabel.text = nocgenres[0] as! String
        self.layoutElement(target: self.view, element: self.ngenreTitleLabel, attr: NSLayoutAttribute.bottom, constant: (topmargin + (marginatline * 1.2)) * -1  )
        self.layoutElement(target: self.view, element: self.ngenreTitleLabel, attr: NSLayoutAttribute.trailing, constant:self.modalWidth * -0.2)

        
        myToolBar = UIToolbar(frame: CGRect(x:0, y: self.view.frame.size.height/6, width:self.view.frame.size.width, height: 40.0))
        myToolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        myToolBar.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1)
        myToolBar.barStyle = UIBarStyle.blackTranslucent
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.done))
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancel))
        myToolBar.setItems([cancelItem, doneItem], animated: true)
   
        //TextFieldをpickerViewとToolVerに関連づけ
        self.genreTextField.inputView = self.ganrePicker
        self.genreTextField.inputAccessoryView = myToolBar


        //決定
        self.submitButton.adjustsImageSizeForAccessibilityContentSizeCategory = true
        self.submitButton.setTitle("決定", for: .normal)
        self.submitButton.setTitleColor(UIColor.white, for: .normal)
        self.submitButton.backgroundColor = UIColor.black
        self.submitButton.addTarget(self, action: #selector(self.doSubmit(sender:)), for:.touchUpInside)

        self.layoutElement(target: self.view, element: self.submitButton, attr: NSLayoutAttribute.bottom, constant: topmargin * -1)
        self.layoutElement(target: self.view, element: self.submitButton, attr: NSLayoutAttribute.centerX, constant:0)
        self.layoutElement(target: self.view, element: self.submitButton, attr: NSLayoutAttribute.width, constant:0, mult: 0.3)

    }

    
    @objc func checkView(sender:UISwitch) {
        print(sender)
        
    }
    
    
    @objc func cancel() {
        self.genreTextField.endEditing(true)
    }
    
    @objc func done() {
        self.genreTextField.endEditing(true)
        self.ntypeValueLabel.text = self.selected["ntype"]
        self.ngenreValueLabel.text = self.selected["nocgenre"]
        print(self.selected)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (component == 0){
            return ntypes.count
        }else if (component == 1){
            return nocgenres.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (component == 0){
            return ntypes[row] as! String
        }else if (component == 1){
            return nocgenres[row] as! String
        }
        return "";
    }
    
    var selected: Dictionary<String,String> = ["ntype":"","nocgenre":""]
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (component == 0){
            self.selected["ntype"] = ntypes[row] as? String
            print(self.selected["ntype"])
            self.genreTextField.text = ntypes[row] as? String
            
        }else if (component == 1){
            self.selected["nocgenre"] = nocgenres[row] as? String
            print(self.selected["nocgenre"])
            self.genreTextField.text = self.selected["ntype"]
            self.genreTextField.text?.append(" ジャンル：")
            self.genreTextField.text?.append(self.selected["nocgenre"]!)
            
        }
    }

    var di:UIPresentationController!
//
//    open func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
//        
//        di = UIPresentationController(presentedViewController: presented, presenting: presenting)
//        return di
//    }
    
    
    lazy var  searchResult:SearchResultViewController = SearchResultViewController()
    
    @objc open func doSubmit(sender : UIButton) {
        let vc = SearchResultViewController()
        let naviVC = narrowNavigationViewController(rootViewController: vc)
        naviVC.viewControllers = [vc]
        present(naviVC, animated: true)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}

