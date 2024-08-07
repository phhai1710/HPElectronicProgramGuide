# HPElectronicProgramGuide

[![Version](https://img.shields.io/cocoapods/v/HPElectronicProgramGuide.svg?style=flat)](https://cocoapods.org/pods/HPElectronicProgramGuide)
[![License](https://img.shields.io/cocoapods/l/HPElectronicProgramGuide.svg?style=flat)](https://cocoapods.org/pods/HPElectronicProgramGuide)
[![Platform](https://img.shields.io/cocoapods/p/HPElectronicProgramGuide.svg?style=flat)](https://cocoapods.org/pods/HPElectronicProgramGuide)

![VideoQuickSeeking](https://github.com/phhai1710/HPElectronicProgramGuide/blob/master/Resources/example.gif?raw=true)

A powerful EPG (Electronic Program Guide) UI library for iOS in Swift. Create stunning program guide interfaces with ease.

HPElectronicProgramGuide is a custom collection view designed specifically for creating Electronic Program Guide (EPG) interfaces in iOS applications. It provides a flexible and customizable solution for displaying program guides with channels and their respective programs.


## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

HPElectronicProgramGuide is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'HPElectronicProgramGuide'
```

## Usage In Swift

``` Swift
let collectionView = HPEpgCollectionView(channelItemSize: CGSize(width: 100, height: 40),
                                         timeItemSize: CGSize(width: 160, height: 40))
collectionView.epgDelegate = self
collectionView.epgDataSource = self
```

Implement the required methods from the HPEpgCollectionViewDataSource protocol to provide the necessary data for the EPG view:

``` Swift
func cellForFirstItem(at indexPath: IndexPath) -> HPEpgCollectionViewCell
func cellForTimeItem(at timeInterval: Int, indexPath: IndexPath) -> HPEpgCollectionViewCell
func cellForChannelItem(at channelIndex: Int, indexPath: IndexPath) -> HPEpgCollectionViewCell
func cellForProgramItem(at programIndex: Int, inChannel channelIndex: Int, indexPath: IndexPath) -> HPProgramCollectionViewCell
func cellForTimeMarker(at indexPath: IndexPath) -> HPTimeMarkerContainerCell


func numberOfChannel() -> Int
func numberOfProgram(inChannel channelIndex: Int) -> Int

func startSecondOfProgram(at programIndex: Int, inChannel channelIndex: Int) -> Int
func endSecondOfProgram(at programIndex: Int, inChannel channelIndex: Int) -> Int
```

Implement the required methods from the HPEpgCollectionViewDelegate protocol to handle user interactions with the EPG view:

``` Swift
func didSelectChannel(at index: Int, indexPath: IndexPath)
func didSelectProgram(at index: Int, inChannel channelIndex: Int, indexPath: IndexPath)
func didScrollToTimeRange(from: Int, to: Int)
```

Customize the collection view cells by subclassing HPEpgCollectionViewCell, HPProgramCollectionViewCell and HPTimeMarkerContainerCell to suit your design needs. Then, registering 5 different cells for Channel, Time Interval, Program, First and Time Marker

``` Swift
collectionView.register(cellClass: ChannelCell.self)
collectionView.register(cellClass: TimeSegmentCell.self)
collectionView.register(cellClass: ProgramCell.self)
collectionView.register(cellClass: FirstCell.self)
collectionView.register(cellClass: TimeMarkerCell.self)
```

For more detailed information and usage examples, refer to the example project included in this repository.


## Contribution
Contributions are welcome! If you find any issues, have feature requests, or would like to contribute to the project, please feel free to submit a pull request or open an issue.

## Author

Hai Pham, phhai1710@gmail.com

## License

HPElectronicProgramGuide is available under the MIT license. See the LICENSE file for more info.
