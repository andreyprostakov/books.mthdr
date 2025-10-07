FactoryBot.define do
  factory :cover_design, class: 'CoverDesign' do
    sequence(:name) { |i| "DESIGN_#{i}" }
    title_color { CoverDesign::COLORS.sample }
    title_font { CoverDesign::FONTS.sample }
    author_name_color { CoverDesign::COLORS.sample }
    author_name_font { CoverDesign::FONTS.sample }
    cover_image { CoverDesign::COVER_IMAGES.sample }
  end
end
