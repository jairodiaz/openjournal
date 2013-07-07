# Taken https://gist.github.com/handerson/2703006

class PubmedApi # a very basic Pubmed API
  require "net/http"
  require "uri"
  require "nokogiri"

  def self.find(ids) # can accept an array of ids or a single id or a string of ids separated by commas
    param = ids.class == Array ? ids.join(",") : ids

    uri = URI.parse("http://eutils.ncbi.nlm.nih.gov/entrez/eutils/esummary.fcgi?db=pubmed&id=#{param}")
    response = Net::HTTP.get_response(uri)

    documents = []

     if response.code_type.to_s == "Net::HTTPOK"

      parsedDoc = Nokogiri::XML(response.body)
      parsedDoc = parsedDoc.css("eSummaryResult DocSum")

      parsedDoc.each do |pd|
        doc = {}
        doc[:title] =pd.css("Item[Name=Title]")[0].text
        doc[:id] = pd.at_css("Item[Name=ArticleIds] Item[Name=pubmed]").text
        doc[:date] =pd.css("Item[Name=PubDate]")[0].text
        doc[:source] =pd.css("Item[Name=FullJournalName]")[0].text
        doc[:url] = "http://www.ncbi.nlm.nih.gov/pubmed/#{doc[:id]}"
        doc[:db] = "pubmed"

        doc[:authors] = []
        pd.css("Item[Name=AuthorList] Item[Name=Author]").each do |author|
          doc[:authors] << author.text
        end

        documents << doc
      end
    end

    documents
  end

  def self.search(terms)
    # see # http://www.ncbi.nlm.nih.gov/books/NBK3827/#pubmedhelp.Search_Field_Descrip for help with terms

    # A search query can be build by going to http://www.ncbi.nlm.nih.gov/pubmed and then using the filters provided.
    # The search terms can then be copied from the "Search details" section on the right-hand side and used here.

    terms = URI.escape(terms, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
    uri = URI.parse("http://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=pubmed&term=#{terms}")
    response = Net::HTTP.get_response(uri)

    ids = []

     if response.code_type.to_s == "Net::HTTPOK"

        parsedDoc = Nokogiri::XML(response.body)
        parsedDoc = parsedDoc.css("eSearchResult")

        if parsedDoc.at_css("Count").text.to_i > 0
          parsedDoc.css("IdList Id").each do |id|
            ids << id.text
          end
        end
      end
   self.find(ids)
  end

end
