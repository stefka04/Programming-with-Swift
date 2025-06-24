import Foundation

class List<T> {
  var value: T
  var next: List<T>?

  init(_ items: Any...) {
    self.value = items[0] as! T

    if items.count == 1 {
      return
    }

    var itemsTemp = items
    itemsTemp.removeFirst()

    var currentElement = self
    for item in itemsTemp {
      currentElement.next = List<T>(item)
      currentElement = currentElement.next!
    }
  }
}

extension List {
  subscript(index: Int) -> T? {
    if index >= length || index < 0 {
      return nil
    }

    var currentElement = self
    var currentIndex = 0
    while currentElement.next != nil && currentIndex < index {
      currentElement = currentElement.next!
      currentIndex += 1
    }
    if currentIndex == index {
      return currentElement.value
    }
    return nil
  }
}

extension List {
  var length: Int {
    var currentElement = self
    var size = 1
    while currentElement.next != nil {
      currentElement = currentElement.next!
      size += 1
    }
    return size
  }
}

extension List {
  func reverse() {
    if self.length == 1 {
      return
    }
    var currentElement: List<T>? = self
    var elements: [T] = [] 
    while currentElement != nil {
      elements.append(currentElement!.value)
      currentElement = currentElement!.next
    }
    currentElement = self
    var currentIndex = elements.count - 1
    while currentElement != nil {
      currentElement!.value = elements[currentIndex]
      currentElement = currentElement!.next
      currentIndex -= 1
    }
  }
}

extension List where T: Hashable {
  func toSet() {
    var currentElement = self
    var previousElement: List<T>? = nil
    var uniqueElements: Set<T> = []

    while currentElement.next != nil {
      if uniqueElements.contains(currentElement.value) {
        previousElement!.next = currentElement.next
        currentElement = previousElement!.next!
      } else {
        uniqueElements.insert(currentElement.value)
        previousElement = currentElement
        currentElement = currentElement.next!
      }
    }
    if uniqueElements.contains(currentElement.value) {
      previousElement!.next = currentElement.next
    }
  }
}

protocol AnyList {
func flatten() -> List<Any>
}
extension List : AnyList {
    func flatten() -> List<Any> {
        var currentElement:List<T>? = self
        var result = List<Any>(0)

        while currentElement != nil {
          if let inner = currentElement!.value as? AnyList {
            let currentRes = inner.flatten()
            appendToResult(result: &result, toAppend: currentRes)
          } else {
            appendToResult(result: &result, toAppend: List<Any>(currentElement!.value))
          }
          currentElement = currentElement!.next
        }
        return result.next ?? result
    }

    private func appendToResult(result:inout List<Any>, toAppend: List<Any>) {
      var currentElement: List<Any>? = result 
      while currentElement!.next != nil {
        currentElement = currentElement!.next
      }
      currentElement!.next = toAppend
    } 
}