# DragonBallDex

<p align="center">
    <img src="https://img.shields.io/badge/Swift-5.9.1-orange.svg" />
    <img src="https://img.shields.io/badge/Xcode-15.2.X-orange.svg" />
    <img src="https://img.shields.io/badge/platforms-iOS-brightgreen.svg?style=flat" alt="iOS" />
    <a href="https://www.linkedin.com/in/rodrigo-silva-6a53ba300/" target="_blank">
        <img src="https://img.shields.io/badge/LinkedIn-@RodrigoSilva-blue.svg?style=flat" alt="LinkedIn: @RodrigoSilva" />
    </a>
</p>

A iOS application written in Swift, that brings a list of Dragon Ball characters using a CollectionView Diffable.

## Contents

- [Features](#features)
- [Requirements](#requirements)
- [Functionalities](#functionalities)
- [Setup](#setup)

## Features

- View Code (UIKit)
- Modern CollectionView Diffable
- UserDefaults
- Custom elements
- Dark Mode

## Requirements

- iOS 17.0 or later
- Xcode 15.0 or later
- Swift 5.0 or later

## Functionalities

- [x] Displays a list of available characters.
- [x] Tapping on a character takes the user to a detailed screen with information about the character.
- [x] Full support for Dark Mode, offering a more pleasant user experience in different lighting conditions.
- [x] Utilizes UIKit components for building the user interface.
- [x] Implements `UICollectionViewDiffableDataSource` to optimize data management and UI updates.

## Setup

First of all download and install Xcode, Swift Package Manager and then clone the repository:

```sh
$ git@github.com:diggosilva/DragonBallDex.git
```

After cloning, do the following:

```sh
$ cd <diretorio-base>/DragonBallDex/
$ open DragonBallDex.xcodeproj/
```
