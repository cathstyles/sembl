# Sembl

* <https://basecamp.com/1782196/projects/3404831-sembl>

## Development

### Cloning

With Boxen:

    boxen sembl
    cd ~/src/sembl

Without Boxen:

    git clone git@bitbucket.org:icelab/sembl.git
    cd sembl

### Setup

    cp config/database{.example,}.yml
    cp .env{.example,}
    bundle install --without production
    bundle exec rake db:create # Not for Boxen
    git remote add heroku git@heroku.com:sembl.git
    heroku pgbackups:capture
    wget `heroku pgbackups:url` -O dump.sql
    pg_restore --verbose --clean --no-acl --no-owner -h localhost -d sembl_development < dump.sql
    rm dump.sql

### Running

With Boxen

    ./script/server
    open http://sembl.dev/

Without Boxen:

    bundle exec rails server
    open http://localhost:3000/

## Heroku

### Deployment

    git push heroku master

### Instantiation

    heroku create sembl
    heroku addons:add pgbackups:auto-month
    heroku addons:add memcachier:dev
    heroku addons:add newrelic:stark
    heroku addons:add papertrail:choklad
    heroku sharing:add andrew.croome@fastmail.fm
    heroku sharing:add andy@icelab.com.au
    heroku sharing:add david@icelab.com.au
    heroku sharing:add hugh@artpop.com.au
    heroku sharing:add john@goldengrouse.com
    heroku sharing:add max@makenosound.com
    heroku sharing:add michael@icelab.com.au
    heroku sharing:add narindajane@gmail.com
    heroku sharing:add sj26@sj26.com
    heroku sharing:add tim@openmonkey.com
    heroku sharing:add toby@icelab.com.au
    heroku config:set { CONFIG_VARS }
    heroku labs:enable user-env-compile -a sembl

### Importing a CSV for "things"

On rails console:

1. If images are in the same directory as the file
    Thing.import_csv("path/to/filename.csv")

2. If images are in different directory
    Thing.import_csv("path/to/filename.csv", image_path: "path/to/images")


### Elasticsearch

We use Elasticsearch for:

* Filtering the Things in games created by power users.
* Sorting the Things with a random seed.

On Heroku. we use the [Bonsai](http://bonsai.io) add-on. This gives us a 10MB index. Currently this is much more than is needed.

Elasticsearch is configured by setting `ELASTICSEARCH_URL` in `.env`. This is overridden by `BONSAI_URL` if it exists (ie. on heroku). If you don't have elasticsearch configured searches default to returning all `Things` (offset and limit are still used though).

Things are indexed on create and update. So if you need to reindex, you can simply run:

```ruby
Thing.all.each { |thing| thing.save }
```

If setting up elasticsearch for the first time, you will need to manually create the "sembl" index:

```
curl -X POST http://#{elasticsearch_url}/sembl
```
