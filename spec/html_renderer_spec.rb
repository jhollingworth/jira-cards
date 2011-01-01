require 'html_renderer'
require 'mock'

describe "When I render the issues" do
  before(:all) do
    @issues = [
      Mock.new({
        :issue_type => "Story", :key => "PY-1"
      })
    ]
    @renderer = HtmlRenderer.new(
      File.dirname(__FILE__) + '/test.erb'
    )
  end

  before(:each) do
    @html = @renderer.render(@issues)
  end
  
  it "should render the issues using the default template" do
    @html.should == "Type:Story\nKey:PY-1"
  end

end