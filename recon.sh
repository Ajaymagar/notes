
#!/bin/bash/

domain=$1
wordlist='path'
resolvers='path'

domain_enum(){

mkdir -p $domain $domain/sources $domain/Recon

subfinder -d $domain -o $domain/sources/subfinder.txt 
assetfinder -subs-only $domain | tee $domain/sources/hackerone.com
amass enum -passive -d $domain -o  $domain/sources/passive.txt 

shuffledns -d $domain -w $wordlist -r $resolvers -o $domain/sources/shuffledns.txt  

cat $domain/sources/*.txt  > $domain/sources/all.txt 

}

domain_enum

resolve_domains(){

shuffledns -d $domain -list $domain/sources/all.txt -r $resolvers  -o $domain/domains.txt 

}

resolving_domains 

http_prob(){

cat $domain/domains.txt | httpx -o $domain/Recon/httpx.txt

}

http_prob

scanner(){

cat $domain/Recon/httpx.txt | nuclei -t nuclei-templates/  -o $domain/Recon/nuclei/cves.txt



}

scanner 

wayback_data(){

cat $domain/domains.txt | gau | tee $domain/Recon/wayback/tmp.txt 
cat $domain/Recon/wayback/tmp.txt | egrep -v '\.css|\.svg|\.png' | sed 's/:80//g;s\:443\\g' |sort -u >> 

}

wayback_data

valid_urls(){

    ffuf -c -u "FUZZ" -w $domain/Recon/wayback/wayback.txt -o valid.txt 
    cat $valid.txt | grep http  

}

valid_urls 


gf_patterns(){

    gf xss valid.txt | tee xss.txt 
    gf sql valid.txt | tee sql.txt 

}

gf_patterns

custom_wordlist(){

    cat waybackdata,txt | unfurl -unique paths > op.txt 

}

custom_wordlist








