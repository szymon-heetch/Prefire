import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct UserStoryMacro: MemberMacro {

    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let structDeclaration = declaration.as(StructDeclSyntax.self) else {
            throw MacroError.macroAppliedToUnsupportedDeclaration
        }

        guard let userStory = structDeclaration.attributes.first?
            .as(AttributeSyntax.self)?.arguments?
            .as(LabeledExprListSyntax.self)?.first?.expression
            .as(StringLiteralExprSyntax.self)?.segments.first?
            .as(StringSegmentSyntax.self)?.content.text else {
            throw MacroError.macroArgumentCannotBeEmpty
        }

        guard !userStory.isEmpty else {
            throw MacroError.macroArgumentCannotBeEmpty
        }

        let variable = try VariableDeclSyntax("static let userStory: String = \"\(raw: userStory)\"")
        
        return [DeclSyntax(variable)]
    }
}
