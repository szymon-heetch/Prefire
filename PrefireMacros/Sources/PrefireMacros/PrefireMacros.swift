@attached(member, names: named(userStory), arbitrary)
public macro UserStory(_ value: String) = #externalMacro(module: "Macros", type: "UserStoryMacro")
