use serde::Serialize;
use warp::http::StatusCode;
use warp::Filter;

/**
%{
  host: get_host(),
  ipv4_addresses: get_ipv4_adresses(),
  env_msg: Application.fetch_env!(:whoami, :env_msg)
}
 */
#[derive(Serialize)]
struct Stats {
    host: String,
    ipv4_addresses: String,
    env_msg: String,
}

#[tokio::main]
async fn main() {
    let routes = warp::any().then(warp::reply::with_status("NOT FOUND", StatusCode::NOT_FOUND));

    warp::serve(routes).run(([0, 0, 0, 0], 4000)).await;
}
