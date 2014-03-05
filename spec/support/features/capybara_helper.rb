module Features
  module CapybaraHelper
    def choose_by_value(value) 
      find("input[value='#{value}']").click
    end

    def have_checked_field_with_value(value)
      expect(page).to have_xpath("//input[@value='#{value}' and @checked='checked']")
    end

    def image_src(selector = nil)
      find(selector || 'img')['src']
    end
  end
end