import win32clipboard
import re

def get_matrix():
    # get clipboard data
    win32clipboard.OpenClipboard()
    data = win32clipboard.GetClipboardData()
    win32clipboard.CloseClipboard()
    data_org = data

    # clean data
    # print(type(data))
    data = re.sub(r"[^\d\&\\]", "", data)
    # print(data)
    # data = data.split("\\")
    data = [t for t in data.split("\\") if bool(re.search(r'\d', t))]
    data = "\n".join(data)
    data = re.sub(r"\&", ", ", data)
    data = "[" + data + "]"

    if data_org == data:
        print("The copied data is unchanged. Please make sure data is copied in a LaTeX format")
    else:
        # set clipboard data
        win32clipboard.OpenClipboard()
        win32clipboard.EmptyClipboard()
        win32clipboard.SetClipboardText(data)
        win32clipboard.CloseClipboard()
        print("A Matlab array from clipboard data can now be pasted!")
    

if __name__ == "__main__":
    get_matrix()

