This repo is used for automatic deployment of https://doegox.github.io/rfidpics

If you wish to add your pictures, PRs are mostly welcome.

It's important to provide proper ownership information as well as open source license terms. I advise to use Creative Commons BY-SA 4.0 if possible.
To appear automatically on the website, information must be provided in the EXIF metadata.

Example:
```
exiv2 -M "set Exif.Image.Artist Firstname Lastname <some@email.com>" -M "set Exif.Image.Copyright Creative Commons BY-SA 4.0"
```
