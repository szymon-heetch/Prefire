import PrefireMacros

@UserStory("Happy Path")
struct UserStoryExampleStruct {

    let a = "A"
    let b = "B"
}

print("User story for type: \(UserStoryExampleStruct.self) is \(UserStoryExampleStruct.userStory)")
