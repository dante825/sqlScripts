awk -v l=36000 '(NR==1){header=$0;next}
                (NR%l==2) { 
                   c=sprintf("%0.5d",c+1); 
                   close(file); file=FILENAME; sub(/csv$/,c".csv",file)
                   print header > file
                }
                {print $0 > file}' company_no_sanc_not_mys_full.csv
