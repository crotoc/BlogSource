perl -lane 'if(!/\!/){print "ipset=/$_/ss_rules_dst_unblock"}' source/_posts/Unblock-region-restriction-of-musics-videos/unblock.rules.txt > source/_posts/Unblock-region-restriction-of-musics-videos/unblock.rules.dnsmasq.conf 

perl -lane 'if(!/\!/){print "ipset=/$_/unblock-youku"}' source/_posts/Unblock-region-restriction-of-musics-videos/unblock.rules.txt > source/_posts/Unblock-region-restriction-of-musics-videos/unblock.rules.v2ray.dnsmasq.conf 
