use std::{env, net::SocketAddr};

use axum::{extract::Path, http::StatusCode, routing::get, Json, Router};
use pnet::datalink::interfaces;
use rand::prelude::*;
use serde::Serialize;

static CURRENT_HEALTH: std::sync::atomic::AtomicUsize = std::sync::atomic::AtomicUsize::new(100);

#[derive(Serialize)]
struct Stats {
    host: String,
    ipv4_addresses: Vec<String>,
    env_msg: String,
}

#[tokio::main]
async fn main() {
    tracing_subscriber::fmt::init();
    let app = Router::new()
        .route("/v1/stats", get(stats))
        .route("/v1/selfdestroy", get(selfdestroy))
        .route("/v1/ready", get(ready))
        .route("/v1/health", get(health))
        .route("/v1/health/:value", get(set_health))
        .route("/v1/askother", get(ask_other));

    let addr = SocketAddr::from(([0, 0, 0, 0], 4000));

    tracing::debug!("listening on {}", addr);

    axum::Server::bind(&addr)
        .serve(app.into_make_service())
        .await
        .unwrap();
}

async fn stats() -> Result<Json<Stats>, StatusCode> {
    let host = hostname::get()
        .map_err(|op| {
            eprintln!("{:?}", op);
            StatusCode::INTERNAL_SERVER_ERROR
        })?
        .into_string()
        .map_err(|op| {
            eprintln!("{:?}", op);
            StatusCode::INTERNAL_SERVER_ERROR
        })?;

    let env_msg = env::var("ENVIRONMENT_MESSAGE")
        .unwrap_or_else(|_| "Test fake environment variable message".to_string());

    let ipv4_addresses: Vec<String> = interfaces()
        .iter()
        .flat_map(|interf| interf.ips.iter().map(|ip| format!("{:?}", ip).to_string()))
        .collect();

    let stats = Stats {
        host,
        ipv4_addresses,
        env_msg,
    };

    Ok(Json(stats))
}

async fn selfdestroy() -> &'static str {
    println!("Good bye");
    std::process::exit(1);
}

async fn ready() -> &'static str {
    "I am ready."
}

async fn health() -> (StatusCode, &'static str) {
    let mut rng = rand::thread_rng();
    let maybe_sick: usize = rng.gen_range(0..100);

    if maybe_sick < CURRENT_HEALTH.load(std::sync::atomic::Ordering::Relaxed) {
        (StatusCode::OK, "I am fine.")
    } else {
        (StatusCode::INTERNAL_SERVER_ERROR, "I am sick.")
    }
}

async fn set_health(Path(value): Path<usize>) -> String {
    if 0 < value && value <= 100 {
        CURRENT_HEALTH.store(value, std::sync::atomic::Ordering::Relaxed);
    }

    format!("Health changed to {}", value)
}

async fn ask_other() -> Result<String, StatusCode> {
    let url = env::var("OTHER_SERVICE_HOST")
        .unwrap_or_else(|_| "http://localhost:4000".to_string());

    let other = reqwest::get(url)
    .await
    .map_err(convert_err)?
    .text()
    .await
    .map_err(convert_err)?;

    Ok(format!("Message from other: {}", other))
}

fn convert_err(err: reqwest::Error) -> StatusCode {
    eprintln!("{:?}", err);
    StatusCode::INTERNAL_SERVER_ERROR
}
