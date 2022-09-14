# Google Calendar API Integration

## Introduction

This a Ruby on Rails APIs application developed as a part of an assignment to integrate Google Calendar API with Rails application.

## Problem Statement

As a user, I want to have my Google Calendar events for today listed on a Web interface,
classified by calendar names.
The events should import and save to db when I connect my account to Google calendar for the
first time, the subsequent events which get
created/updated/deleted should be synced to the db automatically.

## Setup

Follow the instructions and setup Google Calendar application:

[https://developers.google.com/calendar/api/guides/auth](https://developers.google.com/calendar/api/guides/auth)

## Envorinment Variables

For managing google client id and secret keys, create .env file in your project root directory and set these variables in it:

```
GOOGLE_OAUTH_CLIENT_ID
GOOGLE_OAUTH_CLIENT_SECRET
GOOGLE_OAUTH_CALLBACK_URL
```

## Development Setup

- PostgreSQL(12.11)
- Bundler(2.2.3)
- Node(14.20.0)
- Yarn(1.22.19)
- Ruby(3.0.0)
- Rails(7.0.4)
- Bootstrap (5.2.0)

To setup the application, run:
```sh
bundle install
yarn install
```

Now setup the database. Set username and password of pg inside:
```sh
config/database.yml
```

Once changed, run following commands:

```sh
rails db:create
rails data:migrate
```

Start the server:

```sh
rails server
```
OR

```sh
./bin/dev
```

Open browser at: [http://localhost:3000](http://localhost:3000).
