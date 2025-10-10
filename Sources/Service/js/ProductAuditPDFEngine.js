// ProductAuditPDFEngine.js

const { jsPDF } = window.jspdf;

class ProductAuditPDFEngine {

    constructor (doc, name, title, tableHeader, tableBody){
        this.doc = doc
        this.name = name
        this.title = title
        this.tableHeader = tableHeader
        this.tableBody = tableBody
        
        
    }

    byStore() {
        console.log("Proccesed by: console")
    }

    byProduct(){
        console.log("Proccesed by: byProduct")

    }

    bySales() {

        console.log("Proccesed by: bySale")

        bySalesEngine(this.name, this.items, this.title)

    }

    bySalesConcession(){
        console.log("Proccesed by: bySalesConcession")

    }

    byCustomerSales(){
        console.log("Proccesed by: byCustomerSales")

    }

    byUserSales(){
        console.log("Proccesed by: byUserSales")

    }

    byConcession(){
        console.log("Proccesed by: byConcession")

    }

}

function createProductAuditPDF(fileName, title, tableHeader, tableBody) {

    /*
    doc.autoTable({ html: '.table' })
    let finalY = doc.lastAutoTable.finalY || 10
    addImage(imageData, format, x, y, width, height, alias, compression, rotation)
    */

    const doc = new jsPDF({
        orientation: 'l',
        unit: 'mm',
        format: 'legal'
    });


    doc.setProperties({
        title: title,
        creator: 'TierraCero.com | Hacemos tu empresa más grande'
    });

    doc.text('From javascript arrays', 10, 10)

    doc.autoTable({
        startY: 20,
        head: [tableHeader],
        body: tableBody
    });

    doc.save(`${fileName}.pdf`);

}
