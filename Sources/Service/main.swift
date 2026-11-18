import ServiceWorker

#if arch(wasm32)
Service.main()
#else
await Service.main()
#endif
