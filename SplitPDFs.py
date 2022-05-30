from PyPDF2 import PdfFileWriter, PdfFileReader
import os

# folder where all PDF files are stored
# folder where splitted PDF files would be created and stored

directory = r"C:\Users\lenovo\Desktop\ISB - Prof. Parshuram\CDS data\CDS_data"
output_path = r"C:\Users\lenovo\Desktop\ISB - Prof. Parshuram\CDS data\SplittedPDFS"

for filename in os.scandir(directory):
    input_pdf = PdfFileReader(filename.path, strict=False)
    folder_name = (os.path.basename(filename.path)).strip(".pdf")
    path = os.path.join(output_path,folder_name)
    os.mkdir(path)
    for i in range(input_pdf.numPages):
        output = PdfFileWriter()
        output.addPage(input_pdf.getPage(i))
        with open(path+"/"+str(i)+".pdf", "wb") as output_stream:
            output.write(output_stream)