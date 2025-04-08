[![contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat)](https://github.com/artkirienko/rewards-app/issues)
[![GitHub Actions CI](https://github.com/artkirienko/rewards-app/actions/workflows/ci.yml/badge.svg)](https://github.com/artkirienko/rewards-app/actions/workflows/ci.yml)
[![SLOC](https://sloc.xyz/github/artkirienko/rewards-app)](https://en.wikipedia.org/wiki/Source_lines_of_code)
[![Hits-of-Code](https://hitsofcode.com/github/artkirienko/rewards-app?branch=main)](https://hitsofcode.com)

# Take home challenge Rewards App

### Summary:

The challenge is to implement a basic rewards redemption web app that allows a user to do the following:

- View their current reward points balance
- Browse available rewards
- Redeem rewards using their points
- See a history of their reward redemptions

### Tech Stack:

You can use whatever technologies you’d like. I will note that the main technologies at Thanx are React for the front-end, Ruby on Rails for the backend, and MySQL for the database

### Core Requirements:

#### Backend API:

Implement RESTful endpoints for the following:

- Retrieve a user’s current points balance
- Get a list of available rewards
- Allow users to redeem a reward
- Retrieve a user’s redemption history

#### Data Persistence:

Use a database of your choice to store the information as you deem fit

#### Interface:

Implement a simple interface to interact with the backend API. This could be a command-line interface (CLI) or a web-based interface (Preferred if your focus is on the frontend)

#### Documentation:

Provide clear documentation on how to set up and run the application

## Run with Dev Containers

You can run this project using [Dev Containers](https://containers.dev/) to ensure a consistent development environment. Follow the steps below to get started

### Prerequisites
- **[Docker](https://www.docker.com/get-started/)** installed locally on your machine
- A [compatible editor](https://containers.dev/supporting#editors), such as [Visual Studio Code](https://code.visualstudio.com/) or [Cursor AI Editor](https://cursor.sh/), that supports Dev Containers
- The **[Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)** installed in your editor. *Note:* This extension is typically pre-installed in VS Code and Cursor AI Editor

### Steps
1. Clone this repository to your local machine:
   ```bash
   git clone https://github.com/artkirienko/rewards-app
   cd rewards-app
   ```
2. Open the project folder in your editor
3. When prompted, select "Reopen in Container" (or use the command palette: Dev Containers: Reopen in Container)
4. The Dev Container will build and configure the environment based on the provided .devcontainer configuration
5. Once the dev container setup is complete, open the terminal **within your editor** and run `bin/rails s`
6. Open http://localhost:3000/ in your browser to view the application

### Notes
- Ensure Docker is running before launching the Dev Container
- The `.devcontainer/devcontainer.json` file in this repository defines the container setup, including dependencies and tools
- I recommend clicking "Connecting to Dev Container (show log)" in your editor to monitor the container setup process and troubleshoot any issues

# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

- Ruby version

- System dependencies

- Configuration

- Database creation

- Database initialization

- How to run the test suite

- Services (job queues, cache servers, search engines, etc.)

- Deployment instructions

- ...
