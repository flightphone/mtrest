var express = require('express');
var bodyParser = require('body-parser');
var multer = require('multer');
var upload = multer();
var cors = require('cors');
var fs = require('fs');

const { exec } = require('child_process');
const extract = require('extract-zip')



var app = express();
app.use(bodyParser.json()); // support json encoded bodies
app.use(bodyParser.urlencoded({ extended: true }));
app.use(cors());

app.get('/', function (req, res) {
  res.send('<h1>Free xelatex (TexLive2021) online compiler demo</h1>');
});

app.post('/upload/:main', upload.single('file'), function (req, res) {
  let main = req.params['main'];
  if (main == '-')
    main = req.file.originalname;

  main = main.replace(/\..../, '');

  let now = new Date();
  let uniq = now.toISOString().replace(/-/g, '_').replace(/\:/g, '_').replace(/\./g, '_');

  let target = './dnload/' + uniq;
  fs.mkdirSync(target);

  let zipname = './dnload/' + uniq + '.zip';
  let texfile = main + '.tex';

  fs.writeFile(zipname, req.file.buffer, async function (err) {
    if (err) {
      res.send(err);
    }
    else {
      //разархивируем  
      try {
        await extract(zipname, { dir: __dirname + '/dnload/' + uniq })
        //компилируем
        let exe = 'xelatex -interaction nonstopmode -output-driver="xdvipdfmx -i dvipdfmx-unsafe.cfg -q -E" ' + texfile;
        exec(exe, { cwd: target }, (error, stdout, stderr) => {

          try {
            let bf = fs.readFileSync(target + '/' + main + '.pdf');

            //Удаляем файлы  
            fs.unlink(zipname, (err) => { });
            fs.rmdir(target, {
              recursive: true,
            }, () => {
            });

            res.setHeader('Content-Disposition', 'attachment; filename="' + main + '.pdf"');
            res.write(bf, "binary");
            res.end();

          }
          catch (err2) {
            res.send(err2);
          }


        });
      } catch (err1) {
        res.send(err1);
      }
    }
  });
});

app.listen(2000, function () {
  console.log('app listening on port 2000! ');
});