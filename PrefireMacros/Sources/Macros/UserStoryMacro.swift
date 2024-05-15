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

        let labeledExprListSyntax = structDeclaration.attributes.first?
            .as(AttributeSyntax.self)?.arguments?
            .as(LabeledExprListSyntax.self)?.first?.expression

        let userStoryStringLiteral = labeledExprListSyntax?
            .as(StringLiteralExprSyntax.self)?.segments.first?
            .as(StringSegmentSyntax.self)?.content.text

        let memberAccessExprSyntax = labeledExprListSyntax?
            .as(MemberAccessExprSyntax.self)

        let propertyBase = memberAccessExprSyntax?.base?
            .as(DeclReferenceExprSyntax.self)?.baseName.text

        let propertySign = memberAccessExprSyntax?.period.text

        let propertyName = memberAccessExprSyntax?.declName
            .as(DeclReferenceExprSyntax.self)?.baseName.text

        let userStoryStaticProperty = [propertyBase, propertySign, propertyName].compactMap { $0 }.joined()

        let userStory: String

        if let userStoryStringLiteral, !userStoryStringLiteral.isEmpty {
            userStory = "\"\(userStoryStringLiteral)\""
        } else {
            userStory = userStoryStaticProperty
        }

        guard !userStory.isEmpty else {
            throw MacroError.macroArgumentCannotBeEmpty
        }

        let variable = try VariableDeclSyntax("static let userStory: String = \(raw: userStory)")
        
        return [DeclSyntax(variable)]
    }
}
