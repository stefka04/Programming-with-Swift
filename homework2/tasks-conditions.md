## [Задачи](https://github.com/SwiftFMI/swift_2024_2025/blob/main/homework/Swift-%D0%94%D0%BE%D0%BC%D0%B0%D1%88%D0%BD%D0%BE-2.md):

Дадени са следните протоколи (интерфейси):

`Fillable`

```swift
    protocol Fillable {
        var color: String { set, get }
    }
```

`VisualComponent`

```swift

    protocol VisualComponent: Fillable {
        //минимално покриващ правоъгълник
         var boundingBox: Rect { get }
         var parent: VisualComponent? { get }
        func draw()
    }
```
`VisualGroup`

```swift
    protocol VisualGroup: VisualComponent {
        //броят деца
         var numChildren: Int { get }
         //списък от всички деца
        var children: [VisualComponent] { get }
        //добавяне на дете
        func add(child: VisualComponent)
        //премахване на дете
        func remove(child: VisualComponent)
        //премахване на дете от съответния индекс - 0 базиран
        func removeChild(at: Int)
    }
```
и следните помощни структури

```swift    
    struct Point {
        var x: Double
        var y: Double
    }
    
    struct Rect {
        //top-left
        var top:Point
        var width: Double
        var height: Double
        
        init(x: Double, y: Double, width: Double, height: Double) {
            top = Point(x: x, y: y)
            self.width = width
            self.height = height
        }
    }
```
1. Да се имплементират следните класове (или структури, _по избор_):
    * `Triangle: VisualComponent `
        * коструктор `Trinagle(a: Point, b: Point, c: Point, color: String)`
    * `Rectangle: VisualComponent `
        * коструктор `Rectangle(x: Int, y: Int, width: Int, height: Int, color: String)`         
    * `Circle: VisualComponent `
        *  конструктор `Circle(x: Int, y:Int, r: Double, color: String)`
    *  `Path: VisualComponent `
        *  конструктор `Path(points: [Point], color: String)`
    * `HStack: VisualGroup`
        *  конструктор `HStack()`
        *  подрежда всички "деца" едно до другобез отстояние. Подравнене от горе. От лява на дясно.
    * `VStack: VisaulGroup`
        *  конструктор `VStack()`
        *  подрежда всички "деца" едно под друго без отстояние. Ляво подравнени. От горе на доло.
    * `ZStack: VisaulGroup`
        *  конструктор `ZStack()`
        *  подрежда всички "деца" едно над друго по координатите спрямо горен ляв ъгъл.

* Функцията `draw` да отпечатва текстова репрезентация на съответната фигура. Тази функция
няма да се използва при оценяването, но може да ви е полезна.

2. Да се имплементира функция, която определя дълбочината на йерархия от `VisualComponent`
	`func depth(root: VisualComponent?) -> Int`
	
	Пример:
	
		Ако	
		root = 
			HStack
				ZStack
					Circle
					VStack 
						Square
						Circle
				Circle
				Circle
		тогава
		depth(root: roоt) трябва да се оцени до 4
3. Да се имплемнтира функция, която определя броят на елементите на дадено ниво в йерархия от `VisualComponent`. 
	`func count(root: VisualComponent?, level: Int) -> Int`
	
	Пример:
	
		Ако	
		level = 2
		root = 
			HStack (red)
				VStack
					Circle (red)
                    ZStack
                        Square
                        Circle (red)
				Circle (green)
				Circle (blue)
		тогава
		count(root: roоt, level: 2) трябва да се оцени до 3 (VStack, Circle, Circle)

4.  Да се напише функция, която намира най-малкия покриващ правоъгълник на `VisualComponent`.
        `func cover(root: VisualComponent?) -> Rect`
        
        Пример:
        
            Ако    
            root = 
                HStack
                    VStack
                        Circle (x:0, y:0, r:1)
                        Circle (x:0, y:0, r:1)
            тогава
            cover(root: roоt) трябва да оцени до Rect(x: 0, y: 0, width: 2, height: 4)
