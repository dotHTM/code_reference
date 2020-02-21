#!/usr/bin/swift

import Foundation
// import UIKit


// ######### // ######### // ######### // ######### // ######### // ######### 

typealias FoldList = [Bool]
let emptyFoldList : FoldList = []
typealias FoldListRule =  (FoldList)->FoldList

// ######### // ######### // ######### 

func dragonRule(foldList: FoldList)->FoldList{
  return foldList + [true] + foldList.reversed().map{!$0}
} //dragonRule

func triangleRule(foldList: FoldList)->FoldList{
   var result = foldList
  var insertTurn : Bool = true
  result.append(insertTurn)
  for someFold in foldList
  {
        insertTurn = !insertTurn
      result.append(someFold)
        result.append(insertTurn)
  }
  return result
} //triangleRule

func metaRule(_ array : [FoldListRule])->FoldListRule{
  return { foldList in 
    var result = foldList
    array.forEach{ rule in result = rule(result)}
    return result
  }
} // metaRule


// ######### // ######### // ######### // ######### // ######### // ######### 

struct PaperFractal {
  let foldList: FoldList
  let iteration: Int
  
  init(){ 
    foldList = []
    iteration = 0
   }
  init(foldList input_foldList: FoldList, iteration input_iteration: Int){ 
    foldList = input_foldList
    iteration = input_iteration
   }
   
   static let identity = PaperFractal(foldList: [true], iteration : 0)
   static let notIdentity = PaperFractal(foldList: [false], iteration : 0)
}
typealias PaperFractalStep = (PaperFractal)->PaperFractal

// ######### // ######### // ######### 

func stepResult(_ pastState: PaperFractal, foldList: FoldList)->PaperFractal{
  return PaperFractal(
      foldList:  foldList,
      iteration: pastState.iteration + 1
    )
} // stepResult

func createStepper(rule : @escaping FoldListRule) -> PaperFractalStep {
  return { pastState in return stepResult(pastState, foldList: rule( pastState.foldList ) )}
} // createStepper

func iterate(_ pastState: PaperFractal, withRule input_rule: @escaping FoldListRule, times: Int)->PaperFractal{
  var result = pastState 
  Array(1...times).map{_ in input_rule }.forEach{ 
    stepRule in 
    let stepper = createStepper(rule: stepRule )
    result = stepper(result)
  }
  return result
}

func iterate(_ pastState: PaperFractal, withRuleArray input_rule_array: [FoldListRule])->PaperFractal{
  var result = pastState 
  input_rule_array.forEach{ 
    stepRule in 
    let stepper = createStepper(rule: stepRule )
    result = stepper(result)
  }
  return result
}


func turnNumber(_ pastState: PaperFractal, withRule input_rule: @escaping FoldListRule, number: Int)->Bool{
  if number <= pastState.foldList.count { return pastState.foldList[number-1] }
  let stepper = createStepper(rule: input_rule )
  return turnNumber( stepper(pastState), withRule: input_rule, number: number)
}

// ######### // ######### // ######### // ######### // ######### // ######### 

func main(maxIteration : Int){
  let rule = metaRule([dragonRule, triangleRule, dragonRule, triangleRule])
  
  print("calculating fractal up to", maxIteration)
  let maxIteration_startTime = Date().timeIntervalSince1970
  let df = iterate(PaperFractal(), withRule: rule, times: maxIteration)
  // print(df.foldList)
  print("Calculated in " + String(Date().timeIntervalSince1970 - maxIteration_startTime ))

  print("----")
  print("length of foldList")
  let foldList_startTime = Date().timeIntervalSince1970
  let lastTurnNumber = df.foldList.count
  print( " ", lastTurnNumber)
  print("Accessed in " + String(Date().timeIntervalSince1970 - foldList_startTime ))

  print("----")
  print("turn number \(lastTurnNumber)")
  let turnNumber_startTime = Date().timeIntervalSince1970
  print("   is \( turnNumber(PaperFractal(), withRule: rule, number: lastTurnNumber ) )")
  print("Accessed in " + String(Date().timeIntervalSince1970 - turnNumber_startTime ))
} // main

main(maxIteration: 6)
