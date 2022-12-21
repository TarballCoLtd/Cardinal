# REDSwift
RED client for iOS (by tarball)

Pull requests are always welcome! A huge thanks to those of you who choose to contribute.

## (Inexhaustive) List of Planned Features

In no particular order:

- [ ] Collage viewing and search
- [ ] Top 10
- [ ] Sending PMs/messages
- [ ] Home tab that isn't horribly laggy
- [ ] User profile bios
- [ ] User profile albums
- [ ] Proper announcement rendering (unlikely)
- [ ] Downloading torrent files
- Other things I probably forgot

## FAQ

> Do you plan on creating an Android version?

No.

> How can I install this?

Look up a tutorial for AltStore. If you have a Mac, installing via Xcode is easier.

> What is the 'no ATS' version?

App Transport Security (ATS) is a security feature on iOS. By default, it prevents you from querying HTTP sites in favor of HTTPS. I can't simply disable ATS entirely because this would be a security issue, hence the separate version.

**This version has nearly no purpose except to allow HTTP profile picture links. If you don't need this, don't use it.**

> How can I report a bug?

The [issues tab](https://github.com/TarballCoLtd/REDSwift/issues). Please don't use the thread on RED.

> How can I contact you?

I'm always available to chat, whether about this app or not, on RED. Don't hesitate to PM me on the site!

> Will this work on (insert tracker here)?

I don't know. If it uses Gazelle, it may, but no promises. It's up to you to tweak the code accordingly.

> How can I build this myself?

Clone, open in Xcode, set your development team in the project settings, `Product -> Archive`.

> Why do I keep getting notifications for a new announcement?

This is a bug with the RED API. I cannot fix it. It has already been reported on the forum.

> Will this work on iPadOS?

Poorly.
