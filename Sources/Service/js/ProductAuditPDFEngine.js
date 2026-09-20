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

    doc.text(title, 10, 10)

    doc.autoTable({
        startY: 20,
        head: [tableHeader],
        body: tableBody
    });

    doc.save(`${fileName}.pdf`);

}

function productAuditSafeFileName(value) {
    const normalized = String(value || "reporte")
        .normalize("NFD")
        .replace(/[\u0300-\u036f]/g, "")
        .replace(/[^a-zA-Z0-9._-]+/g, "-")
        .replace(/^-+|-+$/g, "");

    return normalized || "reporte";
}

function productAuditRoot(rootId) {
    if (!rootId) {
        return null;
    }

    return document.getElementById(rootId);
}

function productAuditTables(root) {
    if (!root) {
        return [];
    }

    return Array.from(root.querySelectorAll("table"));
}

function productAuditHeading(table, fallbackTitle, index) {
    let current = table.previousElementSibling;

    while (current) {
        if (/^H[1-3]$/.test(current.tagName)) {
            const text = current.textContent.trim();
            if (text) {
                return text;
            }
        }

        const nestedHeadings = current.querySelectorAll("h1, h2, h3");
        if (nestedHeadings.length > 0) {
            const text = nestedHeadings[nestedHeadings.length - 1].textContent.trim();
            if (text) {
                return text;
            }
        }

        current = current.previousElementSibling;
    }

    return index === 0 ? fallbackTitle : `Tabla ${index + 1}`;
}

function productAuditTextLines(root) {
    if (!root) {
        return [];
    }

    return String(root.innerText || "")
        .split(/\n+/)
        .map((line) => line.replace(/\s+/g, " ").trim())
        .filter(Boolean);
}

function productAuditEscapeHTML(value) {
    return String(value || "")
        .replace(/&/g, "&amp;")
        .replace(/</g, "&lt;")
        .replace(/>/g, "&gt;")
        .replace(/"/g, "&quot;")
        .replace(/'/g, "&#039;");
}

function productAuditDownloadBlob(fileName, type, contents) {
    const blob = new Blob([contents], { type });
    const url = URL.createObjectURL(blob);
    const link = document.createElement("a");

    link.href = url;
    link.download = fileName;
    link.style.display = "none";
    document.body.appendChild(link);
    link.click();
    link.remove();

    setTimeout(() => URL.revokeObjectURL(url), 1000);
}

function createProductAuditExcelFromElement(rootId, fileName, title) {
    const root = productAuditRoot(rootId);
    if (!root) {
        return false;
    }

    const reportTitle = String(title || "Reporte");
    const tables = productAuditTables(root);
    let contents = "";

    if (tables.length > 0) {
        contents = tables.map((table, index) => {
            const clone = table.cloneNode(true);
            clone.querySelectorAll("button, img, script, style").forEach((element) => element.remove());

            return `<h2>${productAuditEscapeHTML(productAuditHeading(table, reportTitle, index))}</h2>${clone.outerHTML}`;
        }).join("<br>");
    }
    else {
        const rows = productAuditTextLines(root)
            .map((line) => `<tr><td>${productAuditEscapeHTML(line)}</td></tr>`)
            .join("");
        contents = `<table><tbody>${rows}</tbody></table>`;
    }

    const workbook = `\ufeff<!DOCTYPE html>
<html lang="es-MX">
<head>
    <meta charset="utf-8">
    <style>
        body { font-family: Arial, sans-serif; color: #111827; }
        h1 { color: #0b4f71; }
        h2 { margin-top: 22px; color: #0b4f71; }
        table { border-collapse: collapse; width: 100%; margin-bottom: 18px; }
        th, td { border: 1px solid #94a3b8; padding: 6px 8px; }
        thead, tfoot { background: #dceaf3; font-weight: 700; }
    </style>
</head>
<body>
    <h1>${productAuditEscapeHTML(reportTitle)}</h1>
    ${contents}
</body>
</html>`;

    productAuditDownloadBlob(
        `${productAuditSafeFileName(fileName)}.xls`,
        "application/vnd.ms-excel;charset=utf-8",
        workbook
    );
    return true;
}

function createProductAuditPDFFromElement(rootId, fileName, title) {
    const root = productAuditRoot(rootId);
    if (!root || !window.jspdf || typeof window.jspdf.jsPDF !== "function") {
        return false;
    }

    const reportTitle = String(title || "Reporte");
    const tables = productAuditTables(root);
    const report = new window.jspdf.jsPDF({
        orientation: "landscape",
        unit: "mm",
        format: "legal"
    });
    const pageWidth = report.internal.pageSize.getWidth();
    const pageHeight = report.internal.pageSize.getHeight();
    let cursorY = 16;

    report.setProperties({
        title: reportTitle,
        creator: "TierraCero.com | Hacemos tu empresa más grande"
    });
    report.setFontSize(16);
    report.text(reportTitle, 10, cursorY);
    cursorY += 9;

    if (tables.length > 0 && typeof report.autoTable === "function") {
        tables.forEach((table, index) => {
            const heading = productAuditHeading(table, reportTitle, index);

            if (cursorY > pageHeight - 35) {
                report.addPage();
                cursorY = 15;
            }

            report.setFontSize(11);
            report.text(heading, 10, cursorY);
            cursorY += 4;

            report.autoTable({
                html: table,
                startY: cursorY,
                includeHiddenHtml: true,
                margin: { left: 10, right: 10 },
                theme: "grid",
                styles: {
                    fontSize: 7,
                    cellPadding: 1.8,
                    overflow: "linebreak"
                },
                headStyles: {
                    fillColor: [37, 44, 59],
                    textColor: [237, 247, 255]
                },
                footStyles: {
                    fillColor: [37, 44, 59],
                    textColor: [242, 201, 76],
                    fontStyle: "bold"
                }
            });

            cursorY = (report.lastAutoTable && report.lastAutoTable.finalY
                ? report.lastAutoTable.finalY
                : cursorY) + 10;
        });
    }
    else {
        report.setFontSize(9);
        const lines = report.splitTextToSize(productAuditTextLines(root).join("\n"), pageWidth - 20);

        lines.forEach((line) => {
            if (cursorY > pageHeight - 12) {
                report.addPage();
                cursorY = 15;
            }

            report.text(line, 10, cursorY);
            cursorY += 4.5;
        });
    }

    report.save(`${productAuditSafeFileName(fileName)}.pdf`);
    return true;
}
