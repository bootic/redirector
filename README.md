# Generic URL redirector

Point your DNS to this app, and register redirects.

## Setup

You need Redis running and 'REDIRECTOR_API_TOKEN' set in the environment

## Registering

```
curl -i -X POST -d '{"from":"foo.bar.com", "to":"bar.foo.com"}' -u user:pwd http://redirecting.server.com/api/redirects
```

Now requests to foo.bar.com will be redirected to bar.foo.com

## Listing

`http://redirecting.server.com/api`

## Deleting

curl -i -X DELETE -d '{"from":"foo.bar.com"}' -u user:pwd http://redirecting.server.com/api/redirects

## Dev

```
git clone git@github.com:bootic/redirector.git
cd redirector
bundle install

REDIRECTOR_API_TOKEN=foobar shotgun -p 9292
```

Tests in `spec/`

```
bundle exec rspec spec/*_spec.rb
```