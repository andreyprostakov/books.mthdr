# ArtSpace / Books

Years & centuries of book-smithing.

## Setup

```sh
docker compose up
```

## Usage

Local access: <a href="http://localhost:3010/" target="_blank">http://localhost:3010/</a>

## Development

![rubyBadge](https://img.shields.io/badge/ruby-3.3.5-green)
![railsBadge](https://img.shields.io/badge/rails-6.1.7.10-green)

Code style checks:

```sh
docker exec artspace_books-web-1 pronto run
docker exec artspace_books-web-1 yarn run eslint
```

Tests:

```sh
docker exec artspace_books-web-1 rspec
```

Reindexing for Solr:
```sh
docker exec artspace_books-web-1 rake sunspot:reindex
```
