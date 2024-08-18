import json

def get_input(prompt, allow_empty=True):
    while True:
        value = input(prompt)
        if value or allow_empty:
            return value
        print("This field cannot be empty. Please enter a value.")

def get_resources():
    resources = {}
    while True:
        key = get_input("Enter resource name (or press Enter to finish): ")
        if not key:
            break
        value = get_input(f"Enter value for {key}: ")
        try:
            resources[key] = int(value)
        except ValueError:
            print("Invalid input. Using empty string.")
            resources[key] = value
    return resources

def get_flags():
    flags = {}
    while True:
        key = get_input("Enter flag name (or press Enter to finish): ")
        if not key:
            break
        value = get_input(f"Enter value for {key} (true/false): ")
        flags[key] = value.lower() == 'true'
    return flags

def get_results():
    results = {}
    while True:
        key = get_input("Enter result name (or press Enter to finish): ")
        if not key:
            break
        value = get_input(f"Enter value for {key}: ")
        try:
            results[key] = int(value)
        except ValueError:
            print("Invalid input. Using empty string.")
            results[key] = value
    return results

def get_choice():
    choice = {}
    choice["text"] = get_input("Enter choice text: ")
    choice["resources"] = get_resources()
    choice["flags"] = get_flags()
    choice["results"] = get_results()
    return choice

def get_preconditions():
    preconditions = {}
    while True:
        key = get_input("Enter precondition name (or press Enter to finish): ")
        if not key:
            break
        value = get_input(f"Enter value for {key}: ")
        try:
            preconditions[key] = int(value)
        except ValueError:
            if value.lower() in ['true', 'false']:
                preconditions[key] = value.lower() == 'true'
            else:
                preconditions[key] = value
    return preconditions

def create_event():
    event = {}
    event["Event_title"] = get_input("Enter event title: ")
    event["Event_description"] = get_input("Enter event description: ")
    
    num_choices = int(get_input("Enter number of choices (1-3): ", allow_empty=False))
    while num_choices < 1 or num_choices > 3:
        print("Number of choices must be between 1 and 3.")
        num_choices = int(get_input("Enter number of choices (1-3): ", allow_empty=False))
    
    for i in range(1, num_choices + 1):
        print(f"\nEnter details for Choice {i}:")
        event[f"Choice_{i}"] = get_choice()
    
    print("\nEnter preconditions:")
    event["preconditions"] = get_preconditions()
    
    return event

def main():
    event_key = get_input("Enter event key (e.g., climate_cooldown_1): ")
    event_data = create_event()
    
    json_data = {event_key: event_data}
    
    filename = get_input("Enter filename to save JSON (e.g., event.json): ")
    
    with open(filename, 'w') as f:
        json.dump(json_data, f, indent=4)
    
    print(f"JSON file '{filename}' has been created successfully.")

if __name__ == "__main__":
    main()