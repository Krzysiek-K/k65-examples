BEGIN {
	ndata=0
}

/0x/{
	line=$0
	gsub(/[ \t]+/,"",line)
	gsub(/,/," ",line)
	n=split(line,LINE)
	for(i=1;i<=n;i++)
		DATA[ndata++] = LINE[i];
}


function dump_char(base,		y)
{
	for(y=0;y<8;y++)
		printf("%s%s",y?" ":"\t",DATA[base+y]);
	printf("\n");
}

function dump_row(r,size,	i)
{
	print "\t// Row " r
	for(i=0;i<size;i++) dump_char(r,i);
	print ""
}

END {
	print "data InfoFont {"
	print "\talign 8"

	while(ndata>0 && strtonum(DATA[ndata-1])==0)
		ndata--;
	while(ndata%8)
		ndata++;

	for(i=0;i<ndata;i+=8)
		dump_char(i);

	print "}"
}
