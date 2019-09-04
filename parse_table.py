import re

fh = open('table.txt','r')
performance_report = {}

for line in fh:
    if 'AMBER' in line or 'CHARMM' in line:
        fields = line.strip().split('|')

        if fields[1].replace(' ','') != '':     
           performance_report[fields[1]] = [[fields[2],float(fields[3]),float(fields[4]),float(fields[5])]]
           current_key = fields[1]
        else:
           performance_report[current_key].append([fields[2],float(fields[3]),float(fields[4]),float(fields[5])])





#     var data = google.visualization.arrayToDataTable([
#        ['Card', 'ff99SB', 'charmm36'],
#        ['GTX 1080', 7.02,7.05],    
#         
#        ['GTX 1080 Ti', 10.2,10.0],   
#         
#        ['Titan V', 18.5,18.5],   
#         
#        ['RTX 2080 Ti', 16.3,15.8],         
#      ]);



cardname_mapping = {' `NVIDIA GeForce GTX 1080`_    ':'GTX 1080',
                    ' `NVIDIA GeForce GTX 1080 Ti`_ ':'GTX 1080 Ti',
                    ' `NVIDIA Tesla V100`_          ':'Titan V',
                    ' `NVIDIA GeForce RTX 2080 Ti`_ ':'RTX 2080 Ti'}

for i in [1,2,3]: #1:DHFR,2:FactorIX,3:STMV 
    print('\n\n\n')
    print(["Card", "ff99SB", "charmm36"],',')
    for card in performance_report:
        #s = re.sub('[^0-9a-zA-Z\s+]+', '', card)
        print('["',cardname_mapping[card],'",',performance_report[card][0][i],',',performance_report[card][1][i],'],')

