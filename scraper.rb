#!/bin/env ruby
# encoding: utf-8

require 'wikidata/fetcher'
require 'pry'


site_19 = EveryPolitician::Wikidata.wikipedia_xpath(
  url: 'https://ko.wikipedia.org/wiki/대한민국_제19대_국회의원_목록',
  after: "//h2/span[.='가나다순 보기']",
  before: "//h2/span[.='의석 변동']",
  xpath: '//p//a[not(@class="new")]/@title',
)
category_19 = WikiData::Category.new('분류:대한민국의 제19대 국회의원', 'ko').member_titles

site_20 = EveryPolitician::Wikidata.wikipedia_xpath(
  url: 'https://ko.wikipedia.org/wiki/대한민국_제20대_국회의원_목록',
  after: "//h2/span[.='가나다순 보기']",
  before: "//h2/span[.='의석 변동']",
  xpath: '//p//a[not(@class="new")]/@title',
)
category_20 = WikiData::Category.new('분류:대한민국의 제20대 국회의원', 'ko').member_titles

# Members of the 19th/20th Assembly
sparq = <<EOQ
  SELECT DISTINCT ?item WHERE {
    VALUES ?term { wd:Q12592166 wd:Q22971549 }
    ?item p:P39 [ ps:P39 wd:Q14850694 ; pq:P2937 ?term ]
  }
EOQ
ids = EveryPolitician::Wikidata.sparql(sparq)

EveryPolitician::Wikidata.scrape_wikidata(ids: ids, names: { ko: site_19 | category_19 | site_20 | category_20 })
