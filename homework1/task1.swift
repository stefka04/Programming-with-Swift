import Foundation 

struct SemanticVersion {
  var major:Int
  var minor:Int
  var patch:Int
  var displayValue: String
  var prereleasePart: String?
  var buildPart: String?
  
  init(major: Int = 0, minor: Int = 0, patch:Int = 0, displayValue: String = "", prereleasePart: String? = nil, buildPart: String? = nil) {
    self.major = major
    self.minor = minor
    self.patch = patch
    self.displayValue = displayValue
    self.prereleasePart = prereleasePart
    self.buildPart = buildPart
  }

  init() {
    self.init(major: 0, minor: 0, patch: 0, displayValue: "", prereleasePart: nil, buildPart: nil)
  }

  mutating func convertFromString(source:String) {
  self.displayValue = source
  let tokensBuild: [String] = source.components(separatedBy: "+")
  let tokensPrerelease: [String] = tokensBuild[0].components(separatedBy: "-")
  
  if tokensBuild.count > 1 {
    self.buildPart = tokensBuild[1]
  }
  if tokensPrerelease.count > 1 {
    self.prereleasePart = tokensPrerelease[1]
  }
  let tokensMainVersion: [String] = tokensPrerelease[0].components(separatedBy: ".")
  var currentIndex: Int = 0
  for currentPart in tokensMainVersion { 
    switch currentIndex {
      case 0: self.major = Int(currentPart)!
      case 1: self.minor = Int(currentPart)!
      case 2: self.patch = Int(currentPart)!
      default: break
    }
    currentIndex += 1
  }
  }

  func compareTo(other: SemanticVersion) -> Int {
    if _compareTо(first: self.major, second: other.major) == 0 {
      if _compareTо(first: self.minor, second: other.minor) == 0 {
        if _compareTо(first: self.patch, second: other.patch) == 0 {

          return _comparePrerelease(first: self.prereleasePart, second: other.prereleasePart)
        } else {
           return _compareTо(first: self.patch, second: other.patch)
        }
      } else {
      return _compareTо(first: self.minor, second: other.minor)
    }
    } else {
      return _compareTо(first: self.major, second: other.major)
    }
  }

  private func _compareTо(first: Int, second: Int) -> Int {
    if first > second {
      return 1
    } else if first < second {
      return -1
    } else { 
      return 0
    }
  }

  private func _comparePrerelease(first: String?, second: String?) -> Int {
    if first == nil && second != nil {
      return 1
    } else if first != nil && second == nil{
      return -1
    } else { 
      return 0
    }
  }
}

func isValidPart(version:String, skipLeadingZeroCheck: Bool) -> Bool {
  let tokens: [String] = version.components(separatedBy: ".")
  for currentPart in tokens {
    if currentPart.isEmpty {
      return false
    } 
    if !skipLeadingZeroCheck && currentPart.first == "0" && currentPart.length > 1 {
      let secondCharIndex = version.index(after: version.startIndex) 
      let current = Int(String(currentPart[secondCharIndex...]))
      if current == nil {
        return false
      }
    }
    for currentChar in currentPart {
    if currentChar != "-" && !currentChar.isLetter && !currentChar.isNumber {
        return false
      }
    }
  }
  return true
}


func isValidVersion(version:String) -> Bool {
  if version.isEmpty {
    return false
  }
  
  let tokens: [String] = version.components(separatedBy: ".")
  if tokens.count > 3 {
    return false
  }
  for currentPart in tokens { 
    if currentPart.first == "0" && currentPart.length > 1 {
      return false
    }
    let current = Int(currentPart)
    if current == nil || current! < 0{
      return false
    }
  }
  return true
}

func getPart(version:String, startSymbol: Character) -> (start: String.Index?, part: String?){
 var part: String? = nil
 let partStartIndex = version.firstIndex(of: startSymbol)
 if let partStart = partStartIndex {
    let secondCharIndex = version.index(after: partStart)
    part = String(version[secondCharIndex...])
  }
 return (partStartIndex, part)
}

func isValidFullVersion(version:String) -> Bool {
  var prerelease: (start: String.Index?, part: String?) = getPart(version: version, startSymbol: "-")
  var build: (start: String.Index?, part: String?) = getPart(version: version,startSymbol: "+")
  
  if let buildStartIndex = build.start {
    if let prereleaseStartIndex = prerelease.start {
      if prereleaseStartIndex > buildStartIndex {
        let versionMain = String(version[..<buildStartIndex])
        return isValidVersion(version: versionMain) && isValidPart(version: build.part!, skipLeadingZeroCheck: true)
      }
      let versionMain = String(version[..<prereleaseStartIndex])
      
      prerelease.part = String(version[..<buildStartIndex])
      build.part = String(version[..<version.endIndex])

      return isValidVersion(version: versionMain) && isValidPart(version: prerelease.part!, skipLeadingZeroCheck: false) && isValidPart(version: build.part!, skipLeadingZeroCheck: true)
   } else {
      let versionMain = String(version[..<buildStartIndex])
      return isValidVersion(version: versionMain) && isValidPart(version: build.part!, skipLeadingZeroCheck: true)
   }
  } else if let prereleaseStartIndex = prerelease.start {
      let versionMain = String(version[..<prereleaseStartIndex])

      return isValidVersion(version: versionMain) && isValidPart(version: prerelease.part!, skipLeadingZeroCheck: false)
   } 
   return isValidVersion(version: version)
}

func findMaxVersion(all: [String]) -> String? {
  var maxVersion: SemanticVersion = SemanticVersion(major: -1, minor: -1, patch: -1)
  for versionStr in all {
    if isValidFullVersion(version: versionStr) {
      var currentVersion : SemanticVersion = SemanticVersion()
      currentVersion.convertFromString(source: versionStr)
      if currentVersion.compareTo(other: maxVersion) == 1 {
        maxVersion = currentVersion
      }
    }
  }
    if maxVersion.major != -1 {                    
      return maxVersion.displayValue
    }
    return nil
}
