function isNumeric(str) {
  if (typeof str != "string") return false // we only process strings!
  return !isNaN(str) && // use type coercion to parse the _entirety_ of the string (`parseFloat` alone does not do this)...
             !isNaN(parseFloat(str)) // ...and ensure strings of whitespace fail
}
function updateTags(input){
    let dir = $(input).data("dir")
    let img = $(input).data("img")
    let type = $(input).data("type")
    let val = $(input).val()

    console.log(dir)
    console.log(img)
    console.log(type)
    console.log(val)

    if(val == ""){
        return
    }

    $.post( 'spupload_as15e@52ss.php?save=yes', {
        dir: dir,
        img: img,
        type: type,
        val: val
    })
    .done( function ( output ) {
        console.log( output );
        
        let resp = JSON.parse(output)

        console.log(resp)

        $(`#commbox`).prepend(`<div style="color:green"> ✅ actualizado ${type} </div>`)

        if(type == "materia"){

            let _count = $(input).data("count")

            var nval = 100

            if(val == "alg"){
                nval = 150
            }

            $(`#cost_${_count}`).val(nval)

            $.post( 'spupload_as15e@52ss.php?save=yes', {
                dir: dir,
                img: img,
                type: "cost",
                val: nval
            })
            .done( function ( output ) {
                console.log( output );
                $(`#commbox`).prepend(`<div style="color:green"> ✅ actualizado costo </div>`)
            } )
            .fail( function () {
                $(`#commbox`).prepend(`<div style="color:red"> ⭕️ Error costo </div>`)
            });
        }
    } )
    .fail( function () {
        $(`#commbox`).prepend(`<div style="color:red"> ⭕️ Error ${type} </div>`)
    } );

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
    
    
    var url = `https://intratc.co/api/${channel}/${ie}`
    if(channel == ""){
        url = `https://intratc.co/api/${ie}`
    }
    if (channel.includes('http')){
        url = channel;
        inarr['user'] = getCookie(base+'_user');
        inarr['token'] = getCookie(base+'_token');
        inarr['key'] = getCookie(base+'_key');
    }

    if(tcdevmode){
        console.log(JSON.stringify(inarr))
        console.log(inarr)
    }

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
    `<img src="#" style="width:85%; max-height: 100px">`+
    `<div style="font-size:32px">${cust.saleFolio}</div>`
    
    
    var td = getDate()
    body += `<h4 style="margin-bottom: -3px;" class="unline normalize">Creado: <strong style="color:#000">${td.vDate} ${td.stime}</strong></h4>`
    
    /// El Baron Rojo</strong><br>Calle Juares ###,
    body +=
    `<small style="font-size:10px" class="normalize"><strong> Cuidad Victoria, Tamaulipas<br>`+
    `Lunes a Viernes 9:00 - 6:00 Sabados de 10:00 - 5:00<br></small><br>`+
    `<h2 class="normalize unline" style="margin-bottom: -3px; color:#000000"><strong>${cust.customerName}</strong></h1>`
    
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

function closeUIView(){
    
    console.clear()
    
    if ( document.getElementById(`no`) !== null){
        console.log("found no")
        document.getElementById(`no`).click();
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
    frameDoc.document.write('<link type="text/css" rel="stylesheet" href="https://tierracero.com/dev/core/css/zice.style.css">');
    frameDoc.document.write('</script>');
    frameDoc.document.write('</head><body>');
    frameDoc.document.write(contents);
    frameDoc.document.write('</body></html>');
    frameDoc.document.write(`<script type="text/javascript">`)
    frameDoc.document.write(`
         var options = {
          text: "https://${url}/c/${folio}?p=${deepLinkCode}&m=${mobile}",
          width: 70,
          height: 70,
          colorDark: "#000000",
          colorLight: "#ffffff",
          correctLevel: QRCode.CorrectLevel.H
         }
         var element = document.querySelector("#qrInternal");
         var my_qr_code = new QRCode(element, options);

         var options = {
          text: "https://${url}/c/${folio}?p=${deepLinkCode}&m=${mobile}",
          width: 110,
          height: 110,
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

function renderSalePrint(url, folio, contents, purRefs, pickRef ){
    
    console.log("🟢  🟢  🟢  🟢  🟢  🟢  ")
    
//    var code = `
//         var options = {
//          text: "https://${url}/c/${id}",
//          width: 77,
//          height: 77,
//          colorDark: "#000000",
//          colorLight: "#ffffff",
//          correctLevel: QRCode.CorrectLevel.H
//         }
//         var element = document.querySelector("#qrInternal");
//         var my_qr_code = new QRCode(element, options);
//
//
//`
////[CODE]
//
//    var frame1 = document.createElement('iframe');
//    frame1.name = "frame1";
//    frame1.style.position = "absolute";
//    frame1.style.top = "-10000000px";
//    document.body.appendChild(frame1);
//    var frameDoc = frame1.contentWindow ? frame1.contentWindow : frame1.contentDocument.document ? frame1.contentDocument.document : frame1.contentDocument;
//    frameDoc.document.open();
//
//    frameDoc.document.write('<html><head>');
//    frameDoc.document.write('<meta charset="utf-8">');
//    frameDoc.document.write('<title>Imprimir Documento</title>');
//    frameDoc.document.write('<meta name="viewport" content="width=device-width, initial-scale=1.0">');
//    frameDoc.document.write(`<script type="text/javascript" src="https://tierracero.com/dev/skyline/js/QRCode.js">`);
//    frameDoc.document.write('<link type="text/css" rel="stylesheet" href="https://tierracero.com/dev/core/css/zice.style.css">');
//    frameDoc.document.write('</script>');
//    frameDoc.document.write('</head><body>');
//    frameDoc.document.write(contents);
//    frameDoc.document.write('</body></html>');
//    frameDoc.document.write(`<script type="text/javascript">`)
//    frameDoc.document.write(code)
//    frameDoc.document.write(`</script>`)
//    frameDoc.document.close();
//    setTimeout(function () {
//        window.frames["frame1"].focus();
//        window.frames["frame1"].print();
//        document.body.removeChild(frame1);
//    }, 500);
//    return false;
}

function scrollToBottom(id){
    var objDiv = document.getElementById(id);
    objDiv.scrollTop = objDiv.scrollHeight;
}

function goToPanel(){
    window.location = `panel.php`
}

function goToLogin(){
    window.location = `login`
}
function dragElement(elmnt) {
  var pos1 = 0, pos2 = 0, pos3 = 0, pos4 = 0;
  if (document.getElementById(elmnt.id + "header")) {
    /* if present, the header is where you move the DIV from:*/
    document.getElementById(elmnt.id + "header").onmousedown = dragMouseDown;
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


///
function goToLogin(){
    window.location = `login`
}
