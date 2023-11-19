# [go back to Overview](https://github.com/c4arl0s)

# [HandlingUserInput - Content](https://github.com/c4arl0s/handlinguserinput#go-back-to-overview)

1. [x] [1. Mark the User’s Favorite Landmarks](https://github.com/c4arl0s/handlinguserinput#1-Mark-the-Users-Favorite-Landmarks)
2. [ ] [2. Filter the List View](https://github.com/c4arl0s/handlinguserinput#2-Filter-the-List-View)
3. [ ] [3. Add a Control to Toggle the State](https://github.com/c4arl0s/handlinguserinput#3-Add-a-Control-to-Toggle-the-State)
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

<img width="1074" alt="Screenshot 2023-11-14 at 11 59 53 p m" src="https://github.com/c4arl0s/HandlingUserInput/assets/24994818/09614565-5652-40d3-ae67-4d9d0141b408">

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

<img width="1105" alt="Screenshot 2023-11-15 at 12 05 05 a m" src="https://github.com/c4arl0s/HandlingUserInput/assets/24994818/7cf6330d-fa71-431d-bec5-92f17847a816">

Running Landmarks app.

<img width="511" alt="Screenshot 2023-11-15 at 12 07 49 a m" src="https://github.com/c4arl0s/HandlingUserInput/assets/24994818/b05f1b7d-9351-4e58-a243-e443a142f6b0">

# 2. [Filter the List View](https://github.com/c4arl0s/handlinguserinput#handlinguserinput---content)

You can customize the list view so that it shows all of the landmarks, or just the user’s favorites. To do this, you’ll need to add a bit of `state` to the `LandmarkList` type.

`State` is a `value`, or a `set of values`, that can change over time, and that affects a view’s behavior, content, or layout. You use a property with the `@State` attribute to add state to a view.

![Image](https://github.com/c4arl0s/HandlingUserInput/assets/24994818/a9390a94-036f-4784-bee0-3673ad0b50c0)

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

<img width="468" alt="Screenshot 2023-11-19 at 12 38 50 p m" src="https://github.com/c4arl0s/HandlingUserInput/assets/24994818/03712438-b9c9-46be-a2f4-3a1fb5aa8c93">

```swift
var filteredLandmarks: [Landmark] {
    landmarks.filter { landmark in
        (!showFavoritesOnly || landmark.isFavorite)
    }
}
```

# 3. [Add a Control to Toggle the State](https://github.com/c4arl0s/handlinguserinput#handlinguserinput---content)
# 4. [Use an Observable Object for Storage](https://github.com/c4arl0s/handlinguserinput#handlinguserinput---content)
# 5. [Adopt the Model Object in Your Views](https://github.com/c4arl0s/handlinguserinput#handlinguserinput---content)
# 6. [Create a Favorite Button for Each Landmark](https://github.com/c4arl0s/handlinguserinput#handlinguserinput---content)
