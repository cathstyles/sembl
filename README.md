# Sembl

Sembl is a multiplayer web-based "board" game for finding and sharing resemblences between things.

Important links:

* [Basecamp project](https://basecamp.com/1782196/projects/3404831)
* [Trello board](https://trello.com/b/vr2JHoIc/sembl)

Primary developers:

* Max Wheeler (design & front-end development)
* Andy McCray (design)
* Narinda Reeders (development)
* Nick Binnington (development)

# Development

### First-time setup

Check out the app with babushka:

    $ babushka projects:sembl
    $ cd ~/src/sembl

Install the required gems & prepare the database:

    $ bin/setup

### Running the application locally

    $ foreman start -f Procfile.dev

Visit http://localhost:5000/ to use the app.

### Loading production data

    heroku pgbackups:capture --expire
    curl `heroku pgbackups:url` -o production_db.dump
    pg_restore --verbose --clean --no-acl --no-owner -h localhost -d sembl_development < production_db.dump
    rm production_db.dump

### Working with the Solr search engine

Running `foreman` and specifying `Procfile.dev` (as above) will run a local, app-specific instance of the Solr search engine.

To load the search engine with the app's data, run this rake task:

    $ rake sunspot:reindex

### Importing `Thing` records from CSV

Open the rails console, and then:

If images are in the same directory as the file

    ThingImporter.new("path/to/filename.csv")

If images are in different directory:

    ThingImporter.new("path/to/filename.csv", image_path: "path/to/images")

### Testing emails

Test emails locally using [Mailcatcher](http://mailcatcher.me/). Install it separately:

    $ gem install mailcatcher
    $ mailcatcher

When it is running, visit http://localhost:1080/ to see the emails.

### Running specs

* Start the Solr engine in the test environment: `RAILS_ENV=test rake sunspot:solr:run`
* Have foreman running to serve assets (see the "Running the application locally" section)
* Many of the specs are currently out of date, but there is one large integration spec that runs through a whole 3 player game:
  * `bundle exec rspec spec/features/playing_a_whole_game_spec.rb

# Deployment

The app runs on Heroku. It uses these add-ons:

* Heroku Postgres - database
* PG Backups Auto - database backups
* Heroku Scheduler - scheduled tasks (e.g. email reminders and hostless game management)
* SendGrid - email delivery
* Websolr - hosted solr search engine

Deploy to heroku with git:

    $ git push production master
