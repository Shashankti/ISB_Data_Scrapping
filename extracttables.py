import pandas as pd
import os
import camelot

def getcolname(name):
    name = name.lower()
    if name.find("name") >= 0 or name.find("drug") >= 0 :
        return "Name of Drugs/ Cosmetics"
    elif name.find("batch") >= 0 or name.find("manuf") >= 0 :
        return "Batch No./ Date of Manufacture/ Date of Expiry/ Manufactured By"
    elif name.find("reason") >= 0 :
        return "Reason for Failure"
    elif name.find("receiv") >= 0 :
        return "Received From"
    elif name.find("declared") >= 0 :
        return "Declared by"
    elif name.find("year") >= 0:
        return "Year"
    elif name.find("month") >= 0 :
        return "Month"
    elif name.find("from") >= 0 :
        return "Drawn From"
    elif name.find("draw") >= 0 and name.find("by") >= 0 :
        return "Drawn By"
    elif name.find("n") >= 0 and name.find("s") >= 0 :
        return "Sr. No."
    else :
        return name

def mergelastandfirst(df0, df1):
    df = pd.DataFrame()
    last0 = df0.iloc[-1].tolist()
    first1 = df1.iloc[0].tolist()
    merged = [last0[i] + first1[i] for i in range(len(last0))]
    merged_df = pd.DataFrame([merged])
    df = df.append(df0.iloc[0: df0.shape[0] - 1, :], ignore_index=True)
    df = df.append(merged_df, ignore_index=True)
    df = df.append(df1.iloc[1: df0.shape[1], :], ignore_index=True)
    return df

def merge_Dataframes(df1,df2):
    if not (df2[0][0] == ""):
        df1 = df1.append(df2, ignore_index=True)

    else :
        df1 = mergelastandfirst(df1,df2)

    return df1

# folder where splitted PDF files would be created and stored
main_dir = r"C:\Users\lenovo\Desktop\ISB - Prof. Parshuram\CDS data\Split_PDFs"

# folder where extracted tables would be stored
exl_path = r"C:\Users\lenovo\Desktop\ISB - Prof. Parshuram\CDS data\ExtractedTables"

for folder in os.scandir(main_dir):

    directory = folder.path
    name = os.path.basename(directory).strip(".pdf")
    df = pd.DataFrame()

    try:
        for filename in os.scandir(directory):
            tables = camelot.read_pdf(filename.path)
            try :
                data_f = tables[-1].df
                df = merge_Dataframes(df,data_f)
            except :
                pass

        for col in df.columns:
            colname = getcolname(df.iloc[0,col])
            df = df.rename(columns={col: colname})

        df = df.drop(df.index[[0]])

        excel_path = exl_path + "/" + name + ".xlsx"

        df.to_excel(excel_path, index=False)

    except :
        print(name)




