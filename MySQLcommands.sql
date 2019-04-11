#DUMP TO A .sql FILE AND GENERATE A .png FILE
mysqldump -u shane -p -d bank > mydatabase.sql sqlt-graph -f MySQL -o my-database.png -t png mydatabase.sql

#EXTRACT DATA FROM UCSC FOR THE CHROMOSOME REGION OF INTEREST
mysql -h genome-mysql.soe.ucsc.edu -ugenome -A -e "select e.chrom, e.txStart, e.txEnd, e.strand, e.name, j.name as geneSymbol from ncbiRefSeqCurated e, ncbiRefSeqLink j where e.name = j.id AND e.chrom='${chrom}' AND ((e.txStart >= ${chromStart} AND e.txStart <= ${chromEnd}) OR (e.txEnd >= ${chromStart} AND e.txEnd <= ${chromEnd})) order by e.txEnd desc " hg38 > genlist.txt

#EXTRACT THE DESCRIPTIONS FOR THE GENES IN THE INTERESTING REGION
mysql -h genome-mysql.soe.ucsc.edu -ugenome -A -e "select e.chrom, e.txStart, e.txEnd, e.strand, e.name, j.name, description as geneSymbol from ncbiRefSeqCurated e, ncbiRefSeqLink j where e.name = j.id AND e.chrom='${chrom}' AND ((e.txStart >= ${chromStart} AND e.txStart <= ${chromEnd}) OR (e.txEnd >= ${chromStart} AND e.txEnd <= ${chromEnd})) order by e.txEnd desc " hg38 > desclist.txt
