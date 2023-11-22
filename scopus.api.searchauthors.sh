outfile=ScopusIDs.csv

apikey= # go to https://dev.elsevier.com/apikey/manage to get your API keys
token= #go to https://service.elsevier.com/app/contact/supporthub/dataasaservice/ to requst a token
uni='(University%20of%20Auckland)' #%20 is space

inpfile=HRexample.csv # your input file

if [ -f $outfile ];then
	rm -f $outfile
fi
printf '%s\n' Person Lastname Firstname ScopusID | paste -sd "," >> $outfile


for auid in `cat $inpfile | awk -F, 'NR>1 {print $1}'`
#for auid in '819012306'
do
last=`cat $inpfile | awk -F, '$1==o {print $2}' o=$auid | sed 's/ /%20/g'` #sed replace space with %20
first=`cat $inpfile | awk -v RS='\r?\n' -F, '$1==o {print $3}' o=$auid | sed 's/ /%20/g'` #-v RS='\r?\n' remove carriage return
echo $last
echo $first

#-------------------------call API
metric=ScholarlyOutput
inp=`echo 'https://api.elsevier.com/content/search/author?query=authlast('$last')%20and%20authfirst('$first')%20and%20affil'$uni'&apiKey='$apikey'&insttoken='$token`
echo $inp
out=`curl -X GET --header 'Accept: application/json' $inp`

#results=`echo $out | awk -F'opensearch:totalResults": "' '{print $2}' | awk -F'",' '{print $1}'`
results=`echo $out | awk -F'opensearch:totalResults' '{print $2}' | awk -F'",' '{print $1}' | awk -F':"' '{print $2}'`
echo $results

if [ $results -eq 1 ];then
	scopusid=`echo $out | awk -F'AUTHOR_ID:' '{print $2}' | awk -F'",' '{print $1}'`
	elif [ $results -eq 0 ]; then
	scopusid=notfound
	elif [ $results -gt 1 ]; then
	scopusid=multiple
	else
	scopusid=other
fi

echo $scopusid
printf '%s\n' $auid $last $first $scopusid | paste -sd "," >> $outfile

done #auid
