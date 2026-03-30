import ghostscript
import sys

def gs_clean_pdf(input_pdf, output_pdf):
    args = [
        "gs",
        "-sDEVICE=pdfwrite",
        "-dCompatibilityLevel=1.4",
        "-dPDFSETTINGS=/prepress",
        "-dNOPAUSE",
        "-dQUIET",
        "-dBATCH",
        f"-sOutputFile={output_pdf}",
        input_pdf
    ]

    ghostscript.Ghostscript(*args)

gs_clean_pdf("./1764153613543.pdf", "./1764153613543_cleaned.pdf")
