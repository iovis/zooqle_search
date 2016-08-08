require 'erb'
require 'open-uri'
require 'nokogiri'
require 'yaml'

module ZooqleSearch
  ##
  # Extract a list of results from your search
  # Zooqle.new("Suits s05e16 1080p")
  class Search
    NUMBER_OF_LINKS = 5
    BASE_URL = "https://zooqle.com"

    attr_accessor :url

    def initialize(search)
      @url = "#{BASE_URL}/search?q=#{ERB::Util.url_encode(search)}"
    end

    def results_found?
      @results_found ||= page.at('p:contains("Sorry, no torrents match your query.")').nil?
    rescue OpenURI::HTTPError
      @results_found = false
    end

    def links
      @links ||= generate_links
    end

    private

    def page
      @page ||= Nokogiri::HTML(open(@url))
    end

    def generate_links
      links = []
      return links unless results_found?

      crawled_links = page.css('.table-torrents tr')

      crawled_links.each do |link|
        filename_node = link.at('a')
        filename = filename_node.text if filename_node
        seeders_leechers = link.at('div[title^="Seeders:"]')
        next if filename_node.nil? || filename.strip.empty? || seeders_leechers.nil?

        size = link.at('.progress-bar').text
        magnet = link.at('a[title="Magnet link"]')['href']
        download_url = BASE_URL + link.at('a[title="Generate .torrent"]')['href']

        seeders_leechers = seeders_leechers['title']
        seeders = seeders_leechers[/Seeders: (?<seeders>[\d,]+) \| Leechers: (?<leechers>[\d,]+)/, :seeders]
        leechers = seeders_leechers[/Seeders: (?<seeders>[\d,]+) \| Leechers: (?<leechers>[\d,]+)/, :leechers]

        links << Link.new(filename, size, magnet, download_url, seeders, leechers)
      end

      links.sort!.reverse!

      return links.first(NUMBER_OF_LINKS)
    end
  end
end
