# Books.mtdr

Books in time.
Opinionated collections, insightful presentations.

## Setup

```sh
docker compose run shell
```

## Usage

Server boot: `docker compose --profile web up`

Local access: <a href="http://localhost:3010/" target="_blank">http://localhost:3010/</a>

## Development

![rubyBadge](https://img.shields.io/badge/ruby-3.4.5-green)
![railsBadge](https://img.shields.io/badge/rails-8.0.2-green)

Shell container is the default for running all of the commands below.
Code style checks:

```sh
pronto run
rubocop
yarn run eslint app/javascript/**/*.{js,jsx}
```

Tests:

```sh
rspec
```
