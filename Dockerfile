FROM ubuntu:24.04 AS build

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    automake \
    autotools-dev \
    bsdmainutils \
    build-essential \
    ca-certificates \
    curl \
    git \
    libboost-filesystem-dev \
    libboost-system-dev \
    libboost-test-dev \
    libboost-thread-dev \
    libevent-dev \
    libsqlite3-dev \
    libtool \
    libzmq3-dev \
    pkg-config \
    python3 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace
COPY . .

RUN make distclean >/dev/null 2>&1 || true
RUN cd src/secp256k1 && make distclean >/dev/null 2>&1 || true

RUN ./autogen.sh
RUN ./configure --without-gui --disable-bench --disable-fuzz-binary --without-miniupnpc --without-natpmp
RUN make -C src/secp256k1 -j"$(nproc)" libsecp256k1.la
RUN make -j"$(nproc)"

FROM build AS test
RUN src/test/test_pwdh --run_test=validation_tests

FROM ubuntu:24.04 AS runtime

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    libboost-filesystem1.83.0 \
    libboost-system1.83.0 \
    libboost-thread1.83.0 \
    libevent-2.1-7 \
    libevent-pthreads-2.1-7 \
    libsqlite3-0 \
    libzmq5 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/pwdh
COPY --from=build /workspace/src/pwdhd /usr/local/bin/pwdhd
COPY --from=build /workspace/src/pwdh-cli /usr/local/bin/pwdh-cli
COPY --from=build /workspace/src/pwdh-tx /usr/local/bin/pwdh-tx
COPY --from=build /workspace/src/pwdh-wallet /usr/local/bin/pwdh-wallet

ENTRYPOINT ["pwdhd"]
