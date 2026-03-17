use std::env;
use sqlx::{MySqlPool, query_as};
use serde_json::Value;
use sqlx::FromRow;

#[derive(Debug, FromRow)]
struct ActiveGame {
    id: i64,
    lobby_name: String,
    lobby_password: Option<String>,
    playing: i64,
    placed_cards: Option<Value>,
    untouched_cards: Option<Value>,
}
pub async fn connect_db() -> Result<(), actix_web::Error> {
    println!("connecting to db...");
    dotenvy::dotenv().ok();

    let database_url = env::var("DATABASE_URL")
        .map_err(actix_web::error::ErrorInternalServerError)?;

    println!("Existing .env: {}", database_url);

    let pool = MySqlPool::connect(&database_url)
        .await
        .map_err(actix_web::error::ErrorInternalServerError)?;

    println!("Connected");

    let rows = sqlx::query_as::<_, ActiveGame>(
        "SELECT * FROM active_games LIMIT 5"
    )
        .fetch_all(&pool)
        .await
        .map_err(actix_web::error::ErrorInternalServerError)?;

    println!("Result: {:?}", rows);

    Ok(())
    
}