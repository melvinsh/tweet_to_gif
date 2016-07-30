require "tempfile"
require "nokogiri"
require "open-uri"

tweet_url = ARGV[0]

def command_exists?(name)
  `which #{name}`
  $?.success?
end

abort("[ERROR] ffmpeg not found, can't continue.") unless command_exists?('ffmpeg')
abort("[ERROR] imagemagick not found, can't continue.") unless command_exists?('convert')

unless tweet_url
  puts "usage: tweet_to_gif.rb {tweet URL}"
  exit
end

puts "Retrieving tweet ..."
response = open(tweet_url)
document = Nokogiri::HTML(response)
style = document.at_css(".PlayableMedia-player").attribute("style").value
video_id = style.match(/tweet_video_thumb\/(.*).jpg/)[1]

puts "Downloading video ..."
file = open("https://pbs.twimg.com/tweet_video/#{video_id}.mp4")

puts "Converting video to GIF ..."
`ffmpeg -i #{file.path} -vf scale=640:-1 -r 10 -f image2pipe -vcodec ppm -loglevel 0 - | convert -delay 5 -loop 0 - output/#{video_id}.gif`

puts "[DONE] GIF saved at output/#{video_id}.gif"

