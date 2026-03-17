use sqlx::{MySqlPool, query_as, mysql::MySqlPoolOptions, FromRow};

use serde_json::Value;

use std::time::Instant;

#[derive(Debug, FromRow)]
pub struct ActiveGame {
    id: i64,
    lobby_name: String,
    playing: i64,
}

pub async fn connect_db() -> Result<MySqlPool, sqlx::Error> {
    let start = Instant::now();
    println!("connecting to db...");

    let database_url = std::env::var("DATABASE_URL")
        .expect("DATABASE_URL must be set");

    let pool = MySqlPoolOptions::new()
        .max_connections(10)
        .connect(&database_url)
        .await?;

    println!(".env: {}", database_url);
    println!("Connected");

    let duration = start.elapsed();
    let ms = (duration.as_secs_f64() * 1000.0).ceil() / 1000.0;
    println!("Time elapsed: {:.3} ms\n", ms);

    Ok(pool)
    
}