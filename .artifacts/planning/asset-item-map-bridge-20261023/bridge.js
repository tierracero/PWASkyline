// Asset history has its own map/controller so it cannot replace another view's map.
function createAssetItemLocationMap(mapId, token, lat, lon) {
    const validCoordinate = (latitude, longitude) =>
        Number.isFinite(latitude) && Number.isFinite(longitude) &&
        latitude >= -90 && latitude <= 90 && longitude >= -180 && longitude <= 180;
    if (typeof mapkit === "undefined" || !document.getElementById(mapId) ||
        !validCoordinate(lat, lon)) {
        return null;
    }

    let locationMap = null;
    try {
        mapkit.init({
            authorizationCallback: function(done) { done(token); },
            language: "es"
        });
        locationMap = new mapkit.Map(mapId);
        const currentCoordinate = new mapkit.Coordinate(lat, lon);
        locationMap.region = new mapkit.CoordinateRegion(
            currentCoordinate,
            new mapkit.CoordinateSpan(0.020528323102041, 0.043467582244898)
        );
        const currentMarker = new mapkit.MarkerAnnotation(currentCoordinate, {
            draggable: false,
            selected: true,
            title: "Ubicación actual"
        });
        locationMap.addAnnotation(currentMarker);

        let historyAnnotations = [];
        let historyOverlay = null;
        let destroyed = false;
        const clearHistory = () => {
            if (historyOverlay) { locationMap.removeOverlay(historyOverlay); }
            if (historyAnnotations.length) { locationMap.removeAnnotations(historyAnnotations); }
            historyOverlay = null;
            historyAnnotations = [];
        };

        return {
            // Swift sends the completed, oldest-to-newest selection as JSON.
            setHistory: function(json) {
                if (destroyed) { return false; }
                try {
                    const input = JSON.parse(json);
                    if (!Array.isArray(input)) { return false; }
                    const seen = new Set([`${lat},${lon}`]);
                    const points = [];
                    for (let index = input.length - 1; index >= 0 && points.length < 9; index--) {
                        const point = input[index];
                        if (!point || !validCoordinate(point.latitude, point.longitude)) { continue; }
                        const key = `${point.latitude},${point.longitude}`;
                        if (seen.has(key)) { continue; }
                        seen.add(key);
                        points.push(point);
                    }
                    points.reverse();
                    clearHistory();
                    if (!points.length) { return true; }

                    const coordinates = points.map(point =>
                        new mapkit.Coordinate(point.latitude, point.longitude));
                    historyAnnotations = coordinates.map((coordinate, index) => {
                        const opacity = points.length === 1 ? 0.9 : 0.5 + 0.4 * index / (points.length - 1);
                        const title = `Ubicación anterior ${index + 1}`;
                        return new mapkit.Annotation(coordinate, function() {
                            const element = document.createElement("div");
                            element.textContent = String(index + 1);
                            element.setAttribute("aria-label", title);
                            Object.assign(element.style, {
                                width: "26px",
                                height: "26px",
                                borderRadius: "50%",
                                background: "rgb(145, 145, 145)",
                                color: "black",
                                border: "3px solid rgb(0 0 0)",
                                boxSizing: "border-box",
                                display: "flex",
                                alignItems: "center",
                                justifyContent: "center",
                                fontSize: "12px",
                                fontWeight: "700",
                                opacity: String(opacity)
                            });
                            return element;
                        }, {
                            draggable: false,
                            selected: false,
                            size: { width: 26, height: 26 },
                            anchorOffset: new DOMPoint(0, -13),
                            displayPriority: 1000,
                            title: title,
                            accessibilityLabel: title,
                            calloutEnabled: true
                        });
                    });
                    historyOverlay = new mapkit.PolylineOverlay(coordinates.concat([currentCoordinate]), {
                        style: new mapkit.Style({
                            lineWidth: 4,
                            strokeColor: "rgb(255, 165, 0)",
                            strokeOpacity: 0.65,
                            lineCap: "round",
                            lineJoin: "round"
                        }),
                        enabled: false
                    });
                    locationMap.addOverlay(historyOverlay);
                    locationMap.addAnnotations(historyAnnotations);
                    locationMap.showItems([currentMarker, ...historyAnnotations, historyOverlay], {
                        animate: false,
                        padding: new mapkit.Padding(48, 36, 48, 36)
                    });
                    currentMarker.selected = true;
                    return true;
                } catch (_) {
                    clearHistory();
                    return false;
                }
            },
            destroy: function() {
                if (destroyed) { return; }
                destroyed = true;
                locationMap.destroy();
                historyAnnotations = [];
                historyOverlay = null;
            }
        };
    } catch (_) {
        if (locationMap) { locationMap.destroy(); }
        return null;
    }
}
