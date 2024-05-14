import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(Macros)
import Macros

let testMacros: [String: Macro.Type] = [
    "UserStory": UserStoryMacro.self
]
#endif

final class PrefireMacrosTests: XCTestCase {
    func testUserStoryMacro() {
        #if canImport(Macros)
        assertMacroExpansion(
            """
            @UserStory("HappyPath")
            struct SampleStruct {
            }
            """,
            expandedSource: 
            """
            struct SampleStruct {

                static let userStory: String = "HappyPath"
            }
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
}
