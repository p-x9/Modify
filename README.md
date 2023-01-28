# Modify

Swift syntax sugar for modifying properties

## Usage
### Class Type
```swift
let label: UILabel = UILabel()^ // Must specify type
    .text("Hello")
    .textColor(.red)
    .backgroundColor(.blue)
    .modify {
        $0.sizeToFit()
    }
    .text("Hello2")

/* or */

let label = UILabel()
label^=
    .text("Hello")
    .textColor(.red)
    .backgroundColor(.blue)
    .modify {
        $0.sizeToFit()
    }
    .text("Hello2")
```

### Struct Type
```swift
struct Item {
    var text: String = ""
    var number: Int = 0

    mutating func set(text: String) {
        self.text = text
    }
}
```

#### Copy and Assign
Make a copy and assign a value.
The original `item` is not modified.
```swift
let item = Item()
let new: Item = item^　// Must specify type
    .number(2)
    .number(1)
    .text("2")
    .modify {
        $0.set(text: "1")
    }

print(item) // Item(text: "", number: 0)
print(new) // Item(text: "1", number: 1)
```

#### Assign
Assign a value to `item`.
The original `item` is modified.
```swift
var item = Item() // var
item^=
    .number(2)
    .number(1)
    .text("2")
    .modify {
        $0.set(text: "1")
    }

print(item) // Item(text: "1", number: 1)
```
