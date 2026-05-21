# Forecast App

A modern iOS weather application built with UIKit and Clean Architecture principles.  
The app provides current weather conditions, hourly forecasts, and daily forecasts based on the user’s location.

## Screenshots

<img width="1300" height="782" alt="Image" src="https://github.com/user-attachments/assets/00f4f5dc-e658-43df-9b38-2032715f6f02" />

## Features

- Current weather
- Hourly forecast
- Daily forecast
- Location-based weather
- Pull to refresh
- Error handling with retry action
- UIKit programmatic UI
- UICollectionViewCompositionalLayout
- Async/Await networking
- CoreLocation integration

## Tech Stack

- UIKit
- Swift Concurrency (Async/Await)
- CoreLocation
- URLSession
- MVC/MVP-inspired architecture
- Dependency Injection
- Programmatic Auto Layout

## Architecture

The project is divided into several layers:

- Presentation
- Services
- Models
- Mapper
- UI Components

The app uses a modular structure with dependency injection through a factory.

## Installation

1. Clone the repository
2. Open the `.xcodeproj`
3. Run the project on Simulator or device
