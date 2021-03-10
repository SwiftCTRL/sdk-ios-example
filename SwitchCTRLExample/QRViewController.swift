//
//  QRViewController.swift
//  SwitchCTRL
//
//  Created by sbouchard on 10/06/2020.
//  Copyright (c) 2020 sbouchard. All rights reserved.
//

import UIKit
import SwiftCTRLSDK

class QRViewController: UIViewController {

    private var userToken = "user_token_from_curl_call"

    private var currentQrView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        SwiftCtrl.shared.initialize(with: userToken, delegate: self)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        SwiftCtrl.shared.unregisterForQRCode(userToken: userToken)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension QRViewController: SwiftCtrlObserver {

    func didReceiveQRCode(qrView: UIImageView) {
        
        DispatchQueue.main.async { [weak self] in
            
            guard let strongSelf = self else { return }
            
            strongSelf.currentQrView.removeFromSuperview()
            strongSelf.currentQrView = qrView
            
            strongSelf.currentQrView.contentMode = .scaleAspectFit
            strongSelf.currentQrView.translatesAutoresizingMaskIntoConstraints = false
            strongSelf.view.addSubview(qrView)
            
            NSLayoutConstraint.activate([ strongSelf.currentQrView.centerYAnchor.constraint(equalTo: strongSelf.view.centerYAnchor),
                                          strongSelf.currentQrView.centerXAnchor.constraint(equalTo: strongSelf.view.centerXAnchor),
                                          strongSelf.currentQrView.widthAnchor.constraint(equalToConstant: 200),
                                          strongSelf.currentQrView.heightAnchor.constraint(equalToConstant: 200)])

        }
    }
    
    func didReceiveQRCode(qrBase64Image: String) {
        
    }
    
    // Bytes Array
    func didReceiveQRCode(qrBytesArray: [UInt8]) {
        
    }

    
    func didFinishInitialization() {
        print("yes didFinishInitialization")
        SwiftCtrl.shared.registerForQRCode(userToken: userToken)
    }
    
    func reportError(error: NSError) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "SwiftCTRL Error", message: error.description, preferredStyle: UIAlertController.Style.alert)

            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
                //Cancel Action
            }))

            self.present(alert, animated: true, completion: nil)
        }
    }
}
