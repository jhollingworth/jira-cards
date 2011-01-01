require 'spec_helper'
require 'pdf_renderer'

describe "When I render some html to a pdf" do
  before(:all) do
    @html = "<html><body><h1>Hello world</h1></body></html>"
    @renderer = PdfRenderer.new(File.dirname(__FILE__) + '/test.css')
    @output_path = File.dirname(__FILE__) + '/test.pdf'
  end

  before(:each) do
    @renderer.render(@html, @output_path)
  end

  it "should create the pdf" do
    File.exists?(@output_path).should == true
  end

  after(:each) do
    delete_file(@output_path)
  end
end