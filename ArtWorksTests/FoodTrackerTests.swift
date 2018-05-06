import XCTest
@testable import ArtWorks

class FoodTrackerTests: XCTestCase {
    func testInitFail(){
        let emptyString = ArtWork.init(name: "", description: "desc", genre: "genre", year: "year", image: nil)
        XCTAssertNil(emptyString)
    }
}
