

#!/bin/bash/

domain=$1
validator=$2

mkdir -p $domain  $domain/resolved  $domain/subdomyop $domain/resolvers $domain/portscan/ $domain/nuclei  $domain/aquatone   
mkdir -p $domain/gau  $domain/Javascript $domain/AllParam  $domain/gf_patterns $domain/wordlist $domain/httpx


if [ $validator -eq 2 ]
then
echo "

fresh resolvers


"

dnsvalidator -tL https://public-dns.info/nameservers.txt -threads 20 -o $domain/resolvers/resolvers.txt

echo "
        
   resolvers are download

"
fi

echo "


recon started Boss


"



domain_enum(){

export CHAOS_KEY=de05fda3f05a1e9191438d360e727d3bb40f5cc958267d0362a17811aabb1f5a

  


subfinder -recursive  -silent -d  $domain  >> $domain/subfinder.txt
assetfinder --subs-only $domain  >> $domain/subfinder.txt       
Findomain -t $domain -q  -r  >> $domain/subfinder.txt
chaos -d $domain  >> $domain/subfinder.txt
amass enum -passive -d $domain >> $domain/subfinder.txt
cd git_recon/github-search
github-subdomain -d $domain -o $domain/subfinder.txt
cd ../../

cat $domain/subfinder.txt | wc -l 

cat $domain/subfinder.txt | sort -u >>  $domain/sortedSub.txt 

cat $domain/sortedSub.txt | wc -l 

cat $domain/sortedSub.txt | httpx -status-code -title -web-server -no-color  -silent  >> $domain/httpx/allurls.txt 

cat $domain/httpx/allurls.txt | grep "200" >> $domain/httpx/200.txt

cat $domain/httpx/allurls.txt | grep "403" >> $domain/httpx/403.txt  

cat $domain/httpx/allurls.txt | grep "302" >> $domain/httpx/302.txt  

cat $domain/httpx/allurls.txt | grep "401" >> $domain/httpx/401.txt  

    
cat $domain/sortedSub.txt | httpx -silent >> $domain/nuclei/ipdata.txt

}


domain_enum


resolve_all_subdomains(){

cat $domain/sortedSub.txt | dnsprobe -r CNAME -silent -o  $domain/resolved/cnameallop.txt     

#cat $domain/httpx.txt | dnsprobe -r CNAME -o $domain/resolved/cnamehttpx.txt 

cat $domain/sortedSub.txt | dnsprobe -r A -silent -o  $domain/resolved/Arecordallop.txt    

cat $domain/sortedSub.txt | dnsprobe | awk '{ print $1 }' >> $domain/portscan/resolvedsub.txt 

#cat $domain/httpx.txt | dnsprobe -r A -o  $domain/resolved/ArecordHttpxop.txt    

cat $domain/resolved/Arecordallop.txt | cut -d "" -f3 | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" | sort -u  >> $domain/resolved/resolvedip.txt

cat $domain/resolved/resolvedip.txt | wc -l 
 
}

resolve_all_subdomains 

echo "

    Subdomain Enum Done  Crawling Started running now  

"


spider(){

hakrawler -url $domain -depth 3 -plain >>  $domain/hakrawlerOP.txt

gospider -s "https://$domain/" -o $domain/gospiderOP -c 10 -d 5 --other-source --include-subs --blacklist ".(jpg|jpeg|gif|css|tif|tiff|png|ttf|woff|woff2|ico)" 

#-p http://127.0.0.1:8080     proxy to Burp  

# try to add cookie value --cookie "testA=a; testB=b"  aise 

# gospider ks op kidhar bhu use nahi kiya abhi tak  

}

spider



echo "

    Spidering  ended JS Enum Started 


"


allAboutJS(){

    echo $domain | gau | grep -iE '\.js$' | httpx -status-code -mc 200 -content-type -silent | grep 'application/javascript' | awk '{ print $1}' >>  $domain/Javascript/alljsfiles.txt 

    gau  $domain  |grep -iE '\.js' | grep -ivE '\.json' | sort -u  >> $domain/Javascript/alljsfiles.txt

    getJS --url https://www.$domain --complete --resolve --output $domain/Javascript/alljsfiles.txt

    echo https://www.$domain | subjs >> $domain/Javascript/alljsfiles.txt

    python3 getsrc.py https://$domain  >> $domain/Javascript/alljsfiles.txt

        
    cat $domain/Javascript/alljsfiles.txt | sort -u >> $domain/Javascript/sortedjsFiles.txt
    

}


allAboutJS

screenshot(){
    echo "
    
            aquatone taking Screenshot
    
    "
    cat $domain/portscan/resolvedsub.txt | aquatone -ports xlarge -out $domain/aquatone

}

screenshot


portscan(){
    #naabu -iL hosts.txt
    # naabu -exclude-ports 22,80,443
    echo "
    
                naabu fetching ports
    
    "
    naabu -iL $domain/portscan/resolvedsub.txt -silent -o $domain/portscan/nabbuop.txt

    echo "
            
            Nmap started
    
    "
    nmap -sV -p2075,2076,6443,3868,3366,8443,8080,9443,9091,3000,8000,5900,8081,6000,10000,8181,3306,5000,4000,8888,5432,15672,9999,161,4044,7077,4040,9000,8089,443,7447,7080,8880,8983,5673,7443,19000,19080,9200,80 -T4 -iL $domain/resolved/resolvedip.txt | tee $domain/portscan/serviceVersion.txt

}

portscan




nucleiscan(){
nuclei -update-templates
cat $domain/nuclei/ipdata.txt | nuclei -t ../nuclei-templates -silent -o $domain/nuclei/opdata.txt 

#cat $domain/nuclei/ipdata.txt | nuclei -t ../nuclei-templates/cves -silent -o $domain/nuclei/opdata.txt 

}

nucleiscan

function(){

cd sub-domain/Sudomy/   
#sudomy -d $domain
sudomy -d $domain -dP -eP -cF -pS -tO -gW --httpx --dnsprobe
cd output/
date=$(date +%m-%d-%Y)
cd $date  
cp -r $domain ../../../../$domain/subdomyop
cd ../..

}

function


all_about_urls(){


cd ALL_parameter/ParamSpider
python3 paramspider.py --domain $domain --level high -exclude woff,css,js,png,svg,php,jpg,jpeg,tiff,tif,woff,woff2   --quiet -o $domain/AllParam/paramspiderOP.txt
cd ../..

gau $domain | grep "=" | egrep -iv ".(jpg|png|jpeg|css|js|tif|tiff|png|woff|woff2|ico|pdf|svg|txt)" | sort -u  >> $domain/AllParam/gauParam.txt


}

all_about_urls


valid_urls_by_ffuf(){

ffuf -c -u "FUZZ" -w $domain/AllParam/gauParam.txt -of csv -o $domain/AllParam/validcsvparam.txt
cat $domain/AllParam/validcsvparam.txt | grep http | awk -F "," 'print $1' >> $domain/AllParam/validparam.txt
cat $domain/hakrawlerOP.txt | grep "=" | awk '{ print $2 }' >> $domain/AllParam/validparam.txt
cat $domain/AllParam/paramspiderOP.txt >> $domain/AllParam/validparam.txt


rm $domain/AllParam/validcsvparam.txt

}

valid_urls_by_ffuf


xsscheck(){

    cat demourls.txt | Gxss -c 100 -o output.txt    # sab parameter me Gxss dalta he or check karta he reflect hota he ya nahi 

    # op file ko curl se burp ko bejho manuualy check karne ko 

    #echo "testphp.vulnweb.com" | waybackurls | httpx -silent | Gxss -c 100 -p Xss | sort -u | dalfox pipe

    cat urls.txt | kxss 


}



gf_patterns(){

    gf xss $domain/AllParam/validparam.txt | tee $domain/gfOP/gfxss.txt 
    gf idor $domain/AllParam/validparam.txt | tee $domain/gfOP/idor.txt 
    gf ssrf $domain/AllParam/validparam.txt | tee $domain/gfOP/ssrf.txt 
    gf sqli $domain/AllParam/validparam.txt | tee $domain/gfOP/sqli.txt 
    gf potential $domain/AllParam/validparam.txt | tee $domain/gfOP/potential.txt 
    gf ssti $domain/AllParam/validparam.txt | tee $domain/gfOP/ssti.txt 
    gf rce $domain/AllParam/validparam.txt | tee $domain/gfOP/rce.txt 


}

gf_patterns

echo "wordlist started"

wordlistgen(){

#cat $domain/hakrawlerOP.txt | wc -l 


waybackurls $domain | egrep -iv ".(jpg|png|jpeg|css|js|tif|tiff|png|woff|woff2|ico|pdf|svg|txt|gif)" | sort -u | tee -a $domain/wordlist/data.txt


cat $domain/hakrawlerOP.txt  >> $domain/wordlist/data.txt

cat $domain/wordlist/data.txt | wc -l 

cat $domain/wordlist/data.txt | unfurl -u keys >> $domain/wordlist/keys.txt
cat $domain/wordlist/data.txt | unfurl -u paths >> $domain/wordlist/keys.txt 

wget -qO - $domain | wwwordlist -type html  >> $domain/wordlist/webwords.txt 

#cat $domain/wordlist/data.txt | wordlistgen -qv  >> $domain/wordlist/keys.txt
#cat $domain/wordlist/data.txt | unfurl -u paths | sed 's#/#\n#g' >> $domain/wordlist/keys.txt

cat $domain/wordlist/keys.txt >> $domain/wordlist/finalword.txt

echo "recon Done"

}

wordlistgen



