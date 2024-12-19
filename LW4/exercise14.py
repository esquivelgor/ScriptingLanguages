import csv
import sys

def load_rankings(file_path):
    """Load the rankings from a CSV file into a dictionary."""
    rankings = {}
    try:
        with open(file_path, mode='r') as file:
            reader = csv.reader(file)
            for row in reader:
                if row:
                    rank, domain = row
                    rankings[domain] = int(rank)
    except FileNotFoundError:
        print(f"Error: File '{file_path}' not found.")
        sys.exit(1)
    except Exception as e:
        print(f"Error loading file '{file_path}': {e}")
        sys.exit(1)
    return rankings

def get_domain_rank(domain, tranco_rankings, umbrella_rankings):
    """Return the rankings of a domain in both Tranco and Umbrella databases."""
    tranco_rank = tranco_rankings.get(domain, None)
    umbrella_rank = umbrella_rankings.get(domain, None)
    
    return tranco_rank, umbrella_rank

def main():
    if len(sys.argv) != 2:
        print("Usage: python script.py <domain>")
        sys.exit(1)
    
    domain = sys.argv[1]
    
    # Load rankings
    tranco_rankings = load_rankings('tranco_top_1m.csv')
    umbrella_rankings = load_rankings('umbrella_top_1m.csv')

    # Get domain rank from both databases
    tranco_rank, umbrella_rank = get_domain_rank(domain, tranco_rankings, umbrella_rankings)

    # Output results
    if tranco_rank is not None:
        print(f"Tranco rank for {domain}: {tranco_rank}")
    else:
        print(f"{domain} not found in Tranco ranking.")
    
    if umbrella_rank is not None:
        print(f"Umbrella rank for {domain}: {umbrella_rank}")
    else:
        print(f"{domain} not found in Umbrella ranking.")

if __name__ == "__main__":
    main()
