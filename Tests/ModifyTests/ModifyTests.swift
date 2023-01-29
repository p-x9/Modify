import XCTest
import Modify

struct Item {
    var text: String = ""
    var number: Int = 0

    mutating func set(text: String) {
        self.text = text
    }
}

final class ModifyTests: XCTestCase {
    func testCopyAndAssign() throws {
        let item = Item()
        let new: Item = item^
            .number(2)
            .number(1)
            .text("2")
            .text("1")


        XCTAssertEqual(new.text, "1")
        XCTAssertEqual(new.number, 1)
    }

    func testAssign() throws {
        var item = Item()
        item^=
            .number(2)
            .number(1)
            .text("2")
            .text("1")

        XCTAssertEqual(item.text, "1")
        XCTAssertEqual(item.number, 1)
    }

    func testCopyAndModify() throws {
        let item = Item()
        let new: Item = item^
            .modify {
                $0.set(text: "1")
            }

        XCTAssertEqual(new.text, "1")
    }

    func testModify() throws {
        var item = Item()
        item^=
            .modify {
                $0.set(text: "1")
            }

        XCTAssertEqual(item.text, "1")
    }
}

