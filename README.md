# Forecast

iOS weather app built with Swift + UIKit (programmatic layout). Shows current weather, hourly forecast for 48 hours, 14-day forecast, and detailed metrics. Uses MVP architecture with async/await networking and unit tests.

## Screenshots

<img width="1300" height="782" alt="Image" src="https://github.com/user-attachments/assets/00f4f5dc-e658-43df-9b38-2032715f6f02" />

## Features

- **Current Weather:** Real-time weather conditions
- **Hourly Forecast:** 48-hour forecast
- **Daily Forecast:** 14-day forecast
- **Location-Based Weather:** Automatic weather for user's location
- **Pull to Refresh:** Manual update with refresh control
- **Error Handling:** Retry action for failed requests
- **Programmatic UI:** UIKit with Auto Layout, no storyboards
- **Compositional Layout:** UICollectionViewCompositionalLayout for modern collection views

## Tech Stack

- **Swift** + **UIKit** (programmatic layout)
- **MVP** architecture
- **Swift Concurrency** (Async/Await)
- **CoreLocation** for location services
- **URLSession** for networking
- **Dependency Injection** via factory pattern
- **XCTest** for unit tests

## Architecture

The project is divided into several layers:

- **Presentation:** Views and presenters
- **Services:** Networking, location, and other services
- **Models:** Data entities
- **Mapper:** Transforms API models to presentation models
- **UI Components:** Reusable UI elements

The app uses a modular structure with dependency injection through a factory.

## Installation

- git clone https://github.com/rfhfv/Forecast.git
- cd Forecast
- open Forecast.xcodeproj
