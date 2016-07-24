require 'cgi'
require 'httparty'

module ZooqleSearch
  ##
  # Object that contains the info for a torrent file
  class Link
    attr_reader :filename, :size, :magnet, :download_url, :seeders, :leechers

    def initialize(filename, size, magnet, download_url, seeders, leechers)
      @filename = filename
      @size = size
      @magnet = magnet
      @download_url = download_url
      @seeders = seeders.tr(',', '').to_i
      @leechers = leechers.tr(',', '').to_i
    end

    def <=>(other)
      @seeders <=> other.seeders
    end

    def to_s
      "#{@filename} (#{@size}) - [#{@seeders.to_s.green}/#{@leechers.to_s.red}]"
    end

    def info_hash
      @info_hash ||= extract_hash
    end

    def download(path = './')
      response = HTTParty.get(@download_url)

      raise 'Wrong content-type. Aborting.' unless response.headers['content-type'].include? 'application/x-bittorrent'

      # Get file name from the url
      filename = @filename + '.torrent'
      open(File.join(path, filename), 'w') { |f| f << response }

      # return filename
      filename
    end

    private

    def extract_hash
      # Extract magnet properties to a Hash and then parse the sha1 info hash
      raw_hash = magnet[/(xt.*?)&/, 1]  # extract the xt property
      raw_hash.split(':').last.downcase
    end
  end
end
