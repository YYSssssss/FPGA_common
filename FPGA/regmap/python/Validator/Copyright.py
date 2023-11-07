from datetime import date

class Copyright:
    @staticmethod
    def generate_copyright_header(filename):
        current_date = date.today()
        year = current_date.strftime("%Y")
        full_date = current_date.strftime("%b %d, %Y")
        res = ""
        res += "/*\n"
        res += " *  " + filename + "\n"
        res += " *\n"
        res += " *  (C) Copyright " + year + ", Jabil ltd.\n"
        res += " *\n"
        res += " *  Created on: " + full_date + "\n"
        res += " *\n"
        res += " *  THIS IS AUTO-GENERATED FILE. PLEASE DO NOT EDIT IT.\n"
        res += " */\n"
        return res
