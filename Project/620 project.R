library(SPARQL)
library(ggplot2)
library(wordcloud)
library(RColorBrewer)
library(tm)
library(SnowballC)
library(tau)
library(dplyr)
setwd("/Users/arthur_0804/Desktop/INLS 620/project")

# url
endpoint <- "http://localhost:3030/a4/query"

# namespace
prefix <- c ('dbo', '<http://dbpedia.org/ontology/>',
        'a3', '<http://jiamingqu.com/>', 
        'dbr', '<http://dbpedia.org/resource/>',
        'foaf', '<http://xmlns.com/foaf/0.1/>',
        'rdfs','<http://www.w3.org/2000/01/rdf-schema#>',
        'rdf', '<http://www.w3.org/1999/02/22-rdf-syntax-ns#>',
        'owl','<http://www.w3.org/2002/07/owl#>',
        'xsd',' <http://www.w3.org/2001/XMLSchema#>')

# query1: who made most 3 point goals in 2017
query1 <- "
PREFIX dbo: <http://dbpedia.org/ontology/> 
PREFIX a3: <http://jiamingqu.com/> 
PREFIX dbr: <http://dbpedia.org/resource/> 
PREFIX foaf: <http://xmlns.com/foaf/0.1/> 
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>

SELECT ?years ?object
WHERE {
?subject dbo:activeYears ?years .
?subject foaf:name 'Stephen Curry' .
?subject a3:has3PointFieldGoals ?object .
}"

# run query1:
qd1 <- SPARQL(endpoint,query1,ns=prefix)
df1 <- qd1$results
head(df1)
str(df1)
# change to data frame
df1 <- as.data.frame(df1)
# plot
p1 <- ggplot(df1, aes(x=years, y=object, group=1)) + geom_point() + geom_line()+
  labs(title ="3pts of Stephen Curry", x = "Season", y = "Numbers")
print(p1)

# query2: DAL 2017 line-up
query2 <- "
PREFIX dbo: <http://dbpedia.org/ontology/> 
PREFIX a3: <http://jiamingqu.com/> 
PREFIX dbr: <http://dbpedia.org/resource/> 
PREFIX foaf: <http://xmlns.com/foaf/0.1/> 
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>

SELECT ?name ?points ?game
WHERE {
?subject dbo:activeYears '2017' .
?subject foaf:name ?name .
?subject dbo:club dbr:Dallas_Mavericks .
?subject a3:hasTotalPoints ?points .
?subject a3:playedGame ?game .
}"
# run query2:
qd2 <- SPARQL(endpoint,query2,ns=prefix)
df2 <- qd2$results
head(df2)
str(df2)
# change to data frame
df2 <- as.data.frame(df2)
# add the average column
df2$avg_pts <- df2$points / df2$game
head(df2)
df2 <- arrange(df2,avg_pts)
df2
# plot
p2 <- ggplot(df2, aes(x=reorder(name, -avg_pts), y=avg_pts)) + geom_bar(stat='identity', fill='white', color='steelblue', size = 1, width=1)+
  theme(axis.text.x = element_text(angle = 60, hjust = 1))+
  labs(title ="Line-up of DAL in 2017 and their scores per game", x = "Player", y = "Average Score")+
  scale_y_continuous(breaks = seq(0, 20, by = 5))
print(p2)


# query3: birth place
query3 <- "
PREFIX dbo: <http://dbpedia.org/ontology/> 
PREFIX a3: <http://jiamingqu.com/> 
PREFIX dbr: <http://dbpedia.org/resource/> 
PREFIX foaf: <http://xmlns.com/foaf/0.1/> 
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>

SELECT ?state (count(?state) as ?count)
WHERE{
SELECT DISTINCT ?name ?state
WHERE {
?subject foaf:name ?name .
?subject a3:birthState ?state .
}
}
GROUP BY ?state
ORDER BY DESC(?count)"
# run query3:
qd3 <- SPARQL(endpoint,query3,ns=prefix)
df3 <- qd3$results
head(df3)
str(df3)
# change to data frame
df3 <- as.data.frame(df3)
# extract top 20
df3_new <- df3[1:20,]
# plot
p3 <- ggplot(df3_new, aes(x=reorder(state, -count), y=count)) + geom_bar(stat='identity', fill='white', color='steelblue', size = 1, width=1)+
  theme(axis.text.x = element_text(angle = 60, hjust = 1))+
  labs(title ="Player counts from each state (2012-2017)", x = "State", y = "Count")+
  scale_y_continuous(breaks = seq(0, 100, by = 5))
print(p3)

# wordcloud
tail(df3)
wordcloud(words = df3$state, freq = df3$count, min.freq = 5, random.order=FALSE, rot.per=0.35, 
          colors=brewer.pal(8, "Dark2"))

# query4: schools
query4 <- "
PREFIX dbo: <http://dbpedia.org/ontology/> 
PREFIX a3: <http://jiamingqu.com/> 
PREFIX dbr: <http://dbpedia.org/resource/> 
PREFIX foaf: <http://xmlns.com/foaf/0.1/> 
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>

SELECT ?college (count(?college) as ?count)
WHERE{
SELECT DISTINCT ?name ?college
WHERE {
?subject foaf:name ?name .
?subject dbo:School ?college .
}
}
GROUP BY ?college
ORDER BY DESC(?count)"
# run query3:
qd4 <- SPARQL(endpoint,query4,ns=prefix)
df4 <- qd4$results
head(df4)
str(df4)
# change to data frame
df4 <- as.data.frame(df4)



