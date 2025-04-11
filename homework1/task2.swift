import Foundation

func mySubstring(source: String, from: Int, to: Int) -> String {
  var result:String = ""
  var index:Int = 0
  for currentChar in source {
    if index >= from && index <= to {
      result.insert(currentChar, at:result.endIndex)
    }
    index += 1
  }
  return result
}

func evaluateHelper(expression: inout String) -> Double {
  if let res = Double(expression) {
    return res
  }
  var index:Int = 0
  var bracketsCount:Int = 0
  expression = mySubstring(source: expression, from: 1, to: expression.count - 2)
  for current in expression {
    if current == "(" {
      bracketsCount += 1
    } else if current == ")" {
      bracketsCount -= 1
    } else if bracketsCount == 0 && !current.isNumber && !current.isWhitespace {
      var left: String =  mySubstring(source: expression, from: 0, to: index - 2) 
      let leftEvaluated: Double = evaluateHelper(expression: &left)
  
      var right: String =  mySubstring(source: expression, from: index + 2, to: expression.count - 1) 
      let rightEvaluated: Double = evaluateHelper(expression: &right)
    
      switch current {
      case "^" : return pow(leftEvaluated, rightEvaluated)
      case "+" : return leftEvaluated + rightEvaluated
      case "-" : return leftEvaluated - rightEvaluated
      case "*" : return leftEvaluated * rightEvaluated
      case "/" : return leftEvaluated / rightEvaluated
      default: return 0.0  
     }
    }
    index += 1
  }
  return 0.0
}

//function that calculates an equation 
func evaluate(expression: String) -> Double {
    var toEvaluate: String = expression
    return evaluateHelper(expression: &toEvaluate)
}