import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

@main
struct PrefireMacrosPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        UserStoryMacro.self
    ]
}
