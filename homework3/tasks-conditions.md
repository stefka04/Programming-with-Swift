## [Задачи:](https://github.com/SwiftFMI/swift_2024_2025/blob/main/homework/Swift-%D0%94%D0%BE%D0%BC%D0%B0%D1%88%D0%BD%D0%BE-3.md)

1. Да се имплементира шаблонен свързан списък със съответния интерфейс. 
```swift 
    class List<T> {
        var value: T
        var next: List<T>?
    }

    extension List {
        subscript(index: Int) -> T? {
        //TODO: implementation
        }
    }

    extension List {
        var length: Int {
        //TODO: implementation
        }
    }

    extension List {
        func reverse() {
        //TODO: implementation
        }
    }
```

2. Да се имплемeнтира следната функция, която премахва еднаквите елементи от списък. Т.е. списъка съдържа само различни елементи.

```swift 
    extension List {
        func toSet() {
        //TODO: implementation
        }
    }
```

3. Да се имплемeнтира функция, която от списък от вложени списъци (може да решите задачата и за произволно ниво на влагане) генерира списък с всички елементи.

```swift 
    extension List {
        func flatten() -> List {
        //TODO: implementation
        }
    }
```
Пример:
```swift 
    List<Any>(List<Int>(2, 2), 21, List<Any>(3, List<Int>(5, 8))).flatten()

    List(2, 2, 21, 3, 5, 8)
```
