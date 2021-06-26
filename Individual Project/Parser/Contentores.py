import csv

with open('/home/krow/Documents/PL/SRCR/out.csv') as file:
    f = open("/home/krow/Documents/PL/SRCR/contentores.pl", "w")
    reader = csv.reader(file)
    prev = None
    value = None
    for row in reader:
        f.write("contentor("+row[2]+",'"+row[5]+"','"+row[6]+"',"+row[7]+","+row[8]+","+row[9]+").\n"  )