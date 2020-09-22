This repo is used for automatic deployment of https://doegox.github.io/rfidpics

If you wish to add your pictures, PRs are mostly welcome.

The repo is quite large, you can limit your clone to the latest master:

`git clone --depth 1 https://github.com/doegox/rfidpics.git`

Please respect the following rules:

* Provide pictures in JPEG, up to 95% quality, cropped to fit the card/reader. Avoid perspective, shoot flat.
* Provide proper ownership information: a name and an email, this can be the same as what you use for git commits.
* Provide proper open source license terms. I advise to use Creative Commons BY-SA 4.0 or Public Domain.
* Respect the naming conventions as much as possible (see other files) as well as the directory structure.

To appear automatically on the website, information must be provided in the EXIF metadata.

Example:

```sh
# apt-get install imagemagick
convert mypic.png -quality 95% mypic.jpg
# apt-get install exiv2
exiv2 -M "set Exif.Image.Artist Firstname Lastname <some@email.com>" \
      -M "set Exif.Image.Copyright Creative Commons BY-SA 4.0" \
      mypic.jpg
```

If you think the website itself deserves enhancements, propose your PRs against https://github.com/doegox/rfidpics-engine
