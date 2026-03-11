use std::env;
use sqlx::{MySqlPool};

pub async fn connect_db() {
    println!("connecting to db...");
    dotenvy::dotenv().ok();

    let database_url = env::var("DATABASE_URL")
        .expect("DATABASE_URL must be set");

    println!("Existing .env");

    let pool = MySqlPool::connect(&database_url)
        .await
        .map_err(actix_web::error::ErrorInternalServerError);

    println!("Connected");
}