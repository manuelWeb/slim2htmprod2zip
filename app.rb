# encoding: UTF-8
require 'slim'
require 'htmlbeautifier' 
require 'nokogiri'
require 'zip'
Slim::Engine.set_options pretty: true, sort_attrs: false
projectName = "TH16_Noel"
# Slimed = slim to html + beautify
class Slimed
  attr_accessor :src, :out
  def initialize(src,out)
    @src = src
    @out = out
  end 
  def tohtml
    # ouverture src en lecture
    srcfile = File.open(src, "rb").read
    s2h = Slim::Template.new{srcfile}
    htmlrender = s2h.render
    # beautiful = HtmlBeautifier.beautify(htmlrender, tab_stops: 2)
    File.open(out, "w") do |go|
      go.puts HtmlBeautifier.beautify(htmlrender, tab_stops: 2)
    end
  end
end
bf = Slimed.new('BF/indexC.slim', 'BF/indexC.html')
bv = Slimed.new('BV/indexC.slim', 'BV/indexC.html')
de = Slimed.new('DE/indexC.slim', 'DE/indexC.html')
fr = Slimed.new('FR/indexC.slim', 'FR/indexC.html')
nl = Slimed.new('NL/indexC.slim', 'NL/indexC.html')
uk = Slimed.new('UK/indexC.slim', 'UK/indexC.html')
bf.tohtml
bv.tohtml
de.tohtml
fr.tohtml
nl.tohtml
uk.tohtml
# ToHtmlProd = indexC.htmlToIndex.html+zipMeNow(toHtmlFragment<zipMeNow) 
class ToHtmlProd
  attr_accessor :srcHtml, :srcJs, :path, :zipfile_name
  def initialize(srcHtml,srcJs,path,zipfile_name)
    @srcHtml = srcHtml
    @srcJs = srcJs    
    @path = path
    @zipfile_name = zipfile_name
  end
  def toHtmlFragment
    file =  File.read("#{path}#{srcHtml}")
    doc = Nokogiri::HTML(file, nil, "UTF-8")
    frag = doc.at_css("#evtFirst_Link")
    # puts "\ncode indexC.html full : \n\n #{doc}  \n"
    # puts "\ncode indexC.html frag : \n\n #{frag}  \n"
    # srcJs1 = doc.at_css(srcJs[0])
    srcJs1 = doc.at_css(srcJs[0])
    srcJs2 = doc.at_css(srcJs[1])
    # compil JS + HTML
    File.open("#{path}index.html", "w") do |file|
      # **placer le script JS en debut de document
      file.puts "#{frag}"
      # file.puts "\n#{srcJs1}"
      file.puts "\n#{srcJs1}"
      file.puts "\n#{srcJs2}"
    end
    a = File.read("#{path}index.html").force_encoding("UTF-8")
    # **attention** CODAGE a compléter (GSUB)
    a = a.gsub(/(<img.*?)>/,'\1 />').gsub(/(<input.*?)>/,'\1 />').gsub('é','&eacute;').gsub('è','&egrave;').gsub('ë','&euml;').gsub('ç','&ccedil;').gsub('à','&agrave;').gsub('ï','&iuml;').gsub('ù','&ugrave;').gsub('â','&acirc;').gsub('ê','&ecirc;').gsub('î','&icirc;').gsub('ô','&ocirc;').gsub('û','&ucirc;').gsub('€','&euro;').gsub('<br>',' <br />')
    beautiful = HtmlBeautifier.beautify(a, tab_stops: 2)
    File.open("#{path}index.html", "w") do |i|
      i.puts beautiful
    end
    def zipMeNow
      Dir.chdir "#{path}"
      zipContent = Dir["*"]
      puts zipContent # verif console path/content

      Zip::File.open(zipfile_name, Zip::File::CREATE) do |zipfile|
        zipContent.each do |filename|
          zipfile.add(filename, filename)
        end
        puts "your #{zipfile_name} is ready guy" # verif console folder name + ready
      end
      Dir.chdir "../"
    end
  end
end
date = Time.new
currentdate = date.strftime("%m%y")
# puts currentdate # verif console date
bfprod = ToHtmlProd.new("indexC.html",['[src~="etoilesShow.js"]','[src~="js-btn.js"]'],"BF/","BF#{currentdate}_#{projectName}.zip")
bvprod = ToHtmlProd.new("indexC.html",['[src~="etoilesShow.js"]','[src~="js-btn.js"]'],"BV/","BV#{currentdate}_#{projectName}.zip")
deprod = ToHtmlProd.new("indexC.html",['[src~="etoilesShow.js"]','[src~="js-btn.js"]'],"DE/","DE#{currentdate}_#{projectName}.zip")
frprod = ToHtmlProd.new("indexC.html",['[src~="etoilesShow.js"]','[src~="js-btn.js"]'],"FR/","FR#{currentdate}_#{projectName}.zip")
nlprod = ToHtmlProd.new("indexC.html",['[src~="etoilesShow.js"]','[src~="js-btn.js"]'],"NL/","NL#{currentdate}_#{projectName}.zip")
ukprod = ToHtmlProd.new("indexC.html",['[src~="etoilesShow.js"]','[src~="js-btn.js"]'],"UK/","UK#{currentdate}_#{projectName}.zip")
bfprod.toHtmlFragment
bfprod.zipMeNow
bvprod.toHtmlFragment
bvprod.zipMeNow
deprod.toHtmlFragment
deprod.zipMeNow
frprod.toHtmlFragment
frprod.zipMeNow
nlprod.toHtmlFragment
nlprod.zipMeNow
ukprod.toHtmlFragment
ukprod.zipMeNow

# system("explorer #{fr.out}") # openInBrowser