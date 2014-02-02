module CapybaraHelper
  def choose_by_value(value) 
    find("input[value='#{value}']").click
  end

  def have_checked_field_with_value(value)
    expect(page).to have_xpath("//input[@value='#{value}' and @checked='checked']")
  end
end