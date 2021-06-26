import csv

f = open("/home/krow/Documents/PL/SRCR/locais.pl", "w")

with open('/home/krow/Documents/PL/SRCR/out.csv') as file:
    reader = csv.reader(file)
    prev = None
    value = None
    prevString = None
    for row in reader:
        
        if prev is not None and prev == row[4]:
            if value is not None:
                value = value + "," + prevString[2]
            else:
                value = prevString[2]
        else:
            if prevString is not None:
                f.write("local("+prevString[4]+","+ "["+ value + "," + prevString[2] +"]"+","+prevString[0]+","+prevString[1]+",'"+prevString[3]+"').\n")
                value = row[2]
        
        prev = row[4]
        prevString = row

        


#with open("/home/krow/Documents/PL/SRCR/locais.pl") as file2:
#    reader = 
