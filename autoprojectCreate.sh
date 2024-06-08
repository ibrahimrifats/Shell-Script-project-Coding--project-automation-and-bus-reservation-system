#!/bin/bash

# Function to create a Django project
create_django_project() {
    mkdir -p my_django_project/{my_django_project,apps/{app1,app2/{migrations}},templates,static/{css,js,images},media}
    touch my_django_project/{manage.py,requirements.txt,Dockerfile,docker-compose.yml,.env,.gitignore,README.md}
    touch my_django_project/my_django_project/{__init__.py,settings.py,urls.py,wsgi.py,asgi.py}
    touch my_django_project/apps/app1/{__init__.py,admin.py,apps.py,models.py,tests.py,views.py,urls.py,migrations/__init__.py}
    touch my_django_project/apps/app2/{__init__.py,admin.py,apps.py,models.py,tests.py,views.py,urls.py,migrations/__init__.py}

    echo "# Django project entry point" > my_django_project/manage.py
    echo "# Project settings" > my_django_project/my_django_project/settings.py
    echo "# Project URL configurations" > my_django_project/my_django_project/urls.py
    echo "# WSGI config" > my_django_project/my_django_project/wsgi.py
    echo "# ASGI config" > my_django_project/my_django_project/asgi.py
    echo "# Admin configuration for app1" > my_django_project/apps/app1/admin.py
    echo "# Application configuration for app1" > my_django_project/apps/app1/apps.py
    echo "# Models for app1" > my_django_project/apps/app1/models.py
    echo "# Tests for app1" > my_django_project/apps/app1/tests.py
    echo "# Views for app1" > my_django_project/apps/app1/views.py
    echo "# URL configurations for app1" > my_django_project/apps/app1/urls.py

    echo "Django project structure created."
}

# Function to create a Java project
create_java_project() {
    mkdir -p my_java_project/src/{main/java/com/example,main/resources,test/java/com/example,test/resources,target}
    touch my_java_project/{pom.xml,Dockerfile,.gitignore,README.md}
    touch my_java_project/src/main/java/com/example/App.java
    touch my_java_project/src/test/java/com/example/AppTest.java
    touch my_java_project/src/main/resources/application.properties

    echo "// Main application class" > my_java_project/src/main/java/com/example/App.java
    echo "// Main application test class" > my_java_project/src/test/java/com/example/AppTest.java
    echo "# Project configuration properties" > my_java_project/src/main/resources/application.properties

    echo "Java project structure created."
}

# Function to create a Flask project
create_flask_project() {
    mkdir -p my_flask_project/{app/{main,templates,static/{css,js,images}},tests,venv}
    touch my_flask_project/{config.py,run.py,requirements.txt,Dockerfile,docker-compose.yml,.env,.gitignore,README.md}
    touch my_flask_project/app/{__init__.py,main/{__init__.py,routes.py,forms.py,models.py}}
    touch my_flask_project/tests/{__init__.py,test_main.py}

    echo "# Flask app initialization" > my_flask_project/app/__init__.py
    echo "# Main blueprint initialization" > my_flask_project/app/main/__init__.py
    echo "# Routes for the main blueprint" > my_flask_project/app/main/routes.py
    echo "# Forms for the main blueprint" > my_flask_project/app/main/forms.py
    echo "# Models for the main blueprint" > my_flask_project/app/main/models.py
    echo "# Main test cases" > my_flask_project/tests/test_main.py

    echo "Flask project structure created."
}

# Function to create a C++ project
create_cpp_project() {
    mkdir -p my_cpp_project/{src,include,tests,build}
    touch my_cpp_project/{CMakeLists.txt,Dockerfile,.gitignore,README.md}
    touch my_cpp_project/src/main.cpp
    touch my_cpp_project/include/main.h
    touch my_cpp_project/tests/test_main.cpp

    echo "// Main application file" > my_cpp_project/src/main.cpp
    echo "// Main header file" > my_cpp_project/include/main.h
    echo "// Main test file" > my_cpp_project/tests/test_main.cpp

    echo "C++ project structure created."
}

# Function to handle GitHub operations
handle_github_operations() {
    echo "Enter GitHub repository URL:"
    read REPO_URL
    echo "Select operation: 1) Clone 2) Create branch 3) Merge branch 4) Push code 5) Create pull request"
    read GIT_OPERATION

    case $GIT_OPERATION in
        1)
            git clone $REPO_URL
            ;;
        2)
            echo "Enter branch name:"
            read BRANCH_NAME
            git checkout -b $BRANCH_NAME
            ;;
        3)
            echo "Enter source branch:"
            read SOURCE_BRANCH
            echo "Enter target branch:"
            read TARGET_BRANCH
            git checkout $TARGET_BRANCH
            git merge $SOURCE_BRANCH
            ;;
        4)
            git add .
            echo "Enter commit message:"
            read COMMIT_MESSAGE
            git commit -m "$COMMIT_MESSAGE"
            git push
            ;;
        5)
            echo "Enter source branch:"
            read SOURCE_BRANCH
            echo "Enter target branch:"
            read TARGET_BRANCH
            gh pr create --base $TARGET_BRANCH --head $SOURCE_BRANCH --title "Pull request title" --body "Pull request description"
            ;;
        *)
            echo "Invalid option."
            ;;
    esac
}

# Main menu loop
while true; do
    echo "Select project type to create:"
    echo "1) Django"
    echo "2) Java"
    echo "3) Flask"
    echo "4) C++"
    echo "5) GitHub operations"
    echo "6) Exit"
    read OPTION

    case $OPTION in
        1)
            create_django_project
            ;;
        2)
            create_java_project
            ;;
        3)
            create_flask_project
            ;;
        4)
            create_cpp_project
            ;;
        5)
            handle_github_operations
            ;;
        6)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid option. Please try again."
            ;;
    esac
done
