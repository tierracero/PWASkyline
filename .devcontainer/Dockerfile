FROM swiftstream/web-dev:noble

# SwiftStream omits the feature flag required by Swift 6's trunc_sat instructions.
RUN mkdir -p /usr/local/libexec \
    && mv /usr/local/bin/wasm-opt /usr/local/libexec/wasm-opt
COPY wasm-opt /usr/local/bin/wasm-opt
RUN chmod 755 /usr/local/bin/wasm-opt
