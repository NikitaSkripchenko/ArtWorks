import XCTest
@testable import ArtWorks

class ArtWorksTests: XCTestCase {
    func testInitFail(){
        let emptyString = ArtWork.init(name: "", descriptionT: "desc", genre: "genre", year: "year", image: nil)
        XCTAssertNil(emptyString)
    }
}
