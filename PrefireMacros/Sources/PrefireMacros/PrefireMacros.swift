import Foundation

@attached(extension, names: named(applyUserStory))
@attached(member, names: named(userStory), arbitrary)
public macro UserStory(_ value: String) = #externalMacro(module: "Macros", type: "UserStoryMacro")
