(function (global) {
    "use strict";

    if (global.PWASkylineSpeech) {
        return;
    }

    const Recognition = global.SpeechRecognition || global.webkitSpeechRecognition;
    let recognizer = null;
    let eventCallback = null;
    let currentState = "idle";
    let isAborting = false;
    let currentUtterance = null;

    function emit(event) {
        
        if (typeof eventCallback !== "function") {
            return;
        }

        const payload = Object.assign({
            type: "state",
            state: currentState,
            finalText: "",
            interimText: "",
            errorCode: "",
            message: ""
        }, event || {});

        try {
            eventCallback(JSON.stringify(payload));
        } catch (_) {
            // Swift may already have released its callback during teardown.
        }
    }

    function setState(state) {
        currentState = state;
        emit({ type: "state", state: state });
    }

    function removeHandlers(instance) {
        if (!instance) {
            return;
        }

        instance.onstart = null;
        instance.onresult = null;
        instance.onerror = null;
        instance.onend = null;
        instance.onaudiostart = null;
        instance.onaudioend = null;
        instance.onspeechstart = null;
        instance.onspeechend = null;
    }

    function release(instance, notifyIdle) {
        if (!instance || instance !== recognizer) {
            return;
        }

        if (notifyIdle) {
            currentState = "idle";
            emit({ type: "state", state: "idle" });
        }

        removeHandlers(instance);
        recognizer = null;
        eventCallback = null;
        currentState = "idle";
        isAborting = false;
    }

    function disposeCurrentRecognizer() {
        if (!recognizer) {
            return;
        }

        const previous = recognizer;
        removeHandlers(previous);
        recognizer = null;
        eventCallback = null;
        currentState = "idle";
        isAborting = false;

        try {
            previous.abort();
        } catch (_) {
            // The previous recognizer may already be ending.
        }
    }

    function errorMessage(code) {
        switch (code) {
        case "not-allowed":
        case "service-not-allowed":
            return "No se pudo acceder al micrófono. Verifica el permiso del micrófono en la configuración del navegador.";
        case "audio-capture":
            return "No se encontró un micrófono disponible para iniciar el dictado.";
        case "no-speech":
            return "No se detectó voz. Intenta nuevamente cuando estés listo.";
        case "network":
            return "El servicio de reconocimiento de voz no está disponible en este momento.";
        case "language-not-supported":
            return "El idioma seleccionado no está disponible para el reconocimiento de voz.";
        case "aborted":
            return "El dictado por voz fue cancelado.";
        default:
            return "No fue posible continuar con el reconocimiento de voz.";
        }
    }

    function isSupported() {
        return typeof Recognition === "function";
    }

    function stopSpeaking() {
        if (!global.speechSynthesis) {
            currentUtterance = null;
            return false;
        }

        try {
            global.speechSynthesis.cancel();
            currentUtterance = null;
            return true;
        } catch (_) {
            currentUtterance = null;
            return false;
        }
    }

    function speak(message, options) {
        const text = typeof message === "string" ? message.trim() : "";
        if (
            !text ||
            !global.speechSynthesis ||
            typeof global.SpeechSynthesisUtterance !== "function"
        ) {
            return false;
        }

        stopSpeaking();

        const configuration = options || {};
        const utterance = new global.SpeechSynthesisUtterance(text);
        utterance.lang = configuration.language || "es-MX";
        utterance.rate = Number(configuration.rate) || 1;
        utterance.pitch = Number(configuration.pitch) || 1;

        utterance.onend = function () {
            if (currentUtterance === utterance) {
                currentUtterance = null;
            }
        };
        utterance.onerror = utterance.onend;

        currentUtterance = utterance;
        global.speechSynthesis.speak(utterance);
        return true;
    }

    function start(options, callback) {
        stopSpeaking();
        disposeCurrentRecognizer();
        eventCallback = typeof callback === "function" ? callback : null;

        if (!isSupported()) {
            currentState = "idle";
            emit({
                type: "error",
                state: "idle",
                errorCode: "unsupported",
                message: "El reconocimiento de voz no está disponible en este navegador. Puedes continuar escribiendo normalmente."
            });
            eventCallback = null;
            return false;
        }

        const configuration = options || {};
        const instance = new Recognition();
        recognizer = instance;
        isAborting = false;

        instance.lang = configuration.language || "es-MX";
        instance.continuous = configuration.continuous === true;
        instance.interimResults = configuration.interimResults !== false;
        instance.maxAlternatives = Number(configuration.maxAlternatives) || 1;

        instance.onstart = function () {
            if (instance === recognizer) {
                setState("listening");
            }
        };

        instance.onresult = function (event) {
            if (instance !== recognizer) {
                return;
            }

            let finalText = "";
            let interimText = "";

            for (let index = event.resultIndex; index < event.results.length; index += 1) {
                const result = event.results[index];
                const transcript = result[0] && result[0].transcript ? result[0].transcript : "";

                if (result.isFinal) {
                    finalText += transcript;
                } else {
                    interimText += transcript;
                }
            }

            emit({
                type: "result",
                state: currentState,
                finalText: finalText.trim(),
                interimText: interimText.trim()
            });
        };

        instance.onerror = function (event) {
            if (instance !== recognizer) {
                return;
            }

            const code = event && event.error ? event.error : "unknown";
            if (isAborting && code === "aborted") {
                return;
            }

            currentState = "error";
            emit({
                type: "error",
                state: "error",
                errorCode: code,
                message: errorMessage(code)
            });
            release(instance, true);
        };

        instance.onend = function () {
            release(instance, true);
        };

        setState("starting");

        try {
            instance.start();
            return true;
        } catch (error) {
            emit({
                type: "error",
                state: "error",
                errorCode: "unable-to-start",
                message: "No fue posible iniciar el dictado por voz. Intenta nuevamente."
            });
            release(instance, true);
            return false;
        }
    }

    function stop() {
        if (!recognizer) {
            return false;
        }

        setState("stopping");

        try {
            recognizer.stop();
            return true;
        } catch (_) {
            emit({
                type: "error",
                state: "error",
                errorCode: "unable-to-stop",
                message: "No fue posible detener el dictado por voz correctamente."
            });
            release(recognizer, true);
            return false;
        }
    }

    function abort() {
        stopSpeaking();

        if (!recognizer) {
            currentState = "idle";
            return false;
        }

        const instance = recognizer;
        isAborting = true;
        setState("stopping");
        removeHandlers(instance);

        try {
            instance.abort();
            currentState = "idle";
            emit({ type: "state", state: "idle" });
            recognizer = null;
            eventCallback = null;
            isAborting = false;
            return true;
        } catch (_) {
            recognizer = instance;
            release(instance, true);
            return false;
        }
    }

    function isListening() {
        return currentState === "starting" || currentState === "listening" || currentState === "stopping";
    }

    global.PWASkylineSpeech = Object.freeze({
        isSupported: isSupported,
        start: start,
        stop: stop,
        abort: abort,
        isListening: isListening,
        speak: speak,
        stopSpeaking: stopSpeaking
    });
}(globalThis));
