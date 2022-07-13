//
//  Callback.swift
//  AmbiguousCodable-Example
//
//  Created by William Boles on 13/07/2022.
//

import Foundation

struct Callback: Codable, Equatable {
    let output: [Output]
    let input: [Input]
}

enum Output: Codable, Equatable {
    case prompt(name: String, value: String)
    case choices(name: String, value: [String])
    case defaultChoice(name: String, value: Int)
    
    enum CodingKeys: String, CodingKey {
        case name
        case value
    }
    
    // MARK: - Decoding

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let name = try container.decode(String.self, forKey: .name)
        
        if name == "prompt" {
            let value = try container.decode(String.self, forKey: .value)
            self = .prompt(name: name, value: value)
        } else if name == "choices" {
            let value = try container.decode([String].self, forKey: .value)
            self = .choices(name: name, value: value)
        } else if name == "defaultChoice" {
            let value = try container.decode(Int.self, forKey: .value)
            self = .defaultChoice(name: name, value: value)
        } else {
            fatalError("Unexpected type encountered")
        }
    }
    
    // MARK: - Encoding
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case .prompt(name: let name, value: let value):
            try container.encode(name, forKey: .name)
            try container.encode(value, forKey: .value)
        case .choices(name: let name, value: let value):
            try container.encode(name, forKey: .name)
            try container.encode(value, forKey: .value)
        case .defaultChoice(name: let name, value: let value):
            try container.encode(name, forKey: .name)
            try container.encode(value, forKey: .value)
        }
    }
}

struct Input: Codable, Equatable {
    let name: String
    let value: Int
}
