# Clean-room environment for checking openai/math Comparator challenges.
# Comparator assumes the solution has never been built in the checking
# environment, so the repo is cloned fresh inside the container, never bind-mounted.
FROM ubuntu:24.04

ARG LEAN_TOOLCHAIN=leanprover/lean4:v4.34.1
ARG LEAN4EXPORT_REV=v4.34.0

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      ca-certificates curl git build-essential golang-go zstd \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash checker && mkdir /work && chown checker /work
USER checker
WORKDIR /home/checker
ENV PATH=/home/checker/.elan/bin:/home/checker/go/bin:/home/checker/bin:$PATH

RUN curl -sSfL https://raw.githubusercontent.com/leanprover/elan/master/elan-init.sh \
      | sh -s -- -y --default-toolchain ${LEAN_TOOLCHAIN} \
    && elan toolchain install ${LEAN_TOOLCHAIN}

RUN go install github.com/zouuup/landrun/cmd/landrun@main

# lean4export reads the project's .olean files, which only load under the exact
# Lean version that wrote them, so build it with the project's toolchain.
RUN mkdir -p bin \
    && git clone https://github.com/leanprover/lean4export \
    && cd lean4export && git checkout ${LEAN4EXPORT_REV} \
    && echo ${LEAN_TOOLCHAIN} > lean-toolchain \
    && lake build && cp .lake/build/bin/lean4export ../bin/

RUN git clone https://github.com/leanprover/comparator \
    && cd comparator && lake build && cp .lake/build/bin/comparator ../bin/

COPY --chown=checker run-challenge.sh /home/checker/bin/run-challenge
