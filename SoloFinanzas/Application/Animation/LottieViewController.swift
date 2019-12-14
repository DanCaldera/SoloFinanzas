//
//  AppDelegate.swift
//  SoloFinanzas
//
//  Created by Daniel Caldera on 12/12/19.
//  Copyright © 2019 Calere. All rights reserved.
//

import UIKit
import Lottie

class LottieViewController: UIViewController {
    @IBOutlet weak var aniamtionView: LOTAnimationView!

    override func viewDidLoad() {
        super.viewDidLoad()

        aniamtionView.setAnimation(named: "day_of_the_dead_skull")
        aniamtionView.loopAnimation = true
        aniamtionView.play()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
