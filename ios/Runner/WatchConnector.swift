//
//  WatchConnector.swift
//  Runner
//
//  Created by Ishan on 2024-05-01.
//
import UIKit
import Foundation
import WatchConnectivity


class WatchConnector: NSObject, WCSessionDelegate {
    var session: WCSession?
    
    func flutterChannel() -> FlutterMethodChannel {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let controller : FlutterViewController = appDelegate.window!.rootViewController as! FlutterViewController
        let channel = FlutterMethodChannel(name: "com.ishandini.watch",
                                           binaryMessenger: controller.binaryMessenger)
        return channel
    }
    
    func setup() {
        flutterChannel().setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            switch call.method {
            case "flutterToWatch":
                guard let watchSession = self.session,
                        watchSession.isPaired,
                      watchSession.isReachable,
                      let methodData = call.arguments as? [String: Any],
                        let method = methodData["method"],
                      let data = methodData["data"]  else {
                    result(false)
                    return
                }
                
                let watchData: [String: Any] = ["method": method, "data": data]
                
                // Pass the receiving message to Apple Watch
                watchSession.sendMessage(watchData, replyHandler: nil, errorHandler: nil)
                result(true)
            default:
                result(FlutterMethodNotImplemented)
            }
        })
        
        if WCSession.isSupported() {
            session = WCSession.default;
            session?.delegate = self;
            session?.activate();
        }
    }
    
}

extension WatchConnector {
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            if let method = message["method"] as? String {
                self.flutterChannel().invokeMethod(method, arguments: message)
            }
        }
    }
}
