
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



}

scanner 
