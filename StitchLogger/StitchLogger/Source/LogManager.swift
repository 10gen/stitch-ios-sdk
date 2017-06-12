//
//  LogManager.swift
//  StitchLogger
//
//  Created by Ofer Meroz on 22/03/2017.
//  Copyright © 2017 MongoDB. All rights reserved.
//

import Foundation

private let prefix = "[🍃Mongo🍃]"

public enum LogLevel: Int, CustomStringConvertible {
    case trace, debug, info, warning, error, none
    
    public var description: String {
        switch self {
        case .trace:
            return "Trace"
        case .debug:
            return "Debug"
        case .info:
            return "Info"
        case .warning:
            return "Warning"
        case .error:
            return "Error"
        case .none:
            return "None"
        }
    }
}

public struct LogManager {
    public static var minimumLogLevel = LogLevel.none
}

public func printLog<T>(_ logLevel : LogLevel, text: T, _ file: String = #file, _ function: String = #function, _ line: Int = #line){
    
    if LogManager.minimumLogLevel.rawValue <= logLevel.rawValue {
        let filename = (file as NSString).lastPathComponent
        print("\(prefix):[\(String(describing: logLevel))]: \(filename).\(function)[\(line)]: \(text)")
    }
}
