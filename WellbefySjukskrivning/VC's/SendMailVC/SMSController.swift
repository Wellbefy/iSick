//
//  SMSController.swift
//  WellbefySjukskrivning
//
//  Created by Dennis Galvén on 2018-02-05.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

extension SendMailVC: MFMessageComposeViewControllerDelegate {
    private func canSendText() -> Bool {
        debugPrint(MFMessageComposeViewController.canSendText())
        return MFMessageComposeViewController.canSendText()
    }
    
    func sendSms(parent: String, kid: String) {
        let parentNr = parent
        let kidNr = kid
        if canSendText() {
            sms(body: "\(parentNr) \(kidNr)", messageController: messageController())
        } else {
            self.present(alertController.twoAction(title: "Ojdå!", message: "Det verkar inte gå att skicka sms just nu. Vill du försöka igen?", completion: { OK in
                if OK {
                    
                    self.sendSms(parent: parentNr, kid: kidNr)
                }
            }), animated: true, completion: nil)
        }
    }
    
    func sms(body: String, messageController: MFMessageComposeViewController) {
        messageController.messageComposeDelegate = self
        messageController.recipients = [User.sharedInstance.fkNumber]
        messageController.body = "VAB \(body)"
        messageController.disableUserAttachments()
        DispatchQueue.main.async {
            self.present(messageController, animated: true, completion: nil)
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        sendButton.isHidden = false
        backButton.isHidden = false
        switch result {
        case .sent:
            controller.dismiss(animated: true, completion: {
                self.send(reported: true)
            })
            break
        case .cancelled:
            controller.dismiss(animated: true, completion: nil)
            break
        case .failed:
                let body = controller.body!
                controller.dismiss(animated: true, completion: { self.failed(body: body) })
            break
        }
    }
    
    private func messageController() -> MFMessageComposeViewController {
        return MFMessageComposeViewController()
    }
    
private func failed(body: String) {
        self.present(alertController.twoAction(title: "Ojdå!", message: "Något gick fel. Vill du försöka igen?", completion: { OK in
            if OK {
                self.sms(body: body, messageController: self.messageController())
            } else {
                self.send()
            }
        }), animated: true, completion: nil)
    }
}
