//
//  ArrivalViewController.swift
//  FoodARoma
//
//  Created by alan on 2023-08-09.
//

import UIKit
import PanModal

class ArrivalViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(_ animated: Bool) {
        arrivaldismissed = true
    }


}

extension ArrivalViewController: PanModalPresentable {

    var panScrollable: UIScrollView? {
        return nil
    }
    
    var shortFormHeight: PanModalHeight {
        return .contentHeight(400)
    }

    var longFormHeight: PanModalHeight {
        return .maxHeightWithTopInset(20)
    }
}
