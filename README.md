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
- The **[Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)** installed in your editor. _Note:_ This extension is typically pre-installed in VS Code and Cursor AI Editor

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
6. You are ready for Interacting with Backend API via command-line interface (CLI) 🎉
7. Run tests: open the terminal **within your editor** and run `RAILS_ENV=test bin/rspec`

### Notes

- Ensure Docker is running before launching the Dev Container
- The `.devcontainer/devcontainer.json` file in this repository defines the container setup, including dependencies and tools
- I recommend clicking "Connecting to Dev Container (show log)" in your editor to monitor the container setup process and troubleshoot any issues

## Run with Docker and Docker-Compose

### Prerequisites

- **[Docker](https://www.docker.com/get-started/)** installed locally on your machine

### Steps

```bash
docker-compose -f .devdocker/docker-compose.yml up --build
```

You are ready for Interacting with Backend API via command-line interface (CLI) 🎉

### Run tests

Open new terminal window or tab and run from within project directory

```bash
docker-compose -f .devdocker/docker-compose.yml exec -e RAILS_ENV=test app bin/rspec
```

## Run

### Prerequisites

MySQL 8, Ruby 3.4.2, Rails 8.0.2

### Steps

```
bin/setup
```

You are ready for Interacting with Backend API via command-line interface (CLI) 🎉

### Run tests

```bash
RAILS_ENV=test bin/rspec
```

## Interact with Backend API via command-line interface (CLI)

As soon as you have Rewards App up and running

- ⮕ **Sign in**
  <details>
  <summary>Click to expand/collapse</summary>

  _Request:_

  ```bash
  curl -X POST http://localhost:3000/api/v1/login \
    -H "Content-Type: application/json" \
    -d '{"user": {"email": "one@example.com", "password": "password"}}'
  ```

````

_Example Response:_

```json
{
  "user": {
    "id": 1,
    "name": "Bryan Rainlord",
    "email_address": "one@example.com",
    "points": 45,
    "created_at": "2025-04-09T14:31:15.216Z",
    "updated_at": "2025-04-09T14:53:59.797Z"
  },
  "token": "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxIiwic2NwIjoidXNlciIsImF1ZCI6bnVsbCwiaWF0IjoxNzQ0MjIyODE2LCJleHAiOjE3NDQzMDkyMTYsImp0aSI6IjRlOWQ5ZWIxLTk2MTAtNGRjMS05NTA1LWVjMzMyMWEzYmQxZiJ9.Xr_W558DnvP9zIbWVwTafgiL7DGvhx3ggUr4Xw_7O58"
}
```

  </details>

- Copy your token from this response and use for all the next requests

- ⮕ **User information**
  <details>
  <summary>Click to expand/collapse</summary>

  _Request:_

  ```bash
  curl -X GET http://localhost:3000/api/v1/account \
    -H "Authorization: Bearer <YOUR_TOKEN_HERE>" \
    -H "Content-Type: application/json"
  ```

  _Example Response:_

  ```json
  {
    "name": "Bryan Rainlord",
    "email_address": "one@example.com"
  }
  ```

  </details>

- ⮕ **Retrieve a user’s current points balance**
  <details>
  <summary>Click to expand/collapse</summary>

  _Request:_

  ```bash
  curl -X GET http://localhost:3000/api/v1/account/balance \
    -H "Authorization: Bearer <YOUR_TOKEN_HERE>" \
    -H "Content-Type: application/json"
  ```

  _Example Response:_

  ```json
  {
    "points": 395
  }
  ```

  </details>

- ⮕ **Browse available rewards** (no authentication required)
  <details>
  <summary>Click to expand/collapse</summary>

  _Request:_

  ```bash
  curl -X GET http://localhost:3000/api/v1/rewards
  ```

  _Example Response:_

  ```json
  [
    {
      "id": 1,
      "name": "Tim's Favourite Soup",
      "description": "Free Tim's favourite soup, slice of bread included.",
      "points": 80,
      "created_at": "2025-04-09T18:19:40.233Z",
      "updated_at": "2025-04-09T18:19:40.233Z"
    },
    {
      "id": 2,
      "name": "1 Baked Pie",
      "description": "Small size free baked pie at the cafe.",
      "points": 50,
      "created_at": "2025-04-09T18:19:40.315Z",
      "updated_at": "2025-04-09T18:19:40.315Z"
    },
    {
      "id": 3,
      "name": "Free Brewed Coffee or Tea",
      "description": "Any size free brewed coffee or tea at the cafe.",
      "points": 50,
      "created_at": "2025-04-09T18:19:40.375Z",
      "updated_at": "2025-04-09T18:19:40.375Z"
    },
    {
      "id": 4,
      "name": "Vanilla Cone Pick Up only",
      "description": "Regular size free Vanilla Cone Pick Up only at the cafe.",
      "points": 60,
      "created_at": "2025-04-09T18:19:40.417Z",
      "updated_at": "2025-04-09T18:19:40.417Z"
    },
    {
      "id": 5,
      "name": "Any Size Latte",
      "description": "Any size coffee latte at the cafe.",
      "points": 70,
      "created_at": "2025-04-09T18:19:40.460Z",
      "updated_at": "2025-04-09T18:19:40.460Z"
    },
    {
      "id": 6,
      "name": "Breakfast Wrap",
      "description": "Free breakfast wrap at the cafe.",
      "points": 80,
      "created_at": "2025-04-09T18:19:40.525Z",
      "updated_at": "2025-04-09T18:19:40.525Z"
    },
    {
      "id": 7,
      "name": "Eggs Benedict Meal",
      "description": "Free Eggs Benedict meal including any size brewed tea or coffee, salad, and french fries.",
      "points": 150,
      "created_at": "2025-04-09T18:19:40.558Z",
      "updated_at": "2025-04-09T18:19:40.558Z"
    },
    {
      "id": 8,
      "name": "Dinner Voucher",
      "description": "A voucher for a dinner at the cafe.",
      "points": 300,
      "created_at": "2025-04-09T18:19:40.589Z",
      "updated_at": "2025-04-09T18:19:40.589Z"
    }
  ]
  ```

  </details>

- ⮕ **Show one of the rewards** (no authentication required)
  <details>
  <summary>Click to expand/collapse</summary>

  _Request:_

  ```bash
  curl -X GET http://localhost:3000/api/v1/rewards/3
  ```

  _Example Response:_

  ```json
  {
    "id": 3,
    "name": "Free Brewed Coffee or Tea",
    "description": "Any size free brewed coffee or tea at the cafe.",
    "points": 50,
    "created_at": "2025-04-09T18:19:40.375Z",
    "updated_at": "2025-04-09T18:19:40.375Z"
  }
  ```

  </details>

- ⮕ **Redeem this reward using points**
  <details>
  <summary>Click to expand/collapse</summary>

  _Request:_

  ```bash
  curl -X POST http://localhost:3000/api/v1/rewards/3/redeem \
    -H "Authorization: Bearer <YOUR_TOKEN_HERE>" \
    -H "Content-Type: application/json"
  ```

  _Example Response:_

  ```json
  {
    "message": "Reward redeemed successfully",
    "points_left": 345,
    "points_used": 50
  }
  ```

  </details>

- ⮕ **Try redeeming most expensive reward several time till not enough points**
  <details>
  <summary>Click to expand/collapse</summary>

  _Request:_

  ```bash
  curl -X POST http://localhost:3000/api/v1/rewards/8/redeem \
    -H "Authorization: Bearer <YOUR_TOKEN_HERE>" \
    -H "Content-Type: application/json"
  ```

  _Example Response (when insufficient points):_

  ```json
  {
    "error": "Not enough points"
  }
  ```

  </details>

- ⮕ **See a history of user's reward redemptions**
  <details>
  <summary>Click to expand/collapse</summary>

  _Request:_

  ```bash
  curl -X GET http://localhost:3000/api/v1/account/history \
    -H "Authorization: Bearer <YOUR_TOKEN_HERE>" \
    -H "Content-Type: application/json"
  ```

  _Example Response:_

  ```json
  [
    {
      "points": -300,
      "type": "Reward",
      "name": "Dinner Voucher",
      "description": "A voucher for a dinner at the cafe.",
      "created_at": "2025-04-09T18:25:25.305Z"
    },
    {
      "points": -50,
      "type": "Reward",
      "name": "Free Brewed Coffee or Tea",
      "description": "Any size free brewed coffee or tea at the cafe.",
      "created_at": "2025-04-09T18:23:50.981Z"
    },
    {
      "points": -50,
      "type": "Reward",
      "name": "Free Brewed Coffee or Tea",
      "description": "Any size free brewed coffee or tea at the cafe.",
      "created_at": "2025-04-09T18:19:41.787Z"
    },
    {
      "points": 75,
      "type": "Bonus",
      "name": "Feedback Bonus",
      "description": "Bonus for providing feedback.",
      "created_at": "2025-04-09T18:19:41.739Z"
    },
    {
      "points": 150,
      "type": "Bonus",
      "name": "Anniversary Bonus",
      "description": "Anniversary bonus for users.",
      "created_at": "2025-04-09T18:19:41.689Z"
    },
    {
      "points": 200,
      "type": "Bonus",
      "name": "Birthday Bonus",
      "description": "Birthday bonus for users.",
      "created_at": "2025-04-09T18:19:41.610Z"
    },
    {
      "points": -50,
      "type": "Reward",
      "name": "1 Baked Pie",
      "description": "Small size free baked pie at the cafe.",
      "created_at": "2025-04-09T18:19:41.552Z"
    },
    {
      "points": 50,
      "type": "Bonus",
      "name": "Referral Bonus",
      "description": "Bonus for referring a friend.",
      "created_at": "2025-04-09T18:19:41.496Z"
    },
    {
      "points": -80,
      "type": "Reward",
      "name": "Tim's Favourite Soup",
      "description": "Free Tim's favourite soup, slice of bread included.",
      "created_at": "2025-04-09T18:19:41.393Z"
    },
    {
      "points": 100,
      "type": "Bonus",
      "name": "Sign Up Bonus",
      "description": "Bonus for signing up.",
      "created_at": "2025-04-09T18:19:41.300Z"
    }
  ]
  ```

  </details>
````

## TODO

- code coverage, codecov
- update Devise::JWT::RevocationStrategies::Null to better strategy
- check for modern devise/devise jwt alternatives
- authorization & admin dashboard
- jbuilder, oj, fast-json
- pagination with pagy, any modern gem or from scratch (offset + limit)
- typescript react.js frontend via esbuild vs webpacker
- when user clicks redeem button, play animation
- codeclimate
- save curl instructions as Postman suite or create end-to-end test
