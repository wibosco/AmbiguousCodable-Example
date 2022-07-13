//
//  CallbackTests.swift
//  AmbiguousCodable-ExampleTests
//
//  Created by William Boles on 13/07/2022.
//

import XCTest
@testable import AmbiguousCodable_Example

class CallbackTests: XCTestCase {
    let jsonStr = """
    {
        "type": "ChoiceCallback",
        "output": [
            {
                "name": "prompt",
                "value": "SecondFactorChoice"
            },
            {
                "name": "choices",
                "value": [
                    "Email",
                    "SMS"
                ]
            },
            {
                "name": "defaultChoice",
                "value": 0
            }
        ],
        "input": [
            {
                "name": "IDToken2",
                "value": 0
            }
        ],
        "_id": 5
    }
    """
    
    // MARK: - Tests
    
    // MARK: Decoding

    func test_decodingJSON_typeChangesStructureStaysTheSame() throws {
        let decoded = try JSONDecoder().decode(Callback.self, from: Data(jsonStr.utf8))
        
        let promptOutput = Output.prompt(name: "prompt", value: "SecondFactorChoice")
        let choicesOutput = Output.choices(name: "choices", value: ["Email", "SMS"])
        let defaultOutput = Output.defaultChoice(name: "defaultChoice", value: 0)
        
        let input = Input(name: "IDToken2", value: 0)
        
        let expectedCallback = Callback(output: [promptOutput, choicesOutput, defaultOutput], input: [input])
        
        XCTAssertEqual(decoded, expectedCallback)
    }
    
    // MARK: Encoding
    
    func test_encodingJSON_typeChangesStructureStaysTheSame() throws {
        let promptOutput = Output.prompt(name: "prompt", value: "SecondFactorChoice")
        let choicesOutput = Output.choices(name: "choices", value: ["Email", "SMS"])
        let defaultOutput = Output.defaultChoice(name: "defaultChoice", value: 0)
        
        let input = Input(name: "IDToken2", value: 0)
        
        let callback = Callback(output: [promptOutput, choicesOutput, defaultOutput], input: [input])
        
        let encoded = try JSONEncoder().encode(callback)
        let expectedData = Data("{\"input\":[{\"name\":\"IDToken2\",\"value\":0}],\"output\":[{\"name\":\"prompt\",\"value\":\"SecondFactorChoice\"},{\"name\":\"choices\",\"value\":[\"Email\",\"SMS\"]},{\"name\":\"defaultChoice\",\"value\":0}]}".utf8)
        
        XCTAssertEqual(encoded, expectedData)
    }
}
