import requests
import sys

def get_weather(location):
    API_KEY = "2d351b25a5ec46fab0694510221411"
    BASE_URL = "http://api.weatherapi.com/v1/current.json"

    # Prepare the request URL and parameters
    params = {
        "key": API_KEY,
        "q": location
    }

    try:
        # Make the GET request to WeatherAPI
        response = requests.get(BASE_URL, params=params)
        response.raise_for_status()  # Raise exception if HTTP error occurs

        weather_data = response.json()

        temperature = weather_data["current"]["temp_c"]
        last_updated = weather_data["current"]["last_updated"]

        print(f"Current temperature in {location}: {temperature}°C")
        print(f"Last updated: {last_updated}")

    except requests.exceptions.HTTPError as http_err:
        print(f"HTTP error occurred: {http_err}")
    except requests.exceptions.RequestException as err:
        print(f"Error occurred: {err}")
    except KeyError:
        print("Invalid response from API. Check the location or API key.")

if __name__ == "__main__":
    # Check if a location argument is provided
    if len(sys.argv) < 2:
        print("Usage: python script.py <location>")
        sys.exit(1)

    # Get the location from the first argument
    location = sys.argv[1]

    # Call the function to get weather information
    get_weather(location)
