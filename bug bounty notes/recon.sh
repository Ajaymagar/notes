

#!/bin/bash/

domain=$1
validator=$2

mkdir -p $domain  $domain/resolved  $domain/subdomyop $domain/resolvers $domain/portscan/ $domain/nuclei  $domain/aquatone   
mkdir -p $domain/gau  $domain/Javascript


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



subfinder -recursive  -silent -d  $domain  >> $domain/subfinder.txt
assetfinder --subs-only $domain  >> $domain/subfinder.txt       
Findomain -t $domain -q  -r  >> $domain/subfinder.txt
amass enum -passive -d $domain >> $domain/subfinder.txt        

cat $domain/subfinder.txt | wc -l 

cat $domain/subfinder.txt | sort -u >>  $domain/sortedSub.txt 

cat $domain/sortedSub.txt | wc -l 

cat $domain/sortedSub.txt | httpx -status-code -title -web-server -silent  >> $domain/httpx.txt

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

    Subdomain Enum Done   hakrawler running now  

"


hakrawler -url $domain -depth 3 >>  $domain/hakrawlerOP.txt


echo "

    hakrawler ended JS Enum Started 


"


allAboutJS(){

    echo $domain | gau | grep -iE '\.js$' | httpx -status-code -mc 200 -content-type -silent | grep 'application/javascript' | awk '{ print $1}' >>  $domain/Javascript/alljsfiles.txt 

    getJS --url https://www.$domain --complete --resolve --output $domain/Javascript/alljsfiles.txt

    echo https://www.$domain | subjs >> $domain/Javascript/alljsfiles.txt

    
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
cat $domain/nuclei/ipdata.txt | nuclei -t ../nuclei-templates/cves/ -silent -o $domain/nuclei/opdata.txt 

}

#nucleiscan

function(){

cd sub-domain/Sudomy/   
#sudomy -d $domain
sudomy -d $domain -dP -eP -cF -pS -tO -gW --httpx --dnsprobe
cd output/
date=$(date +%m-%d-%Y)
cd $date  
cp -r $domain ../../../../$domain/subdomyop


}

#function


#all_about_urls(){

# yaha pe gau ayega sab urls ayenge  yaha se  filter hoke sab jagah alag alag folder me jayenge like xss ssrf  


#}

#all_about_urls


