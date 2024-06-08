#!/bin/bash

# Database configuration
DB_NAME="bus_booking"
DB_USER="root"  

# Load MySQL client command with options
mysql_cmd="mysql -u$DB_USER -D$DB_NAME -sse"

# Function to check if a user exists
userExists() {
    local username="$1"
    local result
    result=$($mysql_cmd "SELECT COUNT(*) FROM users WHERE username='$username';")
    if [[ "$result" -gt 0 ]]; then
        return 0
    fi
    return 1
}

# Function to register a new user
registerUser() {
    local username password email
    read -p "Enter username: " username
    if userExists "$username"; then
        echo "Username already exists. Try again."
        return 1
    fi
    read -p "Enter password: " password
    read -p "Enter email: " email
    $mysql_cmd "INSERT INTO users (username, password) VALUES ('$username', '$password');"
    user_id=$($mysql_cmd "SELECT id FROM users WHERE username='$username';")
    $mysql_cmd "INSERT INTO user_emails (user_id, email) VALUES ('$user_id', '$email');"
    echo "Registration successful."
}

# Function to login a user
loginUser() {
    local username password result
    read -p "Enter username: " username
    read -p "Enter password: " password
    result=$($mysql_cmd "SELECT COUNT(*) FROM users WHERE username='$username' AND password='$password';")
    if [[ "$result" -gt 0 ]]; then
        loggedInUser="$username"
        echo "Login successful."
        return 0
    fi
    echo "Invalid username or password. Try again."
    return 1
}

# Function to generate a random ticket code
generateTicketCode() {
    code=""
    for ((i=0; i<6; i++)); do
        code+=$(shuf -i 0-9 -n 1)
    done
    echo "$code"
}

# Function to generate PDF ticket
generatePdfTicket() {
    local name from to journey_date coach ticket_code email
    name="$1"
    from="$2"
    to="$3"
    journey_date="$4"
    coach="$5"
    ticket_code="$6"
    email="$7"

    cat <<EOF >"ticket_$ticket_code.txt"
------------------------------------------------
| Name : $(printf "%-45s" "$name") |
| Department location : $(printf "%-32s" "$from") |
| Destination : $(printf "%-41s" "$to") |
| Time : $(printf "%-46s" "$journey_date") |
| Date : $(printf "%-46s" "$(date +%Y-%m-%d)") |
| Coach : $(printf "%-44s" "$coach") |
| Ticket ID : $(printf "%-40s" "$ticket_code") |
| Seat position :                               |
| Email : $(printf "%-48s" "$email") |
------------------------------------------------
EOF
}

# Function to book a ticket
bookTicket() {
    local name from to journey_date coach ticket_price booking_date ticket_code email
    name="$loggedInUser"
    read -p "Enter journey date (yyyy-mm-dd): " journey_date
    read -p "Enter departure location: " from
    read -p "Enter destination: " to
    echo "Available coaches: Bus A, Bus B, Bus C, Bus D, Bus E, Bus F"
    read -p "Choose a bus: " coach
    ticket_price=100.0  # Example price
    booking_date=$(date +"%Y-%m-%d")
    ticket_code=$(generateTicketCode)
    
    read -p "Enter your email: " email

    $mysql_cmd "INSERT INTO tickets (name, from_location, to_location, journey_date, coach, ticket_price, booking_date, ticket_code) VALUES ('$name', '$from', '$to', '$journey_date', '$coach', $ticket_price, '$booking_date', '$ticket_code');"
    
    generatePdfTicket "$name" "$from" "$to" "$journey_date" "$coach" "$ticket_code" "$email"
    
    echo "Ticket booked successfully. Ticket code: $ticket_code"
}

# Function to cancel a ticket
cancelTicket() {
    local ticket_code
    read -p "Enter ticket code: " ticket_code
    $mysql_cmd "DELETE FROM tickets WHERE ticket_code='$ticket_code' AND name='$loggedInUser';"
    if [[ $? -eq 0 ]]; then
        echo "Ticket cancelled successfully."
    else
        echo "Failed to cancel ticket. Please check the ticket code."
    fi
}

# Function to check bus status
checkBusStatus() {
    local ticket_code result
    read -p "Enter ticket code: " ticket_code
    result=$($mysql_cmd "SELECT * FROM tickets WHERE ticket_code='$ticket_code';")
    if [[ -n "$result" ]]; then
        echo "Ticket Details: $result"
    else
        echo "Ticket not found."
    fi
}

# Function to see ticket position
seeTicketPosition() {
    local ticket_code result
    read -p "Enter ticket code: " ticket_code
    result=$($mysql_cmd "SELECT * FROM tickets WHERE ticket_code='$ticket_code' AND name='$loggedInUser';")
    if [[ -n "$result" ]]; then
        echo "Ticket Details: $result"
    else
        echo "Ticket not found or you are not authorized to view this ticket."
    fi
}

# Main program loop
loggedInUser=""
choice=""

while true; do
    if [[ -z "$loggedInUser" ]]; then
        echo -e "\n1. Register\n2. Login\n3. Exit"
        read -p "Enter your choice: " choice
        case "$choice" in
            1) registerUser ;;
            2) loginUser ;;
            3) echo "Exiting the program." ; exit 0 ;;
            *) echo "Invalid choice. Try again." ;;
        esac
    else
        echo -e "\n1. Book Ticket\n2. Cancel Ticket\n3. Check Bus Status\n4. See Ticket Position\n5. Logout"
        read -p "Enter your choice: " choice
        case "$choice" in
            1) bookTicket ;;
            2) cancelTicket ;;
            3) checkBusStatus ;;
            4) seeTicketPosition ;;
            5) loggedInUser=""; echo "Logged out successfully." ;;
            *) echo "Invalid choice. Try again." ;;
        esac
    fi
done
