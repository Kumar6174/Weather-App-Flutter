# Weather App 🌦️
A Flutter application to display real-time weather information, including temperature, humidity, weather description, and a 3-day forecast. The app supports fetching weather data based on the user's location or a manually searched city.

## Features
##### Current Weather: Displays the city name, temperature, weather description, and humidity.
##### 3-Day Forecast: Provides weather forecasts for the next three days.
##### Location-Based Weather: Automatically fetches weather data using the device's current location.
##### Toggle Unit: Switch between Celsius and Fahrenheit.
##### Responsive Design: Works seamlessly on both portrait and landscape orientations.

## Prerequisites
##### To run the app, ensure you have the following:

##### 1. Flutter Installed: Follow the Flutter installation guide.
##### 2. OpenWeather API Key: Sign up for a free API key at OpenWeather API.
##### 3.Dependencies Installed: Ensure all required Flutter packages are installed.

## How to Run the App

### Clone the Repository
##### git clone https://github.com/Kumar6174/Weather-App-Flutter.git
##### cd weather-app

### Install Dependencies
##### Run the following command to install the required dependencies:

##### flutter pub get

## Add OpenWeather API Key
##### Open the file lib/utils/api_service.dart.
##### Replace YOUR_API_KEY with your actual OpenWeather API key:

##### final String apiKey = 'YOUR_API_KEY';

## Run the App
Connect a physical device or start an emulator.
###Run the following command:

##### flutter run
Alternatively, you can use Android Studio or VS Code to run the app.


## Contribution
##### Contributions are welcome! Feel free to open a pull request or file an issue.

