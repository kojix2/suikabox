require 'suika'

tagger = Suika::Tagger.new

require 'glimmer-dsl-libui'
include Glimmer

data = [[]]

window('SuikaBox', 1000, 500) do
  margined true

  vertical_box do
    @input = multiline_entry do
      stretchy false
      text 'ここに日本語の文章を入力して下さい。'
    end
    horizontal_box do
      stretchy false
      button('消去') do
        stretchy false
        on_clicked do
          @input.text = ''
        end
      end
      button('解析') do
        stretchy false
        on_clicked do
          data.replace(
            tagger.parse(@input.text.force_encoding('UTF-8')).map do |word|
              word.split(/[\t,]/)
            end
          )
        end
      end
    end
    table do
      10.times { |i| text_column(i.to_s) }
      cell_rows data
      editable false
    end
    label do
      stretchy false
      text "Suika #{Suika::VERSION}"
    end
  end
end.show
