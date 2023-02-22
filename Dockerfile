FROM rust:1.66 as build

RUN mkdir -p /opt/whoami

ADD Cargo.toml /opt/whoami/Cargo.toml
ADD Cargo.lock /opt/whoami/Cargo.lock
ADD src /opt/whoami/src

WORKDIR /opt/whoami

RUN cargo build --release

# ===== ===== jarvis ===== =====

FROM gcr.io/distroless/cc

COPY --from=build /opt/whoami/target/release/whoami /

CMD ["/whoami"]