# tweet_to_gif
CLI tool to download GIF files from tweets.

## Installation
Make sure `ffmpeg` and `imagemagick` are installed. If you use Homebrew you can run `brew bundle` to get the required packages. Afterwards, run `bundle install` to get the required gems.

## Usage example
```
➜  tweet_to_gif git:(master) ruby tweet_to_gif.rb https://twitter.com/swept/status/759486156073476096
Retrieving tweet ...
Downloading video ...
Converting video to GIF ...
[DONE] GIF saved at output/Coo8nSMWcAQppZ1.gif
```
