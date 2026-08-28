const fs = require('fs')
const path = require('path')
const webpack = require('webpack')

const findWasmByteLength = (target, isDevelopment, outputPath) => {
    const fileName = `${target}.wasm`.toLowerCase()
    const buildMode = isDevelopment ? 'debug' : 'release'
    const candidateDirectories = [
        path.resolve(__dirname, '..', '.build', '.wasi', 'wasm32-unknown-wasi', buildMode),
        outputPath
    ]

    for (const directory of candidateDirectories) {
        try {
            const matchingFile = fs.readdirSync(directory)
                .find(candidate => candidate.toLowerCase() === fileName)
            if (!matchingFile) continue

            const stats = fs.statSync(path.join(directory, matchingFile))
            if (!stats.isFile()) continue

            const byteLength = stats.size
            if (Number.isSafeInteger(byteLength) && byteLength > 0) {
                return byteLength
            }
        } catch (_) {
            // Webpack can still produce a usable bundle. The loader will show
            // indeterminate progress when no build artifact is available.
        }
    }

    return 0
}

module.exports = (env, argv) => {
    const isDevelopment = argv?.mode === 'development' || process.env.NODE_ENV === 'development'
    const decodedWasmBytes = findWasmByteLength(
        env.app.target,
        isDevelopment,
        env.app.absoluteOutputPath
    )
    const config = {
        entry: env.app.isServiceWorker ? './serviceWorker.js' : './app.js',
        module: {
            rules: [{
                test: /\.ts?$/,
                use: 'ts-loader',
                exclude: /node_modules/
            }]
        },
        plugins: [
            new webpack.DefinePlugin({
                '_SwiftStreamEnv_': JSON.stringify({
                    isDevelopment: isDevelopment,
                    target: env.app.target,
                    wasm: {
                        decodedBytes: decodedWasmBytes
                    }
                })
            })
        ],
        resolve: {
            extensions: ['.tsx', '.ts', '.js']
        },
        output: {
            filename: `${env.app.target}.js`,
            path: env.app.absoluteOutputPath
        }
    }
    if (isDevelopment) {
        config.devtool = 'source-map'
    }
    return config
}
