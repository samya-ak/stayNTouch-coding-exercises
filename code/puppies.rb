#!/usr/bin/env ruby

require 'nokogiri'

# Builds a scraper for a dog adoption website. This scraper opens the paws.html page and collects all baby female dogs on each page. The scraper
# returns the href sources for each matching dog. The DIRECTORY constant contains directory containing paws.html.
#
class Puppies
  DIRECTORY = ::File.join(::File.dirname(__FILE__), '../data')
  INDEX_FILE = File.join(DIRECTORY, 'paws.html')

  # From pagination, extract all the pages
  def self.extract_page_paths
    index = Nokogiri::HTML(File.read(INDEX_FILE))
    index.css('nav.pagination a.page-link')
         .map { |a| a['href'] }
         .uniq
         .compact
         .filter { |path| path != '#' }
  end

  # Iterate through extracted pages and get all 'Female - Baby' dogs
  def self.parse
    page_paths = extract_page_paths
    results = []

    page_paths.each do |path|
      page_path = File.join(DIRECTORY, path)
      next unless File.exist?(page_path)

      page = Nokogiri::HTML(File.read(page_path))
      page.css('div.col-sm-4.dog a').each do |a|
        results.push(a['href']) if a.text.include?('Female - Baby')
      end
    end

    results
  end
end
