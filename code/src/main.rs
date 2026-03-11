use code::{connect_db};
use actix_files::Files;
use actix_web::{get, App, HttpServer, Responder, HttpResponse, Error};
use local_ip_address::local_ip;


#[actix_web::main]
async fn main() -> std::io::Result<()> {
    connect_db().await;

    match local_ip() {
        Ok(ip) => println!("Running on: http//{}:8080/", ip),
        Err(e) => println!("Could not get IP: {}", e),
    }

    HttpServer::new(|| {
        App::new()
            .service(Files::new("/", "./static").index_file("index.html"))
    })
        .bind("0.0.0.0:8080")?
        .run()
        .await
}
