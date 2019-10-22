import XCTest

import EncodingsTests
import NetworkStructuresTests
import SpellingNetworksTests

var tests = [XCTestCaseEntry]()
tests += EncodingsTests.__allTests()
tests += NetworkStructuresTests.__allTests()
tests += SpellingNetworksTests.__allTests()

XCTMain(tests)
