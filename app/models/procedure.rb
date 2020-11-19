require 'nokogiri'

class Procedure < ApplicationRecord
    DATA_SOURCE_URL = "https://en.wikipedia.org/wiki/Medical_procedure#List_of_medical_procedures"
    START_SECTION_ID = 'List_of_medical_procedures'
    END_SECTION_ID = 'See_also'
    
    scope :find_by_name_pattern, ->(pattern) do
        where('lower(name) LIKE ?', "%#{pattern.downcase}%")
        .sort_by do |procedure|
            procedure.name.downcase.index(pattern.downcase)
        end
    end

    def self.collect_data_from_source(source_url=DATA_SOURCE_URL)
        response = HTTParty.get(source_url)
        return unless response.code == 200

        doc = Nokogiri::HTML(response)
        parse_procedures_from_source(doc)
    end

    private

    def self.parse_procedures_from_source(doc)
        # data we need to have starts from 'span#List_of_medical_procedures' and ends just before 'span#See_also'
        # so we need to gather all 'a' tags (placed in ul/li) from START_SECTION_ID to END_SECTION_ID
        # Here we use xpath pattern to get an accurate data slice
        pattern = "//*[@id='#{START_SECTION_ID}']/../following-sibling::"\
                  "ul/li/a[count(following::*[@id='#{END_SECTION_ID}'])]"

        doc.xpath(pattern).map(&:text) 
    end
end
