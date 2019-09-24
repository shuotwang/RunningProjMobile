//
//  NeuralNetwork.swift
//  PureformiPad
//
//  Created by Joe Lao on 8/6/2018.
//  Copyright © 2018 Zhi-I Yeung. All rights reserved.
//

import Foundation
import Accelerate

public class NeuralNetwork {
    
    public struct NetworkData {
        let inputOffset: [Float]
        let inputGain: [Float]
        let inputYMin: Float
        
        let layer1Bias: [Float]
        let layer1Weight: [Float]
        let layer2Bias: [Float]
        let layer2Weight: [Float]
        
        let outputOffset: Float
        let outputGain: Float
        let outputYMin: Float
    }
    
    var data: NetworkData
    var inputFilter: BNNSFilter!
    var outputFilter: BNNSFilter!
    
    init(data: NetworkData) {
        self.data = data
        self.constructNetwork()
    }
    
    public func constructNetwork() {
        let tansig = BNNSActivation(function: .tanh, alpha: 0, beta: 0)
        let identity = BNNSActivation(function: .identity, alpha: 0, beta: 0)
        
        let layer1WeightData = BNNSLayerData(data: data.layer1Weight, data_type: .float, data_scale: 0, data_bias: 0, data_table: nil)
        let layer1BiasData = BNNSLayerData(data: data.layer1Bias, data_type: .float, data_scale: 0, data_bias: 0, data_table: nil)
        var layer1Params = BNNSFullyConnectedLayerParameters(in_size: data.inputOffset.count, out_size: data.layer1Bias.count, weights: layer1WeightData, bias: layer1BiasData, activation: tansig)
        var inputDescripter = BNNSVectorDescriptor(size: data.inputOffset.count, data_type: .float, data_scale: 0, data_bias: 0)
        
        var hiddenDescripter = BNNSVectorDescriptor(size: data.layer1Bias.count, data_type: .float, data_scale: 0, data_bias: 0)
        
        let layer2WeightData = BNNSLayerData(data: data.layer2Weight, data_type: .float, data_scale: 0, data_bias: 0, data_table: nil)
        let layer2BiasData = BNNSLayerData(data: data.layer2Bias, data_type: .float, data_scale: 0, data_bias: 0, data_table: nil)
        var layer2Params = BNNSFullyConnectedLayerParameters(in_size: data.layer1Bias.count, out_size: data.layer2Bias.count, weights: layer2WeightData, bias: layer2BiasData, activation: identity)
        var outputDescripter =  BNNSVectorDescriptor(size: data.layer2Bias.count, data_type: .float, data_scale: 0, data_bias: 0)
        
        self.inputFilter = BNNSFilterCreateFullyConnectedLayer(&inputDescripter, &hiddenDescripter, &layer1Params, nil)
        self.outputFilter = BNNSFilterCreateFullyConnectedLayer(&hiddenDescripter, &outputDescripter, &layer2Params, nil)
    }
    
    public func predict(input: [Float]) -> Float {
        let adjustedInput = mapMinMaxApply(X: input, offset: data.inputOffset, gain: data.inputGain, yMin: data.inputYMin)
        
        var hidden: [Float] = Array(repeating: 0, count: data.layer1Bias.count)
        var output: [Float] = Array(repeating: 0, count: data.layer2Bias.count)
        
        if BNNSFilterApply(inputFilter, adjustedInput, &hidden) != 0 {
            print("Hidden Layer failed.")
        }
        
        if BNNSFilterApply(outputFilter, hidden, &output) != 0 {
            print("Output Layer failed.")
        }
        
        let result = mapMinMaxReverse(output: output[0], offset: data.outputOffset, gain: data.outputGain, yMin: data.outputYMin)
        
        return result
    }
    
    private func mapMinMaxApply(X:[Float], offset:[Float], gain:[Float], yMin: Float) -> [Float] {
        var result = [Float]()
        for i in 0..<X.count {
            let temp = (X[i] - offset[i]) * gain[i] + yMin
            result.append(temp)
        }
        return result
    }
    
    private func mapMinMaxReverse(output:Float, offset:Float, gain:Float, yMin: Float) -> Float {
        return (output - yMin) / gain + offset
    }
    
}
