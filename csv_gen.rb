CONTACTS = 100
INDEXED = true

FILE_NAME = "outlook_contacts"
OUTPUT_DIR_NAME = "csvs"
TEXT_LEN = 8
NUMBER_LEN = 8
EMAIL_LEN = 8
WEBSITE_LEN = 8
EMAIL_END = "@gmail.com"
WEBSITE_END = ".com"
YEAR = "12/12/10"
INDEX_CHARS = ('A'..'Z').to_a + ('0'..'9').to_a

# mapping table
MAPPING = [
    ["Home Phone", 0],
    ["E-mail 3 Address","M"],
    ["E-mail 2 Address","M"],
    ["Web Page","W"],
    ["Anniversary","D"],
    ["Other Street 3", 0],
    ["Other Street 2", 0],
    ["Company Main Phone", 0],
    ["Other Street", 0],
    ["Department", 0],
    ["Title", 0],
    ["Telex", 0],
    ["Other Phone", 0],
    ["Hobby", 0],
    ["Home Address PO Box", 0],
    ["Profession","T"],
    ["Pager", 0],
    ["Home Phone 2", "N"],
    ["Job Title", 0],
    ["Other Country", 0],
    ["Business Phone", "N"],
    ["Home City", "T"],
    ["Notes", "T"],
    ["ISDN", 0],
    ["Company", "T"],
    ["Home Country", "T"],
    ["Business City", "T"],
    ["Business Country", "T"],
    ["Office Location", 0],
    ["Home Street 3", 0],
    ["Home Street 2", 0],
    ["Business Phone 2", 0],
    ["Other Postal Code", 0],
    ["Categories", 0],
    ["Car Phone", 0],
    ["E-mail Address", "M"],
    ["E-mail 2 Display Name", 0],
    ["E-mail Display Name", 0],
    ["Birthday", "D"],
    ["E-mail 3 Display Name", 0],
    ["Other City", 0],
    ["Home Postal Code", "N"],
    ["Business Postal Code", "N"],
    ["Assistant's Phone", 0],
    ["Suffix", 0],
    ["Home State", "T"],
    ["Home Street", "T"],
    ["Home Fax", 0],
    ["Business Street", "T"],
    ["Gender", 0],
    ["Middle Name", "TM"],
    ["Business Street 3", 0],
    ["Business Street 2", 0],
    ["Other Fax", 0],
    ["Business State", "T"],
    ["First Name", "TF"],
    ["Last Name", "TL"],
    ["TTY/TDD Phone", 0],
    ["Business Address PO Box", 0],
    ["Other Address PO Box", 0],
    ["Business Fax", 0],
    ["Language", 0],
    ["Mobile Phone", "N"],
    ["Other State", 0]
]

# methods definition
def gen_text_string(length)
    (0...length).map{65.+(rand(26)).chr}.join.downcase
end

def gen_num_string(length)
    (0...length).map{48.+(rand(10)).chr}.join
end

def gen_email_string(length)
    gen_text_string(length) + EMAIL_END
end

def gen_web_string(length)
    gen_text_string(length) + WEBSITE_END
end

def gen_date_string
    YEAR
end

if INDEXED
	FILE_NAME = FILE_NAME + "_indexed"
else
	FILE_NAME = FILE_NAME + "_random"
end

OUTPUT_FILE_PATH = OUTPUT_DIR_NAME + '/' + FILE_NAME + "_#{CONTACTS}.vcf"

File.open(OUTPUT_FILE_PATH, 'w') do |f|    
    # adding header line in csv file
    MAPPING.each do |row|
        if row == MAPPING.last
            f.print("\"" + row[0] + "\"\n")
        else
            f.print("\"" + row[0] + "\",")
        end        
    end
    
    # generating the rest
    (1..CONTACTS).each do |contact|
		index_char = INDEX_CHARS[contact%INDEX_CHARS.length]
        MAPPING.each do |row|
            temp_str = ""
            case row[1]
                when 0
                    temp_str = "\"\""
				when "TF"
					if INDEXED
						temp_str = "\"" + index_char + "_First_" + contact.to_s + "\""
					else
						temp_str = "\"" + gen_text_string(TEXT_LEN).capitalize + "\""
					end
				when "TM"
					if INDEXED
						temp_str = "\"" + index_char + "_Middle_" + contact.to_s + "\""
					else
						temp_str = "\"" + gen_text_string(TEXT_LEN).capitalize + "\""
					end
				when "TL"
					if INDEXED
						temp_str = "\"" + index_char + "_Last_" + contact.to_s + "\""
					else
						temp_str = "\"" + gen_text_string(TEXT_LEN).capitalize + "\""
					end
                when "T"
                    temp_str = "\"" + gen_text_string(TEXT_LEN) + "\""
                when "N"
                    temp_str = "\"" + gen_num_string(NUMBER_LEN) + "\""
                when "M"
                    temp_str = "\"" + gen_email_string(EMAIL_LEN) + "\""
                when "D"
                    temp_str = "\"" + gen_date_string + "\""
                when "W"
                    temp_str = "\"" + gen_web_string(WEBSITE_LEN) + "\""
                else
                    temp_str = "ERROR!"
            end
            
            if row == MAPPING.last
                temp_str = temp_str + "\n"
            else
                temp_str = temp_str + ","
            end
            
            f.print(temp_str)
        end
    end
end
