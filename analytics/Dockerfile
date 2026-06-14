FROM ocaml/opam:ubuntu-24.04-ocaml-5.4

USER root
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    git \
    pkg-config \
    libev-dev \
    libssl-dev \
    libffi-dev \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

USER opam
WORKDIR /home/opam/app

# Initialize opam switch and install deps
RUN opam init --bare --disable-sandboxing --yes && \
    opam switch create carscope 5.4.0 --yes || true

RUN eval $(opam env --switch=carscope) && \
    opam install dream yojson ppx_deriving_yojson lwt_ppx core_unix dune --yes

# Copy source code
COPY --chown=opam:opam . .

# Build application
RUN eval $(opam env --switch=carscope) && \
    dune build

EXPOSE 8080

CMD ["sh", "-c", "eval $(opam env --switch=carscope) && dune exec bin/server.exe"]
