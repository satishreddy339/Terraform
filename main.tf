provider "google" {
  credentials = file("myfirstproject_gcp_GKE_SA_keys.json")
  project     = "golden-system-436414-h2"
  region      = "asia-south1"  # Use the region, not a specific zone
}

resource "google_sql_database_instance" "sandbox_postgres" {
  name             = "sandbox-postgres-instance"
  database_version = "POSTGRES_16"  # Specify the desired version
  region           = "asia-south1"  # Use the region here, too

  settings {
    tier = "db-f1-micro"  # Lightweight tier suitable for a sandbox
    availability_type = "REGIONAL"  # High availability

    ip_configuration {
      ipv4_enabled = true  # Enable IPv4 for connections
    }

    backup_configuration {
      enabled    = true  # Backups might not be necessary in a sandbox
      start_time = "03:00"  # Time in UTC
    }
  }
}

resource "google_sql_user" "sandbox_user" {
  name     = "sandbox_user"
  instance = google_sql_database_instance.sandbox_postgres.name
  password = "Aadhar@123"  # Use a secure method for managing passwords
}

resource "google_sql_database" "sandbox_database" {
  name     = "sandbox_db"
  instance = google_sql_database_instance.sandbox_postgres.name
}

