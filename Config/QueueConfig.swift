//
//  QueueConfig.swift


import Foundation


enum QueueConfig {
    static let qualityOfServiceClass = DispatchQoS.QoSClass.background
    static let backgroundQueue = DispatchQueue.global(qos: QueueConfig.qualityOfServiceClass)
}



