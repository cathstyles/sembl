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

### Loading production data

    $ heroku pgbackups:capture --expire
    $ curl `heroku pgbackups:url` -o production_db.dump
    $ pg_restore --verbose --clean --no-acl --no-owner -h localhost -d sembl_development < production_db.dump
    $ rm production_db.dump

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

# Deployment

The app runs on Heroku. It uses these add-ons:

* Heroku Postgres - database
* PG Backups Auto - database backups
* Heroku Scheduler - scheduled tasks (e.g. email reminders and hostless game management)
* SendGrid - email delivery
* Websolr - hosted solr search engine

Deploy to heroku via a `git push`:

    $ git push production master
