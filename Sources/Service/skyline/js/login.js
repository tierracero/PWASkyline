
var hasDefaultPropertiesItems = true
while (hasDefaultPropertiesItems) {
    let items = document.getElementsByName("default_theme_properties")
    if (items.length > 0) {
        for (var i = 0; i < items.length; i++ ) {
            items[i].remove();
        }
    }
    else {
        hasDefaultPropertiesItems = false
    }
}
function goToLogin(){
    window.location = `login`
}
