require "tempfile"
require "nokogiri"
require "open-uri"

def command_exists?(name)
  `which #{name}`
  $?.success?
end

abort("[ERROR] ffmpeg not found, can't continue.") unless command_exists?('ffmpeg')
abort("[ERROR] imagemagick not found, can't continue.") unless command_exists?('convert')

tweet_url = ARGV[0]

unless tweet_url
  puts "usage: tweet_to_gif.rb {tweet URL}"
  exit
end

puts "Retrieving tweet ..."
document = Nokogiri::HTML(open(tweet_url))
video_player = document.at_css(".PlayableMedia-player")

abort("[ERROR] Can't find a GIF in this tweet.") unless video_player

video_id = video_player.attribute("style").value.match(/tweet_video_thumb\/(.*).jpg/)[1]

puts "Downloading video ..."
file = open("https://pbs.twimg.com/tweet_video/#{video_id}.mp4")

puts "Converting video to GIF ..."
`ffmpeg -i #{file.path} -vf scale=640:-1 -f image2pipe -vcodec ppm -loglevel 0 - | convert -delay 5 -loop 0 -layers Optimize - output/#{video_id}.gif`

puts "[DONE] GIF saved at output/#{video_id}.gif"

