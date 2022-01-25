//
//  ViewController.swift
//  BillSplitIt
//
//  Created by David Chester on 1/9/22.
//

import UIKit

class ViewController: UIViewController {
    
    // top view with bill amount
    var topLabel: UILabel!
    var billField: UITextField!
    var topView = UIView()
    
    // diner stepper
    var stepperView = UIView()
    var dinerCounter = UIStepper()
    var dinerLabel: UILabel!
    var dinerTitle: UILabel!
    
    // tip picker view and properties
    var tipPicker: UIPickerView!
    var tipPercentageLabel: UILabel!
    var tipArray: [Int] = Array(10...100)
    var tipPercentage = 0
    var tipLabel: UILabel!
    var tipView = UIView()
    
    // total labels
    // the view
    var totalsView = UIView()
    // the title of the view
    var totalsLabel: UILabel!
    // final total amounts
    var totalBill: UILabel!
    var totalTip: UILabel!
    
    // labels for bills
    var totalBillLabel: UILabel!
    var totalTipLabel: UILabel!
    
    //amount properties
    var billPreTip = Float()
    var billSplittotal = Float()
    var tipAmount = Float()
    
    var totalDiners = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
      
        billField.delegate = self
        tipPicker.delegate = self
        tipPicker.dataSource = self
        
      
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    @objc func addDiner(){
        totalDiners += 1
        dinerLabel.text = String(totalDiners)
        if tipPercentageLabel.text != "" {
            calculateTotal()
        }

    }

    func calculateTotal(){
        
        var bill = String()
        var tip = String()
        
        if billPreTip != 0.0 && totalDiners != 0 {
            let result = billPreTip * (1 + tipAmount) / Float(totalDiners)
            
            bill = String(format: "%.2f", result)
            bill.insert("$", at: bill.startIndex)
            totalBill.text = bill
            totalBill.isHidden = false
            totalsLabel.isHidden = false
            totalBillLabel.isHidden = false
            
            
            tip = String(format: "%.2f", (billPreTip * tipAmount))
            tip.insert("$", at: tip.startIndex)
            totalTip.text = tip
            totalTip.isHidden = false
            totalTipLabel.isHidden = false
        }
    }
}

// MARK: Textfield delegate method
extension ViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        billField.text = ""
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if billField.text != nil {
        if var billBeforeTip = billField.text {
                    billPreTip = Float(billBeforeTip)!
                    
                    billBeforeTip.insert("$", at: billBeforeTip.startIndex)
            
                    print(billPreTip)
                    billField.text = billBeforeTip

            }
        }
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            guard let counter = billField.text?.components(separatedBy: ".") else { return false }
            if (counter.count - 1 > 0 && string == ".")  { return false }
            return true
        }
}


    
    


// MARK: Pickerview delegate and data
extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        tipArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let row = String(tipArray[row])
        return row
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        tipPercentageLabel.text = "\(tipArray[row])%"
        tipAmount = Float(tipArray[row]) / 100
        print(tipAmount)
        calculateTotal()
    }
    
}

// MARK: Load view extension + constraints
extension ViewController {
    

override func loadView() {
    view = UIView()
    view.backgroundColor = UIColor(red: 219/255, green: 107/255, blue: 151/255, alpha: 1.0)
    
    
    // MARK: Top+Bill  and view
    topLabel = UILabel()
    topLabel.text = "Enter Bill Total"
    topLabel.textAlignment = .left
    topLabel.font = UIFont.systemFont(ofSize: 20)
    topLabel.textColor = UIColor(red: 219/255, green: 107/255, blue: 151/255, alpha: 1.0)
    topLabel.translatesAutoresizingMaskIntoConstraints = false
    topView.addSubview(topLabel)
    
    billField = UITextField()
    billField.placeholder = "eg. $125.76"
    billField.keyboardType = .decimalPad

    billField.textAlignment = .center
    billField.backgroundColor = UIColor(red: 242/255, green: 255/255, blue: 233/255, alpha: 1.0)
    billField.translatesAutoresizingMaskIntoConstraints = false
    billField.font = UIFont.systemFont(ofSize: 18)
    billField.layer.cornerRadius = 7
    topView.addSubview(billField)
    
    topView.translatesAutoresizingMaskIntoConstraints = false
    topView.backgroundColor = UIColor(red: 217/255, green: 215/255, blue: 241/255, alpha: 0.7)
    view.addSubview(topView)
    
    // MARK: Diner Counter
    
    
    dinerCounter.minimumValue = 0
    dinerCounter.addTarget(self, action: #selector(addDiner), for: .valueChanged)
    dinerCounter.translatesAutoresizingMaskIntoConstraints = false
    stepperView.addSubview(dinerCounter)
    
    dinerLabel = UILabel()
    dinerLabel.text = ""
    dinerLabel.font = UIFont.systemFont(ofSize: 45)
    dinerLabel.textAlignment = .center
    dinerLabel.translatesAutoresizingMaskIntoConstraints = false
    dinerLabel.textColor = UIColor(red: 255/255, green: 203/255, blue: 203/255, alpha: 1.0)
    stepperView.addSubview(dinerLabel)
    
    dinerTitle = UILabel()
    dinerTitle.text = "Total Diners:"
    dinerTitle.textAlignment = .left
    dinerTitle.font = UIFont.systemFont(ofSize: 20)
    dinerTitle.translatesAutoresizingMaskIntoConstraints = false
    dinerTitle.textColor = UIColor(red: 255/255, green: 203/255, blue: 203/255, alpha: 1.0)
    stepperView.addSubview(dinerTitle)
    
    stepperView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(stepperView)
    
    // MARK: Tip + Tip Picker View
    tipPicker = UIPickerView()
    tipPicker.translatesAutoresizingMaskIntoConstraints = false
    tipView.addSubview(tipPicker)
    
    tipLabel = UILabel()
    tipLabel.translatesAutoresizingMaskIntoConstraints = false
    tipLabel.text = "Tip Percentage:"
    tipLabel.textAlignment = .left
    tipLabel.textColor = UIColor(red: 255/255, green: 203/255, blue: 203/255, alpha: 1.0)
    tipLabel.font = UIFont.systemFont(ofSize: 20)
    tipView.addSubview(tipLabel)
    
    tipPercentageLabel = UILabel()
    tipPercentageLabel.translatesAutoresizingMaskIntoConstraints = false
    tipPercentageLabel.text = ""
    tipPercentageLabel.textAlignment = .center
    tipPercentageLabel.textColor = UIColor(red: 255/255, green: 203/255, blue: 203/255, alpha: 1.0)
    tipPercentageLabel.font = UIFont.systemFont(ofSize: 45)
    tipView.addSubview(tipPercentageLabel)
    
    tipView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(tipView)
    
    
    // MARK: Totals
    totalsView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(totalsView)
    
    totalsLabel = UILabel()
    totalsLabel.translatesAutoresizingMaskIntoConstraints = false
    totalsLabel.text = "Total:"
    totalsLabel.isHidden = true
    totalsLabel.textAlignment = .right
    totalsLabel.textColor = UIColor(red: 255/255, green: 203/255, blue: 203/255, alpha: 1.0)
    totalsLabel.font = UIFont.systemFont(ofSize: 20)
    totalsView.addSubview(totalsLabel)
    
    
    totalBill = UILabel()
    totalBill.translatesAutoresizingMaskIntoConstraints = false
    totalBill.text = ""
    totalBill.isHidden = true
    totalBill.textAlignment = .center
    totalBill.textColor = UIColor(red: 231/255, green: 251/255, blue: 190/255, alpha: 1.0)
    totalBill.font = UIFont.systemFont(ofSize: 20)
    totalsView.addSubview(totalBill)
    
    totalBillLabel = UILabel()
    totalBillLabel.translatesAutoresizingMaskIntoConstraints = false
    totalBillLabel.text = "per person"
    totalBillLabel.font = UIFont.systemFont(ofSize: 10)
    totalBillLabel.textColor = UIColor(red: 255/255, green: 203/255, blue: 203/255, alpha: 1.0)
    totalBillLabel.textAlignment = .center
    totalBillLabel.isHidden = true
    totalsView.addSubview(totalBillLabel)
    
    
    totalTip = UILabel()
    totalTip.translatesAutoresizingMaskIntoConstraints = false
    totalTip.textAlignment = .center
    totalTip.font = UIFont.systemFont(ofSize: 20)
    totalTip.text = ""
    totalTip.isHidden = true
    totalTip.textColor = UIColor(red: 231/255, green: 251/255, blue: 190/255, alpha: 1.0)
    totalsView.addSubview(totalTip)
    
    totalTipLabel = UILabel()
    totalTipLabel.translatesAutoresizingMaskIntoConstraints = false
    totalTipLabel.textAlignment = .center
    totalTipLabel.font = UIFont.systemFont(ofSize: 10)
    totalTipLabel.textColor = UIColor(red: 255/255, green: 203/255, blue: 203/255, alpha: 1.0)
    totalTipLabel.text = "with included tip"
    totalTipLabel.isHidden = true
    totalsView.addSubview(totalTipLabel)
    
    
    
    
    // MARK: Constraints
    NSLayoutConstraint.activate([
    
        // MARK: top view and bill field constraints
        topView.topAnchor.constraint(equalTo: view.topAnchor),
        topView.widthAnchor.constraint(equalTo: view.widthAnchor),
        topView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25),
        topView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        
        topLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 30),
        topLabel.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 10),
        
        billField.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 40),
        billField.widthAnchor.constraint(equalTo: topView.widthAnchor, multiplier: 0.7),
        billField.centerXAnchor.constraint(equalTo: topView.centerXAnchor),
        billField.heightAnchor.constraint(equalTo: topView.heightAnchor, multiplier: 0.2),
        
        //  MARK: stepper constraints
        
        stepperView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 10),
        stepperView.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.7),
        stepperView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        stepperView.heightAnchor.constraint(equalTo: view.layoutMarginsGuide.heightAnchor, multiplier: 0.2),
        
        // MARK: Diner constraints
        dinerCounter.trailingAnchor.constraint(equalTo: stepperView.trailingAnchor, constant: -10),
        dinerCounter.centerYAnchor.constraint(equalTo: stepperView.centerYAnchor),
        
        dinerLabel.centerYAnchor.constraint(equalTo: stepperView.centerYAnchor),
       // dinerLabel.leadingAnchor.constraint(equalTo: stepperView.leadingAnchor, constant:),
        dinerLabel.centerXAnchor.constraint(equalTo: dinerTitle.centerXAnchor),
        
        dinerTitle.topAnchor.constraint(equalTo: stepperView.topAnchor, constant: 10),
        dinerTitle.leadingAnchor.constraint(equalTo: stepperView.leadingAnchor),
        
        // MARK: tip picker constraints
        
        tipView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 50),
        tipView.widthAnchor.constraint(equalTo: topView.layoutMarginsGuide.widthAnchor, multiplier: 0.8),
        tipView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        tipView.heightAnchor.constraint(equalTo: view.layoutMarginsGuide.heightAnchor, multiplier: 0.2),
        
        tipLabel.topAnchor.constraint(equalTo: tipView.topAnchor),
        
        
        tipPicker.centerYAnchor.constraint(equalTo: tipView.centerYAnchor),
        tipPicker.widthAnchor.constraint(equalTo: tipView.widthAnchor, multiplier: 0.4),
        tipPicker.heightAnchor.constraint(equalTo: tipView.heightAnchor, multiplier: 0.8),
        tipPicker.trailingAnchor.constraint(equalTo: tipView.trailingAnchor, constant: -50),
                    
        tipPercentageLabel.leadingAnchor.constraint(equalTo: tipView.leadingAnchor, constant: 50),
        tipPercentageLabel.centerYAnchor.constraint(equalTo: tipView.centerYAnchor),
        
        
        // MARK:  totals view and labels
        totalsView.topAnchor.constraint(equalTo: tipView.bottomAnchor, constant: 20),
        totalsView.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.7),
        totalsView.heightAnchor.constraint(equalTo: view.layoutMarginsGuide.heightAnchor, multiplier: 0.15),
        totalsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        
        totalsLabel.topAnchor.constraint(equalTo: totalsView.topAnchor),
        totalsLabel.leadingAnchor.constraint(equalTo: totalsView.leadingAnchor, constant: 20),
        
        totalBill.centerYAnchor.constraint(equalTo: totalsView.centerYAnchor),
        totalBill.centerXAnchor.constraint(equalTo: totalsView.centerXAnchor, constant: -50),
        
        totalBillLabel.topAnchor.constraint(equalTo: totalBill.bottomAnchor, constant: 5),
        totalBillLabel.centerXAnchor.constraint(equalTo: totalBill.centerXAnchor),
        
        totalTip.centerYAnchor.constraint(equalTo: totalsView.centerYAnchor),
        totalTip.centerXAnchor.constraint(equalTo: totalsView.centerXAnchor, constant: 50),
        
        totalTipLabel.topAnchor.constraint(equalTo: totalBillLabel.topAnchor),
        totalTipLabel.centerXAnchor.constraint(equalTo: totalTip.centerXAnchor),
    
    ])
}

}
