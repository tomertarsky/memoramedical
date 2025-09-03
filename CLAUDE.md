# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Rails 8.0.2 application called "Memora Medical" built with modern Rails conventions. The application uses:

- **Framework**: Rails 8.0.2 with Ruby
- **Database**: SQLite3 with Solid adapters (cache, queue, cable)
- **Frontend**: Hotwire stack (Turbo, Stimulus) with Importmap for JavaScript
- **Asset Pipeline**: Propshaft
- **Web Server**: Puma
- **Deployment**: Kamal for containerized deployment

## Development Commands

### Setup and Installation
- `bin/setup` - Complete environment setup (installs dependencies, prepares database, starts server)
- `bin/setup --skip-server` - Setup without starting the server
- `bundle install` - Install Ruby dependencies

### Development Server
- `bin/dev` - Start development server (Rails server via Puma)
- `bin/rails server` - Alternative way to start server

### Database
- `bin/rails db:prepare` - Prepare database (create, migrate, seed if needed)
- `bin/rails db:migrate` - Run database migrations
- `bin/rails db:seed` - Seed database with initial data
- `bin/rails dbconsole` - Open database console

### Testing
- `bin/rails test` - Run the test suite
- `bin/rails test:system` - Run system tests (uses Capybara + Selenium)

### Code Quality
- `bin/rubocop` - Run RuboCop linter (uses rails-omakase style guide)
- `bin/rubocop -a` - Auto-correct RuboCop violations where possible
- `bin/brakeman` - Run security vulnerability analysis

### Utilities
- `bin/rails console` - Open Rails console
- `bin/rails routes` - Display all application routes
- `bin/rails log:clear` - Clear log files
- `bin/rails tmp:clear` - Clear temporary files

### Asset Management
- `bin/importmap` - Manage JavaScript imports via importmap-rails

### Deployment (Kamal)
- `bin/kamal deploy` - Deploy to production
- `bin/kamal console` - Open production console
- `bin/kamal shell` - SSH into production container
- `bin/kamal logs` - View production logs

## Architecture

### Directory Structure
- `app/controllers/` - Rails controllers (inherits from ApplicationController)
- `app/models/` - Rails models (inherits from ApplicationRecord)
- `app/views/` - ERB templates and layouts
- `app/javascript/` - Stimulus controllers and JavaScript modules
- `app/assets/` - Stylesheets and images
- `config/` - Application configuration
- `db/` - Database schemas and migrations
- `test/` - Test files using Rails' built-in testing framework

### Key Configuration
- **Application Class**: `MemoraMedical::Application` (config/application.rb:9)
- **Browser Support**: Modern browsers only with webp, web push, CSS nesting support
- **Testing**: Parallel test execution enabled
- **Deployment**: Configured for containerized deployment with volume persistence

### Solid Stack Integration
The application uses Rails' new Solid adapters:
- `solid_cache` for Rails.cache
- `solid_queue` for Active Job (runs in Puma process via `SOLID_QUEUE_IN_PUMA=true`)
- `solid_cable` for Action Cable

### Code Style
- Uses `rubocop-rails-omakase` for consistent Ruby styling
- Follows Rails 8 conventions and modern practices