protocol Fillable {
  var color: String { set get }
}

protocol VisualComponent: Fillable {
  var boundingBox: Rect { get }
  var parent: VisualComponent? { get }
  func draw()

  func isEqualTo(other: VisualComponent) -> Bool
  func addParent(parent: VisualComponent)
}

protocol VisualGroup: VisualComponent {
  var numChildren: Int { get }
  var children: [VisualComponent] { get }
  mutating func add(child: VisualComponent)
  mutating func remove(child: VisualComponent)
  mutating func removeChild(at: Int)

  func isEqualTo(other: VisualComponent) -> Bool
}

struct Point: Equatable {
  var x: Double
  var y: Double

}

struct Rect: Equatable {
  var top: Point
  var width: Double
  var height: Double

  init(x: Double, y: Double, width: Double, height: Double) {
    top = Point(x: x, y: y)
    self.width = width
    self.height = height
  }

  init() {
    self.init(x: 0, y: 0, width: 0, height: 0)
  }
}

class Triangle: VisualComponent {
  var a: Point
  var b: Point
  var c: Point
  var color: String
  var boundingBox: Rect
  var parent: VisualComponent?

  init(a: Point, b: Point, c: Point, color: String) {
    self.a = a
    self.b = b
    self.c = c
    self.color = color

    self.boundingBox = Rect()
    self.boundingBox.top.x = min(a.x, b.x, c.x)
    self.boundingBox.top.y = min(a.y, b.y, c.y)
    self.boundingBox.height = max(a.y, b.y, c.y) - min(a.y, b.y, c.y)
    self.boundingBox.width = max(a.x, b.x, c.x) - min(a.x, b.x, c.x)
  }

  func addParent(parent: VisualComponent) {
    self.parent = parent
  }

  func draw() {
    /*print(
      "Triangle(a: \(a), b: \(b), c: \(c), color:\(color))"
    )
    print(
      "BoundingBox(top: \(boundingBox.top), height: \(boundingBox.height), width: \(boundingBox.width))"
    )

    if let parent: VisualComponent {
      print("Parent: \(parent)")
    }*/
  }

  func isEqualTo(other: VisualComponent) -> Bool {
    if let other = other as? Triangle {
      return self.color == other.color && self.boundingBox == other.boundingBox && self.a == other.a
        && self.b == other.b && self.c == other.c
    }
    return false
  }
}

class Rectangle: VisualComponent {
  var x: Int
  var y: Int
  var width: Int
  var height: Int
  var color: String
  var boundingBox: Rect
  var parent: VisualComponent?

  init(x: Int, y: Int, width: Int, height: Int, color: String) {
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.color = color

    self.boundingBox = Rect(
      x: Double(x), y: Double(y), width: Double(width), height: Double(height))
  }

  init(x: Double, y: Double, width: Double, height: Double, color: String) {
    self.x = Int(x)
    self.y = Int(y)
    self.width = Int(width)
    self.height = Int(height)
    self.color = color

    self.boundingBox = Rect(
      x: x, y: y, width: width, height: height)
  }

  func addParent(parent: VisualComponent) {
    self.parent = parent
  }

  func draw() {
    /* print(
      "Rectangle(x: \(x), y: \(y), width: \(width), height:\(height), color:\(color),"
    )

    print(
      "BoundingBox(top: \(boundingBox.top), height: \(boundingBox.height), width: \(boundingBox.width))"
    )

    if let parent: VisualComponent {
      print("Parent: \(parent)")
    }*/
  }

  func isEqualTo(other: VisualComponent) -> Bool {
    if let other = other as? Rectangle {
      return self.color == other.color && self.boundingBox == other.boundingBox && self.x == other.x
        && self.y == other.y && self.width == other.width && self.height == other.height
    }
    return false
  }
}

class Circle: VisualComponent {
  var x: Int
  var y: Int
  var r: Double
  var color: String
  var boundingBox: Rect
  var parent: VisualComponent?
  init(x: Int, y: Int, r: Double, color: String) {
    self.x = x
    self.y = y
    self.r = r
    self.color = color

    self.boundingBox = Rect(x: Double(x) - r, y: Double(y) - r, width: 2 * r, height: 2 * r)
  }

   init(x: Double, y: Double, r: Double, color: String) {
    self.x = Int(x)
    self.y = Int(y)
    self.r = r
    self.color = color

    self.boundingBox = Rect(x:x - r, y: y - r, width: 2 * r, height: 2 * r)
  }

  func addParent(parent: VisualComponent) {
    self.parent = parent
  }

  func draw() {
    /* print(
      "Circle(x: \(x), y: \(y), r: \(r), color:\(color),)")

    print(
      "BoundingBox(top: \(boundingBox.top), height: \(boundingBox.height), width: \(boundingBox.width))"
    )

    if let parent: VisualComponent {
      print("Parent: \(parent)")
    }*/
  }
  func isEqualTo(other: VisualComponent) -> Bool {
    if let other = other as? Circle {
      return self.color == other.color && self.boundingBox == other.boundingBox && self.x == other.x
        && self.y == other.y && self.r == other.r
    }
    return false
  }
}

class Path: VisualComponent {
  var points: [Point]
  var color: String
  var boundingBox: Rect
  var parent: VisualComponent?

  init(points: [Point], color: String) {
    self.points = points
    self.color = color

    var maxPointY = -Double.greatestFiniteMagnitude
    var minPointY = Double.greatestFiniteMagnitude

    var minPointX = Double.greatestFiniteMagnitude
    var maxPointX = -Double.greatestFiniteMagnitude
    for point in points {
      minPointX = min(minPointX, point.x)
      maxPointX = max(maxPointX, point.x)

      minPointY = min(minPointY, point.y)
      maxPointY = max(maxPointY, point.y)
    }
    self.boundingBox = Rect(
      x: minPointX, y: minPointY, width: maxPointX - minPointX, height: maxPointY - minPointY)
  }

  func addParent(parent: VisualComponent) {
    self.parent = parent
  }

  func draw() {
    /*print("Points: \(points) color:\(color)")
    print(
      "BoundingBox(top: \(boundingBox.top), height: \(boundingBox.height), width: \(boundingBox.width))"
    )

    if let parent: VisualComponent {
      print("Parent: \(parent)")
    }*/
  }

  func isEqualTo(other: VisualComponent) -> Bool {
    if let other = other as? Path {
      return self.color == other.color && self.boundingBox == other.boundingBox
        && self.points == other.points
    }
    return false
  }
}

class HStack: VisualGroup {
  var children: [VisualComponent]
  var color: String
  var parent: VisualComponent?

  var numChildren: Int {
    return children.count
  }

var boundingBox: Rect {
    if children.isEmpty {
      return Rect()
    }
    var minX = Double.greatestFiniteMagnitude
    var minY = Double.greatestFiniteMagnitude

    let alignedX = children[0].boundingBox.top.x
    let alignedY = children[0].boundingBox.top.y

    var width = 0.0
    var height = 0.0
    var currentX = 0.0
    for child in children {
      minX = min(minX, currentX)
      minY = min(minY, child.boundingBox.top.y, 0)
      currentX += child.boundingBox.width

      height = max(height, child.boundingBox.height)
      width += child.boundingBox.width
    }

    //return Rect(x: alignedX, y: alignedY, width: width, height: height)
    return Rect(x: 0, y: 0, width: width, height: height)
    //return Rect(x: minX, y: minY, width: width, height: height)
  }
  /*var boundingBox: Rect {
    if children.isEmpty {
      return Rect()
    }
    var minX = Double.greatestFiniteMagnitude
    var minY = Double.greatestFiniteMagnitude

    var width = 0.0
    var height = 0.0
    var currentX = 0.0
    for child in children {
      let alignedBox = Rect(
        x: currentX, y: 0, width: child.boundingBox.width, height: child.boundingBox.height)
      minX = min(minX, alignedBox.top.x)
      minY = min(minY, alignedBox.top.y)
      currentX += alignedBox.width

      height = max(height, child.boundingBox.height)
      width += child.boundingBox.width
    }

    return Rect(x: minX, y: minY, width: width, height: height)
  }*/

  init() {
    self.children = []
    self.color = "transparent"
  }

  func add(child: VisualComponent) {
    children.append(child)
    child.addParent(parent: self)
  }

  func remove(child: VisualComponent) {
    var index = 0
    for currentChild in children {
      if child.isEqualTo(other: currentChild) {
        removeChild(at: index)
        break
      }
      index += 1
    }
  }

  func removeChild(at: Int) {
    if at >= 0 && at < children.count {
      children.remove(at: at)
    }
  }

  func addParent(parent: VisualComponent) {
    self.parent = parent
  }

  func draw() {
    /*for child in children {
      child.draw()
    }
    print(
      "HStack: BoundingBox: x:\(boundingBox.top.x), y: \(boundingBox.top.y) , width: \(boundingBox.width), height:\(boundingBox.height)"
    )*/
  }

  func isEqualTo(other: VisualComponent) -> Bool {
    if let other = other as? HStack {
      if self.color == other.color && self.boundingBox == other.boundingBox
        && self.numChildren == other.numChildren
      {
        var index: Int = 0
        for child in other.children {
          if !self.children[index].isEqualTo(other: child) {
            return false
          }
          index += 1
        }
      }
    }
    return false
  }
}

class VStack: VisualGroup {
  var children: [VisualComponent]
  var color: String
  var parent: VisualComponent?

  var numChildren: Int {
    return children.count
  }

  var boundingBox: Rect {
    var minX = Double.greatestFiniteMagnitude
    var maxX = -Double.greatestFiniteMagnitude
    var minY = Double.greatestFiniteMagnitude

    var height = 0.0

    var currentY = 0.0
    var width = 0.0
    for child in children {
      let alignedBox = Rect(
        x: 0.0, y: currentY, width: child.boundingBox.width, height: child.boundingBox.height)

      minX = min(minX, alignedBox.top.x)
      minY = min(minY, alignedBox.top.y)

      maxX = max(maxX, child.boundingBox.top.x + child.boundingBox.width)

      currentY += alignedBox.height

      width = max(width, child.boundingBox.width)
      height += child.boundingBox.height
    }
    return Rect(x: minX, y: minY, width: width, height: height)
  }

  init() {
    self.children = []
    self.color = "transparent"
  }

  func add(child: VisualComponent) {
    children.append(child)

    child.addParent(parent: self)
  }

  func remove(child: VisualComponent) {
    var index = 0
    for currentChild in children {
      if child.isEqualTo(other: currentChild) {
        removeChild(at: index)
        break
      }
      index += 1
    }
  }

  func removeChild(at: Int) {
    if at >= 0 && at < children.count {
      children.remove(at: at)
    }
  }
  func addParent(parent: VisualComponent) {
    self.parent = parent
  }

  func draw() {
    /*for child in children {
      child.draw()
    }
    print(
      "VStack: BoundingBox: x:\(boundingBox.top.x), y: \(boundingBox.top.y) , width: \(boundingBox.width), height:\(boundingBox.height)"
    )*/
  }

  func isEqualTo(other: VisualComponent) -> Bool {
    if let other = other as? VStack {
      if self.color == other.color && self.boundingBox == other.boundingBox
        && self.numChildren == other.numChildren
      {
        var index: Int = 0
        for child in other.children {
          if !self.children[index].isEqualTo(other: child) {
            return false
          }
          index += 1
        }
      }
    }
    return false
  }
}

class ZStack: VisualGroup {
  var children: [VisualComponent]
  var color: String
  var parent: VisualComponent?

  var numChildren: Int {
    return children.count
  }

  var boundingBox: Rect {
    var minX = Double.greatestFiniteMagnitude
    var maxX = -Double.greatestFiniteMagnitude
    var minY = Double.greatestFiniteMagnitude
    var maxY = -Double.greatestFiniteMagnitude

    for child in children {
      minX = min(minX, child.boundingBox.top.x)
      maxX = max(maxX, child.boundingBox.top.x + child.boundingBox.width)

      minY = min(minY, child.boundingBox.top.y)
      maxY = max(maxY, child.boundingBox.top.y + child.boundingBox.width)
    }
    return Rect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
  }

  init() {
    self.children = []
    self.color = "transparent"
  }

  func add(child: VisualComponent) {
    children.append(child)

    child.addParent(parent: self)
  }

  func remove(child: VisualComponent) {
    var index = 0
    for currentChild in children {
      if child.isEqualTo(other: currentChild) {
        removeChild(at: index)
        break
      }
      index += 1
    }
  }

  func removeChild(at: Int) {
    if at >= 0 && at < children.count {
      children.remove(at: at)
    }
  }
  func addParent(parent: VisualComponent) {
    self.parent = parent
  }

  func draw() {
    /* for child in children {
      child.draw()
    }
    print(
      "ZStack: BoundingBox: x:\(boundingBox.top.x), y: \(boundingBox.top.y), width: \(boundingBox.width), height:\(boundingBox.height)"
    )*/
  }

  func isEqualTo(other: VisualComponent) -> Bool {
    if let other = other as? ZStack {
      if self.color == other.color && self.boundingBox == other.boundingBox
        && self.numChildren == other.numChildren
      {
        var index: Int = 0
        for child in other.children {
          if !self.children[index].isEqualTo(other: child) {
            return false
          }
          index += 1
        }
      }
    }
    return false
  }
}

func cover(root: VisualComponent?) -> Rect {
  if let root: VisualComponent = root {
    return root.boundingBox
  }
  return Rect()
}