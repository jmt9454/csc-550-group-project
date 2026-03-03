env "local" {
  src = "file://schema"
  url = "postgres://user:password@localhost:5432/local_dev_db?sslmode=disable"
  dev = "postgres://atlas:password@localhost:5433/local_dev_db_scratchpad?sslmode=disable"
    dir = "file://migrations"
  }