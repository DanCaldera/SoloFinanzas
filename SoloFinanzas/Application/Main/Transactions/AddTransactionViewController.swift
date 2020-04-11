//
//  AddTransactionViewController.swift
//  SoloFinanzas
//
//  Created by Daniel Caldera on 10/04/20.
//  Copyright © 2020 Platzi. All rights reserved.
//

import UIKit

class AddTransactionViewController: UIViewController {
    
    @IBOutlet weak var transactionNameLabel: UITextField!
    @IBOutlet weak var transactionDescriptionLabel: UITextField!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var valueTextField: UITextField!
    
    @IBAction func screenClick(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    private var viewModel = AddTransactionViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        valueTextField.becomeFirstResponder()
    }

    @IBAction func addTransaction(_ sender: UIButton) {
        viewModel.add(
            name: transactionNameLabel.text ?? "new add",
            description: transactionDescriptionLabel.text ?? "",
            value: valueTextField.text ?? "0"
        )

        valueTextField.resignFirstResponder()
        tabBarController?.selectedIndex = 0
        
        navigationController?.popViewController(animated: true)
        
    }
}
