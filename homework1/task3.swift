import Foundation

	protocol Maze {
		init(raw: [[String]])
    mutating func dfs(element: MazeElement, pathsCount: inout Int)
	}
	
  struct MazeElement {
    var row: Int
    var col: Int
    
   init(row: Int = 0, col: Int = 0) {
    self.row = row
    self.col = col
   }
  }

  extension MazeElement: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(row)
        hasher.combine(col)
    }

    static func ==(left: MazeElement, right: MazeElement) -> Bool {
      return left.row == right.row && left.col == right.col
    }
  }
 
struct MazeGraph : Maze {
    var maze: [[String]]
    var visited: [MazeElement:Bool]
    var startElement: MazeElement

    init(raw: [[String]]) {
      self.maze = raw
      self.visited = [MazeElement(row:0, col:0) : false]
      self.startElement = MazeElement(row:0, col:0)
      for rowIndex in 0..<raw.count {
        for colIndex in 0..<raw[0].count {
         let element: MazeElement = MazeElement(row: rowIndex, col: colIndex)
         visited[element] = false
         if raw[rowIndex][colIndex] == "^" {
          startElement = element
         } 
        }
      }
    }

    mutating func dfs(element: MazeElement, pathsCount: inout Int) {
      if !isValidElement(element: element) {
        return
      }
      if let isVisited:Bool = visited[element] {
        if isVisited {
          return
        }
      }
      visited[element] = true
      if self.maze[element.row][element.col] == "*" {
        pathsCount += 1
      }

      let upElement = MazeElement(row: element.row - 1, col: element.col)
      dfs(element: upElement, pathsCount: &pathsCount)
      let downElement = MazeElement(row: element.row + 1, col: element.col)
      dfs(element: downElement, pathsCount: &pathsCount)
      let leftElement = MazeElement(row: element.row, col: element.col - 1)
      dfs(element: leftElement, pathsCount: &pathsCount)
      let rightElement = MazeElement(row: element.row, col: element.col + 1)
      dfs(element: rightElement, pathsCount: &pathsCount)
    }

    func isValidElement(element: MazeElement) -> Bool {
      return _isValidPos(element: element) && _isPassable(element: element)
    }

    private func _isPassable(element: MazeElement) -> Bool {
      return self.maze[element.row][element.col] != "#" && self.maze[element.row][element.col] != "1"
    }
    private func _isValidPos(element: MazeElement) -> Bool {
      return element.row >= 0 && element.row < self.maze.count
       && element.col >= 0 && element.col < self.maze[0].count
    }
  }


	func findPaths(maze: [[String]]) -> Int {
      var maze: MazeGraph = MazeGraph(raw:maze)
      var pathsCount: Int = 0
      maze.dfs(element: maze.startElement, pathsCount: &pathsCount)
      return pathsCount
    }