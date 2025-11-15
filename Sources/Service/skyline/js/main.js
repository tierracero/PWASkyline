

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

function isNumeric(str) {
  if (typeof str != "string") return false // we only process strings!
  return !isNaN(str) && // use type coercion to parse the _entirety_ of the string (`parseFloat` alone does not do this)...
             !isNaN(parseFloat(str)) // ...and ensure strings of whitespace fail
}
function setCookie(cname, cvalue, exdays) {
    var d = new Date();
    d.setTime(d.getTime() + (exdays * 24 * 60 * 60 * 1000));
    var expires = "expires="+d.toUTCString();
    document.cookie = cname + "=" + cvalue + ";" + expires + ";path=/";
    
    $('#downLoadAppInvite').fadeOut(function(){
        $('#downLoadAppInvite').remove
    });

}
function unsetCookie(cname) {
    document.cookie = cname + "=; expires=Thu, 01 Jan 1970 00:00:00 UTC";
}
function getCookie(c_name){
    var c_value = document.cookie;
    var c_start = c_value.indexOf(" " + c_name + "=");
    if (c_start == -1){
        c_start = c_value.indexOf(c_name + "=");
    }
    if (c_start == -1){
        c_value = null;
    }else{
        c_start = c_value.indexOf("=", c_start) + 1;
        var c_end = c_value.indexOf(";", c_start);
        if (c_end == -1){
            c_end = c_value.length;
        }
        c_value = unescape(c_value.substring(c_start,c_end));
    }
    return c_value;
}
function purgeToxicElements(obj){
    var newarr = {}
    let keys = Object.keys(obj)
    

    keys.forEach( key => {
         let nobj = obj[key]
         console.log(key, typeof nobj)
         if(typeof nobj === 'object'){

            if (Array.isArray(nobj)){
                // newarr[key] = purgeToxicArray(nobj)
                var tarr = []
                nobj.forEach( tobj => {

                    

                    if(typeof tobj === 'string'){
                        tarr.push(`${tobj}`)
                    }
                    else if(typeof tobj === 'number'){
                        tarr.push(tobj)
                    }
                    else{
                        tarr.push(purgeToxicElements(tobj))
                    }
                })
                newarr[key] = tarr
            }
            else{
                newarr[key] = purgeToxicElements(nobj)
            }
         }
         else{
            if(typeof nobj === 'string'){
                newarr[key] = nobj.replace(/\?\?/g, "?").replace(/\?\?/g, "?").replace(/\?\?/g, "?").replace(/\?\?/g, "?")
            }
            else{
                newarr[key] = nobj
            }
         }
    });
    return newarr
}
function sendPostNew(channel,ie,inarr,success,error){
    
    var user = localStorage.custCatchUser;
    var token = localStorage.custCatchToken;
    var key = localStorage.custCatchKey;
    var mid = localStorage.custCatchMid;
        
    var url = `https://intratc.co/api/${channel}/${ie}`
    if(channel == ""){
        url = `https://intratc.co/api/${ie}`
    }

//    if(tcdevmode){
//        console.log(JSON.stringify(inarr))
//        console.log(inarr)
//    }

    let narr = purgeToxicElements(inarr)

    console.log("-=-=-=-=-=-=-=-=-=-=-=-")
    console.log(narr)
    console.log("-=-=-=-=-=-=-=-=-=-=-=-")

    // console.log(btoa(JSON.stringify({
    //     'AppID': '1000',
    //     'user': decodeURIComponent(user),
    //     'mid': decodeURIComponent(mid),
    //     'key': decodeURIComponent(key),
    //     'token': decodeURIComponent(token),
    //     'tcon': 'web'
    // })))

    $.ajax({
        url: url,
        type: "POST",
        processData: false,
        headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': btoa(JSON.stringify({
                'AppID': '1000',
                'user': decodeURIComponent(user),
                'mid': decodeURIComponent(mid),
                'key': decodeURIComponent(key),
                'token': decodeURIComponent(token),
                'tcon': 'web'
            }))
        },
        data:JSON.stringify(narr),
        dataType: "json",
        success: function (resp) {
            console.log(resp);
            success(resp);
        },
        error: function (xhr, ajaxOptions, thrownError) {
            console.log(url)
            console.error(xhr.status);
            console.error(ajaxOptions);
            console.error(thrownError);
            error( xhr.status,thrownError)
        }
    });
}
function custLogout(){

    sendPostNew('auth','v1/customerLogout',{},
    (resp)=>{
        if(resp.status != "ok"){
            showError("Error de comunicacion, intente de nuevo",5000)
            return
        }
        
        let life = 0
        let base = getCookie("siteBaseCookie")
        setCookie('siteBaseCookie','',life)
        setCookie(base, '', life)
        setCookie(base+'_user' , '',life)
        setCookie(base+'_token', '',life)
        setCookie(base+'_mid'  , '',life)
        setCookie(base+'_key'  , '',life)
        setCookie(base+'_store' ,'',life)
        setCookie(base+'_workGroop','',life)

        setTimeout(() => {
            window.location.href= 'panel.php'
        }, 100);
    },
    (err,or)=>{
        showError("Error de comunicacion, intente de nuevo",5000)
        unloading();
    })
}
function getDate(uts = null){
    
    let longDays = ['Domingo','Lunes','Martes','Miercoles','Jueves','Viernes','Sabado'];
    let shortDays = ['Dom','Lun','Mar','Mie','Jue','Vie','Sab'];
    let longMonths = ['Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre']
    let shortMonths = ['Ene','Feb','Mar','Abr','May','Jun','Jul','Ago','Sep','Oct','Nov','Dic']
    let months = ['01','02','03','04','05','06','07','08','09','10','11','12'];
    
    var thisDate = new Date()
    
    if(uts != null){
        thisDate = new Date(uts * 1000);
    }
    
    let mesCorto = shortMonths[thisDate.getMonth()]
    let mesLargo = longMonths[thisDate.getMonth()]
    
    let month = (thisDate.getMonth()+1);
    if( month < 10){
        month = '0'+month.toString();
    }
    var day = thisDate.getDate();
    if(day < 10){
        day = '0'+day.toString();
    }
    
    var hour = thisDate.getHours();
    if(hour < 10){
        hour = '0'+hour.toString();
    }
    
    var min = thisDate.getMinutes();
    if(min < 10){
        min = '0'+min.toString();
    }
    
    return {
    day: day,
    month: month,
    year: thisDate.getFullYear(),
    vDate: day+'/'+month+'/'+thisDate.getFullYear().toString().substring(2),
    time: hour+':'+min+':'+thisDate.getSeconds(),
    stime: hour+':'+min,
    hour: hour,
        'min': min,
    sec: thisDate.getSeconds(),
    timestamp: ''+thisDate.getFullYear() + min + day + hour + min+thisDate.getSeconds(),
    uts: Math.round(thisDate.getTime() / 1000),
    dia: longDays[thisDate.getDay()],
    diaCorto: shortDays[thisDate.getDay()],
    mes: mesLargo,
    mesCorto: mesCorto
    };
}
function isoDateToUTS(isoDate){
    
    console.log(Math.floor(new Date(isoDate).getTime() / 1000))
    
    return Math.floor(new Date(isoDate).getTime() / 1000)
}
function formatMoney(n, c, d, t) {
    var c = isNaN(c = Math.abs(c)) ? 2 : c,
    d = d == undefined ? "." : d,
    t = t == undefined ? "," : t,
    s = n < 0 ? "-" : "",
    i = String(parseInt(n = Math.abs(Number(n) || 0).toFixed(c))),
    j = (j = i.length) > 3 ? j % 3 : 0;
    
    return s + (j ? i.substr(0, j) + t : "") + i.substr(j).replace(/(\d{3})(?=\d)/g, "$1" + t) + (c ? d + Math.abs(n - i).toFixed(c).slice(2) : "");
}
function printServiceOrder(type,id,modifiedAt) {
    
    function render(contents){
        // var contents = document.getElementById("msgGrid").innerHTML;
        var frame1 = document.createElement('iframe');
        frame1.name = "frame1";
        frame1.style.position = "absolute";
        frame1.style.top = "-10000000px";
        document.body.appendChild(frame1);
        var frameDoc = frame1.contentWindow ? frame1.contentWindow : frame1.contentDocument.document ? frame1.contentDocument.document : frame1.contentDocument;
        frameDoc.document.open();
        
        frameDoc.document.write('<html><head>');
        frameDoc.document.write('<meta charset="utf-8">');
        frameDoc.document.write('<title>Imprimir Documento</title>');
        frameDoc.document.write('<meta name="viewport" content="width=device-width, initial-scale=1.0">');
        frameDoc.document.write('<link type="text/css" rel="stylesheet" href="https://tierracero.com/dev/core/css/zice.style.css">');
        frameDoc.document.write(`<script type="text/javascript" src="https://tierracero.com/dev/skyline/js/QRCode.js"></scr`+`ipt>`);
        
        
        frameDoc.document.write('</head><body>');
        frameDoc.document.write(contents);
        frameDoc.document.write('</body></html>');
        frameDoc.document.close();
        setTimeout(function () {
            window.frames["frame1"].focus();
            window.frames["frame1"].print();
            document.body.removeChild(frame1);
        }, 500);
        return false;
    }
    
    function renderOrder(id) {
        
        var order = custCatchFolioRefrence[id]
        var notes = custCatchFolioNotesRefrence[id]
        var payments = custCatchFolioPaymentRefrence[id]
        var charges = custCatchFolioChargesRefrence[id]
        var pocs = custCatchFolioPocsRefrence[id]
        var files = custCatchFolioFilesRefrence[id]
        var equipments = custCatchFolioEquipmentRefrence[id]
        
        var typeOfServiceObjectTag = "Entrega"
        if(configServiceTags.typeOfServiceObject == "helth") {
            typeOfServiceObjectTag = "Cita"
        }
        else if(configServiceTags.typeOfServiceObject == "food") {
            typeOfServiceObjectTag = "Entrega"
        }
        else if(configServiceTags.typeOfServiceObject == "delivery") {
            typeOfServiceObjectTag = "Entrega"
        }
        else if(configServiceTags.typeOfServiceObject == "service") {
            typeOfServiceObjectTag = "Entrega"
        }
        else if(configServiceTags.typeOfServiceObject == "product") {
            typeOfServiceObjectTag = "Entrega"
        }
        
        var body = ""
        var equipmentsString = ""
        var cc = 1
        equipments.forEach( eq => {
            
            var tag1 = ""
            if(eq.tag1 != ""){
                tag1 = ` ${configServiceTags.tag1Name}: ${eq.tag1}`
            }
            var tag2 = ""
            if(eq.tag2 != ""){
                tag2 = ` ${configServiceTags.tag2Name}: ${eq.tag2}`
            }
            var tag3 = ""
            if(eq.tag3 != ""){
                tag3 = ` ${configServiceTags.tag3Name}: ${eq.tag3}`
            }
            var tag4 = ""
            if(eq.tag4 != ""){
                tag4 = ` ${configServiceTags.tag4Name}: ${eq.tag4}`
            }
            
            var _es = `<strong>Equipo #${cc}:</strong>${tag1}${tag2}${tag3}${tag4}<br>${configServiceTags.tagDescrName}<br>${eq.tagDescr}<br>`
            
            if(configGeneral.docuWelcome.length > 1000 && configGeneral.docuWelcome.length < 1801){
                var _es = `<strong>#${cc} Equipo:</strong> ${eq.tag1} ${eq.tag2} ${eq.tag3} ${eq.tag4} <br><strong>Descripcion:</strong> ${eq.tagDescr}<br>`
            }
            else if(configGeneral.docuWelcome.length > 1800){
                var _es = `<strong>#${cc}:</strong> ${eq.tag1} ${eq.tag2} ${eq.tag3} ${eq.tag4} ${eq.tagDescr}<br>`
            }
            
            equipmentsString += _es
            if(configServiceTags.checkTag1 == true || configServiceTags.checkTag2 == true || configServiceTags.checkTag3 == true ||configServiceTags.checkTag4 == true){
                if(configServiceTags.checkTag1){
                    equipmentsString += `${configServiceTags.checkTag1Name}: `
                    if(eq.eqtagCheck1){
                        equipmentsString += `SI;`
                    }
                    else{
                        equipmentsString += `NO;`
                    }
                }
                if(configServiceTags.checkTag2){
                    equipmentsString += `${configServiceTags.checkTag2Name}: `
                    if(eq.eqtagCheck2){
                        equipmentsString += `SI;`
                    }
                    else{
                        equipmentsString += `NO;`
                    }
                }
                if(configServiceTags.checkTag3){
                    equipmentsString += `${configServiceTags.checkTag3Name}: `
                    if(eq.eqtagCheck3){
                        equipmentsString += `SI;`
                    }
                    else{
                        equipmentsString += `NO;`
                    }
                }
                if(configServiceTags.checkTag3){
                    equipmentsString += `${configServiceTags.checkTag3Name}: `
                    if(eq.eqtagCheck3){
                        equipmentsString += `SI; `
                    }
                    else{
                        equipmentsString += `NO;`
                    }
                }
                equipmentsString += `<br>$`
            }
            cc++
        });
        
        // custStoreConfig.config.print.document = "miniprinter"
        
        if(custStoreConfig.config.print.document == "letter"){
            
            var fontSize = "12"
            
            if(configGeneral.docuWelcome.length > 1000 && configGeneral.docuWelcome.length < 1801){
                fontSize = "10"
            }
            else if(configGeneral.docuWelcome.length > 1800){
                fontSize = "8"
            }
            
            body =
            `<div style=" height:470px;overflow-x: hidden;">`+
            `<table width="100%" cellspacing="1" cellpadding="1">` +
            `<tr>`+
            `<td align="left" valign="middle" width="33%"><img src="contenido/${mainLogo}" style="max-width: 200px; max-height: 70px"></td>`+
            `<td align="center" valign="middle"><strong style="color:#000000"><div style="font-size:42px">${order.folio}</div> </strong></td>`+
            `<td width="33%" valign="middle">`
            if(typeof order.dueDate !== 'undefined'){
                let td = get_date(order.dueDate)
                var alertText = `${td.dia_corto} ${td.day}/${td.mesCorto} ${td.stime}`
                body += `<h3 style="margin-bottom: -3px;" class="unline normalize">${typeOfServiceObjectTag}: <strong style="color:#000">${alertText}</strong></h3>`
            }
            var td = get_date(order.createdAt)
            body += `<h3 style="margin-bottom: -3px;" class="unline normalize">Creado: <strong style="color:#000">${td.dia_corto} ${td.day}/${td.mesCorto} ${td.stime}</strong></h3>`
            body +=
            `</td>`+
            `</tr>` +
            `<tr>` +
            `<td colspan="2"><h1 class="normalize unline" style="margin-bottom: -3px; color:#000000"><strong>${order.rel_acct_name}</strong></h1></td>`+
            `<td rowspan="4" align="center">`+
            `<div id="qrdivinner" style="margin-bottom:7px"></div>`
            if(custStoreConfig.config.print.image != "none"){
                if(custStoreConfig.config.print.image == "pinpattern"){
                    body += '<img src="https://tierracero.com/dev/core/images/pimg-PatronPIN.jpg" height="180">';
                }
            }
            body +=
            `<div style="border-bottom: #000 solid 1px; margin-top: 24px; margin-bottom: 12px"></div>`+
            `Firma de conformidad`+
            `<div style="border-bottom: #000 solid 1px; margin-top: 32px; margin-bottom: 12px"></div>`+
            `<div align="center">Firma de recibido</div>`+
            `</td>`+
            `</tr>`+
            `<tr>`+
            `<td valign="top" colspan="2" rowspan="2" style="font-size:14px"> Contacto:<strong> `
            
            if(order.street != "" || order.colony() != "" || order.city != ""){
                body += `${order.street} ${order.colony()} ${order.city}`
            }
            
            if(order.rel_acct_mob != "") {
                body += ` Celular: <strong>${order.rel_acct_mob}</strong>`
            }
            if(order.rel_acct_email != "") {
                body += ` Correo: <strong>${order.rel_acct_email}</strong>`
            }
            if(order.rel_acct_tel != "") {
                body += ` Telefono: <strong>${order.rel_acct_tel}</strong>`
            }
            body += `</strong></br>`
            body += equipmentsString
            
            var balance = 0
            
            body +=
            `<div>`+
            `<table width="100%" cellspacing="1" cellpadding="1">`+
            `<tr>`+
            `<td width="35"> <strong>Uni.</strong> </td>`+
            `<td><strong>Description</strong></td>`+
            `<td width="70"><strong>C. Uni.</strong></td>`+
            `<td width="70"><strong>S. Total</strong></td>`+
            `</tr>`
            
            charges.forEach(cha => {
                body +=
                `<tr>`+
                `<td width="35">` +
                (parseFloat(cha.cuant) / 100) +
                `</td>`+
                `<td>`+
                cha.name +
                `</td>`+
                `<td width="70">` +
                formatMoney(parseFloat(cha.cost) / 100) +
                `</td>`+
                `<td width="70">` +
                formatMoney(parseFloat(cha.cost * cha.cuant) / 10000) +
                `</td>`+
                `</tr>`
                
                balance += (cha.cost * cha.cuant)
                
            });
            
            pocs.forEach(cha => {
                
                body +=
                `<tr>`+
                `<td width="35">` +
                `1`+
                `</td>`+
                `<td>`+
                `${cha.name} ${cha.model}`+
                `</td>`+
                `<td width="70">` +
                formatMoney(parseFloat(cha.cost_sold) / 100) +
                `</td>`+
                `<td width="70">` +
                formatMoney(parseFloat(cha.cost_sold) / 100) +
                `</td>`+
                `</tr>`
                
                console.log(cha)
                
                balance += (cha.cost_sold * 100)
                
            });
            
            payments.forEach( pay => {
                balance -= (pay.cost * 100)
                body +=
                `<tr>`+
                `<td width="35">1</td>`+
                `<td>`+
                pay.description +
                `</td>`+
                `<td width="70"></td>`+
                `<td width="70">` +
                formatMoney(parseFloat(pay.cost) / 100) +
                `</td>`+
                `</tr>`
            });
            
            // if(balance >= 0){
            body +=
            `<tr>`+
            `<td width="35"></td>`+
            `<td colspan="2" align="right">Balance </td>`+
            `<td width="70">` +
            formatMoney(parseFloat(balance) / 10000) +
            `</td>`+
            `</tr>`
            // }
            
            body +=
            `</table>`
            
            body +=
            `<div style="font-size:${fontSize}px">`+
            (configGeneral.docuWelcome) +
            `<br>Acuerdo de privacidad en ${orTagsURL}/privacidad.`
            if(configGeneral.docuMoreTerm){
                body += ` Para leer más información, visita ${orTagsURL}/legal.`
            }
            body +=
            `</div>`+
            `</div>`+
            `</td>`+
            `</tr>`
            
            body +=
            `</table>`+
            `</div>`
            
            for(var i = 0; i < custStoreConfig.config.print.lineBreak; i ++){
                body += `<br>`
            }
            
            body +=
            `<div>`+
            `<table width="100%" cellspacing="1" cellpadding="1">` +
            `<tr>`+
            `<td align="left" width="33%"><img src="contenido/${mainLogo}" style="max-width: 200px; max-height: 70px"></td>`+
            `<td align="center">`+
            `<h2 style="margin-bottom: -3px;" class="unline">Orden de Trabajo</h2>`+
            `<small style="font-size:10px" class="normalize">SUC: <strong>${custStoreConfig.store.name}</strong> ${formatPhoneNumber(custStoreConfig.store.telephone)}<br> ${custStoreConfig.store.street} ${custStoreConfig.store.colony()} ${custStoreConfig.store.city}<br>${custStoreConfig.store.schedule_a} ${custStoreConfig.store.schedule_b} ${custStoreConfig.store.schedule_c}<br></small>`+
            `</td>`+
            `<td width="33%" valign="top">`+
            `<strong style="color:#000000"><div style="font-size:24px">FOLIO:</div> <div style="font-size:36px">${order.folio}</div> </strong>`+
            `</td>`+
            `</tr>` +
            `<tr>` +
            `<td colspan="2"><h1 class="normalize unline" style="margin-bottom: -3px; color:#000000"><strong>${order.rel_acct_name}</strong></h1></td>`+
            `<td rowspan="4" align="left">`
            if(typeof order.dueDate !== 'undefined'){
                var td = get_date(order.dueDate)
                let alertText = `${td.dia_corto} ${td.day}/${td.mesCorto} ${td.stime}`
                body += `<h3 style="margin-bottom: -3px;" class="unline normalize">${typeOfServiceObjectTag}: <strong style="color:#000">${alertText}</strong></h3>`
            }
            var td = get_date(order.createdAt)
            body += `<h3 style="margin-bottom: -3px;" class="unline normalize">Creado: <strong style="color:#000">${td.dia_corto} ${td.day}/${td.mesCorto} ${td.stime}</strong></h3>`+
            `<div id="qrdiv" align="center" style="margin:7px"></div>`
            // TODO: Incluir publisis
            // if(custStoreConfig.config.print.image != "none"){
            //     if(custStoreConfig.config.print.image == "pinpattern"){
            //         body += '<img src="https://tierracero.com/dev/core/images/pimg-PatronPIN.jpg" width="180">';
            //     }
            // }
            body +=
            `</td>`+
            `</tr>`+
            `<tr>`+
            `<td valign="top" colspan="2" rowspan="2" style="font-size:14px"> <strong>Contacto:</strong> `
            
            if(order.street != "" || order.colony() != "" || order.city != ""){
                body += `${order.street} ${order.colony()} ${order.city}`
            }
            
            if(order.rel_acct_mob != "") {
                body += ` Celular: <strong>${order.rel_acct_mob}</strong>`
            }
            if(order.rel_acct_email != "") {
                body += ` Correo: <strong>${order.rel_acct_email}</strong>`
            }
            if(order.rel_acct_tel != "") {
                body += ` Telefono: <strong>${order.rel_acct_tel}</strong>`
            }
            body += `</br>`
            body += equipmentsString
            
            body +=
            `<div>`+
            `<table width="100%" cellspacing="1" cellpadding="1">`+
            `<tr>`+
            `<td width="35"> <strong>Uni.</strong> </td>`+
            `<td><strong>Description</strong></td>`+
            `<td width="70"><strong>C. Uni.</strong></td>`+
            `<td width="70"><strong>S. Total</strong></td>`+
            `</tr>`
            charges.forEach(cha => {
                body +=
                `<tr>`+
                `<td width="35">` +
                (parseFloat(cha.cuant) / 100) +
                `</td>`+
                `<td>`+
                cha.name +
                `</td>`+
                `<td width="70">` +
                formatMoney(parseFloat(cha.cost) / 100) +
                `</td>`+
                `<td width="70">` +
                formatMoney(parseFloat(cha.cost * cha.cuant) / 10000) +
                `</td>`+
                `</tr>`
            });
            
            pocs.forEach(cha => {
                body +=
                `<tr>`+
                `<td width="35">` +
                `1`+
                `</td>`+
                `<td>`+
                `${cha.name} ${cha.model}`+
                `</td>`+
                `<td width="70">` +
                formatMoney(parseFloat(cha.cost_sold) / 100) +
                `</td>`+
                `<td width="70">` +
                formatMoney(parseFloat(cha.cost_sold) / 100) +
                `</td>`+
                `</tr>`
            });
            
            payments.forEach( pay => {
                
                body +=
                `<tr>`+
                `<td width="35">1</td>`+
                `<td>`+
                pay.description +
                `</td>`+
                `<td width="70"></td>`+
                `<td width="70">` +
                formatMoney(parseFloat(pay.cost) / 100) +
                `</td>`+
                `</tr>`
            });
            
            // if(balance >= 0){
            body +=
            `<tr>`+
            `<td width="35"></td>`+
            `<td colspan="2" align="right">Balance </td>`+
            `<td width="70">` +
            formatMoney(parseFloat(balance) / 10000) +
            `</td>`+
            `</tr>`
            // }
            
            body +=
            `</table>`
            body +=
            `<div style="font-size:9px">`+
            (configGeneral.docuWelcome) +
            `<br>Acuerdo de privacidad en ${orTagsURL}/privacidad.`
            if(configGeneral.docuMoreTerm){
                body += ` Para leer más información, visita ${orTagsURL}/legal.`
            }
            body +=
            `</div>`+
            `</div>`+
            `</td>`+
            `</tr>`
            
            body +=
            `</table>`+
            `</div>`+
         `<script type="text/javascript">
         
         var options = {
          text: "https://intratc.co/c/${order.id}",
          width: 120,
          height: 120,
          colorDark: "#000000",
          colorLight: "#ffffff",
          correctLevel: QRCode.CorrectLevel.H
         }
         var element = document.querySelector("#qrdiv");
         var my_qr_code = new QRCode(element, options);
         
         
         var options = {
          text: "https://intratc.co/c/${order.id}",
          width: 77,
          height: 77,
          colorDark: "#000000",
          colorLight: "#ffffff",
          correctLevel: QRCode.CorrectLevel.H
         }
         var element = document.querySelector("#qrdivinner");
         var my_qr_code = new QRCode(element, options);
         
         </scr` + `ipt>`
            
            render(body)
        }
        else if(custStoreConfig.config.print.document == "halfLetter"){
            
        }
        else if(custStoreConfig.config.print.document == "miniprinter"){
            body =
            `<div style="width:200px">`+
            `<img src="contenido/${mainLogo}" style="width:85%; max-height: 100px">`+
            `<div style="font-size:32px">${order.folio}</div>`
            
            if(typeof order.dueDate !== 'undefined'){
                var td = get_date(order.dueDate)
                var alertText = `${td.dia_corto} ${td.day}/${td.mesCorto} ${td.stime}`
                body += `<h4 style="margin-bottom: -3px;" class="unline normalize">${typeOfServiceObjectTag}: <strong style="color:#000">${alertText}</strong></h4>`
            }
            
            var td = get_date(order.createdAt)
            body += `<h4 style="margin-bottom: -3px;" class="unline normalize">Creado: <strong style="color:#000">${td.dia_corto} ${td.day}/${td.mesCorto} ${td.stime}</strong></h4>`
            
            body +=
            `<small style="font-size:10px" class="normalize"><strong>${custStoreConfig.store.name}</strong><br>${custStoreConfig.store.street} ${custStoreConfig.store.colony()} ${custStoreConfig.store.city}<br>`+
            `${custStoreConfig.store.schedule_a} ${custStoreConfig.store.schedule_b} ${custStoreConfig.store.schedule_c}<br></small><br>`+
            `<h2 class="normalize unline" style="margin-bottom: -3px; color:#000000"><strong>${order.rel_acct_name}</strong></h1>`
            
            
            if(order.rel_acct_mob != "") {
                body += ` Celular: <strong>${order.rel_acct_mob}</strong>`
            }
            if(order.rel_acct_email != "") {
                body += ` Correo: <strong>${order.rel_acct_email}</strong>`
            }
            if(order.rel_acct_tel != "") {
                body += ` Telefono: <strong>${order.rel_acct_tel}</strong>`
            }
            body += `</br>`
            body += equipmentsString
            var balance = 0
            body +=
            `<div>`+
            `<table width="100%" cellspacing="1" cellpadding="1">`+
            `<tr>`+
            `<td width="35"> <strong>Uni.</strong> </td>`+
            `<td><strong>Description</strong></td>`+
            `<td width="70"><strong>S. Total</strong></td>`+
            `</tr>`
            charges.forEach(cha => {
                body +=
                `<tr>`+
                `<td width="35">` +
                (parseFloat(cha.cuant) / 100) +
                `</td>`+
                `<td>`+
                cha.name +
                `</td>`+
                `<td width="70">` +
                formatMoney(parseFloat(cha.cost * cha.cuant) / 10000) +
                `</td>`+
                `</tr>`
                
                balance += (cha.cost * cha.cuant)
                
            });
            
            payments.forEach( pay => {
                balance -= (pay.cost * 100)
                body +=
                `<tr>`+
                `<td width="35">1</td>`+
                `<td>`+
                pay.description +
                `</td>`+
                `<td width="70">` +
                formatMoney(parseFloat(pay.cost) / 100) +
                `</td>`+
                `</tr>`
            });
            
            if(balance >= 0){
                body +=
                `<tr>`+
                `<td width="35"></td>`+
                `<td align="right">Balance </td>`+
                `<td width="70">` +
                formatMoney(parseFloat(balance) / 10000) +
                `</td>`+
                `</tr>`
            }
            
            body +=
            `</table>`
            
            if(custStoreConfig.config.print.image != "none"){
                body += `<div align="center">`
                if(custStoreConfig.config.print.image == "pinpattern"){
                    body += '<img src="https://tierracero.com/dev/core/images/pimg-PatronPIN.jpg" height="180">';
                }
                body += `</div>`
            }
            
            body +=
            `<div style="font-size:9px">`+
            (configGeneral.docuWelcome) +
            `<br>Acuerdo de privacidad en ${orTagsURL}/privacidad.`
            if(configGeneral.docuMoreTerm){
                body += ` Para leer más información, visita ${orTagsURL}/legal.`
            }
            body +=
            `</div>`+
            `</div>`
            
            body +=
            `<div style="border-bottom: #000 solid 1px; margin-top: 32px; margin-bottom: 12px"></div>`+
            `<div align="center">Firma de conformidad</div>`+
            `<div style="border-bottom: #000 solid 1px; margin-top: 32px; margin-bottom: 12px"></div>`+
            `<div align="center">Firma de recibido</div>`
            
            body += `<div align="center" id="qrdiv" style="margin-top:24px"></div>`
            
            body +=
            `</div>`
            
            body +=
          `<script type="text/javascript">
          
          var options = {
            text: "https://intratc.co/c/${order.id}",
            width: 140,
            height: 140,
            colorDark: "#000000",
            colorLight: "#ffffff",
            correctLevel: QRCode.CorrectLevel.H
          }
          var element = document.querySelector("#qrdiv");
          var my_qr_code = new QRCode(element, options);
          </scr`+`ipt>`
            
            render(body)
        }
        else if(custStoreConfig.config.print.document == "pdf"){
            
            var base = getCookie('siteBaseCookie');
            var token = '';
            var key = '';
            var mid = '';
            
            if(base != null){
                user = getCookie(base+'_user');
                token = getCookie(base+'_token');
                key = getCookie(base+'_key');
                mid = getCookie(base+'_mid');
            }
            
            window.location = `https://tierracero.com/dev/skyline/api.php?ie=printServiceOrder`+
            `&orderid=${id}`+
            `&user=${encodeURIComponent(user)}`+
            `&mid=${encodeURIComponent(mid)}`+
            `&key=${encodeURIComponent(key)}`+
            `&token=${encodeURIComponent(token)}`+
            `&tcon=web`
            
            showSuccess("descargando",2500)
        }
    }
    
    if(type = "order"){
        
        if( id in custCatchFolioRefrence){
            let order = custCatchFolioRefrence[id]
            if(order.modifiedAt == modifiedAt){
                renderOrder(id)
                return
            }
        }
        
        loading('iniciando...',1)
        sendPostNew('custOrder','v1/loadFolio',{id:id},(resp)=>{
            
            let now = Math.round(Date.now() / 1000)
            if(resp.status == "nok"){
                unloading()
                showError(resp.msg,5000)
                return
            }
            
            custCatchFolioRefrence[data.order.id] = data.order
            custCatchFolioNotesRefrence[data.order.id] = data.notes
            custCatchFolioPaymentRefrence[data.order.id] = data.payments
            custCatchFolioChargesRefrence[data.order.id] = data.charges
            custCatchFolioPocsRefrence[data.order.id] = data.charges
            custCatchFolioFilesRefrence[data.order.id] = data.files
            custCatchFolioEquipmentRefrence[data.order.id] = data.equipments
            
            renderOrder(data.order.id)
            
        },(err,or)=>{
            showError("Error de comunicacion, intente de nuevo",5000)
            unloading();
        })
    }
}
function printPdv(payload,custdata) {
    
    function render(contents){
        // var contents = document.getElementById("msgGrid").innerHTML;
        var frame1 = document.createElement('iframe');
        frame1.name = "frame1";
        frame1.style.position = "absolute";
        frame1.style.top = "-10000000px";
        document.body.appendChild(frame1);
        var frameDoc = frame1.contentWindow ? frame1.contentWindow : frame1.contentDocument.document ? frame1.contentDocument.document : frame1.contentDocument;
        frameDoc.document.open();
        
        frameDoc.document.write('<html><head>');
        frameDoc.document.write('<meta charset="utf-8">');
        frameDoc.document.write('<title>Imprimir Documento</title>');
        frameDoc.document.write('<meta name="viewport" content="width=device-width, initial-scale=1.0">');
        frameDoc.document.write(`<script type="text/javascript" src="https://tierracero.com/dev/skyline/js/QRCode.js"></scr`+`ipt>`);
        
        
        frameDoc.document.write('</head><body>');
        frameDoc.document.write(contents);
        frameDoc.document.write('</body></html>');
        frameDoc.document.close();
        setTimeout(function () {
            window.frames["frame1"].focus();
            window.frames["frame1"].print();
            document.body.removeChild(frame1);
        }, 500);
        return false;
    }
    
    let data = JSON.parse(payload)
    let cust = JSON.parse(custdata)
    
    console.clear()
    
    console.log(data)
    console.log(cust)
    body =
    `<div style="width:200px">`+
    `<img src="images/baron_rojo_logo_white.png" style="width:85%; max-height: 100px">`+
    `<div style="font-size:32px">${cust.saleFolio}</div>`
    
    
    var td = getDate()
    body += `<h4 style="margin-bottom: -3px;" class="unline normalize">Creado: <strong style="color:#000">${td.vDate} ${td.stime}</strong></h4>`
    
    body +=
    `<small style="font-size:10px" class="normalize"><strong>El Baron Rojo</strong><br>Calle Juares ###, Cuidad Victoria, Tamaulipas<br>`+
    `Lunes a Viernes 9:00 - 6:00 Sabados de 10:00 - 5:00<br></small><br>`+
    `<h2 class="normalize unline" style="margin-bottom: -3px; color:#000000"><strong>${cust.firstName} ${cust.lastName}</strong></h1>`
    
    /*
    if(order.rel_acct_mob != "") {
        body += ` Celular: <strong>${order.rel_acct_mob}</strong>`
    }
    if(order.rel_acct_email != "") {
        body += ` Correo: <strong>${order.rel_acct_email}</strong>`
    }
    if(order.rel_acct_tel != "") {
        body += ` Telefono: <strong>${order.rel_acct_tel}</strong>`
    }
    body += `</br>`
    body += equipmentsString
    */
    var balance = 0
    body +=
    `<div>`+
    `<table width="100%" cellspacing="1" cellpadding="1">`+
    `<tr>`+
    `<td width="35"> <strong>Uni.</strong> </td>`+
    `<td><strong>Description</strong></td>`+
    `<td width="70"><strong>S. Total</strong></td>`+
    `</tr>`
    data.forEach(cha => {
        body +=
        `<tr>`+
        `<td width="35">` +
        (parseFloat(cha.quant) / 100) +
        `</td>`+
        `<td>`+
        cha.name + ` ` + cha.model +
        `</td>`+
        `<td width="70">` +
        formatMoney(parseFloat(cha.cuni * cha.quant) / 10000) +
        `</td>`+
        `</tr>`
        
        balance += (cha.cuni * cha.quant)
        
    });
    
    if(balance >= 0){
        body +=
        `<tr>`+
        `<td width="35"></td>`+
        `<td align="right">Balance </td>`+
        `<td width="70">` +
        formatMoney(parseFloat(balance) / 10000) +
        `</td>`+
        `</tr>`
    }
    
    body +=
    `</table>`
    
    body +=
    `<div style="font-size:9px">`+
    //(configGeneral.docuWelcome) +
    `<br>Acuerdo de privacidad en https://baronrojotrajes.com/privacidad.`
//    if(configGeneral.docuMoreTerm){
//        body += ` Para leer más información, visita https://baronrojotrajes.com/legal.`
//    }
    body +=
    `</div>`+
    `</div>`
    
    body +=
    `<div style="border-bottom: #000 solid 1px; margin-top: 32px; margin-bottom: 12px"></div>`+
    `<div align="center">Firma de conformidad</div>`+
    `<div style="border-bottom: #000 solid 1px; margin-top: 32px; margin-bottom: 12px"></div>`+
    `<div align="center">Firma de recibido</div>`
    
    body += `<div align="center" id="qrdiv" style="margin-top:24px"></div>`
    
    body +=
    `</div>`
    
    body +=
          `<script type="text/javascript">
          
          var options = {
            text: "https://intratc.co/c/${cust.saleFolio}",
            width: 140,
            height: 140,
            colorDark: "#000000",
            colorLight: "#ffffff",
            correctLevel: QRCode.CorrectLevel.H
          }
          var element = document.querySelector("#qrdiv");
          var my_qr_code = new QRCode(element, options);
          </scr`+`ipt>`
    
    render(body)
    
}
function generalPrint(htmlBody){
    // var contents = document.getElementById("msgGrid").innerHTML;
    var frame1 = document.createElement('iframe');
    frame1.name = "frame1";
    frame1.style.position = "absolute";
    frame1.style.top = "-10000000px";
    document.body.appendChild(frame1);
    var frameDoc = frame1.contentWindow ? frame1.contentWindow : frame1.contentDocument.document ? frame1.contentDocument.document : frame1.contentDocument;
    frameDoc.document.open();
    
    frameDoc.document.write('<html><head>');
    frameDoc.document.write('<meta charset="utf-8">');
    frameDoc.document.write('<title>Imprimir Documento</title>');
    frameDoc.document.write('<meta name="viewport" content="width=device-width, initial-scale=1.0">');
    
    
    frameDoc.document.write('</head><body>');
    frameDoc.document.write(htmlBody);
    frameDoc.document.write('</body></html>');
    frameDoc.document.close();
    setTimeout(function () {
        window.frames["frame1"].focus();
        window.frames["frame1"].print();
        document.body.removeChild(frame1);
    }, 500);
    return false;
}
function closeUIView(){
    
    if ( document.getElementById(`no`) !== null){
        console.log("found no")
        document.getElementById(`no`).click();
        return
    }
    else{
        
        if ( document.getElementById(`uiView4`) !== null){
            console.log("found uiView4")
            document.getElementById(`uiView4`).click();
            return
        }
        else{
            
            if ( document.getElementById(`uiView3`) !== null){
                console.log("found uiView3")
                document.getElementById(`uiView3`).click();
                return
            }
            else{
                
                if ( document.getElementById(`uiView2`) !== null){
                    console.log("found uiView2")
                    document.getElementById(`uiView2`).click();
                    return
                }
                else{
                    if ( document.getElementById(`uiView1`) !== null){
                        console.log("found uiView1")
                        document.getElementById(`uiView1`).click()
                        return
                    }
                    else{
                        if ( document.getElementById(`subView`) !== null){
                            console.log("found subView")
                            document.getElementById(`subView`).click();
                            return
                        }
                        else{
                            if ( document.getElementById(`view`) !== null){
                                console.log("found view")
                                document.getElementById(`view`).click();
                                return
                            }
                            else{
                                if ( document.getElementById(`sideMenu`) !== null){
                                    console.log("found sideMenu")
                                    document.getElementById(`sideMenu`).click();
                                    return
                                }
                            }
                        }
                    }
                }
            }
        }
        
    }
    
}
function isValidEmail(email){
    var reg = /^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/;
    return reg.test(email)
}
function isValidRFC(_rfc, aceptarGenerico = true) {
    
    let rfc = _rfc.toUpperCase().replace(" ","")
    
    const re       = /^([A-ZÑ&]{3,4}) ?(?:- ?)?(\d{2}(?:0[1-9]|1[0-2])(?:0[1-9]|[12]\d|3[01])) ?(?:- ?)?([A-Z\d]{2})([A\d])$/;
    var   validado = rfc.match(re);
    
    if (!validado)  //Coincide con el formato general del regex?
        return false;
    
    //Separar el dígito verificador del resto del RFC
    const digitoVerificador = validado.pop(),
    rfcSinDigito      = validado.slice(1).join(''),
    len               = rfcSinDigito.length,
    
    //Obtener el digito esperado
    diccionario       = "0123456789ABCDEFGHIJKLMN&OPQRSTUVWXYZ Ñ",
    indice            = len + 1;
    var   suma,
    digitoEsperado;
    
    if (len == 12) suma = 0
        else suma = 481; //Ajuste para persona moral
    
    for(var i=0; i<len; i++)
        suma += diccionario.indexOf(rfcSinDigito.charAt(i)) * (indice - i);
    digitoEsperado = 11 - suma % 11;
    if (digitoEsperado == 11) digitoEsperado = 0;
    else if (digitoEsperado == 10) digitoEsperado = "A";
    
    //El dígito verificador coincide con el esperado?
    // o es un RFC Genérico (ventas a público general)?
    if ((digitoVerificador != digitoEsperado)
         && (!aceptarGenerico || rfcSinDigito + digitoVerificador != "XAXX010101000"))
        return false;
    else if (!aceptarGenerico && rfcSinDigito + digitoVerificador == "XEXX010101000")
        return false;
    
    return true;
}

function renderGeneralPrint(url, folio, contents){
    
    var frame1 = document.createElement('iframe');
    frame1.name = "frame1";
    frame1.style.position = "absolute";
    frame1.style.top = "-10000000px";
    document.body.appendChild(frame1);
    var frameDoc = frame1.contentWindow ? frame1.contentWindow : frame1.contentDocument.document ? frame1.contentDocument.document : frame1.contentDocument;
    frameDoc.document.open();
    
    frameDoc.document.write('<html><head>');
    frameDoc.document.write('<meta charset="utf-8">');
    frameDoc.document.write('<title>Imprimir Documento</title>');
    frameDoc.document.write('<meta name="viewport" content="width=device-width, initial-scale=1.0">');
    frameDoc.document.write(`<script type="text/javascript" src="https://tierracero.com/dev/skyline/js/QRCode.js">`);
    frameDoc.document.write('</script>');
    frameDoc.document.write(`<script type="text/javascript" src="/skyline/js/JsBarcode.all.min.js">`);
    frameDoc.document.write('</script>');
    frameDoc.document.write('</head><body>');
    frameDoc.document.write(contents);
    frameDoc.document.write('</body></html>');
    frameDoc.document.close();
    setTimeout(function () {
        window.frames["frame1"].focus();
        window.frames["frame1"].print();
        document.body.removeChild(frame1);
    }, 500);
    return false;
}

function renderFiscalDocumentPrint(url, folio, contents, qrUrl){
    
    /// satQrCode
    
    var frame1 = document.createElement('iframe');
    frame1.name = "frame1";
    frame1.style.position = "absolute";
    frame1.style.top = "-10000000px";
    document.body.appendChild(frame1);
    var frameDoc = frame1.contentWindow ? frame1.contentWindow : frame1.contentDocument.document ? frame1.contentDocument.document : frame1.contentDocument;
    frameDoc.document.open();
    
    frameDoc.document.write('<html><head>');
    frameDoc.document.write('<meta charset="utf-8">');
    frameDoc.document.write('<title>Imprimir Documento</title>');
    frameDoc.document.write('<meta name="viewport" content="width=device-width, initial-scale=1.0">');
    frameDoc.document.write(`<script type="text/javascript" src="https://tierracero.com/dev/skyline/js/QRCode.js">`);
    frameDoc.document.write('</script>');
    frameDoc.document.write(`<script type="text/javascript" src="/skyline/js/JsBarcode.all.min.js">`);
    frameDoc.document.write('</script>');
    frameDoc.document.write('</head><body>');
    frameDoc.document.write(contents);
    frameDoc.document.write('</body></html>');
    frameDoc.document.write(`<script type="text/javascript">`)
    frameDoc.document.write(`

         var options = {
          text: "${qrUrl}",
          width: 120,
          height: 120,
          colorDark: "#000000",
          colorLight: "#ffffff",
          correctLevel: QRCode.CorrectLevel.H
         }

         var element = document.querySelector("#satQrCode");
         var my_qr_code = new QRCode(element, options);

`)
    frameDoc.document.write(`</script>`)
    frameDoc.document.close();
    
    setTimeout(function () {
        window.frames["frame1"].focus();
        window.frames["frame1"].print();
        document.body.removeChild(frame1);
    }, 1000);
    return false;
}

function renderPrint(url, folio, deepLinkCode, mobile, contents){
    
    var frame1 = document.createElement('iframe');
    frame1.name = "frame1";
    frame1.style.position = "absolute";
    frame1.style.top = "-10000000px";
    document.body.appendChild(frame1);
    var frameDoc = frame1.contentWindow ? frame1.contentWindow : frame1.contentDocument.document ? frame1.contentDocument.document : frame1.contentDocument;
    frameDoc.document.open();
    
    frameDoc.document.write('<html><head>');
    frameDoc.document.write('<meta charset="utf-8">');
    frameDoc.document.write('<title>Imprimir Documento</title>');
    frameDoc.document.write('<meta name="viewport" content="width=device-width, initial-scale=1.0">');
    frameDoc.document.write(`<script type="text/javascript" src="https://tierracero.com/dev/skyline/js/QRCode.js">`);
    frameDoc.document.write('</script>');
    frameDoc.document.write(`<script type="text/javascript" src="/skyline/js/JsBarcode.all.min.js">`);
    frameDoc.document.write('</script>');
    frameDoc.document.write('</head><body>');
    frameDoc.document.write(contents);
    frameDoc.document.write('</body></html>');
    frameDoc.document.write(`<script type="text/javascript">`)
    frameDoc.document.write(`

         var options = {
          text: "https://${url}/c/${folio}?p=${deepLinkCode}&m=${mobile}",
          width: 110,
          height: 110,
          colorDark: "#000000",
          colorLight: "#ffffff",
          correctLevel: QRCode.CorrectLevel.H
         }

         var element = document.querySelector("#qrInternal");
         var my_qr_code = new QRCode(element, options);

         var options = {
          text: "https://${url}/c/${folio}?p=${deepLinkCode}&m=${mobile}",
          width: 120,
          height: 120,
          colorDark: "#000000",
          colorLight: "#ffffff",
          correctLevel: QRCode.CorrectLevel.H
         }
         var element = document.querySelector("#qrCustomer");
         var my_qr_code = new QRCode(element, options);
`)
    frameDoc.document.write(`</script>`)
    frameDoc.document.close();
    setTimeout(function () {
        window.frames["frame1"].focus();
        window.frames["frame1"].print();
        document.body.removeChild(frame1);
    }, 500);
    return false;
}

function renderSalePrint(url, folio, contents, purRefs, pickRef, custFolio, custName ){
    
    var code = ""
    
    var snippit = `
         var options = {
          text: "https://${url}/c/${folio}",
          width: 180,
          height: 180,
          colorDark: "#000000",
          colorLight: "#ffffff",
          correctLevel: QRCode.CorrectLevel.H
         }

         var element = document.querySelector("#qrInternal");
         var my_qr_code = new QRCode(element, options);

        JsBarcode("#barcode", "${folio}", {
          lineColor: "#000",
          width: 3,
          height: 50,
          displayValue: true
        });

[CODE]
`

    let purchases = JSON.parse(purRefs)
    
    var keys = Object.keys(purchases)
    
    for( var i = 0; i < keys.length; i++ ){
        
        let f = purchases[keys[i]]
        code = code + `
        
         var options = {
          text: "https://${url}/c/${f}",
          width: 77,
          height: 77,
          colorDark: "#000000",
          colorLight: "#ffffff",
          correctLevel: QRCode.CorrectLevel.H
         }

         var element = document.querySelector("#QR_${keys[i]}");
         var my_qr_code = new QRCode(element, options);
        
                
        JsBarcode("#BC_${keys[i]}", "${f}", {
          lineColor: "#000",
          width: 3,
          height: 50,
          displayValue: true
        });
        
        `
        
        
    }
    
    snippit = snippit.replace("[CODE]",code)
    
    console.log(snippit)
    
    var frame1 = document.createElement('iframe');
    frame1.name = "frame1";
    frame1.style.position = "absolute";
    frame1.style.top = "-10000000px";
    document.body.appendChild(frame1);
    var frameDoc = frame1.contentWindow ? frame1.contentWindow : frame1.contentDocument.document ? frame1.contentDocument.document : frame1.contentDocument;
    frameDoc.document.open();

    frameDoc.document.write('<html><head>');
    frameDoc.document.write('<meta charset="utf-8">');
    frameDoc.document.write(`<title>Imprimir ${folio}</title>`);
    frameDoc.document.write('<meta name="viewport" content="width=device-width, initial-scale=1.0">');
    frameDoc.document.write(`<script type="text/javascript" src="https://tierracero.com/dev/skyline/js/QRCode.js">`);
    frameDoc.document.write('</script>');
    frameDoc.document.write(`<script type="text/javascript" src="/skyline/js/JsBarcode.all.min.js">`);
    frameDoc.document.write('</script>');
    frameDoc.document.write('</head><body>');
    frameDoc.document.write(contents);
    frameDoc.document.write('</body></html>');
    frameDoc.document.write(`<script type="text/javascript">`)
    frameDoc.document.write(snippit)
    frameDoc.document.write(`</script>`)
    frameDoc.document.close();
    setTimeout(function () {
        window.frames["frame1"].focus();
        window.frames["frame1"].print();
        document.body.removeChild(frame1);
    }, 500);
    return false;
}

function printBarcode(upc, contents){
    
    var frame1 = document.createElement('iframe');
    frame1.name = "frame1";
    frame1.style.position = "absolute";
    frame1.style.top = "-10000000px";
    document.body.appendChild(frame1);
    var frameDoc = frame1.contentWindow ? frame1.contentWindow : frame1.contentDocument.document ? frame1.contentDocument.document : frame1.contentDocument;
    frameDoc.document.open();
    
    frameDoc.document.write('<html><head>');
    frameDoc.document.write('<meta charset="utf-8">');
    frameDoc.document.write('<title>Imprimir Documento</title>');
    frameDoc.document.write('<meta name="viewport" content="width=device-width, initial-scale=1.0">');
    frameDoc.document.write(`<script type="text/javascript" src="/skyline/js/JsBarcode.all.min.js">`);
    frameDoc.document.write('</script>');
    frameDoc.document.write('</head><body>');
    frameDoc.document.write(contents);
    frameDoc.document.write('</body></html>');
    frameDoc.document.write(`<script type="text/javascript">`)
    frameDoc.document.write(`
JsBarcode("#barcodeContainer", "${upc}", {
  lineColor: "#000",
  width: 3,
  height: 55,
  displayValue: true
});
`)
    frameDoc.document.write(`</script>`)
    frameDoc.document.close();
    setTimeout(function () {
        window.frames["frame1"].focus();
        window.frames["frame1"].print();
        document.body.removeChild(frame1);
    }, 500);
    return false;
}

function scrollToBottom(id){
    var objDiv = document.getElementById(id);
    objDiv.scrollTop = objDiv.scrollHeight;
}
function openNewWindow(url){
    window.open(url, '_blank')
}
function goToURL(url){
    window.location = url
}
function openTab(url){
    window.open(url, '_blank');
}
function goToPanel(){
    window.location = `panel.php`
}

function goToLogin(){
    window.location = `login`
}

function goToIndex(){
    window.location = `index1.php`
}

function dragElement(elmntid) {
    
    console.log("⭐️ elmntid")
    
    let elmnt = document.getElementById(elmntid)
    
    console.log(elmnt)
    
    console.log(elmnt.id + "Header")
    
  var pos1 = 0, pos2 = 0, pos3 = 0, pos4 = 0;
  if (document.getElementById(elmnt.id + "Header")) {
    /* if present, the header is where you move the DIV from:*/
    document.getElementById(elmnt.id + "Header").onmousedown = dragMouseDown;
  } else {
    /* otherwise, move the DIV from anywhere inside the DIV:*/
    elmnt.onmousedown = dragMouseDown;
  }

  function dragMouseDown(e) {
    e = e || window.event;
    e.preventDefault();
    // get the mouse cursor position at startup:
    pos3 = e.clientX;
    pos4 = e.clientY;
    document.onmouseup = closeDragElement;
    // call a function whenever the cursor moves:
    document.onmousemove = elementDrag;
  }

  function elementDrag(e) {
    e = e || window.event;
    e.preventDefault();
    // calculate the new cursor position:
    pos1 = pos3 - e.clientX;
    pos2 = pos4 - e.clientY;
    pos3 = e.clientX;
    pos4 = e.clientY;
    // set the element's new position:
    elmnt.style.top = (elmnt.offsetTop - pos2) + "px";
    elmnt.style.left = (elmnt.offsetLeft - pos1) + "px";
  }

  function closeDragElement() {
    /* stop moving when mouse button is released:*/
    document.onmouseup = null;
    document.onmousemove = null;
  }
}

function loadFileBase64(id, callback){
    
    let i = 0
    
    let files = document.getElementById(id).files
    
    if(files.length == 0){
        return
    }
    
    let tid = Math.floor(Date.now() / 1000) + "-" + Math.floor(Math.random() * 100) + 1;
    
    var fileToLoad = files[i];
    
    var fileReader = new FileReader();
    
    console.log("⚡️002")
    
    fileReader.id = tid;
    fileReader.name = fileToLoad.name;
    fileReader.onload = function(filedata,ci){
        
        console.log("⚡️003")
        
        callback(JSON.stringify({
            result: filedata.target.result,
            name: filedata.target.name,
        }))
    };
    
    fileReader.readAsDataURL(fileToLoad,i);
    
}

function getElementHeight(id){
    try {
        console.log(`document.getElementById('${id}').offsetHeight`)
        return document.getElementById(id).offsetHeight
    } catch (error) {
      //console.error(error);
    }
}

function getElementWidth(id){
    try {
        
        console.log(`document.getElementById('${id}').offsetWidth`)
        
        return document.getElementById(id).offsetWidth
    } catch (error) {
      //console.error(error);
    }
}

function getElementLeft(id){
    try {
        console.log(`document.getElementById('${id}').offsetLeft`)
        return document.getElementById(id).offsetLeft
    } catch (error) {
      //console.error(error);
    }
}

function getElementTop(id){
    try {
        console.log(`document.getElementById('${id}').offsetTop`)
        return document.getElementById(id).offsetTop
    } catch (error) {
      //console.error(error);
    }
}

function jcrop(id, width, height) {
    
    try {
        const jcrop = Jcrop.attach(id,{
            aspectRatio: 1,
            handles: ["sw", "nw", "ne", "se"],
            cropperId: `${id}Box`
        })
        
        const rect = Jcrop.Rect.fromPoints([50,50],[width,height]);
        jcrop.newWidget(rect,{ aspectRatio: rect.aspect })
        
    } catch (error) {
      //console.error(error);
    }
    
}

var _item

function jcropWithImage(id, itemid, url, width, height) {
    
    let _width = width / 2
    let _height = height / 2
    
    class SvgWidget extends Jcrop.Widget {
      init () {
        super.init();
        const img = new Image();
        img.src = url;
        img.id = `${itemid}Img`;
        this.el.appendChild(img);
      }
    }
    
    const jcrop = Jcrop.attach( id, {
        handles: ["sw", "nw", "ne", "se"],
        aspectRatio: _width/_height,
        cropperId: itemid,
        imageId: `${itemid}Img`,
        widgetConstructor: SvgWidget,
        shadeOpacity: 0.001,
    })
    
    _item = jcrop
    
    const rect = Jcrop.Rect.fromPoints([50,50],[_width,_height]);
    
    jcrop.newWidget(rect,{ aspectRatio: rect.aspect })
    
    console.log("⭐️  new id  ⭐️")
    
    console.log(_item.active.el.id)
    
    /*
    const closeIcon = new Image();
    closeIcon.src = `/skyline/media/cross.png`;

    closeIcon.style.float = 'right'

    closeIcon.style.width = '32px'
    closeIcon.style.padding = '7px'
    closeIcon.style.cursor = 'pointer'
    
    //closeIcon.onclick = function(){document.getElementById(itemid).remove()};
    
    document.getElementById(itemid).append(closeIcon)
    */
    document.getElementById(itemid).style.height = document.getElementById(`${itemid}Img`).offsetHeight.toString() + "px"
    
    //return closeIcon
    
    return document.getElementById(itemid)
    
}

function removeItem(itemid) {
    /*
     window.document.getElementById(`{itemid}Img`).parentNode.id
     
     document.getElementById(itemid)
     */
    console.log("id of chiled object")
    console.log(`${itemid}Img`)
    
    window.document.getElementById(`${itemid}Img`).parentNode.remove()
}

function getParentId(childid){
    return window.document.getElementById(childid).parentNode.id
}

function copyToClipbord(text) {
    navigator.clipboard.writeText(text);
}

function doAccountPayment(amount,title, mobile, firstName, lastName){
    
    localStorage.mobile = mobile
    localStorage.firstName = firstName
    localStorage.lastName = lastName
    
    opay = new OPay("account",`Pago de servicio ${title}`)
    opay.startPaymentForm(amount)
}

var cameraStream

function startCamara() {

  let video = document.getElementById("video");

  cameraStream = navigator.mediaDevices
    .getUserMedia({ video: true, audio: false })
    .then((stream) => {
      video.srcObject = stream;
      video.play();
    })
    .catch((err) => {
      console.error(`An error occurred: ${err}`);
    });
}

function stopVideo() {
    
    let video = document.getElementById("video");
    const stream = video.srcObject;
    const tracks = stream.getTracks();

    tracks.forEach((track) => {
        track.stop();
    });
}

function takePicture() {

    let canvas = document.getElementById("canvas");
    
    let video = document.getElementById("video");
    
    let photo = document.getElementById("photo");
    
    let width = video.videoWidth
    
    let height = video.videoHeight
    
    const context = canvas.getContext("2d");
    
    canvas.width = width;
    
    canvas.height = height;
    
    context.drawImage(video, 0, 0, width, height);

    const data = canvas.toDataURL("image/png");
        
    //return canvas.toDataURL("image/png");
        
    photo.setAttribute("src", data);
    
    stopVideo()
    
    return data
    
}
function sortable(element){
    
    let div = document.getElementById(element);
    
    new Sortable(div, {
        animation: 150,
        ghostClass: 'blue-background-class'
    });
}

function renderElements(grid){
    var elements = document.getElementById(grid).children;
    
    var string = ""
    
    for(var i = 0; i < elements.length; i++) {
        console.log(elements[i].id)
    
       if (string == "") {
           string = elements[i].id
       }
       else {
           string += "," + elements[i].id
       }
    }
    
    return string
}

function download(name, content) {
    
    let mimes = {
        "aac":"audio/aac",
        "abw":"application/x-abiword",
        "arc":"application/octet-stream",
        "avi":"video/x-msvideo",
        "azw":"application/vnd.amazon.ebook",
        "bin":"application/octet-stream",
        "bz":"application/x-bzip",
        "bz2":"application/x-bzip2",
        "csh":"application/x-csh",
        "css":"text/css",
        "csv":"text/csv",
        "doc":"application/msword",
        "epub":"application/epub+zip",
        "gif":"image/gif",
        "htm":"text/html",
        "html":"text/html",
        "ico":"image/x-icon",
        "ics":"text/calendar",
        "jar":"application/java-archive",
        "jpeg":"image/jpeg",
        "jpg":"image/jpeg",
        "js":"application/javascript",
        "json":"application/json",
        "mid":"audio/midi",
        "midi":"audio/midi",
        "mpeg":"video/mpeg",
        "mpkg":"application/vnd.apple.installer+xml",
        "odp":"application/vnd.oasis.opendocument.presentation",
        "ods":"application/vnd.oasis.opendocument.spreadsheet",
        "odt":"application/vnd.oasis.opendocument.text",
        "oga":"audio/ogg",
        "ogv":"video/ogg",
        "ogx":"application/ogg",
        "pdf":"application/pdf",
        "ppt":"application/vnd.ms-powerpoint",
        "rar":"application/x-rar-compressed",
        "rtf":"application/rtf",
        "sh":"application/x-sh",
        "svg":"image/svg+xml",
        "swf":"application/x-shockwave-flash",
        "tar":"application/x-tar",
        "tif":"image/tiff",
        "tiff":"image/tiff",
        "ttf":"font/ttf",
        "vsd":"application/vnd.visio",
        "wav":"audio/x-wav",
        "weba":"audio/webm",
        "webm":"video/webm",
        "webp":"image/webp",
        "woff":"font/woff",
        "woff2":"font/woff2",
        "xhtml":"application/xhtml+xml",
        "xls":"application/vnd.ms-excel",
        "xml":"application/xml",
        "xul":"application/vnd.mozilla.xul+xml",
        "zip":"application/zip",
        "3gp":"video/3gpp",
        "3g2":"video/3gpp2",
        "7z":"application/x-7z-compressed"
    }
    
    let parts = name.split(".")
    
    let ext = parts[(parts.length - 1)]
    
    console.log(mimes[ext])
    
    const file = new File([content], name, {
      type: mimes[ext],
    })
    
    const link = document.createElement('a')
    const url = URL.createObjectURL(file)
    
    link.href = url
    link.download = file.name
    document.body.appendChild(link)
    link.click()
    
    document.body.removeChild(link)
    window.URL.revokeObjectURL(url)
}

function hCaptchaTokenUpdater(object){
    var event = new CustomEvent("hCaptchaToken", { "detail": object});
    document.dispatchEvent(event);
}

function hCaptchaTokenFailed(object){
    var event = new CustomEvent("hCaptchaTokenFailed", { "detail": ""});
    document.dispatchEvent(event);
}

function initmap( url, lat, lon, storeName){
    
    marker = null
    
    $(`#mapkitjs`).height(250)
    
    $(`#mapkitjs`).html('')
    
    map = new mapkit.Map("mapkitjs");
    
    mapkit.init({
        authorizationCallback: function(done) {
            var xhr = new XMLHttpRequest();
            xhr.open("GET", `https://intratc.co/api/jwt/${url}`);
            xhr.addEventListener("load", function() {
                
                console.log("🗾  🗾  🗾  🗾  🗾  🗾  🗾  🗾  🗾  ")
                console.log(`https://intratc.co/api/jwt/${url}`)
                console.log(this.responseText)
                
                done(this.responseText);
            });
            xhr.send();
        },
        language: "es"
    });

    var MarkerAnnotation = mapkit.MarkerAnnotation
    
    var annotations = new mapkit.CoordinateRegion(
        new mapkit.Coordinate(parseFloat(lat), parseFloat(lon)),
        new mapkit.CoordinateSpan(0.020528323102041, 0.043467582244898)
    );

    map.region = annotations;

    marker = new mapkit.MarkerAnnotation(map.center, {
        draggable: false,
        selected: false,
        title: storeName
    });

    map.addAnnotation(marker);
}



mapRefrenceObject = {}

function initiateSingleMap(mapId, token, serchString, callback, updateCoordinate) {
    
    // MARK: Initiate MAP
    
    console.log("🟡  initiateSingleMap")
    
    mapkit.init({
        authorizationCallback: function(done) {
            done(token);
            /*
            var xhr = new XMLHttpRequest();
            xhr.open("GET", `https://intratc.co/api/jwt/${encodeURIComponent(window.location.hostname)}`);
            xhr.addEventListener("load", function() {
                console.log("🟢  initiateSingleMap")
                console.log("🗺 ",this.responseText," 🗺")
                done(this.responseText);
                loadMap(mapId, serchString)
            });
            xhr.send();
             */
            
        },
        language: "es"
     });
    
    loadMap(mapId, serchString, callback, updateCoordinate)
}
function loadMap(mapId, serchString, callback, updateCoordinate) {
    
    console.log("🟡  loadMap")
    
    marker = null
    
    map = new mapkit.Map(mapId);
    
    console.log("🟢  loadMap")
    
    console.log(map)
    
    console.log(" - - - - - - - - - - ")
    
    let search = new mapkit.Search({ getsUserLocation: true }); search.search(serchString, (error, data) => {
        
        if (error) {
            console.log("🔴  ERROR LOADING MAP")
            console.log(error)
        }
        
        console.log(" - - - - - - - - - - ")
        
        console.log(JSON.stringify(data))
        
        console.log(" - - - - - - - - - - ")
        
        if ( data.places.length == 1) {
            
            data.places.map( place => {

                console.log("💎  💎  💎  💎  💎  💎  💎  💎  💎  💎")
                
                updateCoordinate(JSON.stringify({
                    latitude: place.coordinate.latitude,
                    longitude: place.coordinate.longitude
                }))
                
                let annotation = new mapkit.CoordinateRegion(
                    new mapkit.Coordinate(place.coordinate.latitude, place.coordinate.longitude),
                    new mapkit.CoordinateSpan(0.020528323102041, 0.043467582244898)
                );
      
                map.region = annotation;

                marker = new mapkit.MarkerAnnotation(map.center, {
                    draggable: true,
                    selected: true,
                    title: "Selecciona tu ubicación"
                });
                
                marker.addEventListener("drag-start", function(event) {
                    // No need to show "Drag me" message once user has dragged
                    event.target.title = "";
                });
                
                marker.addEventListener("drag-end", function() {
                    
                    updateCoordinate(JSON.stringify({
                        latitude: marker.coordinate.latitude,
                        longitude: marker.coordinate.longitude
                    }))
                    
                });
                
                map.addAnnotation(marker);
            });
            
        }
        
        
        callback(JSON.stringify(data.places))
        
    });

}

function initiatAppleMaps(mapId, token, callback) {
    
    // MARK: Initiate MAP
    
    console.log("🟡  initiateSingleMap")
    
    mapkit.init({
        authorizationCallback: function(done) {
            done(token);
        },
        language: "es"
     });
    
    callback();
}

function loadAppleMap(mapId, locations, updateCoordinate) {
    
    console.log("🟡  loadMap")
    
    marker = null
    
    map = new mapkit.Map(mapId);
    
    console.log(" - - - - - - - - - - ")
    
    console.log("locations JSON:\n", locations)
    
    var locations = JSON.parse(locations);
    
    console.log("locations:\n", locations.length)
    
    for (var i = 0; i < locations.length; i++ ) {
        
        var location = locations[i]
        
        console.log("💎  LOCATION  💎  LOCATION  💎  LOCATION  💎  LOCATION  💎  LOCATION  💎  LOCATION  ")
        
        console.log(location)
        
        let annotation = new mapkit.CoordinateRegion(
            new mapkit.Coordinate(location.latitude, location.longitude),
            new mapkit.CoordinateSpan(0.020528323102041, 0.043467582244898)
        );

        map.region = annotation;

        marker = new mapkit.MarkerAnnotation(map.center, {
            draggable: true,
            selected: true,
            title: "Selecciona tu ubicación"
        });
        
        marker.addEventListener("drag-start", function(event) {
            // No need to show "Drag me" message once user has dragged
            event.target.title = "";
        });
        
        marker.addEventListener("drag-end", function() {
            
            updateCoordinate(JSON.stringify({
                id: locations.id,
                latitude: marker.coordinate.latitude,
                longitude: marker.coordinate.longitude
            }))
            
        });
        
        map.addAnnotation(marker);
        
    }
}

// Function to draw the route once MapKit has returned a response
function directionHandler(error, data) {
    data["routes"].forEach(function(route, routeIdx) {
        if (routeIdx !== 0) { return; }
        overlays = [];
        route['path'].forEach(function(path) {
            // This styles the line drawn on the map
            let overlayStyle = new mapkit.Style({
                lineWidth: 3,
                strokeColor: "#9b6bcc"
            });
            let overlay = new mapkit.PolylineOverlay(path, {
                style: overlayStyle
            });
            overlays.push(overlay);
        });
        appleMapRought.addOverlays(overlays);
        overlayRefrence.push(overlays)
    });
}

// This asks MapKit for directions and when it gets a response sends it to directionHandler
function computeDirections(directions, origin, destination) {
    let directionsOptions = {
        origin: origin,
        destination: destination,
        transportType: mapkit.Directions.Transport.Walking
    };
    directions.route(directionsOptions, directionHandler);
}


// This asks MapKit for directions and when it gets a response sends it to directionHandler
function computeDirectionsHelpper(map, strokeColor, directions, origin, destination) {
    
    function directionHandlerHelper(error, data) {
        
        data["routes"].forEach(function(route, routeIdx) {
            if (routeIdx !== 0) { return; }
            overlays = [];
            route['path'].forEach(function(path) {
                // This styles the line drawn on the map
                let overlayStyle = new mapkit.Style({
                    lineWidth: 3,
                    strokeColor: strokeColor//"#9b6bcc"
                });
                let overlay = new mapkit.PolylineOverlay(path, {
                    style: overlayStyle
                });
                overlays.push(overlay);
            });
            map.addOverlays(overlays);
        });
        
    }
    
    let directionsOptions = {
        origin: origin,
        destination: destination,
        transportType: mapkit.Directions.Transport.Walking
    };
    
    directions.route(directionsOptions, directionHandlerHelper);
}



var appleMapRought = "unset";
var markers = [];
var usermarkers = [];
var overlayRefrence = [];

function initiateMapItemDivContainer(callback){
    
    $( "#mapItemDivContainer" ).sortable({
        update: function( ) {
            
            var items = document.getElementById("mapItemDivContainer").getElementsByClassName("mapItemObject");
            
            var ids = []
            
            if(appleMapRought == "unset"){
                return
            }
            
            for (var i = 0; i < items.length; i++ ) {
                var item = items[i];
                ids.push($(item).val())
            }
            
            console.log(ids)
            
            callback(JSON.stringify(ids))
            
        }
    });
    
}

function removeAppleMapRought(){
    appleMapRought = "unset"
    markers = []
    overlayRefrence = []
    usermarkers = []
}

function loadAppleMapRought(mapId, locations, users, updateCoordinate){
    
    if(appleMapRought == "unset"){
        appleMapRought = new mapkit.Map(mapId);
    }
    
    if( markers.length > 0 ) {
        
        appleMapRought.removeItems(markers)
        
        markers = [];
        
        appleMapRought.removeItems(usermarkers)
        
        usermarkers = [];
        
        overlayRefrence.forEach( ref => {
            appleMapRought.removeOverlays(ref)
        })
        
        overlayRefrence = []
        
    }
    
    console.clear()
    
    console.log(users)
    
    var users = JSON.parse(users);
    
    var userpoints = []
    
    for (var i = 0; i < users.length; i++ ) {
        
        var location = users[i]
        
        console.log("- - - -- - - - - - -- - -")
        console.log(location)
        
        userpoints.push({
            name: location.username,
            lat: location.latitude,
            lon: location.longitude
        })
        
    }
    
    // Loop through the array and create marker for each
    userpoints.forEach(function(location) {
        
        var marker = new mapkit.MarkerAnnotation(new mapkit.Coordinate( location.lat, location.lon), {
            color: "#00a2ff",
            title: location.name,
            draggable: false,
            selected: true
        });
        
        usermarkers.push(marker);
        
    });

    if ( usermarkers.length > 0 ) {
        appleMapRought.showItems(usermarkers);
    }
    
    var locations = JSON.parse(locations);
    
    if (locations.length === 0) {
        return
    }
    
    var location = locations[0]
    
    // This sets the initial region, but is overridden when all points have been potted to automatically set the bounds
    var myRegion = new mapkit.CoordinateRegion(
        new mapkit.Coordinate(location.latitude, location.longitude),
        new mapkit.CoordinateSpan(0.020528323102041, 0.043467582244898)
    );

    appleMapRought.region = myRegion;

    // lastWaypoint variable is 'unset' initially so the map doesn't try and find a route to the lastWaypoint for the first point of the route
    var lastWaypoint = "unset";
    
    var directions = new mapkit.Directions();

    // Array of co-ordinates and label for marker
    var waypoints = []
    
    for (var i = 0; i < locations.length; i++ ) {
        
        var location = locations[i]
        
        waypoints.push({
            orderId: location.orderId,
            name: `${location.folio} ${location.name}`,
            lat: location.latitude,
            lon: location.longitude
        })
        
    }
    
    // Loop through the array and create marker for each
    waypoints.forEach(function(location) {
        
        var marker = new mapkit.MarkerAnnotation(new mapkit.Coordinate( location.lat, location.lon), {
            color: "#9b6bcc",
            title: location.name,
            draggable: true,
            selected: true
        });
        
        marker.addEventListener("drag-start", function(event) {
            
        });
        
        marker.addEventListener("drag-end", function() {
            updateCoordinate(JSON.stringify({
                orderId: location.orderId,
                latitude: marker.coordinate.latitude,
                longitude: marker.coordinate.longitude
            }))
        });
        
        markers.push(marker);
        
        // As long as this isn't the first point on the route, draw a route back to the last point
        if(lastWaypoint != "unset") {
            computeDirections(directions,lastWaypoint,new mapkit.Coordinate( location.lat, location.lon));
        }
        
        lastWaypoint = new mapkit.Coordinate( location.lat, location.lon);
        
    });

    appleMapRought.showItems(markers);
    
}

var strokeColors = [
                    "#00cc00",
                    "#0099ff",
                    "#cc66ff",
                    "#ff6699",
                    "#ff6600",
                    "#990099",
                    "#0000cc",
                    "#00cc66",
                    "#996633"
                ]
Array.prototype.random = function () {
  return this[Math.floor((Math.random()*this.length))];
}
function loadAppleMapUsers(mapId, items, updateCoordinate){
    
    var items = JSON.parse(items);
    
    if (items.length === 0) {
        return
    }
    
    var appleMapUsers = new mapkit.Map(mapId);
    
    var directions = new mapkit.Directions();
    
    var _userpoints = []
    
    var _usermarkers = []
    
    console.clear()
    
    for ( var i = 0; i < items.length; i++ ) {
        
        var item = items[i]
        
        var user = item.user
        
        var userLocations = item.userLocations
        
        var lastWaypointUser = "unset"
        
        if (userLocations.length == 0) {
            continue
        }
        
        var strokeColor = strokeColors.random()
        
        for ( var j = 0; j < userLocations.length; j++ ) {
            
            var location = userLocations[j]
            
            console.log("🟢 🟢  strokeColor " + strokeColor)
            
            if (j == 0) {
            
                _userpoints.push({
                    color: strokeColor,
                    name: `${user.username}`,
                    lat: location.latitude,
                    lon: location.longitude
                })
            }
            
            if(lastWaypointUser != "unset") {
                computeDirectionsHelpper(appleMapUsers, strokeColor, directions, lastWaypointUser, new mapkit.Coordinate( location.latitude, location.longitude));
            }
            
            lastWaypointUser = new mapkit.Coordinate( location.latitude, location.longitude);
            
        }
    }
    
    for ( var i = 0; i < _userpoints.length; i++ ) {
        
        var location = _userpoints[i]
        
        console.log("🟢 🟢  strokeColor " + location.color)
        
        var marker = new mapkit.MarkerAnnotation(new mapkit.Coordinate( location.lat, location.lon), {
            color: location.color,
            title: location.name,
            draggable: false,
            selected: true
        });
    
        _usermarkers.push(marker)
        
    }
    
    appleMapUsers.showItems(_usermarkers);
    
//    _userpoints.forEach(function(location) {
        /*

        */
//    }
    
    
    //
    
    /*
    // lastWaypoint variable is 'unset' initially so the map doesn't try and find a route to the lastWaypoint for the first point of the route
    var lastWaypoint = "unset";
    
    

    // Array of co-ordinates and label for marker
    
    for (var i = 0; i < locations.length; i++ ) {
        
        var location = locations[i]
        
        
    }
    
    // Loop through the array and create marker for each
    waypoints.forEach(function(location) {
        
        var marker = new mapkit.MarkerAnnotation(new mapkit.Coordinate( location.lat, location.lon), {
            color: "#9b6bcc",
            title: location.name,
            draggable: true,
            selected: true
        });
        
        marker.addEventListener("drag-start", function(event) {
            
        });
        
        marker.addEventListener("drag-end", function() {
            updateCoordinate(JSON.stringify({
                orderId: location.orderId,
                latitude: marker.coordinate.latitude,
                longitude: marker.coordinate.longitude
            }))
        });
        
        markers.push(marker);
        
        // As long as this isn't the first point on the route, draw a route back to the last point
        if(lastWaypoint != "unset") {
            computeDirections(directions,lastWaypoint,new mapkit.Coordinate( location.lat, location.lon));
        }
        
        lastWaypoint = new mapkit.Coordinate( location.lat, location.lon);
        
    });

    
    */
}

function webPagesSortable(callback){
    
    $( "#sortable1, #sortable2" ).sortable({
        delay: 300,
        connectWith: ".connectedSortable",
        handle: ".button-handle",
        placeholder: "pageButtonItemPlaceholder",
        items: "li:not(.fixItem)",
        tolerance:'pointer',
        deactivate: ( event, ui )=>{
            
            console.log("ive changed ")
            
            var arr = []
            
            objs = $('#sortable1 .webButtonObject')

            for(var i = 0; i < objs.length; i++){
                console.log(objs[i].id)
                console.log($(objs[i]).val())
                arr.push(objs[i].id)
            }
            
            console.log("--------------")
            console.log(arr)
            console.log("--------------")
            console.log(JSON.stringify(arr))
            console.log("--------------")
            callback(JSON.stringify(arr))
            
        }
    }).disableSelection();
                /*
                 $( "#sortable1, #sortable2" ).sortable({
                     delay: 300,
                     connectWith: ".connectedSortable",
                     handle: ".button-handle",
                     placeholder: "pageButtonItemPlaceholder",
                     items: "li:not(.fixItem)",
                     tolerance:'pointer',
                     deactivate: ( event, ui )=>{
                         console.log("ive changed ")
                         //btn_svc
                         var arr = []
                         objs = $('#sortable1 .webButtonObject')

                         for(var i = 0; i < objs.length; i++){
                             console.log(objs[i].id)
                             console.log($(objs[i]).val())
                             arr.push(objs[i].id)
                         }

                         sendPostNew('theme','v1/updateActiveButtons',{buttons:arr},(resp)=>{
                                 unloading();
                                 if(resp.status == "nok"){
                                     showError(resp.msg,5000)
                                 }
                             },(err,or)=>{
                                 unloading();
                             })
                     
                     }
                 }).disableSelection();
                 */
}

var pinpatterCanvasObject = 'unset'

 // last known position
var lpos = { x: 0, y: 0 };

var ctx = 'unset';

var pinCanvas = 'unset'

var canvasHasPattern = false

class PinPaternCanvas {

    constructor() {
       
    }

    // new position from mouse event
    setPosition(e) {
        lpos.x = e.layerX;
        lpos.y = e.layerY;
    }

    // resize canvas
    resize() {
        //ctx.canvas.width = window.innerWidth;
        //ctx.canvas.height = window.innerHeight;
        ctx.canvas.width = document.getElementById("pinpatterCanvas").offsetWidth;
        ctx.canvas.height = document.getElementById("pinpatterCanvas").offsetHeight;
    }

    reset(){
        lpos = { x: 0, y: 0 };
        ctx.clearRect(0, 0, pinCanvas.width, pinCanvas.height); 
        canvasHasPattern = false
    }

    draw(e) {
        // mouse left button must be pressed
        if (e.buttons !== 1) {
            return;
        }

        // begin
        ctx.beginPath(); 

        ctx.lineWidth = 5;
        ctx.lineCap = 'round';
        ctx.strokeStyle = '#0080ff';

        if ( lpos.x == 0 && lpos.y == 0 )  {
            ctx.moveTo(e.layerX, e.layerY);
        }
        else {
             // from
            ctx.moveTo(lpos.x, lpos.y);
        }
        
        // to
        ctx.lineTo(e.layerX, e.layerY);

        // draw it!
        ctx.stroke(); 

        lpos.x = e.layerX;

        lpos.y = e.layerY;

        canvasHasPattern = true

    }

    loadImage(src){

        console.log(src)

        var img = new Image();

        //drawing of the test image - img1
        img.onload = function () {
            //draw background image
            ctx.drawImage(img,0,0,img.width,img.height,0,0, ctx.canvas.width, ctx.canvas.height);
            //draw a box over the top
            ctx.fillStyle = "rgba(200, 0, 0, 0.0)";
            ctx.fillRect(0, 0, ctx.canvas.width, ctx.canvas.height);
            
        };
    
        img.src = src;
    }

    initiateCanvas() {

        console.clear()

        console.log("🟢  CANVAS")

        var div = document.getElementById("pinpatterCanvas")

        // create canvas element and append it to document body
        pinCanvas = document.createElement('canvas');
        div.appendChild(pinCanvas);

        // some hotfixes... ( ≖_≖)
        div.style.margin = 0;
        pinCanvas.style.position = 'sticky';

        // get canvas 2D context and set him correct size
        ctx = pinCanvas.getContext('2d');
        this.resize();

        this.loadImage("/skyline/media/pinpatern_canvas_3x3.png")

        window.addEventListener('resize', this.resize, true);
        div.addEventListener('mousemove', this.draw, true);
        div.addEventListener('mousedown', this.setPosition, true);
        div.addEventListener('mouseenter', this.setPosition, true);

    }

    deinitiateCanvas() {
        console.log("⚪️  CANVAS")
        var div = document.getElementById("pinpatterCanvas")
        window.removeEventListener('resize', this.resize, true);
        div.removeEventListener('mousemove', this.draw, true);
        div.removeEventListener('mousedown', this.setPosition, true);
        div.removeEventListener('mouseenter', this.setPosition, true);
     }

}

function initiateCanvas(){
    
    if (pinpatterCanvasObject == "unset") {
        pinpatterCanvasObject = new PinPaternCanvas()
    }
    
    pinpatterCanvasObject.initiateCanvas()

}

function deinitiateCanvas(){

    if (pinpatterCanvasObject == "unset") {
        return
    }

    pinpatterCanvasObject.deinitiateCanvas()

    pinpatterCanvasObject = 'unset'

    canvasHasPattern = false
    
}

function resetCanvas(){

    if (pinpatterCanvasObject == "unset") {
        return
    }
    canvasHasPattern = false
    pinpatterCanvasObject.reset()

}

function loadImageCanvas(src){

    if (pinpatterCanvasObject == "unset") {
        return
    }

    console.log(`LOAD_PIN_PATTERN ${src}`)

    pinpatterCanvasObject.loadImage(src)

}

function getImageCanvas() {
    return pinCanvas.toDataURL()
}

function dataURLtoFile(dataurl, filename) {
    var arr = dataurl.split(','),
        mime = arr[0].match(/:(.*?);/)[1],
        bstr = atob(arr[arr.length - 1]), 
        n = bstr.length, 
        u8arr = new Uint8Array(n);
    while(n--){
        u8arr[n] = bstr.charCodeAt(n);
    }
    return new File([u8arr], filename, {type:mime});
}

function activateMap(mapId, geolocation, domian, stores, updateLocation) {

    marker = null

	map = new mapkit.Map(mapId);

	let lat = geolocation.latitud

	let lon = geolocation.longitud

	mapkit.init({
		authorizationCallback: function(done) {

			var xhr = new XMLHttpRequest();

            xhr.open("GET", `https://intratc.co/api/jwt/${encodeURIComponent(domian)}`);

			xhr.addEventListener("load", function() {
				console.log("🗺 ",this.responseText,"🗺 ")
				done(this.responseText);
			});

			xhr.send();

		},
		language: "es"
	});
    
    var storeMapArrays = []
	
    var MarkerAnnotation = mapkit.MarkerAnnotation
    
    for(var i = 0; i < stores.length; i++){
        
        let store = stores[i]

        var succ = new mapkit.Coordinate(parseFloat(store.lat), parseFloat(store.lon));
        var succAnnotation = new MarkerAnnotation(succ);
        succAnnotation.color = "#969696"; 
        succAnnotation.title = store.name;
        succAnnotation.subtitle = "Sucursal";
        succAnnotation.selected = "true";
        // succAnnotation.glyphText = "";
        
        // Add and show both annotations on the map
        storeMapArrays.push(succAnnotation)
    }


    if(storeMapArrays.length > 0){
        map.showItems(storeMapArrays);
    }

    var annotations = new mapkit.CoordinateRegion(
        new mapkit.Coordinate(parseFloat(lat), parseFloat(lon)),
        new mapkit.CoordinateSpan(0.020528323102041, 0.043467582244898)
    );
    
    map.region = annotations;

    marker = new mapkit.MarkerAnnotation(map.center, {
        draggable: true,
        selected: true,
        title: "Selecciona tu ubicación"
    });

    marker.addEventListener("drag-start", function(event) {
        event.target.title = "";
    });

    marker.addEventListener("drag-end", function() {
        
        updateLocation(marker.coordinate.latitude, marker.coordinate.longitude)

    });

    map.addAnnotation(marker);



		/*
		if(lat != null && lon != null){

		}
		else{


		}
            */
}

function searchMap(mapId, domian, street, city, state, zip, country, updateLocation) {

    var serchString = ""
    var hasFeild = 7

    if(street != ""){
        hasFeild += 7
        if(serchString == ""){
            serchString = street
        }
        else{
            serchString += "," + street
        }
    }
    if(city != ""){
        hasFeild += 7
        if(serchString == ""){
            serchString = city
        }
        else{
            serchString += "," + city
        }
    }
    if(state != ""){
        hasFeild += 7
        if(serchString == ""){
            serchString = state
        }
        else{
            serchString += "," + state
        }
    }
    if(zip != ""){
        hasFeild += 7
        if(serchString == ""){
            serchString = zip
        }
        else{
            serchString += "," + zip
        }
    }
    if(country != ""){
        hasFeild += 7
        if(serchString == ""){
            serchString = country
        }
        else{
            serchString += "," + country
        }
    }
    
    marker = null

	map = new mapkit.Map(mapId);

    mapkit.init({
        authorizationCallback: function(done) {

            var xhr = new XMLHttpRequest();

            xhr.open("GET", `https://intratc.co/api/jwt/${encodeURIComponent(domian)}`);

            xhr.addEventListener("load", function() {
                console.log("🗺 ",this.responseText,"🗺 ")
                done(this.responseText);
            });

            xhr.send();

        },
        language: "es"
    });

    let search = new mapkit.Search({ getsUserLocation: true })
    search.search(serchString, (error, data) => {
        
        if (error) {
            // handle search error return;
        }

        let places = data.places

        console.log(`🗺️ Ubicaciones Localizadas ${places.length}`)

        places.forEach( place => {
            console.log(place)
        })
        
        console.log("- - - - - - - - - - - - - - - - - - - ")

        data.places.map(place => {

            updateLocation(place.coordinate.latitude, place.coordinate.longitude)

            let annotation = new mapkit.CoordinateRegion(
                new mapkit.Coordinate(place.coordinate.latitude, place.coordinate.longitude),
                new mapkit.CoordinateSpan((1.005887832 / hasFeild), (2.12991153 / hasFeild))
            );
    
            map.region = annotation;

            marker = new mapkit.MarkerAnnotation(map.center, {
                draggable: true,
                selected: true,
                title: "Selecciona tu ubicación"
            });
            marker.addEventListener("drag-start", function(event) {
                // No need to show "Drag me" message once user has dragged
                event.target.title = "";
            });
            marker.addEventListener("drag-end", function() {
                // Center the loupe on the marker's new location
                // zoomedMap.setCenterAnimated(marker.coordinate);

                updateLocation(marker.coordinate.latitude, marker.coordinate.longitude)
                
            });
            map.addAnnotation(marker);
        });
    });

}

function downloadWithHeader(url, headers) {
    /*
    $.ajax({
        url: url,
        type: "GET",
        headers: headers
    }).done(function() {
        
    });
    */
   $.ajax({
        url: url,
        type: "GET", // Or "get", case-insensitive
        headers: headers,
        success: function(data) {
            // Request successful, process data
            console.log(data);
        },
        error: function(jqXHR, textStatus, errorThrown) {
            // Handle error
            console.error("Error:", textStatus, errorThrown);
        }
    });
}

