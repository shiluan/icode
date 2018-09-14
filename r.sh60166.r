d.p<-dat$price
d.v<-dat$volume

l1<-d.p[4:(length(d.p)-4)]
v1<-d.v[4:(length(d.v)-4)]

l2<-d.p[5:(length(d.p)-3)]
v2<-d.v[5:(length(d.v)-3)]

l3<-d.p[6:(length(d.p)-2)]
v3<-d.v[6:(length(d.v)-2)]

l4<-d.p[7:(length(d.p)-1)]
v4<-d.v[7:(length(d.v)-1)]

l5<-d.p[8:(length(d.p))]
v5<-d.v[8:(length(d.v))]

dat2<-cbind(l1,v1, l2,v2,l3,v3,l4,v4,l5,v5)

colnames(dat2) <- c('price', 'volume', 'price_1', 'volume_1', 'price_2', 'volume_2', 'price_3', 'volume_3', 'price_4', 'volume_4')


l<-NULL
for(i in 1:143){
    l<-append(l,max(d.p[i], d.p[i+1], d.p[i+2]))
}


dat2<-cbind(future3=l, dat2)

