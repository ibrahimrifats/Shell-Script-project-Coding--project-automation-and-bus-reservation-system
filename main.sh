#!/bin/bash

# Function to display the main menu
main_menu() {
    while true; do
        echo "Which project do you want to run?"
        echo "1) Bus Reservation"
        echo "2) Coding project automation"
        echo "3) Exit"
        read -p "Enter your choice: " choice

        case $choice in
            1)
                ./busReservation.sh
                ;;
            2)
                ./autoprojectCreate.sh
                ;;
            3)
                echo "Exiting..."
                exit 0
                ;;
            *)
                echo "Invalid choice. Please try again."
                ;;
        esac
    done
}

# Call the main menu function
main_menu
