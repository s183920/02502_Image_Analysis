import clipboard
import re
import time
import itertools

def img_to_mat(type_of_data = "gray"):
    # get clipboard data
    data = clipboard.paste()
    data_org = data

    # clean data
    if type_of_data == "rgb":
        # data = data.upper()
        data = re.sub(r"[^\d\&\\RGB]", "", data)
        data = [t for t in data.split("\\\\") if bool(re.search(r'\d', t))]
        
        # Red values
        R = [re.findall(r"R\W?:?\W?\d*", t) for t in data]
        R = [", ".join(t) for t in R]
        R = [re.sub("R", "", t) for t in R]
        R = "; ".join(R)
        R = "r = [" + R + "]"
    
        # Green values
        G = [re.findall(r"G\W?:?\W?\d*", t) for t in data]
        G = [", ".join(t) for t in G]
        G = [re.sub("G", "", t) for t in G]
        G = "; ".join(G)
        G = "g = [" + G + "]"

        # Blue values
        B = [re.findall(r"B\W?:?\W?\d*", t) for t in data]
        B = [", ".join(t) for t in B]
        B = [re.sub("B", "", t) for t in B]
        B = "; ".join(B)
        B = "b = [" + B + "]"
        
        # concat data
        data = R + ";\n" + G + ";\n" + B + ";\nim_rgb = cat(3, r, g, b)"
    elif type_of_data == "gray":
        data = re.sub(r"[^\d\&\\]", "", data)
        data = [t for t in data.split("\\") if bool(re.search(r'\d', t))]
        data = ";\n".join(data)
        data = re.sub(r"\&", ", ", data)
        data = "[" + data + "]"
    elif type_of_data == "landmark":
        data = re.sub(r"[^\d\&\\ab-]", "", data)
        
        # test = [re.sub(r"[^\d&ab]", "", t) for t in test.split("\\\\") if bool(re.search(r'\d', t))]
        out = ""
        data = re.sub(r"[\&]", " ", data)
        data = re.findall("\w\d{1} -?\d{1,2} -?\d{1,2}", data)

        for t in data:
            t = t.split(" ")
            out += t[0] + " = [" + t[1] + "; " + t[2] + "];\n"
        
        data = out
    elif type_of_data == "gray_run_enc":
        data = re.sub(r"[^\d,]", "", data)
        data = data.split(",")
        data = [int(i) for i in data]
        data = [[data[i]]*data[i-1] for i in range(1, len(data), 2)]
        data = str(list(itertools.chain(*data))) + ";"
    elif type_of_data == "binary_run_length":
        data = re.sub(r";", ",", data)
        data = re.sub(r"[^\d,\[\(\)]", "", data)
        data = data.split("[")
        data = [re.sub(r"[^\d,]", "", d).split(",") for d in data if bool(re.search(r'\d', d))]
        out = "I = zeros();\n"
        for d in data:
            col = f"{d[1]}" if d[1] == d[2] else f"{d[1]}:{d[2]}"
            out += f"I({d[0]}, {col}) = 1;\n"
        data = out

    # set clipboard data
    if data_org == data:
        print("The copied data is unchanged. Please make sure data is copied in a LaTeX format")
    else:       
        #win32clipboard.OpenClipboard()
        #win32clipboard.EmptyClipboard()
        clipboard.copy(data)
        #win32clipboard.CloseClipboard()
        print("A Matlab array from clipboard data can now be pasted!")
    
    # display message before closing
    time.sleep(2)


if __name__ == "__main__":
    print("Please enter the number of the type of data you have in your clip board")
    print("\t1: RGB table\n\t2: Grey level image\n\t3: Landmark data\n\t" + 
        "4: Gray level run length encoding\n\t5: Binary run length coding")
    type_of_data = int(input("Datatype: "))
    datatype = {1:"rgb", 2:"gray", 3:"landmark", 4: "gray_run_enc", 5: "binary_run_length"}
    assert type_of_data in datatype.keys(), "The given input was not an option"
    img_to_mat(datatype[type_of_data])




