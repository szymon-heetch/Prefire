import PrefireMacros
import SwiftUI


struct ItemPreviewView: View {
    let a = "A"
    let b = "B"

    var body: some View {
        Text("\(a) and \(b)")
    }
}

extension String {
    static let happyPath: String = "Happy Path"
}

@UserStory(.happyPath)
struct Item_Previews: PreviewProvider {
    static var previews: some View {
        ItemPreviewView()
    }
}

@UserStory(String.happyPath)
struct Item_A_Previews: PreviewProvider {
    static var previews: some View {
        ItemPreviewView()
    }
}

@UserStory("Happy Path")
struct Item_B_Previews: PreviewProvider {
    static var previews: some View {
        ItemPreviewView()
    }
}

print("User story for type: \(Item_Previews.self) is \(Item_Previews.userStory)")

print("User story for type: \(Item_A_Previews.self) is \(Item_A_Previews.userStory)")

print("User story for type: \(Item_B_Previews.self) is \(Item_B_Previews.userStory)")
