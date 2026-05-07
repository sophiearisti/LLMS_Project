df <- read.csv('Papers/Trust and Promises/datapaper_anonymized.csv')
cat('Total rows:', nrow(df), '\n')
cat('Trustees (role==1):', sum(df$role==1), '\n')
cat('First 3 trustees with indices:\n')
trustees <- df[df$role==1, ]
print(data.frame(row_index=which(df$role==1)[1:3], 
                 Subject=trustees$Subject[1:3],
                 session=trustees$session[1:3],
                 is_promise=trustees$is_promise[1:3]))
