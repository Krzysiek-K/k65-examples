BEGIN {
	ROW = 0
	COL = 0
	LABEL = ""
}

{byteline=0}
/\.byte/ {
	byteline=1

	line=$0
	sub(/[ \t]*\.byte[ \t]*/,"",line);
	gsub(/,/," ",line);
	n=split(line,LINE)

	DATA[ROW,COL,"label"] = LABEL
	DATA[ROW,COL,"len"] = n
	for(i=1;i<=n;i++)
		DATA[ROW,COL,i-1] = LINE[i]+0

	COL++
}

!byteline && COL>0 {
	COL=0
	ROW++
}

/^[ \t]*[a-zA-Z0-9_]+:/{
	LABEL=$0
	sub(/^[ \t]+/,"",LABEL)
	sub(/:.*$/,"",LABEL)
	LABELROW[LABEL] = ROW
}

function attr_normalize(v,a1,a2,	x,c,c0,c1,c2,c3)
{
	c0=0
	c1=1
	c2=2
	c3=3

	c=rshift(a1,4)
	if(c== 0) c1=0;
	if(c==11) c1=1;
	if(c==15) c1=2;
	if(c== 1) c1=3;

	c=and(a1,15)
	if(c== 0) c2=0;
	if(c==11) c2=1;
	if(c==15) c2=2;
	if(c== 1) c2=3;

	c=and(a2,15)
	if(c== 0) c3=0;
	if(c==11) c3=1;
	if(c==15) c3=2;
	if(c== 1) c3=3;

	#printf("<%d%d%d>",c1,c2,c3)

	q = 0
	for(x=0;x<8;x+=2)
	{
		c = and(rshift(v,x),3)

		if(c==0) c=c0;
		else if(c==1) c=c1;
		else if(c==2) c=c2;
		else if(c==3) c=c3;

		q = or(q,lshift(c,x))
	}

	return q;
}

function dump_char(r,c,		y,a1,a2)
{
	a1 = DATA[LABELROW["colora"],r+1,c]
	a2 = DATA[LABELROW["colorb"],r,c]

	#printf("\t%02X %02X",a1,a2)

	for(y=0;y<8;y++)
		printf("%s%d",y?" ":"\t",attr_normalize(DATA[r,c,y],a1,a2));
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
	print "\t0 0 0 0 0 0 0 0"

	dump_row(0,12)
	dump_row(1,14)

	print "}"
}
