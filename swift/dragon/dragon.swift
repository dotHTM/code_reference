#!/usr/bin/swift

import Foundation
// import UIKit

class PaperFoldedStrip{
    var foldLists : [[Bool]] = []
    var currentIteration : Int {
        get{ return foldLists.count }
    }
    func flatFoldList(_ thruIteration: Int) -> [Bool]{
        var result : [Bool] = []
        result.reserveCapacity(
            2^currentIteration-1)
        if thruIteration <= currentIteration {
            foldLists[0..<thruIteration].forEach({ result.append(contentsOf: $0) })
        }
        return result
    }
    func flatFoldList() -> [Bool] {
        return flatFoldList(currentIteration)
    }
}

class PaperFractal : PaperFoldedStrip{
    func nextIteration(){
        foldLists.append([true])
    }
    
    func iterationUpTo(someIteration: Int)
    { while someIteration > currentIteration { nextIteration() } }
    
    init(_ startingIteration: Int){
        super.init()
        iterationUpTo(someIteration: startingIteration)
    }
    override init(){}
}

class DragonFractal: PaperFractal{
    override func nextIteration(){
        var newFolds = [true]
        foldLists.joined().reversed().forEach({newFolds.append(!$0)})
        foldLists.append(newFolds)
    }
}

// class TriangleFractal: PaperFractal{
//     override func nextIteration(){
//         var newFolds = [true]
//         if currentIteration % 2 == 1 {
//             newFolds = [false]
//         }
//         foldLists.joined().reversed().forEach({newFolds.append(!$0)})
//         foldLists.append(newFolds)
//     }
// }

let someDragon = DragonFractal()

var startTime : Double

let maxIteration = 32
print("calculating fractal up to", maxIteration)
startTime = Date().timeIntervalSince1970
someDragon.iterationUpTo(someIteration: maxIteration)
print("Calculated in " + String(Date().timeIntervalSince1970 - startTime ))

print("----")
print("Current itteration")
startTime = Date().timeIntervalSince1970
print( " ",someDragon.currentIteration)
print("Accessed in " + String(Date().timeIntervalSince1970 - startTime ))

print("----")
print("length of flatfoldlist")
startTime = Date().timeIntervalSince1970
print( " ",someDragon.flatFoldList().count)
print("Accessed in " + String(Date().timeIntervalSince1970 - startTime ))

print("----")
print( "2 ^ iteration" )
startTime = Date().timeIntervalSince1970
print( " ", pow(2, someDragon.currentIteration) )
print("Accessed in " + String(Date().timeIntervalSince1970 - startTime ))

