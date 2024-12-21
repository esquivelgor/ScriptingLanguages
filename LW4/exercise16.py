import sys
import csv
import socket
import struct

def ip_to_int(ip):
    """Convert an IPv4 address to an integer. Stop processing if an IPv6 address is found."""
    try:
        socket.inet_pton(socket.AF_INET, ip)
        return struct.unpack("!I", socket.inet_aton(ip))[0]
    except socket.error:
        return None  

def load_ip_database(filename):
    """Load the IP ranges and country data from the CSV file."""
    ip_data = []
    try:
        with open(filename, mode='r', newline='', encoding='utf-8') as file:
            reader = csv.reader(file)
            for row in reader:
                start_ip, end_ip, country = row
                ip_data.append({
                    'start_ip': start_ip,
                    'end_ip': end_ip,
                    'country': country.strip().lower()
                })
    except Exception as e:
        print(f"Error loading CSV file: {e}")
        sys.exit(1)
    
    return ip_data

def get_ip_ranges_for_country(country, ip_data):
    country = country.strip().lower()
    ranges = [
        f"{entry['start_ip']} - {entry['end_ip']}"
        for entry in ip_data if entry['country'] == country
    ]
    return ranges

def main():
    if len(sys.argv) != 2:
        print("Usage: python script.py <CountryCode>")
        sys.exit(1)

    country_name = sys.argv[1]
    
    # Load the IP database (adjust the path as necessary)
    ip_data = load_ip_database('dbip-country-lite-2024-12.csv')
    
    # Get all IP ranges for the country
    ip_ranges = get_ip_ranges_for_country(country_name, ip_data)
    
    if ip_ranges:
        try:
            with open("res.txt", mode='w', encoding='utf-8') as file:
                file.write("\n".join(ip_ranges))
            print(f"IP ranges for {country_name} have been written.")
        except Exception as e:
            print(f"Error writing to file: {e}")
            sys.exit(1)
    else:
        print(f"No IP ranges found for country: {country_name}")

if __name__ == "__main__":
    main()
