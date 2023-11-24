# [go back to Overview](https://github.com/c4arl0s)

# [HandlingUserInput - Content](https://github.com/c4arl0s/handlinguserinput#go-back-to-overview)

1. [x] [1. Mark the User’s Favorite Landmarks](https://github.com/c4arl0s/handlinguserinput#1-Mark-the-Users-Favorite-Landmarks)
2. [x] [2. Filter the List View](https://github.com/c4arl0s/handlinguserinput#2-Filter-the-List-View)
3. [x] [3. Add a Control to Toggle the State](https://github.com/c4arl0s/handlinguserinput#3-Add-a-Control-to-Toggle-the-State)
4. [ ] [4. Use an Observable Object for Storage](https://github.com/c4arl0s/handlinguserinput#4-Use-an-Observable-Object-for-Storage)
5. [ ] [5. Adopt the Model Object in Your Views](https://github.com/c4arl0s/handlinguserinput#5-Adopt-the-Model-Object-in-Your-Views)
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

To give the user control over the list’s filter, you need to add a control that can alter the value of showFavoritesOnly. You do this by **passing a binding to a toggle control**.

**A binding acts as a reference to a mutable state**. When a user taps the toggle from off to on, and off again, the control uses the binding to update the view’s state accordingly.

<img width="346" alt="Screenshot 2023-11-21 at 10 56 16 a m" src="https://github.com/c4arl0s/HandlingUserInput/assets/24994818/409d7d69-c51c-45af-ad9e-8e7c6480a34c">

# Step 1

Create a nested `ForEach` group to transform the landmarks into rows.

To combine static and dynamic views in a list, or to combine two or more different groups of dynamic views, use the `ForEach` type instead of passing your collection of data to List.


# 4. [Use an Observable Object for Storage](https://github.com/c4arl0s/handlinguserinput#handlinguserinput---content)
# 5. [Adopt the Model Object in Your Views](https://github.com/c4arl0s/handlinguserinput#handlinguserinput---content)
# 6. [Create a Favorite Button for Each Landmark](https://github.com/c4arl0s/handlinguserinput#handlinguserinput---content)
