# xelatex (TexLive2021) online compiler
<pre>
sudo git clone https://github.com/flightphone/mtrest.git .
sudo docker build --tag tlive . 
sudo docker run --rm --name latexcomp -p 2000:2000 --mount type=tmpfs,destination=/usr/src/app/dnload  -d tlive

on client:
curl -F "file=@filename.zip"  -O -J  http://mywebsite:2000/upload/filename.tex

</pre>