# Sembl

Sembl is a multiplayer web-based "board" game for finding and sharing resemblances between things. The backend is coded in Ruby on Rails, and the frontend in React.

## Development with Vagrant

### Installation

You’ll require the following to be installed:

 - VirtualBox
 - Vagrant
 - Ansible

Then run:

```
git clone git@github.com:cathstyles/sembl.git
cd sembl
vagrant plugin install vagrant-hostmanager
vagrant up
vagrant ssh
bin/setup
```

### Running

```
vagrant ssh
foreman start -f Procfile.dev
```

The site should now be running on <http://sembl.dev:3000/>

## Development

### Core models

* __Game__: A Sembl game, which brings together most of the following models and is responsible for managing the state of a game at a given time.
* __Board__: A player selectable game board. Includes attributes for the number of possible players and board layout.
* __Thing__: A "thing" is an image and metadata uploaded by an admin or a player which can be placed onto a "node" during gameplay.
* __Node__: A node is a spot in an active game which is filled, or can be filled, with a thing. Nodes are created when a game is created, and their locations are defined by the game's board.
* __Link__: A link joins two nodes together. Links are also created when a game is created and their locations are defined by the game's board.
* __Move__: A move is not stored in the database. A move occurs when a player places a thing onto a node.
* __Placement__: A placement is created when a user places a thing onto an unfilled node during a "move".
* __Resemblance__: A resemblance or "sembl" is created during gameplay when a user places a thing onto a node and describes the reasoning behind that placement (happens during a "move").
* __User__: A person that has signed up on the website.
* __Profile__: A single profile belongs to a user, and is created when the user signs up. It includes things like "name", "bio" and "avatar".
* __Player__: A user that is currently playing a game. This model stores player related state, such as their current.
* __Rating__: A rating is created during the rating part of gameplay (when, after each round, players rate other people sembls)

### First-time setup

Install the required gems & prepare the database by running this command from the root directory of the application in Terminal:

    $ bin/setup

### Running the application locally

    $ foreman start -f Procfile.dev

Visit http://localhost:5000/ to use the app.

### Setting up the production Heroku Remote

You need to install the [Heroku Toolbelt])(https://toolbelt.heroku.com/), and login to a Heroku account (with `heroku login`) that has access to the Sembl Heroku application.

After that you can add the git remote by running:

    $ heroku git:remote -a production

### Loading production data

You will need [Postgres database server](http://www.postgresql.org/download/) installed. After that, running the following commands will capture, download and restore the production database to your local database server:

    $ heroku pg:backups capture
    $ curl `heroku pg:backups public-url` -o production_db.dump
    $ pg_restore --verbose --clean --no-acl --no-owner -h localhost -d sembl_development < production_db.dump
    $ rm production_db.dump

### Working with the Solr search engine

Running `foreman` and specifying `Procfile.dev` (as above) will run a local, app-specific instance of the Solr search engine.

To load the search engine with the app's data, run this rake task:

    $ rake sunspot:reindex

### Importing `Thing` records from CSV

Open the rails console `rails console`, and then

if images are in the same directory as the file, run:

    ThingImporter.new("path/to/filename.csv")

if images are in different directory, run:

    ThingImporter.new("path/to/filename.csv", image_path: "path/to/images")

### Testing emails

You can test emails locally using [Mailcatcher](http://mailcatcher.me/), which you need to install separately:

    $ gem install mailcatcher
    $ mailcatcher

Now that it is running, visit http://localhost:1080/ to see the emails sent while using the local, development version of application.

### Running specs

Running the specs are a way of testing the application is working as expected prior to deploying it to production (to Heroku).

* Start the Solr engine in the test environment: `RAILS_ENV=test rake sunspot:solr:run` in one terminal session
* Have foreman running in another terminal session to serve assets (see the "Running the application locally" section)
* Many of the specs are currently out of date, but there is one large integration spec that runs through a whole 3 player game. Run this command in a 3rd terminal session:
  * `bundle exec rspec spec/features/playing_a_whole_game_spec.rb`

# Deployment

The production app runs on Heroku and uses these add-ons:

* Heroku Postgres - database
* PG Backups Auto - database backups
* Heroku Scheduler - scheduled tasks (e.g. email reminders and hostless game management)
* SendGrid - email delivery
* Websolr - hosted solr search engine

Deploy to heroku with git:

    $ git push production master

