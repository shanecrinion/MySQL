## Using SQL with BioPython

**Generate an entity relationship diagram**

Download and install SQLFairy, a set of Perl modules to 'dump' a database into database format:

```bash
#INSTALL SQLFAIRY TO GENERATE ER DIAGRAM
sudo apt-get install sqlfairy
```

Use mysqldump:

```mysql
#DUMP TO A .sql FILE AND GENERATE A .png FILE
mysqldump -u shane -p -d bank > mydatabase.sql sqlt-graph -f MySQL -o my-database.png -t png mydatabase.sql
```



View the Entity-Relationship Diagram using Python

```python
from IPython.display import Image
Image (filename='/home/shane/Documents/mydatabase.png')
```



![mydatabase](/home/shane/Documents/mydatabase.png)





## SQL and Remote Databases

Some cancer patients treated with chemotherapy go on to develop drug resistant disease that is refractory to the original treatment. Genomic profiling of these patients show distinct patterns of copy number 
variants (duplications) and deletions of specific regions of the cancer genome, which are a result of the tumour populations evolving in response to the treatment regimen. Often the most important proteins 
involved in this process are the glycoproteins that pump xenobiotics (foreign substances) out of cells - their amplification enhances tumour cells' abilities to remove cytotoxic drugs, and so, counter the effects 
of treatment. A quite common amplification occurs in chromosome 7, specifically within the 7q21-q22 locus. You've been asked to and (ii) generate a set of gene descriptions for each gene. Figure out a
way to search this set of gene descriptions for keywords that are consistent with 'glycoprotein', 'pump', 'xeno' or 'resistance' and from this, identify the likely set of genes involved in the development of 
chemoresistance.



**1.** Identify the genes associated with the amplified locus chr7:77900000-107800000:

*Use the command line <code>mysql</code> program to implement a <code>SQL</code> query against the <code>hg38</code> build of the human genome to find the list of genes within this locus - redirect this output to a file, <code>genes_list.txt</code>*

The <code>7q21-q22</code> susceptible to copy number variants and deletions is specified to extract the correct data from the UCSC Genome Browser:
><code>chrom="chr7"
>chromStart="77900000"
>chromEnd="107800000"
></code>

The remote UCSC MySQL server is the accessed using the following code which write the information so the desired region to the genlist.txt file:

```mysql
mysql -h genome-mysql.soe.ucsc.edu -ugenome -A -e "select e.chrom, e.txStart, e.txEnd, e.strand, e.name, j.name as geneSymbol from ncbiRefSeqCurated e, ncbiRefSeqLink j where e.name = j.id AND e.chrom='${chrom}' AND ((e.txStart >= ${chromStart} AND e.txStart <= ${chromEnd}) OR (e.txEnd >= ${chromStart} AND e.txEnd <= ${chromEnd})) order by e.txEnd desc " hg38 > genlist.txt
```



2. **Generate a set of gene descriptions for each gene.**

*Perform a similar search to generate a set of gene descriptions using the same search constraints - redirect this output to a file, <code>gene_descriptions.txt*</code>

To extract the descriptions for the genes in the interest region, the <code>description</code> field is added to the code that interacts with the UCSC Genome Browser. Write this to another text file, which can then be used in a Python code.

```mysql
mysql -h genome-mysql.soe.ucsc.edu -ugenome -A -e "select e.chrom, e.txStart, e.txEnd, e.strand, e.name, j.name, description as geneSymbol from ncbiRefSeqCurated e, ncbiRefSeqLink j where e.name = j.id AND e.chrom='${chrom}' AND ((e.txStart >= ${chromStart} AND e.txStart <= ${chromEnd}) OR (e.txEnd >= ${chromStart} AND e.txEnd <= ${chromEnd})) order by e.txEnd desc " hg38 > desclist.txt
```

*Using  the keywords above, search through the file gene_descriptions.txt to  identify some - if any - that have one or more of those keywords in  their gene descriptions.*

To do this, I will import `pandas`, `os` and `regular expressions`. `Pandas` is used to create a data frame to interact with gene descriptions. `os` is for reader's operator system to interact and inspect the data frame. Regular expressions `re` is used to compile the genes described by key words associated with glycoprotein pumping.



