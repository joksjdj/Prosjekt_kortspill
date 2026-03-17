use code::{connect_db};
use actix_files::Files;
use actix_web::{get, web, App, HttpServer, Responder, HttpResponse, Error};
use local_ip_address::local_ip;

#[get("/page/{number}/")]
async fn page(id: web::Path<String>) -> impl Responder {
    format!("You requested page: {}", id)
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    let _ = connect_db().await;

    match local_ip() {
        Ok(ip) => println!("Running on: http//{}:8080/", ip),
        Err(e) => println!("Could not get IP: {}", e),
    }

    HttpServer::new(|| {
        App::new()
            .service(page)
            .service(Files::new("/", "./static").index_file("index.html"))
    })
        .bind("0.0.0.0:8080")?
        .run()
        .await
}
