  1. Create a postgres db
  2. Set the URL to your db in .env or provide DATABASE_URI as an environment variable
  3. bundle install
  4. Run tests ```INSERT_SIZE=1000 READ_SIZE=1000 TEST=1 ruby init.rb```
