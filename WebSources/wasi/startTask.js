import { SwiftRuntime } from 'javascript-kit-swift'

const swift = new SwiftRuntime()

const positiveByteLength = value => {
    const byteLength = Number.parseInt(value, 10)
    return Number.isSafeInteger(byteLength) && byteLength > 0 ? byteLength : 0
}

const findWasmMeta = name => {
    if (typeof document === 'undefined') return undefined
    return Array.from(document.head?.querySelectorAll('meta[name]') ?? [])
        .find(meta => meta.getAttribute('name') === name)
}

const setWasmMeta = (name, byteLength) => {
    const bytes = positiveByteLength(byteLength)
    if (bytes === 0 || typeof document === 'undefined' || !document.head) return

    const meta = findWasmMeta(name) ?? document.createElement('meta')
    meta.setAttribute('name', name)
    meta.setAttribute('content', String(bytes))
    meta.setAttribute('data-bytes', String(bytes))
    if (!meta.parentNode) document.head.appendChild(meta)
}

const getConfiguredWasmByteLength = (target, metadata) => {
    const configuredBytes = positiveByteLength(metadata?.decodedBytes)
    if (configuredBytes > 0) setWasmMeta(`${target}.wasm`, configuredBytes)

    return positiveByteLength(
        findWasmMeta(`${target}.wasm`)?.getAttribute('content')
    )
}

const recordResponseMetadata = (target, response) => {
    const transferredBytes = positiveByteLength(response.headers.get('Content-Length'))
    const encoding = (response.headers.get('Content-Encoding') ?? 'identity').toLowerCase()

    if (encoding.includes('br')) {
        setWasmMeta(`${target}.wasm.br`, transferredBytes)
    } else if (encoding.includes('gzip')) {
        setWasmMeta(`${target}.wasm.gz`, transferredBytes)
    } else {
        setWasmMeta(`${target}.wasm`, transferredBytes)
    }
}

export const startWasiTask = async (wasi, target, isService, metadata = {}) => {
    // Fetch the WASM once. A second HEAD request can be queued behind this
    // download and delay the loading UI for the full transfer duration.
    const response = await fetch(`/${target}.wasm`)

    if (!response.ok) {
        if (!isService) document.dispatchEvent(new Event('WASMLoadingError'))
        throw new Error(`Unable to load /${target}.wasm: HTTP ${response.status}`)
    }

    const reader = response.body?.getReader()
    if (!reader) {
        if (!isService) document.dispatchEvent(new Event('WASMLoadingError'))
        throw new Error(`Unable to stream /${target}.wasm`)
    }

    recordResponseMetadata(target, response)

    let decodedByteLength = getConfiguredWasmByteLength(target, metadata)
    const contentEncoding = (response.headers.get('Content-Encoding') ?? '').toLowerCase()
    if (decodedByteLength === 0 && (!contentEncoding || contentEncoding === 'identity')) {
        decodedByteLength = positiveByteLength(response.headers.get('Content-Length'))
    }

    if (!isService) {
        if (decodedByteLength > 0) {
            document.dispatchEvent(new Event('WASMLoadingStarted'))
            document.dispatchEvent(new CustomEvent('WASMLoadingProgress', { detail: 0 }))
        } else {
            document.dispatchEvent(new Event('WASMLoadingStartedWithoutProgress'))
        }
    }

    // Read the decoded response body. Browsers transparently decompress Brotli
    // and Gzip here, so progress must use the decoded .wasm byte length.
    let receivedLength = 0
    let chunks = []
    let lastProgress = 0
    while(true) {
        const {done, value} = await reader.read()
        if (done) break
        chunks.push(value)
        receivedLength += value.length
        if (!isService && decodedByteLength > 0) {
            const progress = Math.min(99, Math.floor(receivedLength / decodedByteLength * 100))
            if (progress > lastProgress) {
                lastProgress = progress
                document.dispatchEvent(new CustomEvent('WASMLoadingProgress', { detail: progress }))
            }
        }
    }
    if (!isService && decodedByteLength > 0) {
        document.dispatchEvent(new CustomEvent('WASMLoadingProgress', { detail: 100 }))
    }

    // Concatenate chunks into a single Uint8Array.
    let chunksAll = new Uint8Array(receivedLength)
    let position = 0
    for (let chunk of chunks) {
        chunksAll.set(chunk, position)
        position += chunk.length
    }

    // Instantiate the WebAssembly file
    const wasmBytes = chunksAll.buffer
    
    const patchWASI = function (wasiObject) {
        // PATCH: @wasmer-js/wasi@0.x forgets to call `refreshMemory` in `clock_res_get`,
        // which writes its result to memory view. Without the refresh the memory view,
        // it accesses a detached array buffer if the memory is grown by malloc.
        // But they wasmer team discarded the 0.x codebase at all and replaced it with
        // a new implementation written in Rust. The new version 1.x is really unstable
        // and not production-ready as far as katei investigated in Apr 2022.
        // So override the broken implementation of `clock_res_get` here instead of
        // fixing the wasi polyfill.
        // Reference: https://github.com/wasmerio/wasmer-js/blob/55fa8c17c56348c312a8bd23c69054b1aa633891/packages/wasi/src/index.ts#L557
        const original_clock_res_get = wasiObject.wasiImport["clock_res_get"]
        
        wasiObject.wasiImport["clock_res_get"] = (clockId, resolution) => {
            wasiObject.refreshMemory()
            return original_clock_res_get(clockId, resolution)
        }
        return wasiObject.wasiImport
    }
    
    var wasmImports = {}
    wasmImports.wasi_snapshot_preview1 = patchWASI(wasi)
    wasmImports.javascript_kit = swift.wasmImports
    wasmImports.__stack_sanitizer = {
        report_stack_overflow: () => {
            throw new Error("Detected stack buffer overflow.")
        }
    }

    const module = await WebAssembly.instantiate(wasmBytes, wasmImports)

    // Node support
    const instance = "instance" in module ? module.instance : module
    
    if (swift && instance.exports.swjs_library_version) {
        swift.setInstance(instance)
    }
    
    // Start the WebAssembly WASI instance
    wasi.start(instance)
    
    // Initialize and start Reactor
    if (instance.exports._initialize) {
        instance.exports._initialize()
        if (instance.exports.__main_argc_argv) {
            instance.exports.__main_argc_argv()
        } else {
            instance.exports.main()
        }
    }
}
