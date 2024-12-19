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
                    'start': ip_to_int(start_ip),
                    'end': ip_to_int(end_ip),
                    'country': country
                })
    except Exception as e:
        print(f"Error loading CSV file: {e}")
        sys.exit(1)
    
    return ip_data

def get_country(ip, ip_data):
    """Determine the country for a given IP address by comparing ranges."""
    ip_int = ip_to_int(ip)
    for entry in ip_data:
        if entry['start'] <= ip_int <= entry['end']:
            return entry['country']
    return "Unknown"

def main():
    if len(sys.argv) != 2:
        print("Usage: python script.py <IPv4_address>")
        sys.exit(1)

    ip = sys.argv[1]
    
    # Load the IP database (adjust the path as necessary)
    ip_data = load_ip_database('dbip-country-lite-2024-12.csv')
    
    # Get the country for the IP address
    country = get_country(ip, ip_data)
    
    print(f"The country for IP address {ip} is: {country}")

if __name__ == "__main__":
    main()
