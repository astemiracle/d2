library(XML)

#decrale the url to extract your last 100 match info into a variable
dotaURL = 'http://api.steampowered.com/IDOTA2Match_112/GetMatchHistory/V001/?key=<key>&format=xml&account_id=<id>'

#load xml in a way that gives you access to each part of the xml file
dota = xmlTreeParse(dotaURL, useInternalNodes=TRUE)
matchHistory = xmlRoot(dota)
xmlName(matchHistory)
names(matchHistory)

match_ids = xpathSApply(matchHistory,"//match_id", xmlValue)

#create a matrix to store all of the data
output = matrix(ncol=12, nrow=100)
j = 0

for (i in match_ids){
  #create unique url for each match id
  j = j + 1
  url = 'http://api.steampowered.com/IDOTA2Match_112/GetMatchDetails/V001/?match_id='
  id = i
  url2 = '&key=<key>&format=xml'
  #pull match details for each match
  matchurl = paste(url, id, url2, sep="")
  dotamatch = xmlTreeParse(matchurl, useInternalNodes=TRUE)
  match = xmlRoot(dotamatch)
  output[j,1] = xpathSApply(match, "//player[account_id = '<id>']/kills", xmlValue)
  output[j,2] = xpathSApply(match, "//player[account_id = '<id>']/deaths", xmlValue)
  output[j,3] = xpathSApply(match, "//player[account_id = '<id>']/assists", xmlValue)
  output[j,4] = xpathSApply(match, "//player[account_id = '<id>']/last_hits", xmlValue)
  output[j,5] = xpathSApply(match, "//player[account_id = '<id>']/denies", xmlValue)
  output[j,6] = xpathSApply(match, "//player[account_id = '<id>']/gold", xmlValue)
  output[j,7] = xpathSApply(match, "//player[account_id = '<id>']/hero_damage", xmlValue)
  output[j,8] = xpathSApply(match, "//player[account_id = '<id>']/tower_damage", xmlValue)
  output[j,9] = xpathSApply(match, "//player[account_id = '<id>']/hero_healing", xmlValue)
  output[j,10] = xpathSApply(match, "//player[account_id = '<id>']/gold_per_min", xmlValue)
  output[j,11] = xpathSApply(match, "//player[account_id = '<id>']/xp_per_min", xmlValue)
  output[j,12] = xpathSApply(match, "//player[account_id = '<id>']/gold_spent", xmlValue)
}

stats = data.frame(output)
col_headers = c('kills', 'deaths', 'assists', 'last_hits', 'denies','gold', 'hero_damage', 'tower_damage', 'hero_healing', 'GPM', 'XPM', 'GoldSpent')
names(stats) = col_headers
write.csv(stats, file = 'dotastats.csv')
