# Install PostgreSQL version 15 using Homebrew
brew install postgresql@15

# Start PostgreSQL service
brew services start postgresql

# Check the installed version of PostgreSQL
psql --version

# Install RVM (Ruby Version Manager)
\curl -sSL https://get.rvm.io | bash -s stable

# Load RVM into your shell session (add this line to your .bash_profile or .zshrc if needed)
source ~/.rvm/scripts/rvm

# Install the latest Ruby version (adjust if you need a specific version)
rvm install ruby

# Set Ruby as default
rvm use ruby --default

# Install the required gems defined in Gemfile
bundle install

# Create the PostgreSQL database
rails db:create

# Run database migrations
rails db:migrate

# Generate dummy data
rake data:dummy:generate_dummy_data

# Install Redis using Homebrew
brew install redis

# Start Redis service
brew services start redis

# Alternatively, you can start Redis manually
redis-server
