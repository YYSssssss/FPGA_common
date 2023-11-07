def log_info(text):
    _log("INFO",text)

def log_error(text):
    _log("ERROR",text)

def _log(prefix, text):
    if type(text) is str:
        print("{}: {}".format(prefix, text))
    elif type(text) is list:
        for i in range(0,len(text)):
            if i == 0:
                print("{}: {}".format(prefix, text[i]))
            else:
                print("{}  {}".format((len(prefix) * " " ), text[i]))
