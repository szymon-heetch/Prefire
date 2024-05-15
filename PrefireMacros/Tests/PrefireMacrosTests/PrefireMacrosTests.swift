import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(Macros)
@testable import Macros

let testMacros: [String: Macro.Type] = [
    "UserStory": UserStoryMacro.self
]
#endif

final class PrefireMacrosTests: XCTestCase {
    func testUserStoryMacroWithStringLiteral() {
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

            extension SampleStruct {
                static func applyUserStory() -> some View {
                    previews
                        .previewUserStory(Self.userStory)
                }
            }
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }

    func testUserStoryMacroWithEmptyStringLiteral() {
        #if canImport(Macros)
        assertMacroExpansion(
            """
            @UserStory("")
            struct SampleStruct {
            }
            """,
            expandedSource:
            """
            struct SampleStruct {
            }
            """,
            diagnostics: [
                DiagnosticSpec(message: MacroError.macroArgumentCannotBeEmpty.description, line: 1, column: 1),
                DiagnosticSpec(message: MacroError.macroArgumentCannotBeEmpty.description, line: 1, column: 1)
            ],
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }

    func testUserStoryMacroForStringConstantWithDot() {
        #if canImport(Macros)
        assertMacroExpansion(
            """
            extension String {
                static let happyPath: String = "Happy Path"
            }

            @UserStory(.happyPath)
            struct SampleStruct {
            }
            """,
            expandedSource:
            """
            extension String {
                static let happyPath: String = "Happy Path"
            }
            struct SampleStruct {

                static let userStory: String = .happyPath
            }

            extension SampleStruct {
                static func applyUserStory() -> some View {
                    previews
                        .previewUserStory(Self.userStory)
                }
            }
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }

    func testUserStoryMacroForStringConstantWithFullSpecification() {
        #if canImport(Macros)
        assertMacroExpansion(
            """
            extension String {
                static let happyPath: String = "Happy Path"
            }

            @UserStory(String.happyPath)
            struct SampleStruct {
            }
            """,
            expandedSource:
            """
            extension String {
                static let happyPath: String = "Happy Path"
            }
            struct SampleStruct {

                static let userStory: String = String.happyPath
            }

            extension SampleStruct {
                static func applyUserStory() -> some View {
                    previews
                        .previewUserStory(Self.userStory)
                }
            }
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }

    func testUserStoryMacroToAddAutomaticSwiftUIModifier() {
        #if canImport(Macros)
        assertMacroExpansion(
            """
            extension String {
                static let happyPath: String = "Happy Path"
            }

            @UserStory(.happyPath)
            @available(iOS 15.0, *)
            struct SampleStruct {
                static var previews: some View {
                    ItemPreviewView()
                        .previewLayout(.sizeThatFits)
                        .customModifier(.customValue)
                }
            }
            """,
            expandedSource:
            """
            extension String {
                static let happyPath: String = "Happy Path"
            }
            @available(iOS 15.0, *)
            struct SampleStruct {
                static var previews: some View {
                    ItemPreviewView()
                        .previewLayout(.sizeThatFits)
                        .customModifier(.customValue)
                }

                static let userStory: String = .happyPath
            }

            @available(iOS 15.0, *) extension SampleStruct {
                static func applyUserStory() -> some View {
                    previews
                        .previewUserStory(Self.userStory)
                }
            }
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
}



