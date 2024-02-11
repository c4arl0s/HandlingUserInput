# [go back to Overview](https://github.com/c4arl0s)

# [HandlingUserInput - Content](https://github.com/c4arl0s/handlinguserinput#go-back-to-overview)

1. [x] [1. Mark the User’s Favorite Landmarks](https://github.com/c4arl0s/handlinguserinput#1-Mark-the-Users-Favorite-Landmarks)
2. [x] [2. Filter the List View](https://github.com/c4arl0s/handlinguserinput#2-Filter-the-List-View)
3. [x] [3. Add a Control to Toggle the State](https://github.com/c4arl0s/handlinguserinput#3-Add-a-Control-to-Toggle-the-State)
4. [x] [4. Use an Observable Object for Storage](https://github.com/c4arl0s/handlinguserinput#4-Use-an-Observable-Object-for-Storage)
5. [x] [5. Adopt the Model Object in Your Views](https://github.com/c4arl0s/handlinguserinput#5-Adopt-the-Model-Object-in-Your-Views)
6. [ ] [6. Create a Favorite Button for Each Landmark](https://github.com/c4arl0s/handlinguserinput#6-Create-a-Favorite-Button-for-Each-Landmark)

# [HandlingUserInput](https://github.com/c4arl0s/handlinguserinput#handlinguserinput---content)

In the `Landmarks` app, a user can flag their favorite places, and filter the list to show just their favorites. To create this feature, you’ll start by adding a switch to the list so users can focus on just their favorites, and then you’ll add a star-shaped button that a user taps to flag a landmark as a favorite.

# 1. [Mark the User’s Favorite Landmarks](https://github.com/c4arl0s/handlinguserinput#handlinguserinput---content)

# Step 1

Open the project you finished in the previous tutorial, and select `Landmark.swift` in the Project navigator.

# Step 2

Add an `isFavorite` property to the Landmark structure. 

The `landmarkData.json` file has a key with this name for each landmark. Because `Landmark` conforms to Codable, you can read the `value` associated with the `key` by creating a new property with the same name as the key.

```swift
import Foundation
import SwiftUI
import CoreLocation

struct Landmark: Hashable, Codable, Identifiable {
    var id: Int
    var name: String
    var park: String
    var state: String
    var description: String
    var isFavorite: Bool
    
    private var imageName: String
    
    var image: Image {
        Image(imageName)
    }
    
    private var coordinates: Coordinates
    
    struct Coordinates: Hashable, Codable {
        var latitude: Double
        var longitude: Double
    }
    
    var locationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude)
    }
}
```

# Step 3

Select `LandmarkRow.swift` in the Project navigator.

# Step 4

After the spacer, add a star image inside an if statement to test whether the current landmark is a favorite.

In SwiftUI blocks, you use if statements to conditionally include views.

```swift
if landmark.isFavorite {
    Image(systemName: "start.fill")
}
```

Complete `LandmarkRow.swift` file:

```swift
import SwiftUI

struct LandmarkRow: View {
    var landmark: Landmark
    var body: some View {
        HStack {
            landmark.image
                .resizable()
                .frame(width: 50, height: 50)
            Text(landmark.name)
            
            Spacer()
            
            if landmark.isFavorite {
                Image(systemName: "star.fill")
            }
        }
    }
}

struct LandmarkRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LandmarkRow(landmark: landmarks[0])
            LandmarkRow(landmark: landmarks[1])
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
```

<img width="1074" alt="Screenshot 2023-11-14 at 11 59 53 p m" src="https://github.com/c4arl0s/HandlingUserInput/assets/24994818/8731b03b-ce22-4ef8-bc75-5f3afc508a27">

# Step 5

Because system images are vector based, you can change their color with the `foregroundStyle(_:)` modifier.

```swift
if landmark.isFavorite {
    Image(systemName: "star.fill")
        .foregroundStyle(.yellow)
}
```

Complete code:

```swift
import SwiftUI

struct LandmarkRow: View {
    var landmark: Landmark
    var body: some View {
        HStack {
            landmark.image
                .resizable()
                .frame(width: 50, height: 50)
            Text(landmark.name)
            Spacer()
            
            if landmark.isFavorite {
                Image(systemName: "star.fill")
                    .foregroundStyle(.yellow)
            }
        }
    }
}

struct LandmarkRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LandmarkRow(landmark: landmarks[0])
            LandmarkRow(landmark: landmarks[1])
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
```

<img width="1105" alt="Screenshot 2023-11-15 at 12 05 05 a m" src="https://github.com/c4arl0s/HandlingUserInput/assets/24994818/67df75c6-2d74-4a5e-823f-4dfd7d354fed">

Running Landmarks app.

<img width="511" alt="Screenshot 2023-11-15 at 12 07 49 a m" src="https://github.com/c4arl0s/HandlingUserInput/assets/24994818/f7c6ff26-9519-402d-ba7d-eb2424fe4e80">

# 2. [Filter the List View](https://github.com/c4arl0s/handlinguserinput#handlinguserinput---content)

You can customize the list view so that it shows all of the landmarks, or just the user’s favorites. To do this, you’ll need to add a bit of `state` to the `LandmarkList` type.

`State` is a `value`, or a `set of values`, that can change over time, and that affects a view’s behavior, content, or layout. You use a property with the `@State` attribute to add state to a view.

<img width="378" alt="Screenshot 2023-11-23 at 9 16 10 p m" src="https://github.com/c4arl0s/HandlingUserInput/assets/24994818/d30ee121-de07-4ac1-8f3b-5d7d117ce3a7">

# Step 1

Select `LandmarkList.swift` in the Project navigator.

# Step 2

Add a `@State` property called `showFavoritesOnly`, with its initial value set to `false`.

> Because you use state properties to hold information that is specific to a view and its subviews, you always create state as `private`.

```swift
import SwiftUI

struct LandmarkList: View {
    @State private var showFavoritesOnly = false
    var body: some View {
        NavigationView {
            List(landmarks) { landmark in
                NavigationLink {
                    LandmarkDetailView(landmark: landmark)
                } label: {
                    LandmarkRow(landmark: landmark)
                }
            }
            .navigationTitle("Landmarks")
        }
    }
}

struct LandmarkList_Previews: PreviewProvider {
    static var previews: some View {
        LandmarkList()
    }
}
```

# Step 3

When you make changes to your view’s structure, like adding or modifying a property, the canvas automatically refreshes.

> If the canvas isn’t visible, select Editor > Canvas to show it.

# Step 4

Compute a filtered version of the landmarks list by checking the `showFavoritesOnly` property and each `landmark.isFavorite` value.

<img width="468" alt="Screenshot 2023-11-19 at 12 38 50 p m" src="https://github.com/c4arl0s/HandlingUserInput/assets/24994818/7db0657f-4a14-488f-97d4-f6f2227cffdf">

```swift
var filteredLandmarks: [Landmark] {
    landmarks.filter { landmark in
        (!showFavoritesOnly || landmark.isFavorite)
    }
}
```

<img width="1449" alt="Screenshot 2023-11-19 at 12 43 37 p m" src="https://github.com/c4arl0s/HandlingUserInput/assets/24994818/7ab960f0-4f86-4342-a9da-7a24e009c583">

# Step 5

Use the filtered version of the list of landmarks in the List.

# Step 6

Change the initial value of `showFavoritesOnly` to `true` to see how the list reacts.

<img width="1449" alt="Screenshot 2023-11-19 at 12 54 01 p m" src="https://github.com/c4arl0s/HandlingUserInput/assets/24994818/b83faf9f-59af-46a3-b9a2-c73cfdd44719">


<img width="1134" alt="Screenshot 2023-11-19 at 12 55 26 p m" src="https://github.com/c4arl0s/HandlingUserInput/assets/24994818/2c4b4cad-781a-4e10-9460-79a5755a3e3f">

```swift
import SwiftUI

struct LandmarkList: View {
    @State private var showFavoritesOnly = true
    
    var filteredLandmarks: [Landmark] {
        landmarks.filter { landmark in
            (!showFavoritesOnly || landmark.isFavorite)
        }
    }
    
    var body: some View {
        NavigationView {
            List(filteredLandmarks) { landmark in
                NavigationLink {
                    LandmarkDetailView(landmark: landmark)
                } label: {
                    LandmarkRow(landmark: landmark)
                }
            }
            .navigationTitle("Landmarks")
        }
    }
}

struct LandmarkList_Previews: PreviewProvider {
    static var previews: some View {
        LandmarkList()
    }
}
```

# 3. [Add a Control to Toggle the State](https://github.com/c4arl0s/handlinguserinput#handlinguserinput---content)

To give the user control over the list’s filter, you need to add a control that can alter the value of `showFavoritesOnly`. You do this by **passing a binding to a toggle control**.

**A binding acts as a reference to a mutable state**. When a user taps the toggle from off to on, and off again, the control uses the binding to update the view’s state accordingly.

<img width="346" alt="Screenshot 2023-11-21 at 10 56 16 a m" src="https://github.com/c4arl0s/HandlingUserInput/assets/24994818/409d7d69-c51c-45af-ad9e-8e7c6480a34c">

# Step 1

Create a nested `ForEach` group to transform the landmarks into rows.

To combine static and dynamic views in a list, or to combine two or more different groups of dynamic views, use the `ForEach` type instead of passing your collection of data to List.

```swift
import SwiftUI

struct LandmarkList: View {
    @State private var showFavoritesOnly = true
    
    var filteredLandmarks: [Landmark] {
        landmarks.filter { landmark in
            (!showFavoritesOnly || landmark.isFavorite)
        }
    }
    
    var body: some View {
        NavigationSplitView {
            List {
                ForEach(filteredLandmarks) { landmark in
                    NavigationLink {
                        LandmarkDetailView(landmark: landmark)
                    } label: {
                        LandmarkRow(landmark: landmark)
                    }
                }
                .navigationTitle("Landmarks")
            }
        } detail: {
            Text("Select a Landmark")
        }
    }
}

struct LandmarkList_Previews: PreviewProvider {
    static var previews: some View {
        LandmarkList()
    }
}
```

<img width="1451" alt="Screenshot 2023-11-23 at 10 16 53 p m" src="https://github.com/c4arl0s/HandlingUserInput/assets/24994818/3eaf0e7c-2e1f-45dc-804d-6ab78762e1c3">

<img width="1080" alt="Screenshot 2023-11-23 at 10 12 42 p m" src="https://github.com/c4arl0s/HandlingUserInput/assets/24994818/c0b3cc27-26b9-4c51-a0f8-a95ef405e83d">

# Step 2

Add a `Toggle` view as the first child of the `List` view, passing a binding to `showFavoritesOnly`.

You use the `$` prefix to access a binding to a state variable, or one of its properties.

<img width="1452" alt="Screenshot 2023-11-23 at 10 30 32 p m" src="https://github.com/c4arl0s/HandlingUserInput/assets/24994818/ef05f203-f8a9-4f59-b33b-c916efbd64f6">

```swift
import SwiftUI

struct LandmarkList: View {
    @State private var showFavoritesOnly = true
    
    var filteredLandmarks: [Landmark] {
        landmarks.filter { landmark in
            (!showFavoritesOnly || landmark.isFavorite)
        }
    }
    
    var body: some View {
        NavigationSplitView {
            List {
                Toggle(isOn: $showFavoritesOnly) {
                    Text("Favorites only")
                }
                
                ForEach(filteredLandmarks) { landmark in
                    NavigationLink {
                        LandmarkDetailView(landmark: landmark)
                    } label: {
                        LandmarkRow(landmark: landmark)
                    }
                }
                .navigationTitle("Landmarks")
            }
        } detail: {
            Text("Select a Landmark")
        }
    }
}

struct LandmarkList_Previews: PreviewProvider {
    static var previews: some View {
        LandmarkList()
    }
}
```

<img width="1086" alt="Screenshot 2023-11-23 at 10 32 11 p m" src="https://github.com/c4arl0s/HandlingUserInput/assets/24994818/642d3b90-18ac-4eb7-a2fb-4515a3c66087">

# Step 3

Before moving on, return the default value of `showsFavoritesOnly` to `false`.

```swift
@State private var showFavoritesOnly = false
```

<img width="365" alt="Screenshot 2023-11-23 at 10 35 28 p m" src="https://github.com/c4arl0s/HandlingUserInput/assets/24994818/28408482-10fa-4f91-beab-e68b7298b5b5">

# Step 4

Use the Live preview and try out this new functionality by tapping the toggle.

![Screen Recording 2024-02-11 at 1 48 10 p m 2024-02-11 1_50_40 p m](https://github.com/c4arl0s/HandlingUserInput/assets/24994818/f009a560-8075-4213-b742-4964696b91ee)

# 4. [Use an Observable Object for Storage](https://github.com/c4arl0s/handlinguserinput#handlinguserinput---content)

To prepare for the user to control which particular landmarks are favorites, you will first store the landmark data using the `Observable()` macro.

<img width="409" alt="Screenshot 2024-02-11 at 1 56 26 p m" src="https://github.com/c4arl0s/HandlingUserInput/assets/24994818/4dd10035-7308-45f9-9dd2-2999b74d6e1a">

With Observation, a view in `SwiftUI` can support data changes without using property wrappers or bindings. `SwiftUI` watches for any observable property changes that could affect a view, and displays the correct version of the view after a change.

# Step 1

In the project's navigation pane, select Model Data.

# Step 2

Declare a new model type using the `Observable()` macro.

<img width="1250" alt="Screenshot 2024-02-11 at 2 11 15 p m" src="https://github.com/c4arl0s/HandlingUserInput/assets/24994818/a0bbf26a-78d5-441b-81d9-a5ad5846cc0b">

`SwiftUI` updates a view only when an observable property changes and the view´s body reads the property directly.

# Step 3

Move the landmarcks array into the model.

<img width="1281" alt="Screenshot 2024-02-11 at 2 17 00 p m" src="https://github.com/c4arl0s/HandlingUserInput/assets/24994818/8842d2b0-2c07-4ed7-8ca3-7097aa9f7a64">

# 5. [Adopt the Model Object in Your Views](https://github.com/c4arl0s/handlinguserinput#handlinguserinput---content)

Now that you have created the `ModelData` object, you need to update your views to adopt it as the data store for your app.

<img width="438" alt="Screenshot 2024-02-11 at 2 31 00 p m" src="https://github.com/c4arl0s/HandlingUserInput/assets/24994818/b633fb4c-102d-4111-a752-d846a423d220">

# Step 1

In `LandmarkList`, add an `@Environment` property wrapper to the view, and an `environment(_:)` modifier to the preview.

<img width="1212" alt="Screenshot 2024-02-11 at 2 55 19 p m" src="https://github.com/c4arl0s/HandlingUserInput/assets/24994818/77268191-fb11-4ffc-8e98-9ed48bb37d08">

The `modelData` property gets ist value automatically, as long as the `environment(_:)` modifier has been applied to a parent. The `@Environment` property wrapper enables you to read the model data of the current view. Adding an `environment(_:)` modifier passes the data object down through the environment.

# Step 2

Use `modelData.landmarks` as the data when filtering landmarks.

<img width="1264" alt="Screenshot 2024-02-11 at 3 00 56 p m" src="https://github.com/c4arl0s/HandlingUserInput/assets/24994818/bd2391e4-825f-4687-b3ee-eb7e54bac9c1">

# Step 3

Update the `LandmarkDetail` view to work with the `ModelData` object in the environment.

<img width="1332" alt="Screenshot 2024-02-11 at 3 07 16 p m" src="https://github.com/c4arl0s/HandlingUserInput/assets/24994818/deb92a17-6079-478e-bae9-61573eda96db">

# Step 4

Update the `LandmarkRow` preview to work with the `ModelData` object.

<img width="1215" alt="Screenshot 2024-02-11 at 3 15 13 p m" src="https://github.com/c4arl0s/HandlingUserInput/assets/24994818/a23b3dbb-3bed-47fe-a432-5b4efb3a1d9e">

# Step 5

Update the `ContentView` preview to add the model object to the environment, which makes the object available to any subview. 

<img width="1210" alt="Screenshot 2024-02-11 at 3 19 05 p m" src="https://github.com/c4arl0s/HandlingUserInput/assets/24994818/9cca846f-f1cd-4df8-b856-ea62e95a8552">

A preview fails if any subview requires a model object in the environment, but the view you are previewing does not have the `environment(_:)` modifier.
Next, you will update the app instance to put the model object in the environment when you run the app in the simulator or on a device.

# 6. [Create a Favorite Button for Each Landmark](https://github.com/c4arl0s/handlinguserinput#handlinguserinput---content)
