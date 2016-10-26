require("RCurl")
require("jsonlite")
# Read in data from DB
df <- data.frame(fromJSON(getURL(URLencode('oraclerest.cs.utexas.edu:5001/rest/native/?query="select * from GASISDATA"'),httpheader=c(DB='jdbc:oracle:thin:@aevum.cs.utexas.edu:1521/f16pdb', USER='cs329e_qmn76', PASS='orcl_qmn76', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))

states = c('TEXAS', 'ALABAMA')

str = paste("where state in (",paste(states, collapse=", "),")")
str

