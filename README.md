# flackr

The code here provides a simple way to produce dynamic web pages for your directories of photos via your hosted webserver: the code relies on a web server, javascript, jquery, justified gallery and a couple of bash shell scripts to serve files. 

To install, copy to your document root such as `/var/www/html` so that you have:
```
/var/www/html/flickr

/var/www/html/cgi-bin/flickr-dirs.sh
/var/www/html/cgi-bin/flickr-imgs.sh

/var/www/html/css/flackr.css
/var/www/html/css/justifiedGallery.min.css
/var/www/html/css/fonts/ProximaNova-Reg-webfont-v2.woff
/var/www/html/css/fonts/proxima-nova-bold.woff2
/var/www/html/css/fonts/proxima-nova-semibold.woff2
/var/www/html/css/fonts/proxima-nova-light.woff2
/var/www/html/css/fonts/proxima-nova-regular.woff2
/var/www/html/css/fonts/ProximaNova-Sbold-webfont-v2.woff

/var/www/html/js/jquery.min.js
/var/www/html/js/jquery.justifiedGallery.min.js

/var/www/html/flickr/index.html
/var/www/html/flickr/_index.html
```
To add _albums_ create a directory under `/var/www/html/flickr` and create thumbnails folder, called `.tn`, under the new directory.  Finally create a symlink to `../_index.html` called `index.html`.  
```
mkdir -p /var/www/html/flickr/foo/.tn
cd /var/www/html/flickr/foo
ln -s ../_index.html index.html
mv /export/public/incoming/foo/* .
for i in *.jpg *.png ; do convert -resize 300 $i .tn/$i; done
```
At this point you can visit http://localhost/flickr/ or http://localhost/flickr/foo to see your albums - the image listings are dynamically created
