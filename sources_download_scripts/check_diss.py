from pypdf import PdfReader

reader = PdfReader("sources/Monzel_2025_Dissertation_BonnDoc.pdf")
print("Total pages in Monzel Dissertation:", len(reader.pages))

# Print first 15 pages for table of contents
toc_text = ""
for i in range(min(15, len(reader.pages))):
    text = reader.pages[i].extract_text()
    if "Inhaltsverzeichnis" in text or "Table of Contents" in text or "Publications" in text or "Publikationen" in text or "Overview" in text:
        print(f"--- Page {i+1} ---")
        print(text[:1500])
