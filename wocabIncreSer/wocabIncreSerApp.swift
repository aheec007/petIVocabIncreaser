//
//  wocabIncreSerApp.swift
//  wocabIncreSer
//
//  Created by alex on 07.08.2023.
//

import SwiftUI
import RealmSwift

/// The main screen that determines whether to present the SyncContentView or the LocalOnlyContentView.
/// For now, it always displays the LocalOnlyContentView.
@main
struct ContentView: SwiftUI.App {
    
    init(){
        let config = Realm.Configuration(
             schemaVersion: 3,
                migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < 1) {

//                    migration.enumerateObjects(ofType: Word.className()) { _, newObject in
//                           newObject!["rareType"] = nil
//
//                    }
                }
        })
        Realm.Configuration.defaultConfiguration = config
        _ = try!Realm()
    }
    
    var body: some Scene {
        WindowGroup {
            LocalOnlyContentView()
        }
    }
}

/// The main content view if not using Sync.
struct LocalOnlyContentView: View {
    @State var searchFilter: String = ""
    // Implicitly use the default realm's objects(ItemGroup.self)
    @ObservedResults(ItemGroup.self) var itemGroups
    
    var body: some View {
        if let itemGroup = itemGroups.first {
            // Pass the ItemGroup objects to a view further
            // down the hierarchy
            ItemsView(itemGroup: itemGroup)
        } else {
            // For this small app, we only want one itemGroup in the realm.
            // You can expand this app to support multiple itemGroups.
            // For now, if there is no itemGroup, add one here.
            ProgressView().onAppear {
                $itemGroups.append(ItemGroup())
            }
        }
    }
}

/// The screen containing a list of items in an ItemGroup. Implements functionality for adding, rearranging,
/// and deleting items in the ItemGroup.
struct ItemsView: View {
    @ObservedRealmObject var itemGroup: ItemGroup
    /// The button to be displayed on the top left.
    var leadingBarButton: AnyView?
    var body: some View {
        NavigationView {
            VStack {
                // The list shows the items in the realm.
                List {
                    ForEach(itemGroup.items) { item in
                        ItemRow(item: item, group: itemGroup)
                    }.onDelete(perform: $itemGroup.items.remove)
                    .onMove(perform: $itemGroup.items.move)
                }
                .listStyle(GroupedListStyle())
                .navigationBarTitle("Words \(itemGroup.items.count)", displayMode: .inline)
                    .navigationBarBackButtonHidden(true)
                    .navigationBarItems(
                        leading: self.leadingBarButton,
                        // Edit button on the right to enable rearranging items
                        trailing: EditButton())
                // Action bar at bottom contains Add button.
                HStack {
                    NavigationLink{
                        WordCardView(group: itemGroup)
                    } label: {
                        Text("Random train")
                    }
                    Spacer()
                    NavigationLink{
                        ItemDetailsView(itemGroup, word: nil )
                    } label: {
                        Text("New Word")
                    }
                }.padding()
            }
        }
    }
}

/// Represents an Item in a list.
struct ItemRow: View {
    @ObservedRealmObject var item: Word
    var group: ItemGroup
    var body: some View {
        // You can click an item in the list to navigate to an edit details screen.
        NavigationLink(destination: ItemDetailsView(group, word: item)) {
            HStack {
                Text(item.name)
                if item.isFavorite {
                    // If the user "favorited" the item, display a heart icon
                    Image(systemName: "heart.fill")
                }
                Spacer()
                Rectangle()
                    .fill(item.rareType.color)
                    .cornerRadius(6)
                    .frame(width: 20, height: 20)
            }
        }
    }
}
