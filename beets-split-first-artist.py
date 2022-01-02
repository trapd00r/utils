# fix https://github.com/beetbox/beets/issues/3176
import re

artist  = 'Jennifer Lopez feat. Pitbull'
artist2 = 'Jennifer Lopez featuring Flo Rida'
artist2 = 'Jennifer Lopez Feat SKOSKAV'
artist3 = 'Eminem'
artist4 = 'Jennifer Lopez & Eminem'
artist5 = 'A-sides Ft Shabba R. & M. Rose'
artist6 = 'Kafta'
artist7 = 'All Hail Y.t, Generalbackpain'
artist8 = 'Armani Depaul, Beachboylos'
artist9 = 'Alex M. Vs. Marc Van Damme'
artist10 = 'the vvs brothers'





print(re.split(',|\s+(feat(.?|uring)|&|(Vs|Ft).)', artist,  1, flags=re.IGNORECASE)[0])
print(re.split(',|\s+(feat(.?|uring)|&|(Vs|Ft).)', artist2, 1, flags=re.IGNORECASE)[0])
print(re.split(',|\s+(feat(.?|uring)|&|(Vs|Ft).)', artist3, 1, flags=re.IGNORECASE)[0])
print(re.split(',|\s+(feat(.?|uring)|&|(Vs|Ft).)', artist4, 1, flags=re.IGNORECASE)[0])
print(re.split(',|\s+(feat(.?|uring)|&|(Vs|Ft).)', artist5, 1, flags=re.IGNORECASE)[0])
print(re.split(',|\s+(feat(.?|uring)|&|(Vs|Ft).)', artist6, 1, flags=re.IGNORECASE)[0])
print(re.split(',|\s+(feat(.?|uring)|&|(Vs|Ft).)', artist7, 1, flags=re.IGNORECASE)[0])
print(re.split(',|\s+(feat(.?|uring)|&|(Vs|Ft).)', artist8, 1, flags=re.IGNORECASE)[0])
print(re.split(',|\s+(feat(.?|uring)|&|(Vs|Ft).)', artist9, 1, flags=re.IGNORECASE)[0])
print(re.split(',|\s+(feat(.?|uring)|&|(Vs|Ft).)', artist10, 1, flags=re.IGNORECASE)[0])
